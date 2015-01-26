From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [nft_compat PATCH v3] nft_compat: adds support for ebtables match/target
Date: Mon, 26 Jan 2015 16:27:21 +0100
Message-ID: <1422286041-5660-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:34339 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbbAZP1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:27:39 -0500
Received: by mail-we0-f170.google.com with SMTP id w55so4261881wes.1
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2015 07:27:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This extends nft_compat to support ebtables matches/targets.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_compat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 265e190..b0635c4 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
 #include <net/netfilter/nf_tables.h>
 
 static int nft_compat_chain_validate_dependency(const char *tablename,
@@ -40,6 +41,7 @@ static int nft_compat_chain_validate_dependency(const char *tablename,
 union nft_entry {
 	struct ipt_entry e4;
 	struct ip6t_entry e6;
+	struct ebt_entry ebt;
 };
 
 static inline void
@@ -100,6 +102,10 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
+	case NFPROTO_BRIDGE:
+		entry->ebt.ethproto = proto;
+		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
+		break;
 	}
 	par->entryinfo	= entry;
 	par->target	= target;
@@ -307,6 +313,10 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
+	case NFPROTO_BRIDGE:
+		entry->ebt.ethproto = proto;
+		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
+		break;
 	}
 	par->entryinfo	= entry;
 	par->match	= match;
@@ -490,6 +500,9 @@ nfnl_compat_get(struct sock *nfnl, struct sk_buff *skb,
 	case AF_INET6:
 		fmt = "ip6t_%s";
 		break;
+	case NFPROTO_BRIDGE:
+		fmt = "ebt_%s";
+		break;
 	default:
 		pr_err("nft_compat: unsupported protocol %d\n",
 			nfmsg->nfgen_family);
-- 
1.9.1

