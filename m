From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nft_compat: set IP6T_F_PROTO flag if protocol is set
Date: Sat, 16 May 2015 20:50:48 +0200
Message-ID: <1431802251-4781-4-git-send-email-pablo@netfilter.org>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[ upstream commit 749177ccc74f9c6d0f51bd78a15c652a2134aa11 ]

ip6tables extensions check for this flag to restrict match/target to a
given protocol. Without this flag set, SYNPROXY6 returns an error.

Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 3.19.x
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Patrick McHardy <kaber@trash.net>
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
