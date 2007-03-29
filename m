From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Thu, 29 Mar 2007 15:12:20 -0700
Message-ID: <20070329221220.GC15170@ipom.com>
References: <45FF7A38.8090907@ipom.com> <460C382E.6020108@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <460C382E.6020108@netfilter.org>
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


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2007 at 12:05:34AM +0200, Pablo Neira Ayuso wrote:
> Sorry for the late reply.
>=20
> Phil Dibowitz wrote:
> > --- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_=
nfnetlink_conntrack.h.orig	2007-03-19 22:53:08.000000000 -0700
> > +++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_=
nfnetlink_conntrack.h	2007-03-19 22:53:30.000000000 -0700
> > @@ -2,6 +2,10 @@
> >  #define _IPCONNTRACK_NETLINK_H
> >  #include <libnfnetlink/linux_nfnetlink.h>
> > =20
> > +#ifdef __cplusplus
> > +extern "C" {
> > +#endif
> > +
>=20
> Do you really need to include the extern "C" in linux_nfnetlink_conntrack=
=2Eh?

I believe so, yes. The alternative is to put it around the #include of
linux_nfnetlink_conntrack.h inside of libnetfilter_conntrack.h, but that is=
n't
as clean and prevents anyone from using it directly. Anything in /usr/inclu=
de
is fair game for using in an #include, and thus should be extern-C-safe.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGDDnEN5XoxaHnMrsRAmgUAJwOB0DCAIKQx1mvbUeW50rPI8BQfgCfcNdS
K2YSpjDDVvXsW/+3GbyvoFQ=
=qLzN
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
