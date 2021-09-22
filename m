Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F333C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72F306109E
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhIVQIe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhIVQId (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 12:08:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE813C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 09:07:03 -0700 (PDT)
Received: from localhost ([::1]:59570 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mT4ly-0006Px-AX; Wed, 22 Sep 2021 18:07:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] nft: cache: Avoid double free of unrecognized base-chains
Date:   Wed, 22 Sep 2021 18:06:29 +0200
Message-Id: <20210922160632.15635-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922160632.15635-1-phil@nwl.cc>
References: <20210922160632.15635-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On error, nft_cache_add_chain() frees the allocated nft_chain object
along with the nftnl_chain it points at. Fix nftnl_chain_list_cb() to
not free the nftnl_chain again in that case.

Fixes: 176c92c26bfc9 ("nft: Introduce a dedicated base chain array")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c                          |  4 +--
 .../shell/testcases/chain/0004extra-base_0    | 27 +++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/chain/0004extra-base_0

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 2c88301cc7445..9a03bbfbb32bb 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -314,9 +314,7 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 		goto out;
 	}
 
-	if (nft_cache_add_chain(h, t, c))
-		goto out;
-
+	nft_cache_add_chain(h, t, c);
 	return MNL_CB_OK;
 out:
 	nftnl_chain_free(c);
diff --git a/iptables/tests/shell/testcases/chain/0004extra-base_0 b/iptables/tests/shell/testcases/chain/0004extra-base_0
new file mode 100755
index 0000000000000..1b85b060c1487
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0004extra-base_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+case $XT_MULTI in
+*xtables-nft-multi)
+	;;
+*)
+	echo skip $XT_MULTI
+	exit 0
+	;;
+esac
+
+set -e
+
+nft -f - <<EOF
+table ip filter {
+        chain INPUT {
+                type filter hook input priority filter
+                counter packets 218 bytes 91375 accept
+        }
+
+        chain x {
+                type filter hook input priority filter
+        }
+}
+EOF
+
+$XT_MULTI iptables -L
-- 
2.33.0

