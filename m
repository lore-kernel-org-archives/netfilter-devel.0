From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/31] netfilter: conntrack: remove unused proto arg from netns init functions
Date: Tue,  9 Oct 2018 01:01:13 +0200
Message-ID: <20181008230125.2330-20-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its unused, next patch will remove l4proto->l3proto number to simplify
l4 protocol demuxer lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 +-
 net/netfilter/nf_conntrack_proto.c           | 5 ++---
 net/netfilter/nf_conntrack_proto_dccp.c      | 2 +-
 net/netfilter/nf_conntrack_proto_generic.c   | 2 +-
 net/netfilter/nf_conntrack_proto_gre.c       | 2 +-
 net/netfilter/nf_conntrack_proto_icmp.c      | 2 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c      | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c       | 2 +-
 net/netfilter/nf_conntrack_proto_udp.c       | 2 +-
 10 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7fdb4b95bba4..420823a8648f 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -84,7 +84,7 @@ struct nf_conntrack_l4proto {
 #endif
 	unsigned int	*net_id;
 	/* Init l4proto pernet data */
-	int (*init_net)(struct net *net, u_int16_t proto);
+	int (*init_net)(struct net *net);
 
 	/* Return the per-net protocol part. */
 	struct nf_proto_net *(*get_net_proto)(struct net *net);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 4896ba44becb..06a182a23d92 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -274,7 +274,7 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 	struct nf_proto_net *pn = NULL;
 
 	if (l4proto->init_net) {
-		ret = l4proto->init_net(net, l4proto->l3proto);
+		ret = l4proto->init_net(net);
 		if (ret < 0)
 			goto out;
 	}
@@ -988,8 +988,7 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
 					&nf_conntrack_l4proto_generic);
 
-	err = nf_conntrack_l4proto_generic.init_net(net,
-					nf_conntrack_l4proto_generic.l3proto);
+	err = nf_conntrack_l4proto_generic.init_net(net);
 	if (err < 0)
 		return err;
 	err = nf_ct_l4proto_register_sysctl(net,
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 1b9e600f707d..d22852ae2316 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -812,7 +812,7 @@ static int dccp_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *pn,
 	return 0;
 }
 
-static int dccp_init_net(struct net *net, u_int16_t proto)
+static int dccp_init_net(struct net *net)
 {
 	struct nf_dccp_net *dn = dccp_pernet(net);
 	struct nf_proto_net *pn = &dn->pn;
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index fea952518d0d..4530f76b51bd 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -136,7 +136,7 @@ static int generic_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int generic_init_net(struct net *net, u_int16_t proto)
+static int generic_init_net(struct net *net)
 {
 	struct nf_generic_net *gn = generic_pernet(net);
 	struct nf_proto_net *pn = &gn->pn;
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 0348aa98950a..810039dcd779 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -329,7 +329,7 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int gre_init_net(struct net *net, u_int16_t proto)
+static int gre_init_net(struct net *net)
 {
 	struct netns_proto_gre *net_gre = gre_pernet(net);
 	int i;
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 2c981622b674..a9d2769f72d8 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -332,7 +332,7 @@ static int icmp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int icmp_init_net(struct net *net, u_int16_t proto)
+static int icmp_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = icmp_pernet(net);
 	struct nf_proto_net *pn = &in->pn;
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index effac451c7e0..8a88db599d66 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -343,7 +343,7 @@ static int icmpv6_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int icmpv6_init_net(struct net *net, u_int16_t proto)
+static int icmpv6_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = icmpv6_pernet(net);
 	struct nf_proto_net *pn = &in->pn;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7d7eb18f658b..9cf59ab280c0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -734,7 +734,7 @@ static int sctp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int sctp_init_net(struct net *net, u_int16_t proto)
+static int sctp_init_net(struct net *net)
 {
 	struct nf_sctp_net *sn = sctp_pernet(net);
 	struct nf_proto_net *pn = &sn->pn;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 14a1a9348fcc..f4954fa7be25 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1506,7 +1506,7 @@ static int tcp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int tcp_init_net(struct net *net, u_int16_t proto)
+static int tcp_init_net(struct net *net)
 {
 	struct nf_tcp_net *tn = tcp_pernet(net);
 	struct nf_proto_net *pn = &tn->pn;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index da94c967c835..4645bf5b20c8 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -290,7 +290,7 @@ static int udp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	return 0;
 }
 
-static int udp_init_net(struct net *net, u_int16_t proto)
+static int udp_init_net(struct net *net)
 {
 	struct nf_udp_net *un = udp_pernet(net);
 	struct nf_proto_net *pn = &un->pn;
-- 
2.11.0
