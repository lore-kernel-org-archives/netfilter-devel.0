From: Phil Dibowitz <phil@ipom.com>
Subject: Re: NFCT_Q_DUMP problem
Date: Wed, 14 Mar 2007 17:54:40 -0700
Message-ID: <20070315005440.GC31683@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
	<45F7A20A.5050302@ipom.com> <45F89724.1080608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45F89724.1080608@trash.net>
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


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 2007 at 01:45:24AM +0100, Patrick McHardy wrote:
> Phil Dibowitz wrote:
> > So I sat down to write some test code today on the new API, and I found=
 all
> > the nice getter functions, which are awesome... but I can't seem to mak=
e the
> > new API work with NFCT_Q_DUMP. I shrunk down my test the bare minimum a=
nd
> > nfct_query *always* returns errno for "Address family not supported by
> > protocol" :(
> >=20
> > new_api_test.c doesn't test the NFCT_Q_DUMP query, so I'm wondering if =
it's
> > perhaps a problem in the NFCT_Q_DUMP query type.
> >=20
> > Here's some sample code:
> >=20
> > [phil@rider nftest]$ cat minitest.c
> > [...]
> >
> > When I run this I get:
> >   [phil@rider nftest]$ sudo ./minitest
> >   dump failed(-1): Address family not supported by protocol
>=20
>=20
> Works fine for me with latest libnfnetlink/libnetfilter_conntrack.

Pablo's email that I was calling nfct_query() wrong (the last arguement
changes depending on the 2nd arguement), was the problem. Once I fixed that,
it worked.

Thanks!

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+JlQN5XoxaHnMrsRAhKaAJ9vfYIQMPhjBMcMJ9bXZRX9FUK+XQCfcrAt
jVWajNkSTiw+p3NOq53AuRk=
=Ha/y
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
