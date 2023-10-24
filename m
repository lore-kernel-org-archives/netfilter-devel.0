Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB131C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbjJXKkx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjJXKkw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:40:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AFE110
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:40:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qvEq8-0007fp-KG; Tue, 24 Oct 2023 12:40:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] check-tree.sh: check and flag /bin/sh usage
Date:   Tue, 24 Oct 2023 12:40:40 +0200
Message-ID: <20231024104044.18669-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Almost all shell tests use /bin/bash already.

In some cases we've had shell tests use /bin/sh, but still having
a bashism.  This causes failures on systems where sh is dash or another,
strict bourne shell.

Flag those via check-tree.sh.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/sets/elem_opts_compat_0 | 2 +-
 tools/check-tree.sh                           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/elem_opts_compat_0 b/tests/shell/testcases/sets/elem_opts_compat_0
index e0129536fcb7..3467cc07e646 100755
--- a/tests/shell/testcases/sets/elem_opts_compat_0
+++ b/tests/shell/testcases/sets/elem_opts_compat_0
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # ordering of element options and expressions has changed, make sure parser
 # accepts both ways
diff --git a/tools/check-tree.sh b/tools/check-tree.sh
index c3aaa08d05ce..e3ddf8bdea58 100755
--- a/tools/check-tree.sh
+++ b/tools/check-tree.sh
@@ -68,6 +68,7 @@ if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
 fi
 for t in "${SHELL_TESTS[@]}" ; do
 	check_shell_dumps "$t"
+	head -n 1 "$t" |grep -q  '^#!/bin/sh' && echo "$t uses sh instead of bash" && EXIT_CODE=1
 done
 
 ##############################################################################
-- 
2.41.0

