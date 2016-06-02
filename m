From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 23:11:07 +0800
Message-ID: <20160602151107.GA23133@insomnia>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602144424.GV3193@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 04:44:24PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 02, 2016 at 10:24:40PM +0800, Boqun Feng wrote:
> > On Thu, Jun 02, 2016 at 01:52:02PM +0200, Peter Zijlstra wrote:
> > About spin_unlock_wait() on ppc, I actually have a fix pending review:
> >=20
> > http://lkml.kernel.org/r/1461130033-70898-1-git-send-email-boqun.feng@g=
mail.com
>=20
> Please use the normal commit quoting style:
>=20
>   d86b8da04dfa ("arm64: spinlock: serialise spin_unlock_wait against conc=
urrent lockers")
>=20

Good point ;-)

> > that patch fixed a different problem when people want to pair a
> > spin_unlock_wait() with a spin_lock().
>=20
> Argh, indeed, and I think qspinlock is still broken there :/ But my poor
> brain is about to give in for the day.
>=20
> Let me go ponder that some :/
>=20

An intial thought of the fix is making queued_spin_unlock_wait() an
atomic-nop too:

static inline void queued_spin_unlock_wait(struct qspinlock *lock)
{
	struct __qspinlock *l =3D (struct __qspinlock *)lock;
=09
	while (!cmpxchg(&l->locked, 0, 0))
		cpu_relax();
}

This could make queued_spin_unlock_wait() a WRITE, with a smp_mb()
preceding it, it would act like a RELEASE, which can be paired with
spin_lock().

Just food for thought. ;-)

> > I think we still need that fix, and there are two conflicts with this
> > series:
> >=20
> > 1.	arch_spin_unlock_wait() code for PPC32 was deleted, and
> > 	consolidated into one.
>=20
> Nice.
>=20
> > 2.	I actually downgraded spin_unlock_wait() to !ACQUIRE ;-)
>=20
> Fail ;-)
>=20
> > I can think of two ways to solve thoes conflicts:
> >=20
> > 1.	Modify my patch to make spin_unlock_wait() an ACQUIRE, and it
> > 	can be merged in powerpc tree, and possible go into to mainline
> > 	before 4.7. Then there is no need for this series to have code
> > 	for ppc, therefore no conflict.
>=20
> Hardly any other unlock_wait is an acquire, everyone is 'broken' :-/
>=20
> > or
> >=20
> > 2.	I can rebase my patch on this series, and it can be added in
> > 	this series, and will go into mainline at 4.8.
> >=20
> >=20
> > Michael and Peter, any thought?
>=20
> I'm fine with it going in early, I can rebase, no problem.

OK, I will resend a new patch making spin_unlock_wait() align the
semantics in your series.

Regards,
Boqun

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXUEyFAAoJEEl56MO1B/q4ufQH/0BvjR1+294JEsykaE/dMgGd
Kw0dZpxsFWrXboMwBqbkGM0uo3N+5cTN8xExWmW7aFYOcpQOFrN0wTtHLJTmlbX4
mJrrjyrBKNim4nI0XEELGjADbEtBci7h9aJ/O9sWcH3sbLnPh014CGtZ1fiiqIMp
AjajDoNTt2m5tCfAWgBD/B84IQKTDj5YbvfkpJY2c2wcHXLgUjpzMK/u/SPeNs9n
4rRXyha5oFnlRTaqAeT+SOl3OviH79fJKuCiXa2EvNJBYIACmMARnXpFXHTbnZkG
U6VbsHB1U5MKplfoLNPqp05QQDUE524kbt41skghVOC90pEKNle2pGUfB2E0fUc=
=A8rU
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
