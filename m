From: Harald Welte <laforge@gnumonks.org>
Subject: Re: nf/ctnetlink and notify
Date: Tue, 21 Jan 2003 11:01:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121100137.GM15225@sunbeam.de.gnumonks.org>
References: <20030120171129.GB27847@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTLCc13+3hfAZ6SL"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030120171129.GB27847@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HTLCc13+3hfAZ6SL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2003 at 06:11:29PM +0100, Kovacs Krisztian wrote:
>=20
>   Hi,
>=20
>   I'd have a question regarding the nfnetlink/ctnetlink patch in the
> 'extra' suite of POM. In this version of nfnetlink, the notify callback
> API is missing (ip_conntrack_notify_register() and friends), while in the
> old version in the oldnat directory it is part of the ctnetlink patch. Why
> was this left out of the patch?=20

because I wanted to have a minimum subset of the functionality first.  A
subset that doesn't require adding any API to the conntrack core.  As
you may have noticed, with recent newnat-enabled kernels, nfnetlink is
totally self-contained.

> What are the main concerns with the _notify() code in the old patch?

It's quite some time ago.  I don't even  remember what the case was.
But there was something (sorry...)

>   As I can see some kind of such notification service will be required to
> complete the nfnetlink patch, because in its current state it's totally
> uncapable of sending messages on conntrack state changes.=20

True.  This is one of the first issues on my TODO after iptables-1.2.8
is released and some of the bugzilla bugs are closed.

> (And one possible typo in the patch: in nfnetlink_conntrack.c
> ctnetlink_create is not commented out, but there is no use of this
> function.)

I'm aware of that, thanks.

>  Kov=E1cs Kriszti=E1n

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--HTLCc13+3hfAZ6SL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+LRqBXaXGVTD0i/8RAtlhAKCRMjMLQVIOvvXjRLmet4AYANKgLwCgnxQG
nM1pexAMH4O95Q3BWjk0ZS8=
=/bqA
-----END PGP SIGNATURE-----

--HTLCc13+3hfAZ6SL--
