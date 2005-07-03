From: Harald Welte <laforge@netfilter.org>
Subject: Re: svn diff for Legato NetWorker RPC/RSH modules
Date: Sun, 3 Jul 2005 16:02:50 +0200
Message-ID: <20050703140250.GC3186@sunbeam.de.gnumonks.org>
References: <42C7DEAD.4010209@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXE3caftPhBF8dmD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Stes <stes@pandora.be>
Content-Disposition: inline
In-Reply-To: <42C7DEAD.4010209@pandora.be>
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


--MXE3caftPhBF8dmD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 03, 2005 at 02:48:45PM +0200, David Stes wrote:
>=20
> Hello,
>=20
> Here is the result of a "svn diff" for some changes to the "patch-o-matic=
-ng" .
>=20
> These changes are for using the RPC/RSH modules for Legato NetWorker traf=
fic=20
> over a netfilter firewall.
>=20
> Is it please possible to commit this diff ?

yes, but it would be applied by one of the coreteam members (such as me)

> When I try to commit the changes myself, I get a "Forbidden" (permission=
=20
> denied).

well, obviously we don't let everybody commit to our repositories ;)
What would you think if everyone could change the code of your packet
filter?

> Here is the DIFF :

it's garbled, probably by your mailer.  please re-send as a MIME
attachment.  thanks!
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MXE3caftPhBF8dmD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCx/AKXaXGVTD0i/8RAqxjAJ9/QbnYsSO4AwVcPgUxa307mh/DBwCghYsR
jKZxrnBQZl660qgFPxrU7NA=
=TYbV
-----END PGP SIGNATURE-----

--MXE3caftPhBF8dmD--
