From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] iptables: update gitignore list
Date: Thu, 20 Aug 2015 08:21:09 -0400
Message-ID: <20150820122109.GE21236@vapier>
References: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
 <CAOkSjBgdJbigrwanoFOSfUzCt8gGLvyWHp0RoAqv9=YkWSq7Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbbHTMVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 08:21:11 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgdJbigrwanoFOSfUzCt8gGLvyWHp0RoAqv9=YkWSq7Gg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20 Aug 2015 13:46, Arturo Borrero Gonzalez wrote:
> On 20 August 2015 at 13:13, Mike Frysinger <vapier@gentoo.org> wrote:
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  include/linux/netfilter_ipv4/ip_tables.h | 2 +-
> >  iptables/.gitignore                      | 3 +++
> >  libiptc/libiptc.c                        | 4 +++-
> >  3 files changed, 7 insertions(+), 2 deletions(-)
>=20
> Perhaps this change doesn't belong to this patch:

yes, i did `git add` to extract the ignore, but then used -a w/commit
-mike

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV1cY1AAoJEEFjO5/oN/WBpvsQALajHxkbS/NmNplA1irY21H3
7P2MYZoUVQ8jZ1gJYSnLXEByuqXpmbHmmdxsZJpVJgM947Z18znNnQqVXo6y96MV
kyHImBwln3wz5qx0p88dByIBrMVRdWxXvyesp/lKBLRXyMhngGG1xl0i1p1auha7
g/zecQQb+LksDWxeT9g47brc81mzfK5ebTudeJgLINLnnGjBBofbsRzv2noxQ+mA
6u+BtnkJqrXUyz45HPPEP651xbS3EKyoh6O0f+SogNQWHVBk2SfTIHsQ/jepzHNc
hEBC1kYaY38jQpwRZ/5fl6hsn1LRLGSuPfqY/z5RUAELYm9CXcf3+PEFrlbgB8+6
OA/1MM2xX0IgqCgy88VQA3APGLkqpchyLad8+2eTUNr3RfLYliVPk3JwII6nihf5
OMVLBUdB66lDfZuhta50aJxLVJxAruu3SFrYKupT+QNwI5IGtOi6+P7A8Fdrb/FY
93TsEB6UFyaUJ0RxbuKWGm/H0eGZ+j9B6+FZHvIuPk74vVTY9CYRBdKI+fB/8eei
09nbkAKIONzMhqAa8hm8et2e/OKZekgPWoSIo/LRRKNlMTTsf8gNYv7UssoVLRVN
Aip7o55ht8DIkdSWmH6/Q51tQzpxdtb8TeF1FDvedQDU1wBaE6IZoklU6+hq2DZ4
uAfHXgA8ZCFBSIPhv3om
=Kl/Q
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
