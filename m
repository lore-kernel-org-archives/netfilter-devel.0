Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11DCC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906532075D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfC0IUj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:20:39 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38834 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726237AbfC0IUj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 04:20:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h93nX-0002bJ-Iy; Wed, 27 Mar 2019 09:20:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/6] netfilter: replace NF_NAT_NEEDED with IS_ENABLED(CONFIG_NF_NAT)
Date:   Wed, 27 Mar 2019 09:22:26 +0100
Message-Id: <20190327082229.29399-4-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190327082229.29399-1-fw@strlen.de>
References: <20190327082229.29399-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NF_NAT_NEEDED is true whenever nat support for either ipv4 or ipv6 is
enabled.  Now that the af-specific nat configuration switches have been
removed, IS_ENABLED(CONFIG_NF_NAT) has the same effect.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h                   |  2 +-
 include/net/netfilter/nf_conntrack_expect.h |  2 +-
 net/netfilter/Kconfig                       |  5 -----
 net/netfilter/nf_conntrack_expect.c         |  2 +-
 net/netfilter/nf_conntrack_netlink.c        | 16 ++++++++--------
 net/netfilter/nf_conntrack_sip.c            |  2 +-
 net/openvswitch/conntrack.c                 | 18 +++++++++---------
 7 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 72cb19c3db6a..09c71df8ccfe 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -360,7 +360,7 @@ extern struct nf_nat_hook __rcu *nf_nat_hook;
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_hook *nat_hook;
 
 	rcu_read_lock();
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 006e430d1cdf..93ce6b0daaba 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -48,7 +48,7 @@ struct nf_conntrack_expect {
 	/* Expectation class */
 	unsigned int class;
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	union nf_inet_addr saved_addr;
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d43ffb09939b..8d42566b2735 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -404,11 +404,6 @@ config NF_NAT
 	  forms of full Network Address Port Translation. This can be
 	  controlled by iptables, ip6tables or nft.
 
-config NF_NAT_NEEDED
-	bool
-	depends on NF_NAT
-	default y
-
 config NF_NAT_AMANDA
 	tristate
 	depends on NF_CONNTRACK && NF_NAT
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 334d6e5b7762..59c18804a10a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -336,7 +336,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 
 	exp->tuple.dst.u.all = *dst;
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
 	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
 #endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66c596d287a5..32fe3060375a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -45,7 +45,7 @@
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #endif
@@ -655,7 +655,7 @@ static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 	       + ctnetlink_secctx_size(ct)
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
 #endif
@@ -1494,7 +1494,7 @@ static int ctnetlink_get_ct_unconfirmed(struct net *net, struct sock *ctnl,
 	return -EOPNOTSUPP;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 static int
 ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
@@ -1586,7 +1586,7 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 static int
 ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 {
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	int ret;
 
 	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
@@ -2369,7 +2369,7 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 	       + ctnetlink_secctx_size(ct)
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
 #endif
@@ -2699,7 +2699,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	struct nf_conn *master = exp->master;
 	long timeout = ((long)exp->timeout.expires - (long)jiffies) / HZ;
 	struct nf_conn_help *help;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
 #endif
@@ -2717,7 +2717,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 				 CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	if (!nf_inet_addr_cmp(&exp->saved_addr, &any_addr) ||
 	    exp->saved_proto.all) {
 		nest_parms = nla_nest_start(skb, CTA_EXPECT_NAT | NLA_F_NESTED);
@@ -3180,7 +3180,7 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 			   struct nf_conntrack_expect *exp,
 			   u_int8_t u3)
 {
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *tb[CTA_EXPECT_NAT_MAX+1];
 	struct nf_conntrack_tuple nat_tuple = {};
 	int err;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b50857..6b2044beef0c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -933,7 +933,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
 			break;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 		if (!direct_rtp &&
 		    (!nf_inet_addr_cmp(&exp->saved_addr, &exp->tuple.dst.u3) ||
 		     exp->saved_proto.udp.port != exp->tuple.dst.u.udp.port) &&
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 51080004677e..89158d2114e6 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -28,7 +28,7 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/ipv6_frag.h>
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_nat.h>
 #endif
 
@@ -73,7 +73,7 @@ struct ovs_conntrack_info {
 	u32 eventmask;              /* Mask of 1 << IPCT_*. */
 	struct md_mark mark;
 	struct md_labels labels;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
 #endif
 };
@@ -719,7 +719,7 @@ static bool skb_nfct_cached(struct net *net,
 	return ct_executed;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
  * Returns either NF_ACCEPT or NF_DROP.
@@ -901,7 +901,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 
 	return err;
 }
-#else /* !CONFIG_NF_NAT_NEEDED */
+#else /* !CONFIG_NF_NAT */
 static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 		      const struct ovs_conntrack_info *info,
 		      struct sk_buff *skb, struct nf_conn *ct,
@@ -1322,7 +1322,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 	return 0;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 static int parse_nat(const struct nlattr *attr,
 		     struct ovs_conntrack_info *info, bool log)
 {
@@ -1459,7 +1459,7 @@ static const struct ovs_ct_len_tbl ovs_ct_attr_lens[OVS_CT_ATTR_MAX + 1] = {
 				    .maxlen = sizeof(struct md_labels) },
 	[OVS_CT_ATTR_HELPER]	= { .minlen = 1,
 				    .maxlen = NF_CT_HELPER_NAME_LEN },
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	/* NAT length is checked when parsing the nested attributes. */
 	[OVS_CT_ATTR_NAT]	= { .minlen = 0, .maxlen = INT_MAX },
 #endif
@@ -1537,7 +1537,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 				return -EINVAL;
 			}
 			break;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 		case OVS_CT_ATTR_NAT: {
 			int err = parse_nat(a, info, log);
 
@@ -1650,7 +1650,7 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	return err;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 static bool ovs_ct_nat_to_attr(const struct ovs_conntrack_info *info,
 			       struct sk_buff *skb)
 {
@@ -1752,7 +1752,7 @@ int ovs_ct_action_to_attr(const struct ovs_conntrack_info *ct_info,
 	    nla_put_u32(skb, OVS_CT_ATTR_EVENTMASK, ct_info->eventmask))
 		return -EMSGSIZE;
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	if (ct_info->nat && !ovs_ct_nat_to_attr(ct_info, skb))
 		return -EMSGSIZE;
 #endif
-- 
2.19.2

