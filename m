Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5848C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiKWQoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiKWQoG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13B22B24B
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fxjqytuhL89AwINGjTeljG4JcsQUJgDOlcQtcCw5Txo=; b=i7o6ETqzGs11SaVB79WF/5nZsC
        dBx2djzrGmBAg0DNqAlBbotIIOdcibzoh/rrQAKyOG1Rh3an68TiM3lasuwf97vGhChDSaNA8zrz4
        BvQ9VO4juQpRxQxsRjgA9nFyz6/kBLX8biAKFx1RiWNBwcJMosMe7l9Az0Mg5IXpz3ZlUYrz3BGAx
        S6ZXSVNAd1gAD3GL+uoIh/MF5cjkWQ6HddngPE8rbtNTbzkMVQeRRDK4lX2NB8je8GaYynQcYU/yE
        2tFy544KzYZsg2198s8GLkMjSC4EwdkkaSDNZiMv6NWMZHzoSD6b+ly6mM68+0yKjKpbSpNtuXoP/
        9vP6nNaw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsqy-0003wz-3f
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/13] extensions: TOS: Fix v1 xlate callback
Date:   Wed, 23 Nov 2022 17:43:45 +0100
Message-Id: <20221123164350.10502-9-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Translation entirely ignored tos_mask field.

Fixes: b669e18489709 ("extensions: libxt_TOS: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_TOS.c      | 33 +++++++++++++++++++++++----------
 extensions/libxt_TOS.txlate |  9 ++++++---
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index b66fa329f4150..4fc849bd2468b 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -183,28 +183,41 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
 }
 
+static int __tos_xlate(struct xt_xlate *xl, const char *ip,
+		       uint8_t tos, uint8_t tosmask)
+{
+	xt_xlate_add(xl, "%s dscp set ", ip);
+	if ((tosmask & 0x3f) == 0x3f)
+		xt_xlate_add(xl, "0x%02x", tos >> 2);
+	else if (!tos)
+		xt_xlate_add(xl, "%s dscp and 0x%02x",
+			     ip, (uint8_t)~tosmask >> 2);
+	else if (tos == tosmask)
+		xt_xlate_add(xl, "%s dscp or 0x%02x", ip, tos >> 2);
+	else if (!tosmask)
+		xt_xlate_add(xl, "%s dscp xor 0x%02x", ip, tos >> 2);
+	else
+		xt_xlate_add(xl, "%s dscp and 0x%02x xor 0x%02x",
+			     ip, (uint8_t)~tosmask >> 2, tos >> 2);
+	return 1;
+}
+
 static int tos_xlate(struct xt_xlate *xl,
 		     const struct xt_xlate_tg_params *params)
 {
 	const struct ipt_tos_target_info *info =
 			(struct ipt_tos_target_info *) params->target->data;
-	uint8_t dscp = info->tos >> 2;
-
-	xt_xlate_add(xl, "ip dscp set 0x%02x", dscp);
 
-	return 1;
+	return __tos_xlate(xl, "ip", info->tos, UINT8_MAX);
 }
 
 static int tos_xlate6(struct xt_xlate *xl,
 		     const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_tos_target_info *info =
-			(struct ipt_tos_target_info *) params->target->data;
-	uint8_t dscp = info->tos >> 2;
+	const struct xt_tos_target_info *info =
+			(struct xt_tos_target_info *)params->target->data;
 
-	xt_xlate_add(xl, "ip6 dscp set 0x%02x", dscp);
-
-	return 1;
+	return __tos_xlate(xl, "ip6", info->tos_value, info->tos_mask);
 }
 
 static struct xtables_target tos_tg_reg[] = {
diff --git a/extensions/libxt_TOS.txlate b/extensions/libxt_TOS.txlate
index 0952310edc4ac..9c12674299359 100644
--- a/extensions/libxt_TOS.txlate
+++ b/extensions/libxt_TOS.txlate
@@ -14,10 +14,13 @@ ip6tables-translate -A INPUT -j TOS --set-tos Normal-Service
 nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
 
 ip6tables-translate -A INPUT -j TOS --and-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x04
 
 ip6tables-translate -A INPUT -j TOS --or-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp or 0x04
 
 ip6tables-translate -A INPUT -j TOS --xor-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp xor 0x04
+
+ip6tables-translate -A INPUT -j TOS --set-tos 0x12/0x34
+nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x32 xor 0x04
-- 
2.38.0

