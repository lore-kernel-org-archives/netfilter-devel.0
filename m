From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_compat: set IP6T_F_PROTO flag if protocol is set
Date: Sat, 21 Mar 2015 19:36:58 +0100
Message-ID: <1426963018-6838-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbbCUSdL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 14:33:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6tables extensions check for this flag to restrict match/target to a
given protocol. Without this flag set, SYNPROXY6 returns an error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 213584c..65f3e2b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -133,6 +133,9 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
 		break;
 	case AF_INET6:
+		if (proto)
+			entry->e6.ipv6.flags |= IP6T_F_PROTO;
+
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
@@ -344,6 +347,9 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
 		break;
 	case AF_INET6:
+		if (proto)
+			entry->e6.ipv6.flags |= IP6T_F_PROTO;
+
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
-- 
1.7.10.4

