From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Tue, 7 Jun 2016 19:43:15 +0800
Message-ID: <20160607114315.GF23133@insomnia>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160606160836.GC30154@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SnV5plBeK2Ge1I9g"
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
In-Reply-To: <20160606160836.GC30154@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2016 at 06:08:36PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 02, 2016 at 06:57:00PM +0100, Will Deacon wrote:
> > > This 'replaces' commit:
> > >=20
> > >   54cf809b9512 ("locking,qspinlock: Fix spin_is_locked() and spin_unl=
ock_wait()")
> > >=20
> > > and seems to still work with the test case from that thread while
> > > getting rid of the extra barriers.
>=20
> New version :-)
>=20
> This one has moar comments; and also tries to address an issue with
> xchg_tail(), which is its own consumer. Paul, Will said you'd love the
> address dependency through union members :-)
>=20
> (I should split this in at least 3 patches I suppose)
>=20
> ARM64 and PPC should provide private versions of is_locked and
> unlock_wait; because while this one deals with the unordered store as
> per qspinlock construction, it still relies on cmpxchg_acquire()'s store
> being visible.
>=20

[snip]

> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index ce2f75e32ae1..e1c29d352e0e 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -395,6 +395,8 @@ void queued_spin_lock_slowpath(struct qspinlock *lock=
, u32 val)
>  	 * pending stuff.
>  	 *
>  	 * p,*,* -> n,*,*
> +	 *
> +	 * RELEASE, such that the stores to @node must be complete.
>  	 */
>  	old =3D xchg_tail(lock, tail);
>  	next =3D NULL;
> @@ -405,6 +407,15 @@ void queued_spin_lock_slowpath(struct qspinlock *loc=
k, u32 val)
>  	 */
>  	if (old & _Q_TAIL_MASK) {
>  		prev =3D decode_tail(old);
> +		/*
> +		 * The above xchg_tail() is also load of @lock which generates,
> +		 * through decode_tail(), a pointer.
> +		 *
> +		 * The address dependency matches the RELEASE of xchg_tail()
> +		 * such that the access to @prev must happen after.
> +		 */
> +		smp_read_barrier_depends();

Should this barrier be put before decode_tail()? Because it's the
dependency old -> prev that we want to protect here.

Regards,
Boqun

> +
>  		WRITE_ONCE(prev->next, node);
> =20
>  		pv_wait_node(node, prev);
[snip]

--SnV5plBeK2Ge1I9g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXVrNPAAoJEEl56MO1B/q4BmgH/RegPytBD13oKJMUMuLrWM/s
o6pCfEuLlJKh63j5A4IlWXyVy8WfL7SbkHvM1TQTSU6egcY+QdUBUCh5OJfosP25
YwtYikofxec3TqzBx3FhjZzdbbZdHHvhg9RRYr5DJThIzhJiP1LVhW1kwcfQpcab
/K7dZ3UnTHdtI55EjGEePU+U05kO85Nis5zE6d2bpkRA8o6WlAzzzjDATdndpnlF
qvLmsX2+xt6vJ0WUio+f8blCJ7flNJJZKv5Mg/cJSEJEgWok81MLOWyBz0yeo5x0
Upfp5NxVUq3gPowDABZAKxAzLz5sb/+1NUmznh4EMbV69e04yU/eXesN3e7UoSA=
=VM0Y
-----END PGP SIGNATURE-----

--SnV5plBeK2Ge1I9g--
