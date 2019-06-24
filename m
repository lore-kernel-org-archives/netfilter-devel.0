Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA60FC48BD3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4A9A20663
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 22:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfFXWQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:16:51 -0400
Received: from a3.inai.de ([88.198.85.195]:53230 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbfFXWQu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 18:16:50 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id 6F1FD25EAAF3; Tue, 25 Jun 2019 00:16:48 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id D99F63BB696A;
        Tue, 25 Jun 2019 00:16:45 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/3] build: unbreak non-functionality of --disable-python
Date:   Tue, 25 Jun 2019 00:16:43 +0200
Message-Id: <20190624221645.28591-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---
 configure.ac | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 75cf919..b71268e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,11 +103,14 @@ AC_ARG_WITH([python_bin],
 	   )
 
 AS_IF([test "x$PYTHON_BIN" = "x"], [
-	AS_IF([test "x$enable_python" = "xyes"], [AC_MSG_ERROR([Python asked but not found])])
-	AS_IF([test "x$enable_python" = "xcheck"], [AC_MSG_WARN([Python not found, continuing anyway])])
+	AS_IF([test "x$enable_python" = "xyes"], [AC_MSG_ERROR([Python asked but not found])],
+	[test "x$enable_python" = "xcheck"], [
+		AC_MSG_WARN([Python not found, continuing anyway])
+		enable_python=no
 	])
+])
 
-AM_CONDITIONAL([HAVE_PYTHON], [test "x$PYTHON_BIN" != "x"])
+AM_CONDITIONAL([HAVE_PYTHON], [test "$enable_python" != "no"])
 
 AC_CONFIG_FILES([					\
 		Makefile				\
@@ -138,7 +141,7 @@ nft configuration:
   libxtables support:		${with_xtables}
   json output support:          ${with_json}"
 
-AS_IF([test "x$PYTHON_BIN" != "x"], [
+AS_IF([test "$enable_python" != "no"], [
 	echo "  enable Python:		yes (with $PYTHON_BIN)"
 	], [
 	echo "  enable Python:		no"
-- 
2.21.0

