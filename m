From: Harald Welte <laforge@netfilter.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Tue, 23 Dec 2003 18:30:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031223173022.GA3879@obroa-skai.de.gnumonks.org>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> <plopm3zndjoexg.fsf@drizzt.kilobug.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Ga=EBl?= Le Mignot <kilobug@freesurf.fr>
Content-Disposition: inline
In-Reply-To: <plopm3zndjoexg.fsf@drizzt.kilobug.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2003 at 02:13:15PM +0100, Ga=EBl Le Mignot wrote:
> I've tested pom-ng on 2.6.0  with USAGI patch, the patch-o-matic seems
> to work, but the kernel doesn't compile (I put nearly all patches, and
> select M in the kernel config wherever it was possible):
>=20
>   CC      net/core/netfilter.o
> net/core/netfilter.c: In function `nf_log_register':
> net/core/netfilter.c:760: warning: implicit declaration of function `br_w=
rite_lock_bh'
> net/core/netfilter.c:760: error: `BR_NETPROTO_LOCK' undeclared (first use=
 in this function)
> net/core/netfilter.c:760: error: (Each undeclared identifier is reported =
only once
> net/core/netfilter.c:760: error: for each function it appears in.)
> net/core/netfilter.c:765: warning: implicit declaration of function `br_w=
rite_unlock_bh'
> net/core/netfilter.c: In function `nf_log_unregister':
> net/core/netfilter.c:770: error: `BR_NETPROTO_LOCK' undeclared (first use=
 in this function)
> make[3]: *** [net/core/netfilter.o] Error 1
>=20
>=20
> I think maybe some patches doesn't work with 2.6, would it possible to
> add a way to select patch that works with 2.6 ? like ./runme extra-2.6
> or such ?

yes, indeed.  There are numerous patches that would not work in the
2.6.x kernels.  They have yet to be identified.  Once they are
identified, we can put a special "requires" tag into the 'info' file of
those patches.

This way the 2.4 only patches would only be offered if you have a 2.4.x
kernel source (and vice-versa).

You could help us in finding out which patches compile and which ones
don't.

> --=20
> Gael Le Mignot "Kilobug" - kilobug@nerim.net - http://kilobug.free.fr

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6HutXaXGVTD0i/8RAjD2AKCgkfqMVhs+Cfu3SCwS3hxZWrG+IgCgkQR/
fFTziJ3Cqr7VPbgYQFwgypw=
=9wPN
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
