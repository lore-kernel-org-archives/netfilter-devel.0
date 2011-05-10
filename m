From: pablo@netfilter.org
Subject: [PATCH 8/8] netfilter: revert a2361c8735e07322023aedc36e4938b35af31eb0
Date: Tue, 10 May 2011 12:05:59 +0200
Message-ID: <1305021959-2980-9-git-send-email-pablo@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48617 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1EJKGc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:32 -0400
In-Reply-To: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch reverts a2361c8735e07322023aedc36e4938b35af31eb0:
"[PATCH] netfilter: xt_conntrack: warn about use in raw table"

Florian Wesphal says:
"... when the packet was sent from the local machine the skb
already has ->nfct attached, and -m conntrack seems to do
the right thing."

Acked-by: Jan Engelhardt <jengelh@medozas.de>
Reported-by: Florian Wesphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_DSCP.c      |    2 +-
 net/netfilter/xt_conntrack.c |    5 -----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index ae82716..0a22919 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+	nv   = (orig & info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 481a86f..61805d7 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -272,11 +272,6 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	int ret;
 
-	if (strcmp(par->table, "raw") == 0) {
-		pr_info("state is undetermined at the time of raw table\n");
-		return -EINVAL;
-	}
-
 	ret = nf_ct_l3proto_try_module_get(par->family);
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
-- 
1.7.2.3

