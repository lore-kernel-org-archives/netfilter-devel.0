From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Tue, 7 Jun 2016 20:45:53 +0800
Message-ID: <20160607124553.GG23133@insomnia>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160606160836.GC30154@twins.programming.kicks-ass.net>
 <20160607114315.GF23133@insomnia>
 <20160607120016.GG30154@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, Waiman.Long@hpe.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
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
In-Reply-To: <20160607120016.GG30154@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 07, 2016 at 02:00:16PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 07, 2016 at 07:43:15PM +0800, Boqun Feng wrote:
> > On Mon, Jun 06, 2016 at 06:08:36PM +0200, Peter Zijlstra wrote:
> > > diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> > > index ce2f75e32ae1..e1c29d352e0e 100644
> > > --- a/kernel/locking/qspinlock.c
> > > +++ b/kernel/locking/qspinlock.c
> > > @@ -395,6 +395,8 @@ void queued_spin_lock_slowpath(struct qspinlock *=
lock, u32 val)
> > >  	 * pending stuff.
> > >  	 *
> > >  	 * p,*,* -> n,*,*
> > > +	 *
> > > +	 * RELEASE, such that the stores to @node must be complete.
> > >  	 */
> > >  	old =3D xchg_tail(lock, tail);
> > >  	next =3D NULL;
> > > @@ -405,6 +407,15 @@ void queued_spin_lock_slowpath(struct qspinlock =
*lock, u32 val)
> > >  	 */
> > >  	if (old & _Q_TAIL_MASK) {
> > >  		prev =3D decode_tail(old);
> > > +		/*
> > > +		 * The above xchg_tail() is also load of @lock which generates,
> > > +		 * through decode_tail(), a pointer.
> > > +		 *
> > > +		 * The address dependency matches the RELEASE of xchg_tail()
> > > +		 * such that the access to @prev must happen after.
> > > +		 */
> > > +		smp_read_barrier_depends();
> >=20
> > Should this barrier be put before decode_tail()? Because it's the
> > dependency old -> prev that we want to protect here.
>=20
> I don't think it matters one way or the other. The old->prev
> transformation is pure; it doesn't depend on any state other than old.
>=20

But wouldn't the old -> prev transformation get broken on Alpha
semantically in theory? Because Alpha could reorder the LOAD part of the
xchg_tail() and decode_tail(), which results in prev points to other
cpu's mcs_node.

Though, this is fine in current code, because xchg_release() is actually
xchg() on Alpha, and Alpha doesn't use qspinlock.

> I put it between prev and dereferences of prev, because that's what made
> most sense to me; but really anywhere between the load of @old and the
> first dereference of @prev is fine I suspect.

I understand the barrier here serves more for a documentation purpose,
and I don't want to a paranoid ;-) I'm fine with the current place, just
thought we could put it at somewhere more conforming to our memory
model.

/me feel myself a paranoid anyway...

Regards,
Boqun

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXVsH9AAoJEEl56MO1B/q4mQEH+wWQhKaTf24U2ucZV5B6dIdJ
tO4dBppfEuFsZBDFPIf5tWL4JBmkwsoMLo8YjlHh7sZv3pRhtb/ZTTTYhqv5tP+p
WtjFqpcdf40hsGdtTQi14jKNGgA6VRvnZnhmAj1A2Fc7oNjjEP3VZd8/SbWOGE43
cXqafqq/QX2jUATLB1N46JBey/7voEZbX9fRldpVzvi68dXMnU2OIr/YMTPWOlgw
2O+qi0e6anV7lCC2uFnCbuCplotceZPAJ3xD92nDYtwQ0UZBEyb7iirPgGFX95Ff
l/vZ81Hk9b1JPbYKaKvg4kysTdg/v1+S4evsKexoF2sD6ysOJ8zOtvZWAH7isbs=
=80tz
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--
