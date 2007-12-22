From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_conntrack match revision 1
Date: Sat, 22 Dec 2007 03:39:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220338320.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55146 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLVCjO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:39:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_conntrack match revision 1. It uses fixed types, the
new nf_inet_addr and comes with IPv6 support, thereby completely
superseding xt_state.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_conntrack.h |   16 ++
 net/netfilter/xt_conntrack.c           |  194 +++++++++++++++++++++++++++++----
 net/netfilter/xt_state.c               |    2 
 3 files changed, 192 insertions(+), 20 deletions(-)

Index: linux-2.6_nosov/include/linux/netfilter/xt_conntrack.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_conntrack.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_conntrack.h
@@ -6,7 +6,9 @@
 #define _XT_CONNTRACK_H
 
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
-#include <linux/in.h>
+#ifdef __KERNEL_
+#	include <linux/in.h>
+#endif
 
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
 #define XT_CONNTRACK_STATE_INVALID (1 << 0)
@@ -60,4 +62,16 @@ struct xt_conntrack_info
 	/* Inverse flags */
 	u_int8_t invflags;
 };
+
+struct xt_conntrack_match_info {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	u_int32_t expires_min, expires_max;
+	u_int16_t l4proto;
+	u_int8_t state_mask, status_mask;
+	u_int8_t match_flags, invert_flags;
+};
+
 #endif /*_XT_CONNTRACK_H*/
Index: linux-2.6_nosov/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6_nosov/net/netfilter/xt_conntrack.c
@@ -18,12 +18,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables connection tracking match module");
 MODULE_ALIAS("ipt_conntrack");
+MODULE_ALIAS("ip6t_conntrack");
 
 static bool
-conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+conntrack_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
 	const struct nf_conn *ct;
@@ -112,6 +113,137 @@ conntrack_mt(const struct sk_buff *skb, 
 }
 
 static bool
+conntrack_addrcmp(const union nf_inet_addr *kaddr,
+                  const union nf_inet_addr *uaddr,
+                  const union nf_inet_addr *umask, unsigned int l3proto)
+{
+	if (l3proto == AF_INET)
+		return (kaddr->ip & umask->ip) == uaddr->ip;
+	else if (l3proto == AF_INET6)
+		return (kaddr->ip6[0] & umask->ip6[0]) == uaddr->ip6[0] &&
+		       (kaddr->ip6[1] & umask->ip6[1]) == uaddr->ip6[1] &&
+		       (kaddr->ip6[2] & umask->ip6[2]) == uaddr->ip6[2] &&
+		       (kaddr->ip6[3] & umask->ip6[3]) == uaddr->ip6[3];
+	else
+		return false;
+}
+
+static inline bool
+conntrack_mt_origsrc(const struct nf_conn *ct,
+                     const struct xt_conntrack_match_info *sinfo,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3,
+	       &sinfo->origsrc_addr, &sinfo->origsrc_mask, family);
+}
+
+static inline bool
+conntrack_mt_origdst(const struct nf_conn *ct,
+                     const struct xt_conntrack_match_info *sinfo,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3,
+	       &sinfo->origdst_addr, &sinfo->origdst_mask, family);
+}
+
+static inline bool
+conntrack_mt_replsrc(const struct nf_conn *ct,
+                     const struct xt_conntrack_match_info *sinfo,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3,
+	       &sinfo->replsrc_addr, &sinfo->replsrc_mask, family);
+}
+
+static inline bool
+conntrack_mt_repldst(const struct nf_conn *ct,
+                     const struct xt_conntrack_match_info *sinfo,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3,
+	       &sinfo->repldst_addr, &sinfo->repldst_mask, family);
+}
+
+static bool
+conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_conntrack_match_info *sinfo = matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	unsigned int statebit;
+
+	ct = nf_ct_get(skb, &ctinfo);
+
+#define FWINV(b, i) ((b) ^ !!(sinfo->invert_flags & (i)))
+
+	if (ct == &nf_conntrack_untracked)
+		statebit = XT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct)
+		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
+	else
+		statebit = XT_CONNTRACK_STATE_INVALID;
+
+	if (sinfo->match_flags & XT_CONNTRACK_STATE) {
+		if (ct != NULL) {
+			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
+				statebit |= XT_CONNTRACK_STATE_SNAT;
+			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
+				statebit |= XT_CONNTRACK_STATE_DNAT;
+		}
+		if (FWINV(!(statebit & sinfo->state_mask), XT_CONNTRACK_STATE))
+			return false;
+	}
+
+	if (ct == NULL)
+		return sinfo->match_flags & XT_CONNTRACK_STATE;
+
+	if ((sinfo->match_flags & XT_CONNTRACK_PROTO) &&
+	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
+	    sinfo->l4proto, XT_CONNTRACK_PROTO))
+		return false;
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGSRC)
+		if (conntrack_mt_origsrc(ct, sinfo, match->family) ^
+		    !!(sinfo->invert_flags & XT_CONNTRACK_ORIGSRC))
+			return false;
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGDST)
+		if (conntrack_mt_origdst(ct, sinfo, match->family) ^
+		    !!(sinfo->invert_flags & XT_CONNTRACK_ORIGDST))
+			return false;
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLSRC)
+		if (conntrack_mt_replsrc(ct, sinfo, match->family) ^
+		    !!(sinfo->invert_flags & XT_CONNTRACK_REPLSRC))
+			return false;
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLDST)
+		if (conntrack_mt_repldst(ct, sinfo, match->family) ^
+		    !!(sinfo->invert_flags & XT_CONNTRACK_REPLDST))
+			return false;
+
+	if ((sinfo->match_flags & XT_CONNTRACK_STATUS) &&
+	    FWINV(!(ct->status & sinfo->status_mask), XT_CONNTRACK_STATUS))
+		return false;
+
+	if (sinfo->match_flags & XT_CONNTRACK_EXPIRES) {
+		unsigned long expires = 0;
+
+		if (timer_pending(&ct->timeout))
+			expires = (ct->timeout.expires - jiffies) / HZ;
+		if (FWINV(!(expires >= sinfo->expires_min &&
+		    expires <= sinfo->expires_max),
+		    XT_CONNTRACK_EXPIRES))
+			return false;
+	}
+	return true;
+#undef FWINV
+}
+
+static bool
 conntrack_mt_check(const char *tablename, const void *ip,
                    const struct xt_match *match, void *matchinfo,
                    unsigned int hook_mask)
