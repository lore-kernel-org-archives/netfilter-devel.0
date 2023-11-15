Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC91C47076
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 09:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbjKOJmn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 04:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjKOJml (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 04:42:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87DDB11D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 01:42:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft 4/4] tests: shell: restore pipapo and chain binding coverage in standalone 30s-stress
Date:   Wed, 15 Nov 2023 10:42:31 +0100
Message-Id: <20231115094231.168870-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115094231.168870-1-pablo@netfilter.org>
References: <20231115094231.168870-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not disable pipapo and chain binding coverage for standalone runs by
default. Instead, turn them on by default and allow users to disable them
through:

 # export NFT_TEST_HAVE_chain_binding=n; bash tests/shell/testcases/transactions/30s-stress 3600
 ...
 running standalone with:
 NFT_TEST_HAVE_chain_binding=n
 NFT_TEST_HAVE_pipapo=y

given feature detection is not available in this case, thus, user has to
provide an explicit hint on what this kernel supports.

Fixes: c5b5b1044fdd ("tests/shell: add feature probing via "features/*.nft" files")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/30s-stress | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index b6ad06abed32..5c0a9465711b 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -6,6 +6,15 @@ runtime=30
 
 # allow stand-alone execution as well, e.g. '$0 3600'
 if [ x"$1" != "x" ] ;then
+	echo "running standalone with:"
+	if [ -z "${NFT_TEST_HAVE_chain_binding+x}" ]; then
+		NFT_TEST_HAVE_chain_binding=y
+	fi
+	if [ -z "${NFT_TEST_HAVE_pipapo+x}" ]; then
+		NFT_TEST_HAVE_pipapo=y
+	fi
+	echo "NFT_TEST_HAVE_chain_binding="$NFT_TEST_HAVE_chain_binding
+	echo "NFT_TEST_HAVE_pipapo="$NFT_TEST_HAVE_pipapo
 	if [ $1 -ge 0 ]; then
 		runtime="$1"
 	else
-- 
2.30.2

