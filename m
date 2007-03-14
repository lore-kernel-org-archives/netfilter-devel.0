From: Phil Dibowitz <phil@ipom.com>
Subject: Re: NFCT_Q_DUMP problem
Date: Wed, 14 Mar 2007 09:11:03 -0700
Message-ID: <45F81E97.7030903@ipom.com>
References: <45F4B34F.3020007@ipom.com>
	<45F527F2.40404@netfilter.org>	<45F6558A.2070601@ipom.com>
	<45F671CA.6010401@netfilter.org>	<45F7A20A.5050302@ipom.com>
	<45F7F5D6.8070904@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig7EFFCE37DF90215C42A1138D"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7F5D6.8070904@netfilter.org>
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
--------------enig7EFFCE37DF90215C42A1138D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> u_int8_t family =3D AF_INET;
> res =3D nfct_query(cth, NFCT_Q_DUMP, &family);

Whoops, thanks!

> I'm thinking about changing this to use va_list, thus not needing to
> pass &family which is a bit ugly. This is one of the minor nitpicks of
> the new API that I'd like to improve.
>=20
> BTW, when do you plan to release your application?

iptstate(8) is already a released and stable piece of software, but a whi=
le
back Harald Welte had mentioned I should port it from using
/proc/net/ip_conntrack to "ctnetlink". But at the time ctnetlink was neit=
her
a stable API nor a friendly API nor was it in any common distros.

However libnetfilter_conntrack is in many distros now and is cleaner and
easier to use, and is a (more?) stable API. So I decided to finally make =
the
switch.

As for when it'll get released... eh... few weeks? The port to the old AP=
I
is done, the port to the new API should be done the next time I have an h=
our
or so, and then I have a few new features pending for this release.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig7EFFCE37DF90215C42A1138D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+B6XN5XoxaHnMrsRAuygAJ9W4jwGDrTLV6tCI/slc8FGu8dlhQCggUyW
c4EUJ6qR1PI+2zQTRLNcVvQ=
=X0mk
-----END PGP SIGNATURE-----

--------------enig7EFFCE37DF90215C42A1138D--
