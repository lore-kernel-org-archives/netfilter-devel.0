From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/52] netfilter: conntrack: constify list of builtin trackers
Date: Mon,  8 Jan 2018 21:19:10 +0100
Message-ID: <20180108202000.12989-3-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h   | 10 +++++-----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  2 +-
 net/netfilter/nf_conntrack_proto.c             | 12 ++++++------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 0e5618ec8b9d..7fbb8f64a96e 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -125,18 +125,18 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 				const struct nf_conntrack_l4proto *proto);
 int nf_ct_l4proto_pernet_register(struct net *net,
-				  struct nf_conntrack_l4proto *const proto[],
+				  const struct nf_conntrack_l4proto *const proto[],
 				  unsigned int num_proto);
 void nf_ct_l4proto_pernet_unregister(struct net *net,
-				struct nf_conntrack_l4proto *const proto[],
+				const struct nf_conntrack_l4proto *const proto[],
 				unsigned int num_proto);
 
 /* Protocol global registration. */
-int nf_ct_l4proto_register_one(struct nf_conntrack_l4proto *proto);
+int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *proto);
 void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *proto);
-int nf_ct_l4proto_register(struct nf_conntrack_l4proto *proto[],
+int nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const proto[],
 			   unsigned int num_proto);
-void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *proto[],
+void nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const proto[],
 			      unsigned int num_proto);
 
 /* Generic netlink helpers */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 89af9d88ca21..bb2c868a5621 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -368,7 +368,7 @@ MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("ip_conntrack");
 MODULE_LICENSE("GPL");
 
-static struct nf_conntrack_l4proto *builtin_l4proto4[] = {
+static const struct nf_conntrack_l4proto * const builtin_l4proto4[] = {
 	&nf_conntrack_l4proto_tcp4,
 	&nf_conntrack_l4proto_udp4,
 	&nf_conntrack_l4proto_icmp,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 3b80a38f62b8..7340ca7cc362 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -368,7 +368,7 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 	.owner		= THIS_MODULE,
 };
 
-static struct nf_conntrack_l4proto *builtin_l4proto6[] = {
+static const struct nf_conntrack_l4proto * const builtin_l4proto6[] = {
 	&nf_conntrack_l4proto_tcp6,
 	&nf_conntrack_l4proto_udp6,
 	&nf_conntrack_l4proto_icmpv6,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 19c3b1b84544..afdeca53e88b 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -385,7 +385,7 @@ void nf_ct_l4proto_unregister_sysctl(struct net *net,
 
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
-int nf_ct_l4proto_register_one(struct nf_conntrack_l4proto *l4proto)
+int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 
@@ -498,7 +498,7 @@ void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister_one);
 
-int nf_ct_l4proto_register(struct nf_conntrack_l4proto *l4proto[],
+int nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 			   unsigned int num_proto)
 {
 	int ret = -EINVAL, ver;
@@ -520,7 +520,7 @@ int nf_ct_l4proto_register(struct nf_conntrack_l4proto *l4proto[],
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_register);
 
 int nf_ct_l4proto_pernet_register(struct net *net,
-				  struct nf_conntrack_l4proto *const l4proto[],
+				  const struct nf_conntrack_l4proto *const l4proto[],
 				  unsigned int num_proto)
 {
 	int ret = -EINVAL;
@@ -541,7 +541,7 @@ int nf_ct_l4proto_pernet_register(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register);
 
-void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto[],
+void nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
 			      unsigned int num_proto)
 {
 	mutex_lock(&nf_ct_proto_mutex);
@@ -551,12 +551,12 @@ void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto[],
 
 	synchronize_net();
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_destroy(kill_l4proto, l4proto);
+	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister);
 
 void nf_ct_l4proto_pernet_unregister(struct net *net,
-				struct nf_conntrack_l4proto *const l4proto[],
+				const struct nf_conntrack_l4proto *const l4proto[],
 				unsigned int num_proto)
 {
 	while (num_proto-- != 0)
-- 
2.11.0
