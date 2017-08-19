From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/7] rt: add path mss support
Date: Sun, 20 Aug 2017 01:14:12 +0200
Message-ID: <20170819231413.15164-7-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39312 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752031AbdHSXOP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:15 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only use case is to allow similar behaviour to iptables
TCPMSS --clamp-mss-to-pmtu, by combining this via tcp exthdr:

tcp option mss set rt mss

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 1 +
 src/parser_bison.y                  | 1 +
 src/rt.c                            | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 40096de04e96..5441b190852f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -813,6 +813,7 @@ enum nft_rt_keys {
 	NFT_RT_CLASSID,
 	NFT_RT_NEXTHOP4,
 	NFT_RT_NEXTHOP6,
+	NFT_RT_TCPMSS,
 };
 
 /**
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 533347264729..cfac6ba251fb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3095,6 +3095,7 @@ rt_expr			:	RT	rt_key
 
 rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 			|	NEXTHOP		{ $$ = NFT_RT_NEXTHOP4; }
+			|	MSS		{ $$ = NFT_RT_TCPMSS; }
 			;
 
 ct_expr			: 	CT	ct_key
diff --git a/src/rt.c b/src/rt.c
index cd2d5a4ed7b9..073d8c927153 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -73,6 +73,11 @@ static const struct rt_template rt_templates[] = {
 					      16 * BITS_PER_BYTE,
 					      BYTEORDER_BIG_ENDIAN,
 					      true),
+	[NFT_RT_TCPMSS]		= RT_TEMPLATE("mss",
+					      &integer_type,
+					      2 * BITS_PER_BYTE,
+					      BYTEORDER_HOST_ENDIAN,
+					      false),
 };
 
 static void rt_expr_print(const struct expr *expr, struct output_ctx *octx)
-- 
2.13.0

