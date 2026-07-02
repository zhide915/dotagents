# Deep Modules

Interface-design reference. Assumes SKILL.md's rules: the ladder, the
deletion test, the two-implementations rule.

## Vocabulary — one term per concept

- **Module** — anything with an interface and an implementation: a function,
  class, package, or slice spanning tiers. Scale-agnostic on purpose.
- **Interface** — everything a caller must know to use the module correctly:
  the signature plus invariants, ordering constraints, error modes, required
  configuration, and performance characteristics.
- **Implementation** — the code inside.
- **Seam** — the place where behavior can vary without editing callers;
  where an interface lives.
- **Adapter** — a concrete implementation filling a seam (the Postgres repo,
  the in-memory fake).
- **Depth** — behavior per unit of interface a caller must learn.
- **Leverage** — the callers' gain from depth: one implementation pays back
  across N call sites and M tests.
- **Locality** — the maintainers' gain: changes, bugs, and knowledge
  concentrate in one place. Fix once, fixed everywhere.

## Deep vs shallow

Deep: small interface, lots hidden. Shallow: interface nearly as complex as
the implementation — callers learn as much as the module saves them. Avoid.

When designing an interface, push on three questions:

- Can there be fewer methods?
- Can the parameters be simpler?
- Can more complexity move inside?

Depth is a property of the interface, not the implementation: a deep module
may be built from small swappable parts internally — they're just not the
caller's business.

## Designing for testability

1. **Accept dependencies, don't create them.**

   ```typescript
   function processOrder(order, paymentGateway) {}        // testable
   function processOrder(order) {
     const gateway = new StripeGateway();                 // hard to test
   }
   ```

2. **Return results, don't mutate in place.**

   ```typescript
   function calculateDiscount(cart): Discount {}          // testable
   function applyDiscount(cart): void { cart.total -= d } // hard to test
   ```

3. **Small surface.** Fewer methods mean fewer tests; fewer parameters mean
   simpler setup.

**The interface is the test surface.** Tests cross the same seam callers do.
Needing to reach past the interface to test means the module is the wrong
shape. A module may keep internal seams for its own tests — don't expose
them in the interface.

## Dependency categories

A module's dependencies decide how it is tested across its seam:

1. **In-process** — pure computation, in-memory state. Test directly; no
   adapter.
2. **Local-substitutable** — a faithful local stand-in exists (in-memory
   SQLite, temp filesystem). Run tests against the stand-in; keep the seam
   internal.
3. **Remote but owned** — your own service across a network. Define a port
   at the seam: a transport adapter (HTTP/queue) for production, an
   in-memory adapter for tests. The logic stays in one deep module even
   though deployment is distributed.
4. **True external** — third-party services (Stripe, Twilio). Inject as a
   port; tests provide a mock adapter.

Categories 3 and 4 satisfy the two-implementations rule with production +
test adapters.

## Replace, don't layer

When deepening existing code:

- Old unit tests on the absorbed shallow modules are waste once
  interface-level tests exist — delete them.
- New tests assert observable outcomes through the new interface, not
  internal state.
- Tests should survive internal refactors. A test that must change when the
  implementation changes was testing past the interface.
