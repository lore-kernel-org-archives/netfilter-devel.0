Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C86C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 10:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiLAKNd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 05:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiLAKN0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 05:13:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E1310B4E
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 02:13:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p0gZG-0001gD-2q; Thu, 01 Dec 2022 11:13:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft] extensions: add xt_statistics random mode translation
Date:   Thu,  1 Dec 2022 11:13:17 +0100
Message-Id: <20221201101317.16818-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use meta random and bitops to replicate what xt_statistics
is doing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_statistic.c      | 8 +++++++-
 extensions/libxt_statistic.txlate | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 4f3341a3d116..37915adc8bc3 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -141,13 +141,19 @@ static int statistic_xlate(struct xt_xlate *xl,
 
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
-		return 0;
+		xt_xlate_add(xl, "meta random & %u %s %u",
+			     INT_MAX,
+			     info->flags & XT_STATISTIC_INVERT ? ">=" : "<",
+			     info->u.random.probability);
+		break;
 	case XT_STATISTIC_MODE_NTH:
 		xt_xlate_add(xl, "numgen inc mod %u %s%u",
 			     info->u.nth.every + 1,
 			     info->flags & XT_STATISTIC_INVERT ? "!= " : "",
 			     info->u.nth.packet);
 		break;
+	default:
+		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_statistic.txlate b/extensions/libxt_statistic.txlate
index 3196ff20b90d..627120c598a6 100644
--- a/extensions/libxt_statistic.txlate
+++ b/extensions/libxt_statistic.txlate
@@ -5,4 +5,4 @@ iptables-translate -A OUTPUT -m statistic --mode nth ! --every 10 --packet 5
 nft 'add rule ip filter OUTPUT numgen inc mod 10 != 5 counter'
 
 iptables-translate -A OUTPUT -m statistic --mode random --probability 0.1
-nft # -A OUTPUT -m statistic --mode random --probability 0.1
+nft 'add rule ip filter OUTPUT meta random & 2147483647 < 214748365 counter'
-- 
2.37.4

