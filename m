From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next v3] netfilter: x_tables: add context to know if extension runs from nft_compat
Date: Mon,  2 Mar 2015 16:46:36 +0100
Message-ID: <1425311196-5271-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39263 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbbCBPnE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 10:43:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, we have four xtables extensions that cannot be used from the
xt over nft compat layer. The problem is that they need real access to
the full blown xt_entry to validate that the rule comes with the right
dependencies. This check was introduced to overcome the lack of
sufficient userspace dependency validation in iptables.

To resolve this problem, this patch introduces a new field to the
xt_tgchk_param structure that tell us if the extension is run from
nft_compat context.

The four affected extensions are:

1) CLUSTERIP, this target has been superseded by xt_cluster. So just
   bail out by returning -EINVAL.

2) TCPMSS. Relax the checking when used from nft_compat. If used with
   the wrong configuration, it will corrupt !syn packets by adding TCP
   MSS option.

3) SYNPROXY6. Don't check for e->ipv6.flags if used from nft_compat.

4) ebt_stp. Relax the check to make sure it uses the reserved
   destination MAC address for STP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: check for e->ipv6.flags from SYNPROXY6 if not from nft_compat.

 include/linux/netfilter/x_tables.h |    2 ++
 net/bridge/netfilter/ebt_stp.c     |    6 ++++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 +++++
 net/ipv6/netfilter/ip6t_SYNPROXY.c |    2 +-
 net/netfilter/nft_compat.c         |    2 ++
 net/netfilter/xt_TCPMSS.c          |    6 ++++++
 6 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index a3e215b..09f3820 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -62,6 +62,7 @@ struct xt_mtchk_param {
 	void *matchinfo;
 	unsigned int hook_mask;
 	u_int8_t family;
+	bool nft_compat;
 };
 
 /**
@@ -92,6 +93,7 @@ struct xt_tgchk_param {
 	void *targinfo;
 	unsigned int hook_mask;
 	u_int8_t family;
+	bool nft_compat;
 };
 
 /* Target destructor parameters */
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 071d872..0c40570 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -164,8 +164,10 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 	    !(info->bitmask & EBT_STP_MASK))
 		return -EINVAL;
 	/* Make sure the match only receives stp frames */
-	if (!ether_addr_equal(e->destmac, bridge_ula) ||
-	    !ether_addr_equal(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
+	if (!par->nft_compat &&
+	    (!ether_addr_equal(e->destmac, bridge_ula) ||
+	     !ether_addr_equal(e->destmsk, msk) ||
+	     !(e->bitmask & EBT_DESTMAC)))
 		return -EINVAL;
 
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e90f83a..a287e02 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -367,6 +367,11 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	struct clusterip_config *config;
 	int ret;
 
+	if (par->nft_compat) {
+		pr_err("cannot use this target from nftables compat\n");
+		return -EINVAL;
+	}
+
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index a0d1727..f0432cf 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -430,7 +430,7 @@ static int synproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_entry *e = par->entryinfo;
 
-	if (!(e->ipv6.flags & IP6T_F_PROTO) ||
+	if ((!par->nft_compat && !(e->ipv6.flags & IP6T_F_PROTO)) ||
 	    e->ipv6.proto != IPPROTO_TCP ||
 	    e->ipv6.invflags & XT_INV_PROTO)
 		return -EINVAL;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index a990df2..365c531 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -158,6 +158,7 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		par->hook_mask = 0;
 	}
 	par->family	= ctx->afi->family;
+	par->nft_compat = true;
 }
 
 static void target_compat_from_user(struct xt_target *t, void *in, void *out)
@@ -371,6 +372,7 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		par->hook_mask = 0;
 	}
 	par->family	= ctx->afi->family;
+	par->nft_compat = true;
 }
 
 static void match_compat_from_user(struct xt_match *m, void *in, void *out)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index e762de5..8c3190e 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -277,6 +277,9 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
+	if (par->nft_compat)
+		return 0;
+
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
@@ -299,6 +302,9 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
+	if (par->nft_compat)
+		return 0;
+
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
-- 
1.7.10.4

