Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18444C4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbhLUThT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241816AbhLUThR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9228C061756
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qriOO/xUFo2QIDkm9EK2IA3TXP8jmbGS814hgP9lMp0=; b=o81pJKrMwv/wtMYmY183wOu7up
        XwwRGr/kmqv7bxkau2FGPmRggUTvPktr3bJtqnEnPvXjGUKTIjicMtXmZfmWPNjaW0Z4cUENzPkfT
        Fn+Y8c4/ShvqPXJjSrslLFsFNqr0oFpo9VOQXWk+PcBRHgqqnZQFBcEovnFPw5sohPk90RNyQ0oUu
        /RTdtEUSLjyAmUcQByI+rsbv/RjTh9dxTxQYIKgpTC8NOjrCh4mgQN9pGo7xNYO6BmIxqAdkmPa42
        D+MzNCWGz9ebEynFGarKpDx1kXhFgk6fU+8RICe0Aab4+jr5PuBoHSsOro1+QhMh2EY6U3CI8BTSv
        mp90pe/Q==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwk-0019T9-1C
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 06/11] src: reduce indentation
Date:   Tue, 21 Dec 2021 19:36:52 +0000
Message-Id: <20211221193657.430866-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221193657.430866-1-jeremy@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Re-arrange some switch-cases and conditionals to reduce levels of
indentation.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 10 +++-------
 src/payload.c             | 18 +++++++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 39b0574e38c8..36ead8029691 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2079,14 +2079,10 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 	case NFPROTO_NETDEV:
 	case NFPROTO_BRIDGE:
 		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		return family == nfproto;
 	default:
-		if (family == NFPROTO_IPV4 &&
-		    nfproto != NFPROTO_IPV4)
-			return false;
-		else if (family == NFPROTO_IPV6 &&
-			 nfproto != NFPROTO_IPV6)
-			return false;
-
 		return true;
 	}
 
diff --git a/src/payload.c b/src/payload.c
index 79008762825f..576eb149f71d 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -733,13 +733,17 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 		break;
 	}
 
-	if (expr->payload.base == PROTO_BASE_TRANSPORT_HDR &&
-	    dep->left->payload.base == PROTO_BASE_TRANSPORT_HDR) {
-		if (dep->left->payload.desc == &proto_icmp)
-			return payload_may_dependency_kill_icmp(ctx, expr);
-		if (dep->left->payload.desc == &proto_icmp6)
-			return payload_may_dependency_kill_icmp(ctx, expr);
-	}
+	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
+		return true;
+
+	if (dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
+		return true;
+
+	if (dep->left->payload.desc == &proto_icmp)
+		return payload_may_dependency_kill_icmp(ctx, expr);
+
+	if (dep->left->payload.desc == &proto_icmp6)
+		return payload_may_dependency_kill_icmp(ctx, expr);
 
 	return true;
 }
-- 
2.34.1

