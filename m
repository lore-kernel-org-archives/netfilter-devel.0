Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1876C64EC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 17:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB1RQE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 12:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjB1RQE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 12:16:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37EE1449E
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 09:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m2CfxnNPgDXA/k+03QtJwsAT7PRs2HgelPqWMrU3Nl0=; b=HG+vD9WcnTTKoaXWs+QbfLfe1N
        NUhk9gfC0Ho1pDvZxEcgbOr7aLuiBJynQnuHrtX11Xdpa2S2nr5ypXRcqhNiFazSPaQsHKJhYvq1O
        VH2hKP7zTS8s52tmRuD21yKwMlFTLDYjFQ/Mp1t0UizeVp5yhcImHW/PRUeO0l08fBLlasMfUU1fo
        aPpNCvSkR0APVqPKTconqq+YgNTcPch4UBRM8BNMY6TbYqtrd6krPgELJ9Z6d2N7yMkNT3i4VohUv
        vosgPm+BBlKHVYYlA+grri+vPax7SIAMOPtJy1GWv0pZb1R+KhE6k6BVvaQyeOsnP3TO5/cRW63Pk
        eR+nahkA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pX3a2-0004cx-CJ; Tue, 28 Feb 2023 18:15:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Garver <eric@garver.life>
Subject: [iptables PATCH] nft-restore: Fix for deletion of new, referenced rule
Date:   Tue, 28 Feb 2023 18:15:49 +0100
Message-Id: <20230228171549.28483-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Combining multiple corner-cases here:

* Insert a rule before another new one which is not the first. Triggers
  NFTNL_RULE_ID assignment of the latter.

* Delete the referenced new rule in the same batch again. Causes
  overwriting of the previously assigned RULE_ID.

Consequently, iptables-nft-restore fails during *insert*, because the
reference is dangling.

Reported-by: Eric Garver <eric@garver.life>
Fixes: 760b35b46e4cc ("nft: Fix for add and delete of same rule in single batch")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                   |  3 ++-
 .../ipt-restore/0003-restore-ordering_0          | 16 ++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 63468cf3b1344..5896fd410ca78 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2343,7 +2343,8 @@ static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 
 	nftnl_rule_list_del(r);
 
-	if (!nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE))
+	if (!nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE) &&
+	    !nftnl_rule_get_u32(r, NFTNL_RULE_ID))
 		nftnl_rule_set_u32(r, NFTNL_RULE_ID, ++h->rule_id);
 
 	obj = batch_rule_add(h, NFT_COMPAT_RULE_DELETE, r);
diff --git a/iptables/tests/shell/testcases/ipt-restore/0003-restore-ordering_0 b/iptables/tests/shell/testcases/ipt-restore/0003-restore-ordering_0
index 3f1d229e915ff..5482b7ea17298 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0003-restore-ordering_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0003-restore-ordering_0
@@ -123,3 +123,19 @@ EXPECT='-A FORWARD -m comment --comment "rule 1" -j ACCEPT
 -A FORWARD -m comment --comment "rule 3" -j ACCEPT'
 
 diff -u -Z <(echo -e "$EXPECT") <(ipt_show)
+
+# test adding, referencing and deleting the same rule in a batch
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-A FORWARD -m comment --comment "first rule" -j ACCEPT
+-A FORWARD -m comment --comment "referenced rule" -j ACCEPT
+-I FORWARD 2 -m comment --comment "referencing rule" -j ACCEPT
+-D FORWARD -m comment --comment "referenced rule" -j ACCEPT
+COMMIT
+EOF
+
+EXPECT='-A FORWARD -m comment --comment "first rule" -j ACCEPT
+-A FORWARD -m comment --comment "referencing rule" -j ACCEPT'
+
+diff -u -Z <(echo -e "$EXPECT") <(ipt_show)
-- 
2.38.0