@@ -144,7 +276,7 @@ struct compat_xt_conntrack_info
 	u_int8_t			invflags;
 };
 
-static void conntrack_mt_compat_from_user(void *dst, void *src)
+static void conntrack_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_conntrack_info *cm = src;
 	struct xt_conntrack_info m = {
@@ -161,7 +293,7 @@ static void conntrack_mt_compat_from_use
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int conntrack_mt_compat_to_user(void __user *dst, void *src)
+static int conntrack_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_conntrack_info *m = src;
 	struct compat_xt_conntrack_info cm = {
@@ -179,29 +311,53 @@ static int conntrack_mt_compat_to_user(v
 }
 #endif
 
-static struct xt_match conntrack_mt_reg __read_mostly = {
-	.name		= "conntrack",
-	.match		= conntrack_mt,
-	.checkentry	= conntrack_mt_check,
-	.destroy	= conntrack_mt_destroy,
-	.matchsize	= sizeof(struct xt_conntrack_info),
+static struct xt_match conntrack_mt_reg[] __read_mostly = {
+	{
+		.name       = "conntrack",
+		.revision   = 0,
+		.family     = AF_INET,
+		.match      = conntrack_mt_v0,
+		.checkentry = conntrack_mt_check,
+		.destroy    = conntrack_mt_destroy,
+		.matchsize  = sizeof(struct xt_conntrack_info),
+		.me         = THIS_MODULE,
 #ifdef CONFIG_COMPAT
-	.compatsize	= sizeof(struct compat_xt_conntrack_info),
-	.compat_from_user = conntrack_mt_compat_from_user,
-	.compat_to_user	= conntrack_mt_compat_to_user,
+		.compatsize       = sizeof(struct compat_xt_conntrack_info),
+		.compat_from_user = conntrack_mt_compat_from_user_v0,
+		.compat_to_user   = conntrack_mt_compat_to_user_v0,
 #endif
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
+	},
+	{
+		.name       = "conntrack",
+		.revision   = 1,
+		.family     = AF_INET,
+		.matchsize  = sizeof(struct xt_conntrack_match_info),
+		.match      = conntrack_mt,
+		.checkentry = conntrack_mt_check,
+		.destroy    = conntrack_mt_destroy,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "conntrack",
+		.revision   = 1,
+		.family     = AF_INET6,
+		.matchsize  = sizeof(struct xt_conntrack_match_info),
+		.match      = conntrack_mt,
+		.checkentry = conntrack_mt_check,
+		.destroy    = conntrack_mt_destroy,
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init conntrack_mt_init(void)
 {
-	return xt_register_match(&conntrack_mt_reg);
+	return xt_register_matches(conntrack_mt_reg,
+	       ARRAY_SIZE(conntrack_mt_reg));
 }
 
 static void __exit conntrack_mt_exit(void)
 {
-	xt_unregister_match(&conntrack_mt_reg);
+	xt_unregister_matches(conntrack_mt_reg, ARRAY_SIZE(conntrack_mt_reg));
 }
 
 module_init(conntrack_mt_init);
Index: linux-2.6_nosov/net/netfilter/xt_state.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_state.c
+++ linux-2.6_nosov/net/netfilter/xt_state.c
@@ -81,6 +81,8 @@ static struct xt_match state_mt_reg[] __
 
 static int __init state_mt_init(void)
 {
+	printk(KERN_NOTICE "xt_state is obsolete, please use "
+	       "xt_conntrack instead.\n");
 	return xt_register_matches(state_mt_reg, ARRAY_SIZE(state_mt_reg));
 }
 
