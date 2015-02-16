From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH] netfilter: nft_compat: add support for arptables extensions
Date: Mon, 16 Feb 2015 11:32:28 +0100
Message-ID: <20150216103227.4630.10051.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38448 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755386AbbBPKci (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2015 05:32:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to arptables extensions from nft_compat.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_compat.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1279cd8..29fbcf2 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_arp/arp_tables.h>
 #include <net/netfilter/nf_tables.h>
 
 static int nft_compat_chain_validate_dependency(const char *tablename,
@@ -42,6 +43,7 @@ union nft_entry {
 	struct ipt_entry e4;
 	struct ip6t_entry e6;
 	struct ebt_entry ebt;
+	struct arpt_entry arp;
 };
 
 static inline void
@@ -140,6 +142,8 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		entry->ebt.ethproto = proto;
 		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
 		break;
+	case NFPROTO_ARP:
+		break;
 	}
 	par->entryinfo	= entry;
 	par->target	= target;
@@ -351,6 +355,8 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		entry->ebt.ethproto = proto;
 		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
 		break;
+	case NFPROTO_ARP:
+		break;
 	}
 	par->entryinfo	= entry;
 	par->match	= match;
@@ -537,6 +543,9 @@ nfnl_compat_get(struct sock *nfnl, struct sk_buff *skb,
 	case NFPROTO_BRIDGE:
 		fmt = "ebt_%s";
 		break;
+	case NFPROTO_ARP:
+		fmt = "arpt_%s";
+		break;
 	default:
 		pr_err("nft_compat: unsupported protocol %d\n",
 			nfmsg->nfgen_family);

