Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED82309EFB
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 16:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769618478; cv=none; b=JfYkzubNdTSSrn6G7oIuqoGYv6g05Q1hz2UKbWncbjdtf1kYqf4MenYUiQBo4w7qakEci7L0GAdS8e2OO/s38Wz7MGF/z0izPUYdb2mbInHbKtugox+Ae6fAGcMh92X2ehX0+kFs26T+4Sstdj0HJIXr7j2sinwJvlx+rAsFBV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769618478; c=relaxed/simple;
	bh=8i7L1bbXjn5/IEP8LvBjO2IZ3G/8BfQ4OaXEL/j+3h0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sa7n4MuAq3xxd4HMg1jkZWUDWMC9l+bzTToooyuvzWZDAlwAFFVbrmrqYMO6XWKiCYnAXrvuxopaf50KxGDNAK4uE3GVso6YdLYouIo/V4Ly/SXuvtlQJRNDog+lOnqN3A8Zoc7glFF93rvEzQ33NKfYq5cvCsYVQZNGCLb2uv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=hADbFeu6; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="hADbFeu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vk4SeS+QKmzYGyHrtTHuezKLjOP4gbEsMfE2/Puv/WQ=; b=hADbFeu6Yo3ER5amXdfAGhbKIH
	zwCaSQ0OQA3mVVGWEjPsBMRDcnvguSOzICvgs9LO3m5M3sKoNGGR4E1FRTyVZnM2WV/szw6SCBsCS
	0jzFj7l1TbEkbI1mo7jtyv8AK70ejS1xAV+DpvjuBS2cOsaXYx1L6X6Oc+AyYWV3a/XUMY06kX1Z+
	bqkYiOjyaUS9NtjopoSp6X95qUEK5JS2K+blZDTXOy5fKjJMDngGZaOhi4SvoFUNKnL609QhO1oCh
	1PSlK9fcT48f1ouvbaMaqqZ++tqDZc8n19n7ZkiaIZl7wu20M23FEb5ea8ou7AU6H4/hiJy3YzoMH
	dUgP2X6Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vl8bS-0000000CBcn-0d9P;
	Wed, 28 Jan 2026 16:41:14 +0000
Date: Wed, 28 Jan 2026 16:41:13 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Arnout Engelen <arnout@bzzt.net>, Philipp Bartsch <phil@grmr.de>
Subject: Re: [nft PATCH] configure: Generate BUILD_STAMP at configure time
Message-ID: <20260128164113.GC2884714@celephais.dreamlands>
References: <20260128145251.26767-1-phil@nwl.cc>
 <20260128151152.GB2884714@celephais.dreamlands>
 <aXo7Wvl0-TtCkVMH@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1Q/2x66+dBVH0CVV"
