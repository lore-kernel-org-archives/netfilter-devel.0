From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/47] netfilter: nf_conntrack_broadcast: remove useless parameter
Date: Fri, 30 Mar 2018 13:36:46 +0200
Message-ID: <20180330113729.18335-5-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

parameter protoff in nf_conntrack_broadcast_help is not used anywhere.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 3 +--
 net/netfilter/nf_conntrack_broadcast.c      | 1 -
 net/netfilter/nf_conntrack_netbios_ns.c     | 5 +++--
 net/netfilter/nf_conntrack_snmp.c           | 5 +++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index fc39bbaf107c..32c2a94a219d 100644
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
index ecc3ab784633..a1086bdec242 100644
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
index 496ce173f0c1..a4a59dc7cf17 100644
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
index 87b95a2c270c..2d0f8e010821 100644
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
2.11.0
