Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32118C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166F16142A
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhKRWNw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:13:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57912 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhKRWNv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 17:13:51 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C68F664B1E
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 23:08:42 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] Revert "configure: default to libedit for cli"
Date:   Thu, 18 Nov 2021 23:10:44 +0100
Message-Id: <20211118221044.432552-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Revert b4dded0ca78d ("configure: default to libedit for cli"), it seems
editline/history.h is not packaged by all distros, leading to
compilation breakage unless you explicitly select readline.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index bb65f749691c..70b28f9d35bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -69,7 +69,7 @@ AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
 
 AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
             [disable interactive CLI (libreadline, editline or linenoise support)])],
-            [], [with_cli=editline])
+            [], [with_cli=readline])
 
 AS_IF([test "x$with_cli" = xreadline], [
 AC_CHECK_LIB([readline], [readline], ,
-- 
2.30.2

