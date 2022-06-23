Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D6CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 13:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiFWNFf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 09:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiFWNFf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 09:05:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF623BBED
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 06:05:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4MWa-0005Yo-Qy; Thu, 23 Jun 2022 15:05:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/6] netfilter: x_tables: use correct integer types
Date:   Thu, 23 Jun 2022 15:05:10 +0200
Message-Id: <20220623130514.13775-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623130514.13775-1-fw@strlen.de>
References: <20220623130514.13775-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sparse complains because __be32 and u32 are mixed without
conversions.  Use the correct types, no code changes.

Furthermore, xt_DSCP generates a bit truncation warning:
"cast truncates bits from constant value (ffffff03 becomes 3)"

The truncation is fine (and wanted). Add a private definition and use that
instead.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_DSCP.c      | 8 ++++----
 net/netfilter/xt_TCPMSS.c    | 4 ++--
 net/netfilter/xt_connlimit.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index eababc354ff1..cfa44515ab72 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -24,6 +24,8 @@ MODULE_ALIAS("ip6t_DSCP");
 MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 
+#define XT_DSCP_ECN_MASK	3u
+
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -34,8 +36,7 @@ dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 
-		ipv4_change_dsfield(ip_hdr(skb),
-				    (__force __u8)(~XT_DSCP_MASK),
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
 				    dinfo->dscp << XT_DSCP_SHIFT);
 
 	}
@@ -52,8 +53,7 @@ dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return NF_DROP;
 
-		ipv6_change_dsfield(ipv6_hdr(skb),
-				    (__force __u8)(~XT_DSCP_MASK),
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
 				    dinfo->dscp << XT_DSCP_SHIFT);
 	}
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 122db9fbb9f4..116a885adb3c 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -239,8 +239,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		oldlen = ipv6h->payload_len;
 		newlen = htons(ntohs(oldlen) + ret);
 		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->csum = csum_add(csum_sub(skb->csum, oldlen),
-					     newlen);
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
 		ipv6h->payload_len = newlen;
 	}
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 46fcac75f726..5d04ef80a61d 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -62,10 +62,10 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[4] = zone->id;
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
-		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
-			  iph->daddr : iph->saddr;
 
-		key[0] &= info->mask.ip;
+		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
+			 (__force __u32)iph->daddr : (__force __u32)iph->saddr;
+		key[0] &= (__force __u32)info->mask.ip;
 		key[1] = zone->id;
 	}
 
-- 
2.35.1

