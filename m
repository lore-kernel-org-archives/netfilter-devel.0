Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF992F6930
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769716724; cv=none; b=VtWEIUDdQbnRjR+Ycc9jS8quoZ8WaxvSU0hyfpBFAnLH2nvs1tvdnNgMK8maBqGEVUOIzrLtooyZTREyPw+HXJTCTHuHMufdI6aaVLA0qfqtVaVlyXLzmr+pHw8oTzoldmDDQMracX2S0PO6pnmjkEDLNiGeIJyFa7LGwPMb9mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769716724; c=relaxed/simple;
	bh=90kTMHxjntqj1ddOqhcIRhP65+ZZlKaWJbLTxlEjnmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=djnV5MsLLLqQdVCrGOfq84FKOvZPKWCtyKL0/QCyMmc2klrE8Ut/PXsJAOn3/3+1OFBi2ydKImxeItsXpDvf0e4B9+U62+bvtif9Xque4NynydeS1yHYS33S5/pQsEOQeIDMd9OYRYcq2ObW5pfU1n0DTD7SDsNwDteG+nl5JPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ByoxWPev; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ByoxWPev"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fhhYbGyjz+mjuuCgB6ElvpYY4d+1yNj+iWWpDc2nrks=; b=ByoxWPevA6HkcX4Lj4ybQ7pSCF
	hO1ZRjLYftbbbX7MPqKIQ8gE84Glk71oBKIo8WhH4kmoVfb+r+htqBDL5Bq0iIL3W9yMiI5FvSasc
	gkF2idchWqXJjYeRG+2xW2YvCuXTf+Ucpv7HL2879ZJFPbKabZDUV20vfV6JwKy2U68YDYpJccQ2z
	abGIufWnavgei374813Mq6l1dBE9WTMVhJ/IrRJqA4BxaAPbakFJcIiD4ogsRR5ZNNa9b3eTPOSES
	LAAVfebLklYIZdUiRZwypciYY3uvPwG4Xy+TcjSI5+x0gfErk2FdHI6zNib7J7Zft9ooYbBQkvqrl
	5yqE8EmQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlYA5-000000000W0-2rtO;
	Thu, 29 Jan 2026 20:58:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] configure: Auto-detect libz unless explicitly requested
Date: Thu, 29 Jan 2026 20:58:36 +0100
Message-ID: <20260129195836.13988-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If user did not pass --with-zlib and it is not available, simply turn
off rule compat expression compression. It is not strictly necessary and
users may not care.

While at it, drop the conditional AC_DEFINE() call: In fact,
AC_CHECK_LIB() does that already.

Fixes: ff5f6a208efcc ("nft-ruleparse: Fallback to compat expressions in userdata")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac          | 9 +++++----
 iptables/nft-compat.c | 6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index d42588c8a4b6d..2a8abf21b98c5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -79,11 +79,12 @@ AC_ARG_ENABLE([profiling],
 	[enable_profiling="$enableval"], [enable_profiling="no"])
 AC_ARG_WITH([zlib], [AS_HELP_STRING([--without-zlib],
 	    [Disable payload compression of rule compat expressions])],
-           [], [with_zlib=yes])
+           [], [with_zlib=check])
 AS_IF([test "x$with_zlib" != xno], [
        AC_CHECK_LIB([z], [compress], ,
-		    AC_MSG_ERROR([No suitable version of zlib found]))
-       AC_DEFINE([HAVE_ZLIB], [1], [Define if you have zlib])
+		    [if test "x$with_zlib" != xcheck; then
+			AC_MSG_ERROR([No suitable version of zlib found])
+		     fi; with_zlib=no])
 ])
 
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
@@ -297,7 +298,7 @@ echo "
   nftables support:			${enable_nftables}
   connlabel support:			${enable_connlabel}
   profiling support:			${enable_profiling}
-  compress rule compat expressions:	${with_zlib}
+  compress rule compat expressions:	${with_zlib/check/yes}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
diff --git a/iptables/nft-compat.c b/iptables/nft-compat.c
index 632733ca0cade..dfcc05b89856a 100644
--- a/iptables/nft-compat.c
+++ b/iptables/nft-compat.c
@@ -16,7 +16,7 @@
 #include <string.h>
 #include <xtables.h>
 
-#ifdef HAVE_ZLIB
+#ifdef HAVE_LIBZ
 #include <zlib.h>
 #endif
 
@@ -64,7 +64,7 @@ pack_rule_udata_ext_data(struct rule_udata_ext *rue,
 			 const void *data, size_t datalen)
 {
 	size_t datalen_out = datalen;
-#ifdef HAVE_ZLIB
+#ifdef HAVE_LIBZ
 	compress(rue->data, &datalen_out, data, datalen);
 	rue->flags |= RUE_FLAG_ZIP;
 #else
@@ -144,7 +144,7 @@ __nftnl_expr_from_udata_ext(struct rule_udata_ext *rue, const void *data)
 static struct nftnl_expr *
 nftnl_expr_from_zipped_udata_ext(struct rule_udata_ext *rue)
 {
-#ifdef HAVE_ZLIB
+#ifdef HAVE_LIBZ
 	uLongf datalen = rue->orig_size;
 	struct nftnl_expr *expr = NULL;
 	void *data;
-- 
2.51.0

