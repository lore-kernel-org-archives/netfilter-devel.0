From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/23] netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size
Date: Tue,  7 Nov 2017 01:52:09 +0100
Message-ID: <20171107005213.22618-20-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We currently call ->nlattr_tuple_size() once at register time and
cache result in l4proto->nla_size.

nla_size is the only member that is written to, avoiding this would
allow to make l4proto trackers const.

We can use ->nlattr_tuple_size() at run time, and cache result in
the individual trackers instead.

This is an intermediate step, next patch removes nlattr_size()
callback and computes size at compile time, then removes nla_size.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h   |  4 ++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  9 +++++++--
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  9 +++++++--
 net/netfilter/nf_conntrack_core.c              |  9 +++++++--
 net/netfilter/nf_conntrack_netlink.c           | 10 +++++++---
 net/netfilter/nf_conntrack_proto.c             |  2 --
 net/netfilter/nf_conntrack_proto_tcp.c         |  9 +++++++--
 7 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index e06518874144..46e786ffcf2f 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -74,7 +74,7 @@ struct nf_conntrack_l4proto {
 	int (*tuple_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
 	/* Calculate tuple nlattr size */
-	int (*nlattr_tuple_size)(void);
+	unsigned int (*nlattr_tuple_size)(void);
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
 	const struct nla_policy *nla_policy;
@@ -144,7 +144,7 @@ int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple);
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
-int nf_ct_port_nlattr_tuple_size(void);
+unsigned int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 8969420cecc3..1849fedd9b81 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -258,9 +258,14 @@ static int icmp_nlattr_to_tuple(struct nlattr *tb[],
 	return 0;
 }
 
-static int icmp_nlattr_tuple_size(void)
+static unsigned int icmp_nlattr_tuple_size(void)
 {
-	return nla_policy_len(icmp_nla_policy, CTA_PROTO_MAX + 1);
+	static unsigned int size __read_mostly;
+
+	if (!size)
+		size = nla_policy_len(icmp_nla_policy, CTA_PROTO_MAX + 1);
+
+	return size;
 }
 #endif
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index dca921df28e1..3ac0d826afc4 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -259,9 +259,14 @@ static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
 	return 0;
 }
 
-static int icmpv6_nlattr_tuple_size(void)
+static unsigned int icmpv6_nlattr_tuple_size(void)
 {
-	return nla_policy_len(icmpv6_nla_policy, CTA_PROTO_MAX + 1);
+	static unsigned int size __read_mostly;
+
+	if (!size)
+		size = nla_policy_len(icmpv6_nla_policy, CTA_PROTO_MAX + 1);
+
+	return size;
 }
 #endif
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 28e675150853..0e516947c16f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1563,9 +1563,14 @@ int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 }
 EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_to_tuple);
 
-int nf_ct_port_nlattr_tuple_size(void)
+unsigned int nf_ct_port_nlattr_tuple_size(void)
 {
-	return nla_policy_len(nf_ct_port_nla_policy, CTA_PROTO_MAX + 1);
+	static unsigned int size __read_mostly;
+
+	if (!size)
+		size = nla_policy_len(nf_ct_port_nla_policy, CTA_PROTO_MAX + 1);
+
+	return size;
 }
 EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_tuple_size);
 #endif
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index de4053d84364..6e0adfefb9ed 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -533,11 +533,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
-static inline size_t ctnetlink_proto_size(const struct nf_conn *ct)
+static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 {
 	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
-	size_t len;
+	size_t len, len4 = 0;
 
 	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
 	len = l3proto->nla_size;
@@ -545,8 +545,12 @@ static inline size_t ctnetlink_proto_size(const struct nf_conn *ct)
 
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	len += l4proto->nla_size;
+	if (l4proto->nlattr_tuple_size) {
+		len4 = l4proto->nlattr_tuple_size();
+		len4 *= 3u; /* ORIG, REPLY, MASTER */
+	}
 
-	return len;
+	return len + len4;
 }
 
 static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 83f739e9dc08..3b06ff3f2dee 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -398,8 +398,6 @@ int nf_ct_l4proto_register_one(struct nf_conntrack_l4proto *l4proto)
 	l4proto->nla_size = 0;
 	if (l4proto->nlattr_size)
 		l4proto->nla_size += l4proto->nlattr_size();
-	if (l4proto->nlattr_tuple_size)
-		l4proto->nla_size += 3 * l4proto->nlattr_tuple_size();
 
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   l4proto);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8f283294d70f..b12fc07111d0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1277,9 +1277,14 @@ static int tcp_nlattr_size(void)
 		+ nla_policy_len(tcp_nla_policy, CTA_PROTOINFO_TCP_MAX + 1);
 }
 
-static int tcp_nlattr_tuple_size(void)
+static unsigned int tcp_nlattr_tuple_size(void)
 {
-	return nla_policy_len(nf_ct_port_nla_policy, CTA_PROTO_MAX + 1);
+	static unsigned int size __read_mostly;
+
+	if (!size)
+		size = nla_policy_len(nf_ct_port_nla_policy, CTA_PROTO_MAX + 1);
+
+	return size;
 }
 #endif
 
-- 
2.11.0
