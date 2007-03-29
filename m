From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Thu, 29 Mar 2007 16:11:03 -0700
Message-ID: <20070329231103.GD15170@ipom.com>
References: <45FF7A38.8090907@ipom.com> <460C382E.6020108@netfilter.org>
	<20070329221220.GC15170@ipom.com> <460C3F45.4040406@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <460C3F45.4040406@netfilter.org>
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


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2007 at 12:35:49AM +0200, Pablo Neira Ayuso wrote:
> Phil Dibowitz wrote:
> > On Fri, Mar 30, 2007 at 12:05:34AM +0200, Pablo Neira Ayuso wrote:
> >> Do you really need to include the extern "C" in linux_nfnetlink_conntr=
ack.h?
> >=20
> > I believe so, yes. The alternative is to put it around the #include of
> > linux_nfnetlink_conntrack.h inside of libnetfilter_conntrack.h, but tha=
t isn't
> > as clean and prevents anyone from using it directly. Anything in /usr/i=
nclude
> > is fair game for using in an #include, and thus should be extern-C-safe.
>=20
> Applied. Thanks Phil.
>=20
> BTW, got no reply on my suggestion about your project name. Thoughts?

While I understand the point you were making, my project has been around for
years - I'm not renaming it. That'll cause more confusion than anything els=
e,
IMO. It's in all major distros and many people are well acquanted with what
the software is and is not...

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGDEeHN5XoxaHnMrsRAlceAJ9VmOVo2hSFwFcIpjVBCkk/e5o0hwCfcpRR
RC77BTC3hX5Tgm5ADG4RXpA=
=tIeH
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
