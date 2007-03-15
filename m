From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack.h missing struct nf_conntrack definition
Date: Wed, 14 Mar 2007 22:25:40 -0700
Message-ID: <45F8D8D4.7000909@ipom.com>
References: <20070314222130.GB31683@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB69FAF1034873CA6F5ABAFCF"
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314222130.GB31683@ipom.com>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB69FAF1034873CA6F5ABAFCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Phil Dibowitz wrote:
> None of the libnetfilter_conntrack's "public" headers include the full
> definition of struct nf_conntrack.
>=20
> It's not a 'private' structure (__*), thought it uses private structure=
s
> within it...  This means I can't do things like memcpy() them, sizeof()=
 them,
> or even build an STL vector of them (yeah, I know, ew, yuck, c++).
>=20
> Since nf_conntrack structs are passed around to the applications using =
nfct,
> it seems reasonable to desire to do things with them.

Looks like this was sorta thought of. Apparently you can return
NFCT_CB_STOLEN which will cause it to not be freed. I can then keep point=
ers
to the object rather than the object itself...

Oh well - I already restructured my code to get around this. :)

So you can ignore the original email.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigB69FAF1034873CA6F5ABAFCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+NjUN5XoxaHnMrsRArIqAJ0Zwk/TnA7jEerjxYD8GLs/5jEjBACeNm+T
kXHgCgCQnf68KanldC5qJio=
=HFRg
-----END PGP SIGNATURE-----

--------------enigB69FAF1034873CA6F5ABAFCF--
