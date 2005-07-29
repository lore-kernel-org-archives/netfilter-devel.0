From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH 3/3] pom-ng: update sip-conntrack-nat for 2.6.12
Date: Fri, 29 Jul 2005 18:46:41 +0200
Message-ID: <20050729164641.GA4133@zion.homelinux.com>
References: <20050726190519.GA2128@zion.homelinux.com>
	<20050729105612.GC7063@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050729105612.GC7063@rama.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Harald,

On Fri, Jul 29, 2005 at 12:56:12PM +0200, Harald Welte told us:
> the changes are non-intrusive and only affect changing from lockhelp
> macros to regular locking functions.  I don't see how those four changed
> lines would create a bug.

of course, but who nows :-)

>=20
> btw: if you do any future merges (2.6.13 and beyond have yet another
> change in the helper api...), please just send me an incremental diff to
> the last version in patch-o-matic-ng (e.g. to 2.6.12 in the 2.6.13
> case).

alright, I'll do so!!


Thanks,

Sven

>=20
> I will make a 'svn cp' of the 2.6.12 code and then apply your diff on
> top of it.  Right now I have to do 'svn cp', apply your patch to some
> other location, copy the files over, and then do 'svn diff' in order to
> see what you actually changed.
>=20
> thanks!
> --=20
> - Harald Welte <laforge@netfilter.org>                 http://netfilter.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie



--=20
Linux zion 2.6.13-rc3-mm1 #17 PREEMPT Thu Jul 28 02:56:37 CEST 2005 i686 at=
hlon i386 GNU/Linux
 18:44:59 up 1 day, 15:44,  3 users,  load average: 0.27, 0.09, 0.03

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC6l1xo4FAdB2PneQRAqMNAJ0TiNCQ61NGeAeudbCMEIxUAeJ0RwCfWWTP
mgCbq4oYjc+lwYj6bR7gtCM=
=siMK
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
