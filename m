Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ACB369220
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613116; cv=none; b=QOmKw0ZoHFdY7MNCa+TxNSZfEQJFvuFGP98Rd9JO0Mexd60pCbLCh37U2tcUvCoy5TcMLzhQdJsLvg0RfJA7IvAw2IJX7LLD7V/T2WSNBHtMVLGMQXHVXTNl44ytwkFK0RTtuiWRXlp3zraeI98DDG34l8ks15V5UT6NJXwFFKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613116; c=relaxed/simple;
	bh=5nITQj3FMsJs0MJrjGN2itWixeEtuFjIfFtvc1fPMus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9mpsqKfFY/0Fvhm/ffzF8rYswlVeLZrxYfeZ4pHCHgITXSCeC2neTA7eldrpZYJtvr23Tc5mYITqipiO43LEkUWuEMefZq6at6P6ZAG2yC3vvsP3TqrneDlbXWSNo7qie2bWaSCM6GyobB/s46ncjIJ9smXBXpSNHNwmn2tSDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=amnHPD7i; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="amnHPD7i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MSv/sT6ByKK1WyJdqD9Q00I98iXeP6GbjBxX9cwA8pg=; b=amnHPD7iEBtCSt98xzvuIIUfFD
	fpWscf+/uRtljvZd1+L8/ZrZwRBRBeT95sQU93kRfHto1tT4w2o1WxYApxNijjy6IJW7Qz/+QDuUi
	agQDF0ZLFTzGcR5vkaHn4nTN4K8aATnBtXR6RpePVBFaICv0v5i09ThnMFiaLb3yNYeXmkhVU+EOr
	26yJ8/cY9gKOleR1pLQvlT+MK2DR07OxqxMgALxMWZLoXCxhMjMvPruWqE5menCn7izuuM5HuF/ZW
	kMeGybNMhGCTFa4RBmlaPRP5ZHHtT2HTj/uIr3cJ00buWF6Oi64S+ONHuHiEBngk2WC9Ho07RmVPC
	gN6v5SVQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vl7Cz-0000000CArS-1Lq2;
	Wed, 28 Jan 2026 15:11:53 +0000
Date: Wed, 28 Jan 2026 15:11:52 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Arnout Engelen <arnout@bzzt.net>, Philipp Bartsch <phil@grmr.de>
Subject: Re: [nft PATCH] configure: Generate BUILD_STAMP at configure time
Message-ID: <20260128151152.GB2884714@celephais.dreamlands>
References: <20260128145251.26767-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZDrgvVd8mOfUENJT"
Content-Disposition: inline
In-Reply-To: <20260128145251.26767-1-phil@nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--ZDrgvVd8mOfUENJT
Content-Type: multipart/mixed; boundary="y/vVfI+RwF2FKJhA"
Content-Disposition: inline


--y/vVfI+RwF2FKJhA
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2026-01-28, at 15:52:51 +0100, Phil Sutter wrote:
>Several flaws were identified with the previous approach at generating
>the build timestamp during compilation:
>
>- Recursive expansion of the BUILD_STAMP make variable caused changing
>  values upon each gcc call
>- Partial recompiling could also lead to changing BUILD_STAMP values in
>  objects
>
>While it is possible to work around the above issues using simple
>expansion and a mandatorily recompiled source file holding the values,
>generating the stamp at configure time is a much simpler solution and
>deemed sufficient enough for the purpose.
>
>While at it:
>
>- Respect SOURCE_DATE_EPOCH environment variable to support reproducible
>  builds, suggested by Philipp Bartsch
>- Guard the header against multiple inclusion, just in case
>
>Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
>Reported-by: Arnout Engelen <arnout@bzzt.net>
>Closes: https://github.com/NixOS/nixpkgs/issues/478048
>Sugested-by: Philipp Bartsch <phil@grmr.de>
>Cc: Jeremy Sowden <jeremy@azazel.net>
>Signed-off-by: Phil Sutter <phil@nwl.cc>
>---
> Makefile.am  |  2 --
> configure.ac | 16 ++++++++--------
> 2 files changed, 8 insertions(+), 10 deletions(-)
>
>diff --git a/Makefile.am b/Makefile.am
>index 5c7c197f43ca7..c60c2e63d5aff 100644
>--- a/Makefile.am
>+++ b/Makefile.am
>@@ -159,8 +159,6 @@ AM_CFLAGS = \
> 	\
> 	$(GCC_FVISIBILITY_HIDDEN) \
> 	\
>-	-DMAKE_STAMP=$(MAKE_STAMP) \
>-	\
> 	$(NULL)
>
> AM_YFLAGS = -d -Wno-yacc
>diff --git a/configure.ac b/configure.ac
>index dd172e88ca581..ff1d86213eb80 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -152,20 +152,20 @@ AC_CONFIG_COMMANDS([stable_release],
>                    [stable_release=$with_stable_release])
> AC_CONFIG_COMMANDS([nftversion.h], [
> (
>+	echo "#ifndef NFTABLES_NFTVERSION_H"
>+	echo "#define NFTABLES_NFTVERSION_H"
>+	echo ""
> 	echo "static char nftversion[[]] = {"
> 	echo "	${VERSION}," | tr '.' ','
> 	echo "	${STABLE_RELEASE}"
> 	echo "};"
>-	echo "static char nftbuildstamp[[]] = {"
>-	for i in `seq 56 -8 0`; do
>-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
>-	done
>-	echo "};"
>+	printf "static char nftbuildstamp[[]] = { "
>+	printf "%.16x" "$(printenv SOURCE_DATE_EPOCH || date '+%s')" | \
>+		sed -e 's/\(..\)/0x\1, /g' -e 's/, $/ };\n/'
>+	echo ""
>+	echo "#endif /* NFTABLES_NFTVERSION_H */"
> ) >nftversion.h
> ])
>-# Current date should be fetched exactly once per build,
>-# so have 'make' call date and pass the value to every 'gcc' call
>-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
>
> AC_ARG_ENABLE([distcheck],
> 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),

