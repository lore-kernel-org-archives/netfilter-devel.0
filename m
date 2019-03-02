Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B979C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0826120838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfCBSgZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:25 -0500
Received: from mail.us.es ([193.147.175.20]:36078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfCBSgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 748AF1361B1
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E3EDDA863
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53869DA7F4; Sat,  2 Mar 2019 19:36:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37F5ADA84E;
        Sat,  2 Mar 2019 19:36:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DD5674265A2F;
        Sat,  2 Mar 2019 19:36:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/29] netfilter: nat: remove l3proto struct
Date:   Sat,  2 Mar 2019 19:35:55 +0100
Message-Id: <20190302183613.3159-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

All l3proto function pointers have been removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h |  8 -----
 net/netfilter/nf_nat_core.c            | 54 ----------------------------------
 net/netfilter/nf_nat_proto.c           | 38 ------------------------
 3 files changed, 100 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index 8ee0b5b629c7..9a68f2b53a9e 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -2,10 +2,6 @@
 #ifndef _NF_NAT_L3PROTO_H
 #define _NF_NAT_L3PROTO_H
 
-struct nf_nat_l3proto {
-	u8	l3proto;
-};
-
 unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 			      enum nf_nat_manip_type mtype,
 			      enum ip_conntrack_dir dir);
@@ -13,10 +9,6 @@ void nf_nat_csum_recalc(struct sk_buff *skb,
 			u8 nfproto, u8 proto, void *data, __sum16 *check,
 			int datalen, int oldlen);
 
-int nf_nat_l3proto_register(const struct nf_nat_l3proto *);
-void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *);
-const struct nf_nat_l3proto *__nf_nat_l3proto_find(u8 l3proto);
-
 int nf_nat_icmp_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 				  enum ip_conntrack_info ctinfo,
 				  unsigned int hooknum);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8c5c29189383..d9b70e560007 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -35,8 +35,6 @@
 static spinlock_t nf_nat_locks[CONNTRACK_LOCKS];
 
 static DEFINE_MUTEX(nf_nat_proto_mutex);
-static const struct nf_nat_l3proto __rcu *nf_nat_l3protos[NFPROTO_NUMPROTO]
-						__read_mostly;
 static unsigned int nat_net_id __read_mostly;
 
 static struct hlist_head *nf_nat_bysource __read_mostly;
@@ -58,12 +56,6 @@ struct nat_net {
 	struct nf_nat_hooks_net nat_proto_net[NFPROTO_NUMPROTO];
 };
 
-inline const struct nf_nat_l3proto *
-__nf_nat_l3proto_find(u8 family)
-{
-	return rcu_dereference(nf_nat_l3protos[family]);
-}
-
 #ifdef CONFIG_XFRM
 static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 				       const struct nf_conn *ct,
@@ -849,33 +841,6 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	return 0;
 }
 
-static void nf_nat_l3proto_clean(u8 l3proto)
-{
-	struct nf_nat_proto_clean clean = {
-		.l3proto = l3proto,
-	};
-
-	nf_ct_iterate_destroy(nf_nat_proto_remove, &clean);
-}
-
-int nf_nat_l3proto_register(const struct nf_nat_l3proto *l3proto)
-{
-	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
-
-void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *l3proto)
-{
-	mutex_lock(&nf_nat_proto_mutex);
-	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], NULL);
-	mutex_unlock(&nf_nat_proto_mutex);
-	synchronize_rcu();
-
-	nf_nat_l3proto_clean(l3proto->l3proto);
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_unregister);
-
 /* No one using conntrack by the time this called. */
 static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
@@ -1122,7 +1087,6 @@ int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
 	mutex_unlock(&nf_nat_proto_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_nat_register_fn);
 
 void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
 		          unsigned int ops_count)
@@ -1171,7 +1135,6 @@ void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
 unlock:
 	mutex_unlock(&nf_nat_proto_mutex);
 }
-EXPORT_SYMBOL_GPL(nf_nat_unregister_fn);
 
 static struct pernet_operations nat_net_ops = {
 	.id = &nat_net_id,
@@ -1186,8 +1149,6 @@ static struct nf_nat_hook nat_hook = {
 	.manip_pkt		= nf_nat_manip_pkt,
 };
 
-int nf_nat_l3proto_init(void);
-void nf_nat_l3proto_exit(void);
 static int __init nf_nat_init(void)
 {
 	int ret, i;
@@ -1222,19 +1183,6 @@ static int __init nf_nat_init(void)
 	WARN_ON(nf_nat_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
 
-	ret = nf_nat_l3proto_init();
-	if (ret) {
-		nf_ct_extend_unregister(&nat_extend);
-		nf_ct_helper_expectfn_unregister(&follow_master_nat);
-		RCU_INIT_POINTER(nf_nat_hook, NULL);
-
-		synchronize_net();
-		kvfree(nf_nat_bysource);
-		unregister_pernet_subsys(&nat_net_ops);
-
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -1244,8 +1192,6 @@ static void __exit nf_nat_cleanup(void)
 
 	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
 
-	nf_nat_l3proto_exit();
-
 	nf_ct_extend_unregister(&nat_extend);
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 8284ed1b3173..f5c60d3b9d38 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -35,11 +35,6 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
-#if IS_ENABLED(CONFIG_IPV6)
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
-#endif
-
 static void nf_csum_update(struct sk_buff *skb,
 			   unsigned int iphdroff, __sum16 *check,
 			   const struct nf_conntrack_tuple *t,
@@ -555,10 +550,6 @@ void nf_nat_csum_recalc(struct sk_buff *skb,
 	WARN_ON_ONCE(1);
 }
 
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
-	.l3proto		= NFPROTO_IPV4,
-};
-
 int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 				  struct nf_conn *ct,
 				  enum ip_conntrack_info ctinfo,
@@ -779,36 +770,7 @@ void nf_nat_l3proto_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops
 }
 EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_unregister_fn);
 
-int nf_nat_l3proto_init(void)
-{
-	int ret = nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
-
 #if IS_ENABLED(CONFIG_IPV6)
-	if (ret)
-		return ret;
-
-	ret = nf_nat_l3proto_register(&nf_nat_l3proto_ipv6);
-	if (ret == 0)
-		return ret;
-
-	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
-#endif
-	return ret;
-}
-
-void nf_nat_l3proto_exit(void)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv6);
-#endif
-	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
-	.l3proto		= NFPROTO_IPV6,
-};
-
 int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 				    struct nf_conn *ct,
 				    enum ip_conntrack_info ctinfo,
-- 
2.11.0


