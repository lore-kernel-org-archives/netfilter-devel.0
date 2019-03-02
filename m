Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE27DC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B841520838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfCBSg3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:29 -0500
Received: from mail.us.es ([193.147.175.20]:36090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbfCBSg1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7AE71361AE
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD6CCDA867
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2788DA85D; Sat,  2 Mar 2019 19:36:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D567DA85D;
        Sat,  2 Mar 2019 19:36:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B5BFC4265A2F;
        Sat,  2 Mar 2019 19:36:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/29] netfilter: nat: remove nf_nat_l3proto.h and nf_nat_core.h
Date:   Sat,  2 Mar 2019 19:35:56 +0100
Message-Id: <20190302183613.3159-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The l3proto name is gone, its header file is the last trace.
While at it, also remove nf_nat_core.h, its very small and all users
include nf_nat.h too.

before:
   text    data     bss     dec     hex filename
  22948    1612    4136   28696    7018 nf_nat.ko

after removal of l3proto register/unregister functions:
   text	   data	    bss	    dec	    hex	filename
  22196	   1516	   4136	  27848	   6cc8 nf_nat.ko

checkpatch complains about overly long lines, but line breaks
do not make things more readable and the line length gets smaller
here, not larger.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h          | 39 +++++++++++++++++++++++++++++++++
 include/net/netfilter/nf_nat_core.h     | 29 ------------------------
 include/net/netfilter/nf_nat_l3proto.h  | 26 ----------------------
 net/ipv4/netfilter/iptable_nat.c        |  8 +++----
 net/ipv4/netfilter/nft_chain_nat_ipv4.c |  6 ++---
 net/ipv6/netfilter/ip6table_nat.c       |  8 +++----
 net/ipv6/netfilter/nft_chain_nat_ipv6.c |  6 ++---
 net/netfilter/nf_conntrack_core.c       |  1 -
 net/netfilter/nf_conntrack_netlink.c    |  2 +-
 net/netfilter/nf_nat_core.c             |  2 --
 net/netfilter/nf_nat_helper.c           |  2 --
 net/netfilter/nf_nat_proto.c            | 18 +++++++--------
 net/netfilter/nft_nat.c                 |  2 --
 net/netfilter/xt_nat.c                  |  2 +-
 net/openvswitch/conntrack.c             |  4 +---
 15 files changed, 60 insertions(+), 95 deletions(-)
 delete mode 100644 include/net/netfilter/nf_nat_core.h
 delete mode 100644 include/net/netfilter/nf_nat_l3proto.h

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index e53b4f9b8b44..cf332c4e0b32 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -73,4 +73,43 @@ int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *nat_ops, unsigned int ops_count);
 void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
 			  unsigned int ops_count);
+
+unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			   unsigned int hooknum, struct sk_buff *skb);
+
+unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
+			      enum nf_nat_manip_type mtype,
+			      enum ip_conntrack_dir dir);
+void nf_nat_csum_recalc(struct sk_buff *skb,
+			u8 nfproto, u8 proto, void *data, __sum16 *check,
+			int datalen, int oldlen);
+
+int nf_nat_icmp_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum);
+
+int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
+				    enum ip_conntrack_info ctinfo,
+				    unsigned int hooknum, unsigned int hdrlen);
+
+int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops);
+void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
+
+int nf_nat_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops);
+void nf_nat_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
+
+unsigned int
+nf_nat_inet_fn(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state);
+
+int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
+
+static inline int nf_nat_initialized(struct nf_conn *ct,
+				     enum nf_nat_manip_type manip)
+{
+	if (manip == NF_NAT_MANIP_SRC)
+		return ct->status & IPS_SRC_NAT_DONE;
+	else
+		return ct->status & IPS_DST_NAT_DONE;
+}
 #endif
diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
deleted file mode 100644
index dc7cd0440229..000000000000
--- a/include/net/netfilter/nf_nat_core.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NF_NAT_CORE_H
-#define _NF_NAT_CORE_H
-#include <linux/list.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat.h>
-
-/* This header used to share core functionality between the standalone
-   NAT module, and the compatibility layer's use of NAT for masquerading. */
-
-unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			   unsigned int hooknum, struct sk_buff *skb);
-
-unsigned int
-nf_nat_inet_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state);
-
-int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family);
-
-static inline int nf_nat_initialized(struct nf_conn *ct,
-				     enum nf_nat_manip_type manip)
-{
-	if (manip == NF_NAT_MANIP_SRC)
-		return ct->status & IPS_SRC_NAT_DONE;
-	else
-		return ct->status & IPS_DST_NAT_DONE;
-}
-
-#endif /* _NF_NAT_CORE_H */
diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
deleted file mode 100644
index 9a68f2b53a9e..000000000000
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NF_NAT_L3PROTO_H
-#define _NF_NAT_L3PROTO_H
-
-unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
-			      enum nf_nat_manip_type mtype,
-			      enum ip_conntrack_dir dir);
-void nf_nat_csum_recalc(struct sk_buff *skb,
-			u8 nfproto, u8 proto, void *data, __sum16 *check,
-			int datalen, int oldlen);
-
-int nf_nat_icmp_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
-				  enum ip_conntrack_info ctinfo,
-				  unsigned int hooknum);
-
-int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
-				    enum ip_conntrack_info ctinfo,
-				    unsigned int hooknum, unsigned int hdrlen);
-
-int nf_nat_l3proto_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops);
-void nf_nat_l3proto_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
-
-int nf_nat_l3proto_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops);
-void nf_nat_l3proto_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
-
-#endif /* _NF_NAT_L3PROTO_H */
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a317445448bf..007da0882412 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -15,8 +15,6 @@
 #include <net/ip.h>
 
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 
 static int __net_init iptable_nat_table_init(struct net *net);
 
