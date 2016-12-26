From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: [PATCH xtables-addons] build: support for Linux 4.10
Date: Mon, 26 Dec 2016 16:14:02 +0100
Message-ID: <1482765242-31943-1-git-send-email-ralph.sennhauser@gmail.com>
Cc: Ralph Sennhauser <ralph.sennhauser@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:35479 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753978AbcLZPOU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Dec 2016 10:14:20 -0500
Received: by mail-wj0-f196.google.com with SMTP id hb5so15562408wjc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Dec 2016 07:14:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 613dbd95723aee7abd16860745691b6c7bda20dc (netfilter:
x_tables: move hook state into xt_action_param structure) changes the
struct xt_action_param, accommodate for it.

Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
---
 extensions/ACCOUNT/xt_ACCOUNT.c |  4 ++++
 extensions/compat_xtables.h     |  4 ++++
 extensions/xt_CHAOS.c           | 21 +++++++++++++++++++--
 extensions/xt_DELUDE.c          |  8 +++++++-
 extensions/xt_DNETMAP.c         | 23 ++++++++++++++++++-----
 extensions/xt_ECHO.c            |  4 ++++
 extensions/xt_LOGMARK.c         |  4 ++++
 extensions/xt_TARPIT.c          |  8 ++++++++
 extensions/xt_iface.c           |  8 ++++++++
 extensions/xt_lscan.c           |  4 ++++
 10 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/extensions/ACCOUNT/xt_ACCOUNT.c b/extensions/ACCOUNT/xt_ACCOUNT.c
index ee17839..4705fa7 100644
--- a/extensions/ACCOUNT/xt_ACCOUNT.c
+++ b/extensions/ACCOUNT/xt_ACCOUNT.c
@@ -482,12 +482,16 @@ static void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8,
 static unsigned int
 ipt_acc_target(struct sk_buff *skb, const struct xt_action_param *par)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	struct ipt_acc_net *ian = net_generic(par->state->net, ipt_acc_net_id);
+#else
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(4,4,0)
 	struct ipt_acc_net *ian = net_generic(par->net, ipt_acc_net_id);
 #else
 	struct net *net = dev_net(par->in ? par->in : par->out);
 	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
 #endif
+#endif
 	struct ipt_acc_table *ipt_acc_tables = ian->ipt_acc_tables;
 	const struct ipt_acc_info *info =
 		par->targinfo;
diff --git a/extensions/compat_xtables.h b/extensions/compat_xtables.h
index a6c61ac..78a7fbf 100644
--- a/extensions/compat_xtables.h
+++ b/extensions/compat_xtables.h
@@ -82,11 +82,15 @@ static inline void proc_remove(struct proc_dir_entry *de)
 
 static inline struct net *par_net(const struct xt_action_param *par)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 10, 0)
+	return par->state->net;
+#else
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 4, 0)
 	return par->net;
 #else
 	return dev_net((par->in != NULL) ? par->in : par->out);
 #endif
+#endif
 }
 
 #endif /* _XTABLES_COMPAT_H */
diff --git a/extensions/xt_CHAOS.c b/extensions/xt_CHAOS.c
index 9c80855..cee2026 100644
--- a/extensions/xt_CHAOS.c
+++ b/extensions/xt_CHAOS.c
@@ -58,8 +58,12 @@ xt_chaos_total(struct sk_buff *skb, const struct xt_action_param *par)
 
 	{
 		struct xt_action_param local_par;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		local_par.state    = par->state;
+#else
 		local_par.in        = par->in,
 		local_par.out       = par->out,
+#endif
 		local_par.match     = xm_tcp;
 		local_par.matchinfo = &tcp_params;
 		local_par.fragoff   = fragoff;
@@ -74,12 +78,16 @@ xt_chaos_total(struct sk_buff *skb, const struct xt_action_param *par)
 	destiny = (info->variant == XTCHAOS_TARPIT) ? xt_tarpit : xt_delude;
 	{
 		struct xt_action_param local_par;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		local_par.state    = par->state;
+#else
 		local_par.in       = par->in;
 		local_par.out      = par->out;
 		local_par.hooknum  = par->hooknum;
+		local_par.family   = par->family;
+#endif
 		local_par.target   = destiny;
 		local_par.targinfo = par->targinfo;
-		local_par.family   = par->family;
 		destiny->target(skb, &local_par);
 	}
 }
