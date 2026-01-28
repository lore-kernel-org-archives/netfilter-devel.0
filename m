Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41858302779
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625075; cv=none; b=RuXIPvPoIh6QCTL4E2JhgeYq2oTB4ovkpvwR04ykSGhdAsr6a4gbLQOljXVx8p7k2EoCsVZHy2zobrHyd0CeKYiSIEwYXPE5pDjaJoFeNw8xhyitxgLUrz8VbtGbCY+dZ4OIJehxbfdkiQ3nES23nyU3CBVkYtkH0Fks7DxYU54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625075; c=relaxed/simple;
	bh=iAMZOw2U0vJux5X/wz8ZqA0f/0QM2+W64ME+NVPBIqU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YNlTR8njNcX1h+5Yv8i0CsaRIBnBasuA5QOeL/BUe+B+DUz7adYzNo6PzZdXtWaFRkHAaEGwgLZ+RDpqtOlgfAMHOpr3stkt8fKgP8IUDSNyi+xM5PIIimS5aMmYVxQxVxYZucS+ESn0PdrfoKmSqZMCFN7AuFlOxLAbGfeHXoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=pI8ds2ic; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="pI8ds2ic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tOFCy1WlRk3fflaZumni+FFV8DBiCcZ5BRH2NSOsPNw=; b=pI8ds2icQedMo+hQlY3ZXvG64s
	zJqPHQSzZlP4Yh7iH3PZsMlgexCnOUX6t1xDuOg98hsXf62FZY7UR74YS6TIPKQUkiq+gz6JxTeXV
	CLtiKimKjSZs61W5qf3TI22rowX1NSM8wjGyU/N5vEQdspnmSxLgMgTWPQxcRiYAFOHYEcAXNVhY1
	88Ms5shhcLtFfAQW4KgyrsNL0qGcF1aqjGxhhHHx8IrB3dLQ/LILHq+Kh/lp4XNBOYvXOUoh4g95W
	tS53KCl9EqPIKzqJk1TetFCvlH7Ap+1UhGC0tuHpSU7uxZYL3zkm+tksIqNvjNwvBVTeDMAq20WYE
	3QKXzi/w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vlAJt-0000000CCaf-013Z
	for netfilter-devel@vger.kernel.org;
	Wed, 28 Jan 2026 18:31:13 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 1/3] build: simplify the instantation of nftversion.h
Date: Wed, 28 Jan 2026 18:31:05 +0000
Message-ID: <20260128183107.215838-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Add an nftversion.h.in autoconf input file which configure uses to instantiate
nftversion.h in the usual way.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac    | 19 +++----------------
 nftversion.h.in | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+), 16 deletions(-)
 create mode 100644 nftversion.h.in

diff --git a/configure.ac b/configure.ac
index dd172e88ca58..2c61072e0682 100644
--- a/configure.ac
+++ b/configure.ac
@@ -147,22 +147,8 @@ AM_CONDITIONAL([BUILD_SERVICE], [test "x$unitdir" != x])
 AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
             [Stable release number])],
             [], [with_stable_release=0])
-AC_CONFIG_COMMANDS([stable_release],
-                   [STABLE_RELEASE=$stable_release],
-                   [stable_release=$with_stable_release])
-AC_CONFIG_COMMANDS([nftversion.h], [
-(
-	echo "static char nftversion[[]] = {"
-	echo "	${VERSION}," | tr '.' ','
-	echo "	${STABLE_RELEASE}"
-	echo "};"
-	echo "static char nftbuildstamp[[]] = {"
-	for i in `seq 56 -8 0`; do
-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
-	done
-	echo "};"
-) >nftversion.h
-])
+AC_SUBST([STABLE_RELEASE],[$with_stable_release])
+AC_SUBST([NFT_VERSION], [$(echo "${VERSION}" | tr '.' ',')])
 # Current date should be fetched exactly once per build,
 # so have 'make' call date and pass the value to every 'gcc' call
 AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
@@ -175,6 +161,7 @@ AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
+		nftversion.h                            \
 		])
 AC_OUTPUT
 
diff --git a/nftversion.h.in b/nftversion.h.in
new file mode 100644
index 000000000000..6f897719d005
--- /dev/null
+++ b/nftversion.h.in
@@ -0,0 +1,19 @@
+#ifndef NFTABLES_NFTVERSION_H
+#define NFTABLES_NFTVERSION_H
+
+static char nftversion[] = {
+	@NFT_VERSION@,
+	@STABLE_RELEASE@
+};
+static char nftbuildstamp[] = {
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
+#endif /* !defined(NFTABLES_NFTVERSION_H) */
-- 
2.51.0

