Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA55FC10F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72BEA2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfDORAp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:45 -0400
Received: from mail.us.es ([193.147.175.20]:50496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbfDORAo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38D961C4436
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EE99DA729
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1E036DA709; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C193CDA710;
        Mon, 15 Apr 2019 19:00:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9214D4265A31;
        Mon, 15 Apr 2019 19:00:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/22] netfilter: replace NF_NAT_NEEDED with IS_ENABLED(CONFIG_NF_NAT)
Date:   Mon, 15 Apr 2019 19:00:15 +0200
Message-Id: <20190415170028.3470-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

NF_NAT_NEEDED is true whenever nat support for either ipv4 or ipv6 is
enabled.  Now that the af-specific nat configuration switches have been
removed, IS_ENABLED(CONFIG_NF_NAT) has the same effect.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 4e0145ea033e..a7252f3baeb0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -367,7 +367,7 @@ extern struct nf_nat_hook __rcu *nf_nat_hook;
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
index 6548271209a0..f4384c096d0d 100644
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
index 39fcc1ed18f3..d5454d1031a3 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -928,7 +928,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
 			break;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 		if (!direct_rtp &&
 		    (!nf_inet_addr_cmp(&exp->saved_addr, &exp->tuple.dst.u3) ||
 		     exp->saved_proto.udp.port != exp->tuple.dst.u.udp.port) &&
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0be3ab5bde26..626629944450 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -29,7 +29,7 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/ipv6_frag.h>
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_nat.h>
 #endif
 
@@ -75,7 +75,7 @@ struct ovs_conntrack_info {
 	struct md_mark mark;
 	struct md_labels labels;
 	char timeout[CTNL_TIMEOUT_NAME_MAX];
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
 #endif
 };
@@ -721,7 +721,7 @@ static bool skb_nfct_cached(struct net *net,
 	return ct_executed;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
  * Returns either NF_ACCEPT or NF_DROP.
@@ -903,7 +903,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 
 	return err;
 }
-#else /* !CONFIG_NF_NAT_NEEDED */
+#else /* !CONFIG_NF_NAT */
 static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 		      const struct ovs_conntrack_info *info,
 		      struct sk_buff *skb, struct nf_conn *ct,
@@ -1330,7 +1330,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 	return 0;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 static int parse_nat(const struct nlattr *attr,
 		     struct ovs_conntrack_info *info, bool log)
 {
@@ -1467,7 +1467,7 @@ static const struct ovs_ct_len_tbl ovs_ct_attr_lens[OVS_CT_ATTR_MAX + 1] = {
 				    .maxlen = sizeof(struct md_labels) },
 	[OVS_CT_ATTR_HELPER]	= { .minlen = 1,
 				    .maxlen = NF_CT_HELPER_NAME_LEN },
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	/* NAT length is checked when parsing the nested attributes. */
 	[OVS_CT_ATTR_NAT]	= { .minlen = 0, .maxlen = INT_MAX },
 #endif
@@ -1547,7 +1547,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 				return -EINVAL;
 			}
 			break;
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 		case OVS_CT_ATTR_NAT: {
 			int err = parse_nat(a, info, log);
 
@@ -1677,7 +1677,7 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	return err;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 static bool ovs_ct_nat_to_attr(const struct ovs_conntrack_info *info,
 			       struct sk_buff *skb)
 {
@@ -1783,7 +1783,7 @@ int ovs_ct_action_to_attr(const struct ovs_conntrack_info *ct_info,
 			return -EMSGSIZE;
 	}
 
-#ifdef CONFIG_NF_NAT_NEEDED
+#if IS_ENABLED(CONFIG_NF_NAT)
 	if (ct_info->nat && !ovs_ct_nat_to_attr(ct_info, skb))
 		return -EMSGSIZE;
 #endif
-- 
2.11.0

