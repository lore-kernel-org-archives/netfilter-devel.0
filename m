From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_broadcast: remove useless parameter
Date: Sun, 11 Feb 2018 23:28:18 +0900
Message-ID: <20180211142818.9890-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36262 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbeBKO21 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Feb 2018 09:28:27 -0500
Received: by mail-pf0-f193.google.com with SMTP id p8so1020949pff.3
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Feb 2018 06:28:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parameter protoff in nf_conntrack_broadcast_help is not used anywhere.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 3 +--
 net/netfilter/nf_conntrack_broadcast.c      | 1 -
 net/netfilter/nf_conntrack_netbios_ns.c     | 5 +++--
 net/netfilter/nf_conntrack_snmp.c           | 5 +++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index fc39bba..32c2a94 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -132,8 +132,7 @@ void nf_conntrack_helper_pernet_fini(struct net *net);
 int nf_conntrack_helper_init(void);
 void nf_conntrack_helper_fini(void);
 
-int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
-				struct nf_conn *ct,
+int nf_conntrack_broadcast_help(struct sk_buff *skb, struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo,
 				unsigned int timeout);
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index ecc3ab7..a1086bd 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -20,7 +20,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 
 int nf_conntrack_broadcast_help(struct sk_buff *skb,
-				unsigned int protoff,
 				struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo,
 				unsigned int timeout)
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 496ce17..a4a59dc 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -41,9 +41,10 @@ static struct nf_conntrack_expect_policy exp_policy = {
 };
 
 static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
-		   struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+			   struct nf_conn *ct,
+			   enum ip_conntrack_info ctinfo)
 {
-	return nf_conntrack_broadcast_help(skb, protoff, ct, ctinfo, timeout);
+	return nf_conntrack_broadcast_help(skb, ct, ctinfo, timeout);
 }
 
 static struct nf_conntrack_helper helper __read_mostly = {
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index 87b95a2..2d0f8e01 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -36,11 +36,12 @@ int (*nf_nat_snmp_hook)(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_snmp_hook);
 
 static int snmp_conntrack_help(struct sk_buff *skb, unsigned int protoff,
-		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+			       struct nf_conn *ct,
+			       enum ip_conntrack_info ctinfo)
 {
 	typeof(nf_nat_snmp_hook) nf_nat_snmp;
 
-	nf_conntrack_broadcast_help(skb, protoff, ct, ctinfo, timeout);
+	nf_conntrack_broadcast_help(skb, ct, ctinfo, timeout);
 
 	nf_nat_snmp = rcu_dereference(nf_nat_snmp_hook);
 	if (nf_nat_snmp && ct->status & IPS_NAT_MASK)
-- 
2.9.3