@@ -100,9 +108,13 @@ chaos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	if ((unsigned int)prandom_u32() <= reject_percentage) {
 		struct xt_action_param local_par;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		local_par.state    = par->state;
+#else
 		local_par.in       = par->in;
 		local_par.out      = par->out;
 		local_par.hooknum  = par->hooknum;
+#endif
 		local_par.target   = xt_reject;
 		local_par.targinfo = &reject_params;
 		return xt_reject->target(skb, &local_par);
@@ -111,7 +123,12 @@ chaos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	/* TARPIT/DELUDE may not be called from the OUTPUT chain */
 	if (iph->protocol == IPPROTO_TCP &&
 	    info->variant != XTCHAOS_NORMAL &&
-	    par->hooknum != NF_INET_LOCAL_OUT)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	    par->state->hook
+#else
+	    par->hooknum
+#endif
+	    != NF_INET_LOCAL_OUT)
 		xt_chaos_total(skb, par);
 
 	return NF_DROP;
diff --git a/extensions/xt_DELUDE.c b/extensions/xt_DELUDE.c
index aff281f..80865ed 100644
--- a/extensions/xt_DELUDE.c
+++ b/extensions/xt_DELUDE.c
@@ -151,7 +151,13 @@ delude_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	 * a problem, as that is supported since Linux 2.6.35. But since we do not
 	 * actually want to have a connection open, we are still going to drop it.
 	 */
-	delude_send_reset(par_net(par), skb, par->hooknum);
+	delude_send_reset(par_net(par), skb,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	                  par->state->hook
+#else
+	                  par->hooknum
+#endif
+	                  );
 	return NF_DROP;
 }
 
diff --git a/extensions/xt_DNETMAP.c b/extensions/xt_DNETMAP.c
index bdef6d3..ec6177a 100644
--- a/extensions/xt_DNETMAP.c
+++ b/extensions/xt_DNETMAP.c
@@ -356,7 +356,11 @@ out:
 static unsigned int
 dnetmap_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	struct net *net = dev_net(par->state->in ? par->state->in : par->state->out);
+#else
 	struct net *net = dev_net(par->in ? par->in : par->out);
+#endif
 	struct dnetmap_net *dnetmap_net = dnetmap_pernet(net);
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -367,16 +371,21 @@ dnetmap_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	struct dnetmap_entry *e;
 	struct dnetmap_prefix *p;
 	__s32 jttl;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	unsigned int hooknum = par->state->hook;
+#else
+	unsigned int hooknum = par->hooknum;
+#endif
 
-	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING ||
-		     par->hooknum == NF_INET_LOCAL_OUT ||
-		     par->hooknum == NF_INET_PRE_ROUTING);
+	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING ||
+		     hooknum == NF_INET_LOCAL_OUT ||
+		     hooknum == NF_INET_PRE_ROUTING);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	jttl = tginfo->flags & XT_DNETMAP_TTL ? tginfo->ttl * HZ : jtimeout;
 
 	/* in prerouting we try to map postnat-ip to prenat-ip */
-	if (par->hooknum == NF_INET_PRE_ROUTING) {
+	if (hooknum == NF_INET_PRE_ROUTING) {
 		postnat_ip = ip_hdr(skb)->daddr;
 
 		spin_lock_bh(&dnetmap_lock);
@@ -407,7 +416,7 @@ dnetmap_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		newrange.min_proto = mr->min_proto;
 		newrange.max_proto = mr->max_proto;
 		return nf_nat_setup_info(ct, &newrange,
-					 HOOK2MANIP(par->hooknum));
+					 HOOK2MANIP(hooknum));
 	}
 
 	prenat_ip = ip_hdr(skb)->saddr;