Content-Disposition: inline
In-Reply-To: <aXo7Wvl0-TtCkVMH@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--1Q/2x66+dBVH0CVV
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-01-28, at 17:37:46 +0100, Phil Sutter wrote:
> On Wed, Jan 28, 2026 at 03:11:52PM +0000, Jeremy Sowden wrote:
> > On 2026-01-28, at 15:52:51 +0100, Phil Sutter wrote:
> > >Several flaws were identified with the previous approach at generating
> > >the build timestamp during compilation:
> > >
> > >- Recursive expansion of the BUILD_STAMP make variable caused changing
> > >  values upon each gcc call
> > >- Partial recompiling could also lead to changing BUILD_STAMP values in
> > >  objects
> > >
> > >While it is possible to work around the above issues using simple
> > >expansion and a mandatorily recompiled source file holding the values,
> > >generating the stamp at configure time is a much simpler solution and
> > >deemed sufficient enough for the purpose.
> > >
> > >While at it:
> > >
> > >- Respect SOURCE_DATE_EPOCH environment variable to support reproducib=
le
> > >  builds, suggested by Philipp Bartsch
> > >- Guard the header against multiple inclusion, just in case
> > >
> > >Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
> > >Reported-by: Arnout Engelen <arnout@bzzt.net>
> > >Closes: https://github.com/NixOS/nixpkgs/issues/478048
> > >Sugested-by: Philipp Bartsch <phil@grmr.de>
> > >Cc: Jeremy Sowden <jeremy@azazel.net>
> > >Signed-off-by: Phil Sutter <phil@nwl.cc>
> > >---
> > > Makefile.am  |  2 --
> > > configure.ac | 16 ++++++++--------
> > > 2 files changed, 8 insertions(+), 10 deletions(-)
> > >
> > >diff --git a/Makefile.am b/Makefile.am
> > >index 5c7c197f43ca7..c60c2e63d5aff 100644
> > >--- a/Makefile.am
> > >+++ b/Makefile.am
> > >@@ -159,8 +159,6 @@ AM_CFLAGS =3D \
> > > 	\
> > > 	$(GCC_FVISIBILITY_HIDDEN) \
> > > 	\
> > >-	-DMAKE_STAMP=3D$(MAKE_STAMP) \
> > >-	\
> > > 	$(NULL)
> > >
> > > AM_YFLAGS =3D -d -Wno-yacc
> > >diff --git a/configure.ac b/configure.ac
> > >index dd172e88ca581..ff1d86213eb80 100644
> > >--- a/configure.ac
> > >+++ b/configure.ac
> > >@@ -152,20 +152,20 @@ AC_CONFIG_COMMANDS([stable_release],
> > >                    [stable_release=3D$with_stable_release])
> > > AC_CONFIG_COMMANDS([nftversion.h], [
> > > (
> > >+	echo "#ifndef NFTABLES_NFTVERSION_H"
> > >+	echo "#define NFTABLES_NFTVERSION_H"
> > >+	echo ""
> > > 	echo "static char nftversion[[]] =3D {"
> > > 	echo "	${VERSION}," | tr '.' ','
> > > 	echo "	${STABLE_RELEASE}"
> > > 	echo "};"
> > >-	echo "static char nftbuildstamp[[]] =3D {"
> > >-	for i in `seq 56 -8 0`; do
> > >-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
> > >-	done
> > >-	echo "};"
> > >+	printf "static char nftbuildstamp[[]] =3D { "
> > >+	printf "%.16x" "$(printenv SOURCE_DATE_EPOCH || date '+%s')" | \
> > >+		sed -e 's/\(..\)/0x\1, /g' -e 's/, $/ };\n/'
> > >+	echo ""
> > >+	echo "#endif /* NFTABLES_NFTVERSION_H */"
> > > ) >nftversion.h
> > > ])
> > >-# Current date should be fetched exactly once per build,
> > >-# so have 'make' call date and pass the value to every 'gcc' call
> > >-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > >
> > > AC_ARG_ENABLE([distcheck],
> > > 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> >
> > One other thing that I wondered about is why we are generating
> > nftversion.h like this.   How about the attached?
>=20
> Oh, much simpler. You wonder why I apparently reimplemented parts of
> autotools? The obvious answer is incompetence! ;)

:)

> Will you formally submit a patch?

Sure.

J.

--1Q/2x66+dBVH0CVV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpejwVCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmesmbmorqVUpWxef7w2/xeHVbTVmY4LoA/mh4+F/qI7
IRYhBGwdtFNj70A3vVbVFymGrAq98QQNAACrNA/+MGJYqiG9bJwEPA7cnoDBXIQy
6NBH8uPF+O2i+k3AfvzgEuGJKsA7mSCVK7l5FMTZT2Sdl1ERXdjGfjbj/eNNBCEq
FkK/80ICI8a3XfmVAuFYmhXxufewaqf1nMPN1jOXUFOBqwhT8KthLVHFPo3VkJ9q
fpLVuB0M/go26mgo52Q17LsOBxb8QDB9qCXJzE8vvuTMU5lE58CSaO9EOCfR/Wwf
mwBf0uWLCIHkMvqDjVdRkOp9Bqj2hlqQjnuNMxD/XrPslbRmqRMUjQr4WkzEeEQ2
gKgyfuXZEtJk13tOSEYF1N7ihb4QU8X466AccdXspall7H+dx1F1pTd97w0W6T/O
ahNMPTFj27m4CYKYhbCR5nMYPvdXtBCGaYc1NYg5nKzjYSGllUnLh9+YWttd5waQ
hZuAQQ3Ie7LHKNJPu+niihDL3xPbmtTVA9IJXFstEL8HlTL0iDS9qMJUAVQWpOzo
yaIoNrjy5BBTgBknvYPwV1SHmP/bcupoXrsrf8/BfezSgQZ7bf3Ap0YrzdalbPUR
QbsXlzWzv+XBGN7cJYiuJvBMbokDQKyAmT6rcBL68kg/pDSFjmqtntRdIZ2Kgj4d
eQwtMeRdOMqJ0HJPiLZSDbIA0HmyYncO8Jm9B8H+/8vCDggciC8Z8DtmjSn/MMF/
6vkOuN8V8eSdrlbKpzo=
=6TtD
-----END PGP SIGNATURE-----

--1Q/2x66+dBVH0CVV--
