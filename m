Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7825B2690F9
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769611983; cv=none; b=IGDPgt+xi+5hZ7NX6QGozRFyZaJjshNOLx0xMTUf7ayFIslTtzwSaYtUCacXhY5Qpe7wT+JaXqHpabsrPB5X5EBrpSfIQfPGZizZveuq8zgYJsVpZAmpgPprUB8+hXhiOARyoVFybEgLgZG8vojGKguxlpZkQwPh/Xc/lqq0oMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769611983; c=relaxed/simple;
	bh=Zcy03AlI76qWuplBuG/Sx1U+9Bxo2nRoJVNz1LMUvHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OzbJJq4brvP+PtPXxmAdLeEIpdrRJ6GP99KMuRHHoL3Y0cLz/dV9VwF4StF65ZgBIDXkdIyB4459oHIPCufvVrynnF8C0fb85KMSYdnYEG2le2jf4Sy0HKNulaDg75hsz+P+mvurrpvlwhTVSbqh8z/IVhGxnqlr34cE9MrQrv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UH9PxZgJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UH9PxZgJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lATB8ZV0CeInglVimYJCLwigXJttHA4zUCXig8YHnqc=; b=UH9PxZgJgcAwj8rwMJy+lNrHRI
	u3T5gLz7jwV3dqlHbbCnU4w2Tq/dyfJ5K5vdXNJUKqaabwQuY6ZZVvq8yzQkSLt05sH0Bf18agGpK
	ZlYzS8cQ3zxqh0tjJRJUcEl0hNmLn7Km6eziXP4gL2GgnVtQfFHFNTfG3HQwyhp+k/ULuQkRBVw/o
	5n/2N1mtrnburw9QvxDO069USKwKemIurMdV4cG2DRmkDOX+okc0I1jDub4mI6MNEB5o01Lx17Pr/
	AgLoCY7TS3q4NjwI8D6sMeE1kt45gGbB+jRegd4uJDgNa/sij45jR6MaI7I0zhr8p2YRDc0kQO6Dt
	TvuzfRuw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vl6ue-000000006Qc-3o5j;
	Wed, 28 Jan 2026 15:52:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Arnout Engelen <arnout@bzzt.net>,
	Philipp Bartsch <phil@grmr.de>,
	Jeremy Sowden <jeremy@azazel.net>
Subject: [nft PATCH] configure: Generate BUILD_STAMP at configure time
Date: Wed, 28 Jan 2026 15:52:51 +0100
Message-ID: <20260128145251.26767-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several flaws were identified with the previous approach at generating
the build timestamp during compilation:

- Recursive expansion of the BUILD_STAMP make variable caused changing
  values upon each gcc call
- Partial recompiling could also lead to changing BUILD_STAMP values in
  objects

While it is possible to work around the above issues using simple
expansion and a mandatorily recompiled source file holding the values,
generating the stamp at configure time is a much simpler solution and
deemed sufficient enough for the purpose.

While at it:

- Respect SOURCE_DATE_EPOCH environment variable to support reproducible
  builds, suggested by Philipp Bartsch
- Guard the header against multiple inclusion, just in case

Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
Reported-by: Arnout Engelen <arnout@bzzt.net>
Closes: https://github.com/NixOS/nixpkgs/issues/478048
Sugested-by: Philipp Bartsch <phil@grmr.de>
Cc: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am  |  2 --
 configure.ac | 16 ++++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 5c7c197f43ca7..c60c2e63d5aff 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -159,8 +159,6 @@ AM_CFLAGS = \
 	\
 	$(GCC_FVISIBILITY_HIDDEN) \
 	\
-	-DMAKE_STAMP=$(MAKE_STAMP) \
-	\
 	$(NULL)
 
 AM_YFLAGS = -d -Wno-yacc
diff --git a/configure.ac b/configure.ac
index dd172e88ca581..ff1d86213eb80 100644
--- a/configure.ac
+++ b/configure.ac
@@ -152,20 +152,20 @@ AC_CONFIG_COMMANDS([stable_release],
                    [stable_release=$with_stable_release])
 AC_CONFIG_COMMANDS([nftversion.h], [
 (
+	echo "#ifndef NFTABLES_NFTVERSION_H"
+	echo "#define NFTABLES_NFTVERSION_H"
+	echo ""
 	echo "static char nftversion[[]] = {"
 	echo "	${VERSION}," | tr '.' ','
 	echo "	${STABLE_RELEASE}"
 	echo "};"
-	echo "static char nftbuildstamp[[]] = {"
-	for i in `seq 56 -8 0`; do
-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
-	done
-	echo "};"
+	printf "static char nftbuildstamp[[]] = { "
+	printf "%.16x" "$(printenv SOURCE_DATE_EPOCH || date '+%s')" | \
+		sed -e 's/\(..\)/0x\1, /g' -e 's/, $/ };\n/'
+	echo ""
+	echo "#endif /* NFTABLES_NFTVERSION_H */"
 ) >nftversion.h
 ])
-# Current date should be fetched exactly once per build,
-# so have 'make' call date and pass the value to every 'gcc' call
-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
 
 AC_ARG_ENABLE([distcheck],
 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
-- 
2.51.0