@@ -495,7 +504,11 @@ bind_new_prefix:
 	newrange.max_addr.ip = postnat_ip;
 	newrange.min_proto = mr->min_proto;
 	newrange.max_proto = mr->max_proto;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(par->state->hook));
+#else
 	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(par->hooknum));
+#endif
 
 no_rev_map:
 no_free_ip:
diff --git a/extensions/xt_ECHO.c b/extensions/xt_ECHO.c
index fe7497c..60cb815 100644
--- a/extensions/xt_ECHO.c
+++ b/extensions/xt_ECHO.c
@@ -35,7 +35,11 @@ echo_tg6(struct sk_buff *oldskb, const struct xt_action_param *par)
 	void *payload;
 	struct flowi6 fl;
 	struct dst_entry *dst = NULL;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	struct net *net = dev_net((par->state->in != NULL) ? par->state->in : par->state->out);
+#else
 	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
+#endif
 
 	/* This allows us to do the copy operation in fewer lines of code. */
 	if (skb_linearize(oldskb) < 0)
diff --git a/extensions/xt_LOGMARK.c b/extensions/xt_LOGMARK.c
index 7616962..ed14604 100644
--- a/extensions/xt_LOGMARK.c
+++ b/extensions/xt_LOGMARK.c
@@ -76,7 +76,11 @@ logmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	printk("<%u>%.*s""iif=%d hook=%s nfmark=0x%x "
 	       "secmark=0x%x classify=0x%x",
 	       info->level, (unsigned int)sizeof(info->prefix), info->prefix,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	       skb_ifindex(skb), hook_names[par->state->hook],
+#else
 	       skb_ifindex(skb), hook_names[par->hooknum],
+#endif
 	       skb_nfmark(skb), skb_secmark(skb), skb->priority);
 
 	ct = nf_ct_get(skb, &ctinfo);
diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 95faba0..f759eb1 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -455,7 +455,11 @@ tarpit_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return NF_DROP;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	tarpit_tcp4(par_net(par), skb, par->state->hook, info->variant);
+#else
 	tarpit_tcp4(par_net(par), skb, par->hooknum, info->variant);
+#endif
 	return NF_DROP;
 }
 
@@ -497,7 +501,11 @@ tarpit_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		return NF_DROP;
 	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+	tarpit_tcp6(par_net(par), skb, par->state->hook, info->variant);
+#else
 	tarpit_tcp6(par_net(par), skb, par->hooknum, info->variant);
+#endif
 	return NF_DROP;
 }
 #endif
diff --git a/extensions/xt_iface.c b/extensions/xt_iface.c
index 030a644..be52a52 100644
--- a/extensions/xt_iface.c
+++ b/extensions/xt_iface.c
@@ -45,9 +45,17 @@ static const struct net_device *iface_get(const struct xt_iface_mtinfo *info,
     const struct xt_action_param *par, struct net_device **put)
 {
 	if (info->flags & XT_IFACE_DEV_IN)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		return par->state->in;
+#else
 		return par->in;
+#endif
 	else if (info->flags & XT_IFACE_DEV_OUT)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		return par->state->out;
+#else
 		return par->out;
+#endif
 	return *put = dev_get_by_name(&init_net, info->ifname);
 }
 
diff --git a/extensions/xt_lscan.c b/extensions/xt_lscan.c
index 184ee63..3a7d2ed 100644
--- a/extensions/xt_lscan.c
+++ b/extensions/xt_lscan.c
@@ -204,7 +204,11 @@ lscan_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		unsigned int n;
 
 		n = lscan_mt_full(ctdata->mark & connmark_mask, ctstate,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
+		    par->state->in == init_net.loopback_dev, tcph,
+#else
 		    par->in == init_net.loopback_dev, tcph,
+#endif
 		    skb->len - par->thoff - 4 * tcph->doff);
 
 		ctdata->mark = (ctdata->mark & ~connmark_mask) | n;
-- 
2.7.3

