From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/50]: nf_conntrack: remove 'ignore_conntrack' argument
	from nf_conntrack_find_get
Date: Sat,  7 Jul 2007 14:23:37 +0200 (MEST)
Message-ID: <20070707122253.1589.46836.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: remove 'ignore_conntrack' argument from nf_conntrack_find_get

All callers pass NULL, this also doesn't seem very useful for modules.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 892f7d5c721019097ab8961c1933f6e9c8746781
tree 8efa763a13bb97de29a3702fac3215392a68939c
parent eee0fb7b7e679c8e8d8ae0b613e20229c4e54394
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:41 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:41 +0200

 include/net/netfilter/nf_conntrack_core.h      |    3 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    4 ++--
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    7 +++----
 net/netfilter/nf_conntrack_netlink.c           |    6 +++---
 net/netfilter/nf_conntrack_pptp.c              |    2 +-
 7 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 6351948..2fa3a1b 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -58,8 +58,7 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 /* Find a connection corresponding to a tuple. */
 extern struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple,
-		      const struct nf_conn *ignored_conntrack);
+nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple);
 
 extern int __nf_conntrack_confirm(struct sk_buff **pskb);
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 129a8cc..a103f59 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -334,7 +334,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		return -EINVAL;
 	}
 
-	h = nf_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple);
 	if (h) {
 		struct sockaddr_in sin;
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index f4fc657..91fb277 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -187,13 +187,13 @@ icmp_error_message(struct sk_buff *skb,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(&innertuple, NULL);
+	h = nf_conntrack_find_get(&innertuple);
 	if (!h) {
 		/* Locally generated ICMPs will match inverted if they
 		   haven't been SNAT'ed yet */
 		/* FIXME: NAT code has to handle half-done double NAT --RR */
 		if (hooknum == NF_IP_LOCAL_OUT)
-			h = nf_conntrack_find_get(&origtuple, NULL);
+			h = nf_conntrack_find_get(&origtuple);
 
 		if (!h) {
 			DEBUGP("icmp_error_message: no match\n");
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 8814b95..a514661 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -193,7 +193,7 @@ icmpv6_error_message(struct sk_buff *skb,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(&intuple, NULL);
+	h = nf_conntrack_find_get(&intuple);
 	if (!h) {
 		DEBUGP("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 992d0ef..8ed761c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -244,13 +244,12 @@ EXPORT_SYMBOL_GPL(__nf_conntrack_find);
 
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
-nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple,
-		      const struct nf_conn *ignored_conntrack)
+nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_tuple_hash *h;
 
 	read_lock_bh(&nf_conntrack_lock);
-	h = __nf_conntrack_find(tuple, ignored_conntrack);
+	h = __nf_conntrack_find(tuple, NULL);
 	if (h)
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
 	read_unlock_bh(&nf_conntrack_lock);
@@ -574,7 +573,7 @@ resolve_normal_ct(struct sk_buff *skb,
 	}
 
 	/* look for tuple match */
-	h = nf_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple);
 	if (!h) {
 		h = init_conntrack(&tuple, l3proto, l4proto, skb, dataoff);
 		if (!h)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0627559..d310ec8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -689,7 +689,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -744,7 +744,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(&tuple, NULL);
+	h = nf_conntrack_find_get(&tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1426,7 +1426,7 @@ ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = nf_conntrack_find_get(&master_tuple, NULL);
+	h = nf_conntrack_find_get(&master_tuple);
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 115bcb5..da36c48 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -146,7 +146,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 	DEBUGP("trying to timeout ct or exp for tuple ");
 	NF_CT_DUMP_TUPLE(t);
 
-	h = nf_conntrack_find_get(t, NULL);
+	h = nf_conntrack_find_get(t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
 		DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
