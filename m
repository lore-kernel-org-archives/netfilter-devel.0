Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DDAC001B2
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343797AbjKIQXP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjKIQXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 852B335AD
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:10 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 01/12] tests: shell: export DIFF to use it from feature scripts
Date:   Thu,  9 Nov 2023 17:22:53 +0100
Message-Id: <20231109162304.119506-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

export DIFF so it can be used from feature scripts to probe the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/run-tests.sh | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 27a0ec43042a..e51d51c9539b 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -572,6 +572,12 @@ feature_probe()
 	return 1
 }
 
+DIFF="$(which diff)"
+if [ ! -x "$DIFF" ] ; then
+	DIFF=true
+fi
+export DIFF
+
 for feat in "${_HAVE_OPTS[@]}" ; do
 	var="NFT_TEST_HAVE_$feat"
 	if [ -z "${!var+x}" ] ; then
@@ -590,11 +596,6 @@ if [ "$NFT_TEST_JOBS" -eq 0 ] ; then
 	fi
 fi
 
-DIFF="$(which diff)"
-if [ ! -x "$DIFF" ] ; then
-	DIFF=true
-fi
-
 declare -A JOBS_PIDLIST
 
 _NFT_TEST_VALGRIND_VGDB_PREFIX=
-- 
2.30.2