One other thing that I wondered about is why we are generating
nftversion.h like this.   How about the attached?

J.

--y/vVfI+RwF2FKJhA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nft-configure-make-stamp.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile.am b/Makefile.am
index b134330d5ca2..ceb222578f93 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -159,8 +159,6 @@ AM_CFLAGS =3D \
 	\
 	$(GCC_FVISIBILITY_HIDDEN) \
 	\
-	-DMAKE_STAMP=3D$(MAKE_STAMP) \
-	\
 	$(NULL)
=20
 AM_YFLAGS =3D -d -Wno-yacc
diff --git a/configure.ac b/configure.ac
index dd172e88ca58..ba936a42febd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -147,25 +147,9 @@ AM_CONDITIONAL([BUILD_SERVICE], [test "x$unitdir" !=3D=
 x])
 AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
             [Stable release number])],
             [], [with_stable_release=3D0])
-AC_CONFIG_COMMANDS([stable_release],
-                   [STABLE_RELEASE=3D$stable_release],
-                   [stable_release=3D$with_stable_release])
-AC_CONFIG_COMMANDS([nftversion.h], [
-(
-	echo "static char nftversion[[]] =3D {"
-	echo "	${VERSION}," | tr '.' ','
-	echo "	${STABLE_RELEASE}"
-	echo "};"
-	echo "static char nftbuildstamp[[]] =3D {"
-	for i in `seq 56 -8 0`; do
-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
-	done
-	echo "};"
-) >nftversion.h
-])
-# Current date should be fetched exactly once per build,
-# so have 'make' call date and pass the value to every 'gcc' call
-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
+AC_SUBST([STABLE_RELEASE],[$with_stable_release])
+AC_SUBST([NFT_VERSION], [$(echo "${VERSION}" | tr '.' ',')])
+AC_SUBST([MAKE_STAMP], [${SOURCE_DATE_EPOCH:-$(date +%s)}])
=20
 AC_ARG_ENABLE([distcheck],
 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
@@ -175,6 +159,7 @@ AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distc=
heck" =3D "xyes"])
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
+		nftversion.h                            \
 		])
 AC_OUTPUT
=20
diff --git a/nftversion.h.in b/nftversion.h.in
new file mode 100644
index 000000000000..92e8ca1d53cf
--- /dev/null
+++ b/nftversion.h.in
@@ -0,0 +1,21 @@
+#ifndef NFTVERSION_H_INCLUDED
+#define NFTVERSION_H_INCLUDED
+
+#define MAKE_STAMP @MAKE_STAMP@
+
+static char nftversion[] =3D {
+	@NFT_VERSION@,
+	@STABLE_RELEASE@
+};
+static char nftbuildstamp[] =3D {
+	((uint64_t)MAKE_STAMP >> 56) & 0xff,
+	((uint64_t)MAKE_STAMP >> 48) & 0xff,
+	((uint64_t)MAKE_STAMP >> 40) & 0xff,
+	((uint64_t)MAKE_STAMP >> 32) & 0xff,
+	((uint64_t)MAKE_STAMP >> 24) & 0xff,
+	((uint64_t)MAKE_STAMP >> 16) & 0xff,
+	((uint64_t)MAKE_STAMP >> 8) & 0xff,
+	((uint64_t)MAKE_STAMP >> 0) & 0xff,
+};
+
+#endif /* !defined(NFTVERSION_H_INCLUDED) */

--y/vVfI+RwF2FKJhA--

--ZDrgvVd8mOfUENJT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpeic3CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmf/ccEQBCRYuP6IjRk+Ii4mU1sCCRtay5oDj5cNU9gd
cBYhBGwdtFNj70A3vVbVFymGrAq98QQNAACY6A//dbFFjSUDpB/9F5zOnYZfMttN
OtBTdECE85Lz2/mcp0sGSBjSBVKJKBKBaNCQ4WnbLX8D/t7/xaYirJSmrvGB9yhO
S1jX4JtDnZCYzFS23RfybLYxjpXtK17cZ0Vds8Spjv/K+OhJ6hP+0/pmf5tvhisz
QJ4C7Ti6SLXGeo0WwYCp5oPNLdgYdSa7RKBpzxF/m1awwodV3Ba7/sjlgllpBFmn
XhI71KQryYFPKPp2gX8U5iMNxvtg858P8tNiW9yIWTPjHo2MMCvS1wbrKNkfE/FS
WetZDLFWBwbuXzWXq8iOuNVA56oB3eMMXaC0yYsnZuywMPkPdWmyEVIRVX0pRhGo
VYz92O4fyd4MXaqFI8uIHLA8SvBOXE7Ntc6Jr8DfbepRw1IvPe/dRND/MwTYh3Zq
nuf4v6XFD6S9kzStE5J3tOKbbsJTp4xWLVb+VxTiuUBxwkl90jkbNT2o3CcMkMUt
jX+oWb9kTyUGNwaHioNYaAO7Dbm+0QSE6Z+KAOp8OzMHpzwZMKo0FgStEwzg0nJq
HS4Ux+TbArhOOmD2rcGXO1tdACaxEVldZQfpkqp+VutcvyU7xLUHxFXUnk3VnMxq
e7dDBPTBLYxersgYeKvcoPt8hBogAO2tVLY8QFK7gKrS+0A0ieTRuixASSv3LfPV
QruYrXUstu6W77Wf4s4=
=bOR4
-----END PGP SIGNATURE-----

--ZDrgvVd8mOfUENJT--
