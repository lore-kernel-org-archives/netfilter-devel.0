From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/7] rt: tcpmss get support
Date: Sun, 20 Aug 2017 01:14:08 +0200
Message-ID: <20170819231413.15164-3-fw@strlen.de>
References: <20170819231413.15164-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39292 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752021AbdHSXOC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:14:02 -0400
In-Reply-To: <20170819231413.15164-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 1 +
 src/expr/rt.c                       | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4766f5091b5f..2e174d820190 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -815,6 +815,7 @@ enum nft_rt_keys {
 	NFT_RT_CLASSID,
 	NFT_RT_NEXTHOP4,
 	NFT_RT_NEXTHOP6,
+	NFT_RT_TCPMSS,
 };
 
 /**
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 5088e6630c95..62c01a0be0f5 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -20,7 +20,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_RT_MAX
-#define NFT_RT_MAX (NFT_RT_NEXTHOP6 + 1)
+#define NFT_RT_MAX (NFT_RT_TCPMSS + 1)
 #endif
 
 struct nftnl_expr_rt {
@@ -120,6 +120,7 @@ static const char *rt_key2str_array[NFT_RT_MAX] = {
 	[NFT_RT_CLASSID]	= "classid",
 	[NFT_RT_NEXTHOP4]	= "nexthop4",
 	[NFT_RT_NEXTHOP6]	= "nexthop6",
+	[NFT_RT_TCPMSS]		= "tcpmss",
 };
 
 static const char *rt_key2str(uint8_t key)
-- 
2.13.0

