From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 25 May 2016 13:39:30 +0800
Message-ID: <20160525053930.GC21433@insomnia>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Cc: Waiman Long <waiman.long@hpe.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, will.deacon@arm.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160525045329.GQ4148@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 09:53:29PM -0700, Paul E. McKenney wrote:
> On Tue, May 24, 2016 at 11:01:21PM -0400, Waiman Long wrote:
> > On 05/24/2016 10:27 AM, Peter Zijlstra wrote:
> > >Introduce smp_acquire__after_ctrl_dep(), this construct is not
> > >uncommen, but the lack of this barrier is.
> > >
> > >Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>
> > >---
> > >  include/linux/compiler.h |   14 ++++++++++----
> > >  ipc/sem.c                |   14 ++------------
> > >  2 files changed, 12 insertions(+), 16 deletions(-)
> > >
> > >--- a/include/linux/compiler.h
> > >+++ b/include/linux/compiler.h
> > >@@ -305,20 +305,26 @@ static __always_inline void __write_once
> > >  })
> > >
> > >  /**
> > >+ * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a c=
ontrol dependency
> > >+ *
> > >+ * A control dependency provides a LOAD->STORE order, the additional =
RMB
> > >+ * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE=
} order,
> > >+ * aka. ACQUIRE.
> > >+ */
> > >+#define smp_acquire__after_ctrl_dep()		smp_rmb()
> > >+
> > >+/**
> > >   * smp_cond_acquire() - Spin wait for cond with ACQUIRE ordering
> > >   * @cond: boolean expression to wait for
> > >   *
> > >   * Equivalent to using smp_load_acquire() on the condition variable =
but employs
> > >   * the control dependency of the wait to reduce the barrier on many =
platforms.
> > >   *
> > >- * The control dependency provides a LOAD->STORE order, the additiona=
l RMB
> > >- * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE=
} order,
> > >- * aka. ACQUIRE.
> > >   */
> > >  #define smp_cond_acquire(cond)	do {		\
> > >  	while (!(cond))				\
> > >  		cpu_relax();			\
> > >-	smp_rmb(); /* ctrl + rmb :=3D acquire */	\
> > >+	smp_acquire__after_ctrl_dep();		\
> > >  } while (0)
> > >
> > >
> >=20
> > I have a question about the claim that control dependence + rmb is
> > equivalent to an acquire memory barrier. For example,
> >=20
> > S1:    if (a)
> > S2:       b =3D 1;
> >        smp_rmb()
> > S3:    c =3D 2;
> >=20
> > Since c is independent of both a and b, is it possible that the cpu
> > may reorder to execute store statement S3 first before S1 and S2?
>=20
> The CPUs I know of won't do, nor should the compiler, at least assuming
> "a" (AKA "cond") includes READ_ONCE().  Ditto "b" and WRITE_ONCE().
> Otherwise, the compiler could do quite a few "interesting" things,
> especially if it knows the value of "b".  For example, if the compiler
> knows that b=3D=3D1, without the volatile casts, the compiler could just
> throw away both S1 and S2, eliminating any ordering.  This can get
> quite tricky -- see memory-barriers.txt for more mischief.
>=20
> The smp_rmb() is not needed in this example because S3 is a write, not

but S3 needs to be an WRITE_ONCE(), right? IOW, the following code can
result in reordering:

S1:	if (READ_ONCE(a))
S2:		WRITE_ONCE(b, 1);
=09
S3:	c =3D 2; // this can be reordered before READ_ONCE(a)

but if we change S3 to WRITE_ONCE(c, 2), the reordering can not happen
for the CPUs you are aware of, right?

Regards,
Boqun

> a read.  Perhaps you meant something more like this:
>=20
> 	if (READ_ONCE(a))
> 		WRITE_ONCE(b, 1);
> 	smp_rmb();
> 	r1 =3D READ_ONCE(c);
>=20
> This sequence would guarantee that "a" was read before "c".
>=20
> 							Thanx, Paul
>=20

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXRTqOAAoJEEl56MO1B/q4RQkH/iBGfbHClRtAG9k0L4RXZYBi
u89RoKzD8csL5stgsk08PpOuZ/1jwJEa36e8qSahvdwEQP0Kztldz935IKPtgv8u
RrkDN6P1GBeKFmWEA/dqOrl8hpYDux2crFuzlUBQbs5/kTBhzj3U0V18G7XySzZf
Ip5GB1dinPFmMTMBu6yth9LtLdrDr0CVCt2ClDmDyHqX34YgPv22lA+LWgXmoZQ4
bMosUsFdZr/hUcBz/+pE8/CxExbDUrDywQlEu0zZmQHlYPrYCLTVFJ7qGHbFtLts
GH7nNQVQ68u7NR5uxQvgdl9U2d1k2mQO1jkGNwum/FyQQvt1JwF2Vo2fu3+n/W4=
=iPuN
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