@@ -70,10 +68,10 @@ static int ipt_nat_register_lookups(struct net *net)
 	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv4_ops); i++) {
-		ret = nf_nat_l3proto_ipv4_register_fn(net, &nf_nat_ipv4_ops[i]);
+		ret = nf_nat_ipv4_register_fn(net, &nf_nat_ipv4_ops[i]);
 		if (ret) {
 			while (i)
-				nf_nat_l3proto_ipv4_unregister_fn(net, &nf_nat_ipv4_ops[--i]);
+				nf_nat_ipv4_unregister_fn(net, &nf_nat_ipv4_ops[--i]);
 
 			return ret;
 		}
@@ -87,7 +85,7 @@ static void ipt_nat_unregister_lookups(struct net *net)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv4_ops); i++)
-		nf_nat_l3proto_ipv4_unregister_fn(net, &nf_nat_ipv4_ops[i]);
+		nf_nat_ipv4_unregister_fn(net, &nf_nat_ipv4_ops[i]);
 }
 
 static int __net_init iptable_nat_table_init(struct net *net)
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index a3c4ea303e3e..0d1ad5901aff 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -20,10 +20,8 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_ipv4.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
 
 static unsigned int nft_nat_do_chain(void *priv,
@@ -40,12 +38,12 @@ static unsigned int nft_nat_do_chain(void *priv,
 
 static int nft_nat_ipv4_reg(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_nat_l3proto_ipv4_register_fn(net, ops);
+	return nf_nat_ipv4_register_fn(net, ops);
 }
 
 static void nft_nat_ipv4_unreg(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_nat_l3proto_ipv4_unregister_fn(net, ops);
+	nf_nat_ipv4_unregister_fn(net, ops);
 }
 
 static const struct nft_chain_type nft_chain_nat_ipv4 = {
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 67ba70ab9f5c..3e1fab9d7503 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -17,8 +17,6 @@
 #include <net/ipv6.h>
 
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 
 static int __net_init ip6table_nat_table_init(struct net *net);
 
@@ -72,10 +70,10 @@ static int ip6t_nat_register_lookups(struct net *net)
 	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv6_ops); i++) {
-		ret = nf_nat_l3proto_ipv6_register_fn(net, &nf_nat_ipv6_ops[i]);
+		ret = nf_nat_ipv6_register_fn(net, &nf_nat_ipv6_ops[i]);
 		if (ret) {
 			while (i)
-				nf_nat_l3proto_ipv6_unregister_fn(net, &nf_nat_ipv6_ops[--i]);
+				nf_nat_ipv6_unregister_fn(net, &nf_nat_ipv6_ops[--i]);
 
 			return ret;
 		}
@@ -89,7 +87,7 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv6_ops); i++)
-		nf_nat_l3proto_ipv6_unregister_fn(net, &nf_nat_ipv6_ops[i]);
+		nf_nat_ipv6_unregister_fn(net, &nf_nat_ipv6_ops[i]);
 }
 
 static int __net_init ip6table_nat_table_init(struct net *net)
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index 8a081ad7d5db..e66bfd0b3d15 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -18,10 +18,8 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_ipv6.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ipv6.h>
 
 static unsigned int nft_nat_do_chain(void *priv,
@@ -38,12 +36,12 @@ static unsigned int nft_nat_do_chain(void *priv,
 
 static int nft_nat_ipv6_reg(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_nat_l3proto_ipv6_register_fn(net, ops);
+	return nf_nat_ipv6_register_fn(net, ops);
 }
 
 static void nft_nat_ipv6_unreg(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_nat_l3proto_ipv6_unregister_fn(net, ops);
+	nf_nat_ipv6_unregister_fn(net, ops);
 }
 
 static const struct nft_chain_type nft_chain_nat_ipv6 = {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e139c256e269..4a9107e4a69c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -51,7 +51,6 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netns/hash.h>
 #include <net/ip.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 349b42a65c8a..66c596d287a5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -46,7 +46,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #ifdef CONFIG_NF_NAT_NEEDED
-#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #endif
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d9b70e560007..11acd7367623 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -22,8 +22,6 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 0a8dd5f368cd..ccc06f7539d7 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -22,8 +22,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 
 /* Frobs data inside this packet, which is linear. */
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index f5c60d3b9d38..62743da3004f 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -20,8 +20,6 @@
 
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 
 #include <linux/ipv6.h>
 #include <linux/netfilter_ipv6.h>
@@ -758,17 +756,17 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	},
 };
 
-int nf_nat_l3proto_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops)
+int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops)
 {
 	return nf_nat_register_fn(net, ops, nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
 }
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_register_fn);
+EXPORT_SYMBOL_GPL(nf_nat_ipv4_register_fn);
 
-void nf_nat_l3proto_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
 {
 	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
 }
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_unregister_fn);
+EXPORT_SYMBOL_GPL(nf_nat_ipv4_unregister_fn);
 
 #if IS_ENABLED(CONFIG_IPV6)
 int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
@@ -1010,16 +1008,16 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	},
 };
 
-int nf_nat_l3proto_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops)
+int nf_nat_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops)
 {
 	return nf_nat_register_fn(net, ops, nf_nat_ipv6_ops,
 				  ARRAY_SIZE(nf_nat_ipv6_ops));
 }
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_register_fn);
+EXPORT_SYMBOL_GPL(nf_nat_ipv6_register_fn);
 
-void nf_nat_l3proto_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+void nf_nat_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
 {
 	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
 }
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_unregister_fn);
+EXPORT_SYMBOL_GPL(nf_nat_ipv6_unregister_fn);
 #endif /* CONFIG_IPV6 */
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index c15807d10b91..e93aed9bda88 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -21,9 +21,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
 
 struct nft_nat {
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index ac91170fc8c8..61eabd171186 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -14,7 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat.h>
 
 static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index def4d28fcbc3..1b6896896fff 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -29,9 +29,7 @@
 #include <net/ipv6_frag.h>
 
 #ifdef CONFIG_NF_NAT_NEEDED
-#include <linux/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
+#include <net/netfilter/nf_nat.h>
 #endif
 
 #include "datapath.h"
-- 
2.11.0


