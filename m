From: Harald Welte <laforge@netfilter.org>
Subject: Re: Newbie Question: Locking in Netfilter hook module?
Date: Mon, 14 Jul 2003 09:47:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714074724.GC6538@naboo>
References: <20030711085849.10325.qmail@web10902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ned Ren <nedren@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030711085849.10325.qmail@web10902.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2003 at 01:58:49AM -0700, Ned Ren wrote:
> Hi,=20
>=20
> This maybe a silly question. I'm wondering for hook modules that I
> write for netfilter, is it necessary to do locking (critical section)
> when accessing my own global structures?=20

Yes, it is always necessarry to lock your global structures.  All of
netfilter is running in softirq context.

> This is regarding SINGLE CPU systems, is there anything that would
> preempt my module while it's at it such as interrupt etc?

hard interrupts can always interrupt a softirq - but a softirq doesn't
interrupt another softirq (on single cpu).

However, all kernel code _has_ to be SMP safe.

> Thank you!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/EmALXaXGVTD0i/8RAjLmAJ4wdmYdfKUuI1398aY3ZfOXQoh9pwCfXwM4
Qr6gaFjru8TlHSUTvh6c8gw=
=mHNh
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
