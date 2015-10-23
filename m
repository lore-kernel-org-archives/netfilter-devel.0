From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 6/9] netfilter: nat: add dependencies on conntrack module
Date: Fri, 23 Oct 2015 12:43:23 +0200
Message-ID: <1445597006-11264-7-git-send-email-fw@strlen.de>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45004 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbbJWKne (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2015 06:43:34 -0400
In-Reply-To: <1445597006-11264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MASQUERADE, S/DNAT and REDIRECT already call functions that depend
on the conntrack module.

However, since the conntrack hooks are now registered in a lazy fashion
(i.e., only when needed) a symbol reference is not enough.

Thus, when something is added to a nat table, make sure that it will see
packets by calling nf_ct_netns_get() which will register the conntrack
hooks in the current netns.

An alternative would be to add these dependencies to the NAT table.

However, that has problems when using MODULES=n builds -- we might try
to register e.g. ipv6 conntrack before that 'modules' initcall has run,
leading to NULL deref crashes since its per-netns storage has not yet been
allocated.

Adding the dependency in the modules instead has the advantage that
nat table also has no cpu cost until rules are added.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v1 patchset.

 net/ipv4/netfilter/ipt_MASQUERADE.c |  8 +++++++-
 net/netfilter/xt_NETMAP.c           | 11 +++++++++--
 net/netfilter/xt_REDIRECT.c         | 12 ++++++++++--
 net/netfilter/xt_nat.c              | 18 +++++++++++++++++-
 4 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index da7f02a..e758e53 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -41,7 +41,7 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return 0;
+	return nf_ct_netns_get(par->net, par->family);
 }
 
 static unsigned int
@@ -58,6 +58,11 @@ masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return nf_nat_masquerade_ipv4(skb, par->hooknum, &range, par->out);
 }
 
+static void masquerade_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_ct_netns_put(par->net, par->family);
+}
+
 static struct xt_target masquerade_tg_reg __read_mostly = {
 	.name		= "MASQUERADE",
 	.family		= NFPROTO_IPV4,
@@ -66,6 +71,7 @@ static struct xt_target masquerade_tg_reg __read_mostly = {
 	.table		= "nat",
 	.hooks		= 1 << NF_INET_POST_ROUTING,
 	.checkentry	= masquerade_tg_check,
+	.destroy	= masquerade_tg_destroy,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index b253e07..222458c 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -60,7 +60,12 @@ static int netmap_tg6_checkentry(const struct xt_tgchk_param *par)
 
 	if (!(range->flags & NF_NAT_RANGE_MAP_IPS))
 		return -EINVAL;
-	return 0;
+	return nf_ct_netns_get(par->net, par->family);
+}
+
+static void netmap_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_ct_netns_put(par->net, par->family);
 }
 
 static unsigned int
@@ -111,7 +116,7 @@ static int netmap_tg4_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return 0;
+	return nf_ct_netns_get(par->net, par->family);
 }
 
 static struct xt_target netmap_tg_reg[] __read_mostly = {
@@ -127,6 +132,7 @@ static struct xt_target netmap_tg_reg[] __read_mostly = {
 		              (1 << NF_INET_LOCAL_OUT) |
 		              (1 << NF_INET_LOCAL_IN),
 		.checkentry = netmap_tg6_checkentry,
+		.destroy    = netmap_tg_destroy,
 		.me         = THIS_MODULE,
 	},
 	{
@@ -141,6 +147,7 @@ static struct xt_target netmap_tg_reg[] __read_mostly = {
 		              (1 << NF_INET_LOCAL_OUT) |
 		              (1 << NF_INET_LOCAL_IN),
 		.checkentry = netmap_tg4_check,
+		.destroy    = netmap_tg_destroy,
 		.me         = THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
index 03f0b37..1406516 100644
--- a/net/netfilter/xt_REDIRECT.c
+++ b/net/netfilter/xt_REDIRECT.c
@@ -40,7 +40,13 @@ static int redirect_tg6_checkentry(const struct xt_tgchk_param *par)
 
 	if (range->flags & NF_NAT_RANGE_MAP_IPS)
 		return -EINVAL;
-	return 0;
+
+	return nf_ct_netns_get(par->net, par->family);
+}
+
+static void redirect_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_ct_netns_put(par->net, par->family);
 }
 
 /* FIXME: Take multiple ranges --RR */
@@ -56,7 +62,7 @@ static int redirect_tg4_check(const struct xt_tgchk_param *par)
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
 		return -EINVAL;
 	}
-	return 0;
+	return nf_ct_netns_get(par->net, par->family);
 }
 
 static unsigned int
@@ -72,6 +78,7 @@ static struct xt_target redirect_tg_reg[] __read_mostly = {
 		.revision   = 0,
 		.table      = "nat",
 		.checkentry = redirect_tg6_checkentry,
+		.destroy    = redirect_tg_destroy,
 		.target     = redirect_tg6,
 		.targetsize = sizeof(struct nf_nat_range),
 		.hooks      = (1 << NF_INET_PRE_ROUTING) |
@@ -85,6 +92,7 @@ static struct xt_target redirect_tg_reg[] __read_mostly = {
 		.table      = "nat",
 		.target     = redirect_tg4,
 		.checkentry = redirect_tg4_check,
+		.destroy    = redirect_tg_destroy,
 		.targetsize = sizeof(struct nf_nat_ipv4_multi_range_compat),
 		.hooks      = (1 << NF_INET_PRE_ROUTING) |
 		              (1 << NF_INET_LOCAL_OUT),
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index bea7464..8107b3e 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -23,7 +23,17 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 			par->target->name);
 		return -EINVAL;
 	}
-	return 0;
+	return nf_ct_netns_get(par->net, par->family);
+}
+
+static int xt_nat_checkentry(const struct xt_tgchk_param *par)
+{
+	return nf_ct_netns_get(par->net, par->family);
+}
+
+static void xt_nat_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_ct_netns_put(par->net, par->family);
 }
 
 static void xt_nat_convert_range(struct nf_nat_range *dst,
@@ -106,6 +116,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.name		= "SNAT",
 		.revision	= 0,
 		.checkentry	= xt_nat_checkentry_v0,
+		.destroy	= xt_nat_destroy,
 		.target		= xt_snat_target_v0,
 		.targetsize	= sizeof(struct nf_nat_ipv4_multi_range_compat),
 		.family		= NFPROTO_IPV4,
@@ -118,6 +129,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.name		= "DNAT",
 		.revision	= 0,
 		.checkentry	= xt_nat_checkentry_v0,
+		.destroy	= xt_nat_destroy,
 		.target		= xt_dnat_target_v0,
 		.targetsize	= sizeof(struct nf_nat_ipv4_multi_range_compat),
 		.family		= NFPROTO_IPV4,
@@ -129,6 +141,8 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 	{
 		.name		= "SNAT",
 		.revision	= 1,
+		.checkentry	= xt_nat_checkentry,
+		.destroy	= xt_nat_destroy,
 		.target		= xt_snat_target_v1,
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
@@ -139,6 +153,8 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 	{
 		.name		= "DNAT",
 		.revision	= 1,
+		.checkentry	= xt_nat_checkentry,
+		.destroy	= xt_nat_destroy,
 		.target		= xt_dnat_target_v1,
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
-- 
2.0.5

