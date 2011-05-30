From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning in Linus' tree
Date: Mon, 30 May 2011 11:43:33 +1000
Message-ID: <20110530114333.6aa13281.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_May_2011_11_43_33_+1000_PCpJtQVSRZ9Xlk63"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Signature=_Mon__30_May_2011_11_43_33_+1000_PCpJtQVSRZ9Xlk63
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
produced this warning:

net/ipv4/netfilter/nf_nat_standalone.c: In function 'nf_nat_fn':
net/ipv4/netfilter/nf_nat_standalone.c:119:2: warning: case value '4' not i=
n enumerated type 'enum ip_conntrack_info'
net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_tg':
net/ipv4/netfilter/ipt_CLUSTERIP.c:324:3: warning: case value '4' not in en=
umerated type 'enum ip_conntrack_info'

I am now using gcc v4.5.2.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_May_2011_11_43_33_+1000_PCpJtQVSRZ9Xlk63
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN4vZFAAoJEDMEi1NhKgbsZ0gH/0icvXHPifE7pBoUVkdbbZ01
vMyADneqGZv5HRWXTPR2UfU8MV7ghR2LOj+BWVd5EGLBoYJsaoEEHjpHCj6FGBON
1WP1yuIoNRyk1xcESbM+e6A6fTMiL9d/LcSAzDS9uC+8GYMz8+ZgGeI+oyvRSe2C
gUMvPkvAw9XHzrOvttaoeGTmZBfV33AtLq+U78u8S1lSWFOxtCi3sP0Adda8C1G3
KOdnFIounHezgVNxstArhbd+gSXK1qaoxiSd9n+f8eo20QTTNj5/949uA1Md0AeA
zmptwSleMfSm9Ka50EclZGaTOYxMS1GYjF6ZQzR2nCCeBn0+bOktBf5m0Wp282Q=
=6Q41
-----END PGP SIGNATURE-----

--Signature=_Mon__30_May_2011_11_43_33_+1000_PCpJtQVSRZ9Xlk63--
