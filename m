From: Philip Craig <philipc@snapgear.com>
Subject: [RFC] conntrack: add local/remote bit to conntrack tuple for tproxy
 support
Date: Fri, 26 Jun 2009 17:43:24 +1000
Message-ID: <4A447C1C.5050901@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030005020803050907060806"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:43554 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753023AbZFZHn0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:43:26 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bne.snapgear.com (Postfix) with ESMTP id 86929EBBB9
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2009 17:43:26 +1000 (EST)
Received: from bne.snapgear.com ([127.0.0.1])
	by localhost (bne.snapgear.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w2V2IAV86Fnm for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Jun 2009 17:43:24 +1000 (EST)
Received: from [192.168.0.3] (philipc2.sw.moreton.com.au [10.46.1.58])
	by bne.snapgear.com (Postfix) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2009 17:43:24 +1000 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030005020803050907060806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If you use tproxy both to redirect the incoming connection to the proxy,
and to set the original source address/port for the outgoing connection
from the proxy, then you end up with two connections that are currently
indistinguishable by conntrack.

Possible workarounds for this problem are:

- don't preserve the source port on the outgoing connection. This
greatly reduces the chance of a clash, but it is still possible when a
client is making multiple simultaneous connections to the proxy.

- use NOTRACK to avoid conntracking one of the connections. This works,
except that I want conntrack for both connections, for example to log
them.

- don't do that. Things work fine if you use iptables NAT to redirect
the incoming connection. This is the solution I plan to use for now, but
it won't work for IPv6.

I've developed a patch for conntrack that solves the problem. It's still
quite raw, but I would appreciate any comments on the approach (and
whether something like this would be considered for mainline).

I've added two bits to each conntrack tuple to signify whether the
source and destination of the tuple are local or remote.

The main problem with this approach is that we don't know in the
prerouting hook whether the destination is local or remote.

I've solved this by delaying setting the destination bit until the
conntrack is confirmed, which means all conntrack comparison and
hashing is done without the destination bit. This may mean the
destination bit isn't needed in the first place, but I've kept it
because it makes tuple inversion simple (I'm not sure if anything
needs tuple inversion after the conntrack is confirmed). Even if the
destination bit was removed, the source bit for the reply tuple still
cannot be determined until after routing.

That's about all there is to the patch. I've started the netlink changes
for debugging purposes. I'm not sure yet how to make things like
conntrack creation via netlink backward compatible with a userspace that
doesn't know about the new bits. I guess the default could be set based
on whether the address is local.

I also haven't thought much about whether expectations and related ICMP
packets are being handled correctly.

Also, the rename of nf_conntrack_tuple.dst.dir is just temporary so that
the compiler flags all uses for me.

--------------030005020803050907060806
Content-Type: text/x-patch;
 name="conntrack.tproxy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack.tproxy.patch"

Index: linux-2.6.x/include/linux/netfilter/nf_conntrack_tuple_common.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/linux/netfilter/nf_conntrack_tuple_common.h,v
retrieving revision 1.1.1.1
diff -u -p -r1.1.1.1 nf_conntrack_tuple_common.h
--- linux-2.6.x/include/linux/netfilter/nf_conntrack_tuple_common.h	4 Jan 2006 00:42:51 -0000	1.1.1.1
+++ linux-2.6.x/include/linux/netfilter/nf_conntrack_tuple_common.h	26 Jun 2009 06:32:02 -0000
@@ -3,11 +3,23 @@
 
 enum ip_conntrack_dir
 {
-	IP_CT_DIR_ORIGINAL,
-	IP_CT_DIR_REPLY,
-	IP_CT_DIR_MAX
+	IP_CT_DIR_ORIGINAL = 0x00,
+	IP_CT_DIR_REPLY = 0x01,
 };
 
+#define IP_CT_DIR_MAX   0x02
+
+#define IP_CT_LOCAL_SRC 0x02
+#define IP_CT_LOCAL_DST 0x04
+#define IP_CT_LOCAL_MASK (IP_CT_LOCAL_SRC | IP_CT_LOCAL_DST)
+
+static inline u_int8_t nf_ct_invert_dir(u_int8_t ctdir)
+{
+	return ((ctdir ^ IP_CT_DIR_REPLY) & ~IP_CT_LOCAL_MASK) |
+	       ((ctdir & IP_CT_LOCAL_SRC) << 1) |
+	       ((ctdir & IP_CT_LOCAL_DST) >> 1);
+}
+
 #define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
 
 #endif /* _NF_CONNTRACK_TUPLE_COMMON_H */
Index: linux-2.6.x/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/linux/netfilter/nfnetlink_conntrack.h,v
retrieving revision 1.1.1.8
diff -u -p -r1.1.1.8 nfnetlink_conntrack.h
--- linux-2.6.x/include/linux/netfilter/nfnetlink_conntrack.h	25 Mar 2009 01:16:58 -0000	1.1.1.8
+++ linux-2.6.x/include/linux/netfilter/nfnetlink_conntrack.h	26 Jun 2009 06:32:02 -0000
@@ -40,6 +40,7 @@ enum ctattr_type {
 	CTA_NAT_SEQ_ADJ_ORIG,
 	CTA_NAT_SEQ_ADJ_REPLY,
 	CTA_SECMARK,
+	CTA_DIR,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
Index: linux-2.6.x/include/net/netfilter/nf_conntrack.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/net/netfilter/nf_conntrack.h,v
retrieving revision 1.7
diff -u -p -r1.7 nf_conntrack.h
--- linux-2.6.x/include/net/netfilter/nf_conntrack.h	25 Mar 2009 06:28:27 -0000	1.7
+++ linux-2.6.x/include/net/netfilter/nf_conntrack.h	26 Jun 2009 06:32:02 -0000
@@ -149,7 +149,7 @@ static inline struct nf_conn *
 nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 {
 	return container_of(hash, struct nf_conn,
-			    tuplehash[hash->tuple.dst.dir]);
+			    tuplehash[NF_CT_DIRECTION(hash)]);
 }
 
 static inline u_int16_t nf_ct_l3num(const struct nf_conn *ct)
@@ -218,7 +218,8 @@ extern void nf_conntrack_hash_insert(str
 extern void nf_conntrack_flush(struct net *net, u32 pid, int report);
 
 extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
-			      unsigned int nhoff, u_int16_t l3num,
+			      unsigned int nhoff, unsigned int hooknum,
+			      u_int16_t l3num,
 			      struct nf_conntrack_tuple *tuple);
 extern bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 				 const struct nf_conntrack_tuple *orig);
Index: linux-2.6.x/include/net/netfilter/nf_conntrack_core.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/net/netfilter/nf_conntrack_core.h,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 nf_conntrack_core.h
--- linux-2.6.x/include/net/netfilter/nf_conntrack_core.h	25 Mar 2009 01:17:05 -0000	1.1.1.9
+++ linux-2.6.x/include/net/netfilter/nf_conntrack_core.h	26 Jun 2009 06:32:02 -0000
@@ -35,6 +35,7 @@ extern bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
 		unsigned int dataoff,
+		unsigned int hooknum,
 		u_int16_t l3num,
 		u_int8_t protonum,
 		struct nf_conntrack_tuple *tuple,
@@ -51,17 +52,18 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 extern struct nf_conntrack_tuple_hash *
 nf_conntrack_find_get(struct net *net, const struct nf_conntrack_tuple *tuple);
 
-extern int __nf_conntrack_confirm(struct sk_buff *skb);
+extern int __nf_conntrack_confirm(struct sk_buff *skb, unsigned int hooknum);
 
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
-static inline int nf_conntrack_confirm(struct sk_buff *skb)
+static inline int nf_conntrack_confirm(struct sk_buff *skb,
+				       unsigned int hooknum)
 {
 	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 	int ret = NF_ACCEPT;
 
 	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-			ret = __nf_conntrack_confirm(skb);
+			ret = __nf_conntrack_confirm(skb, hooknum);
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
 	}
Index: linux-2.6.x/include/net/netfilter/nf_conntrack_l3proto.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/net/netfilter/nf_conntrack_l3proto.h,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 nf_conntrack_l3proto.h
--- linux-2.6.x/include/net/netfilter/nf_conntrack_l3proto.h	24 Jul 2008 00:12:19 -0000	1.1.1.9
+++ linux-2.6.x/include/net/netfilter/nf_conntrack_l3proto.h	26 Jun 2009 06:32:02 -0000
@@ -24,6 +24,8 @@ struct nf_conntrack_l3proto
 	/* Protocol name */
 	const char *name;
 
+	bool (*local_hook)(unsigned int hooknum);
+
 	/*
 	 * Try to fill in the third arg: nhoff is offset of l3 proto
          * hdr.  Return true if possible.
Index: linux-2.6.x/include/net/netfilter/nf_conntrack_tuple.h
===================================================================
RCS file: /cvs/sw/linux-2.6.x/include/net/netfilter/nf_conntrack_tuple.h,v
retrieving revision 1.5
diff -u -p -r1.5 nf_conntrack_tuple.h
--- linux-2.6.x/include/net/netfilter/nf_conntrack_tuple.h	25 Mar 2009 06:28:27 -0000	1.5
+++ linux-2.6.x/include/net/netfilter/nf_conntrack_tuple.h	26 Jun 2009 06:32:02 -0000
@@ -95,7 +95,7 @@ struct nf_conntrack_tuple
 		u_int8_t protonum;
 
 		/* The direction (for tuplehash) */
-		u_int8_t dir;
+		u_int8_t ctdir;
 	} dst;
 };
 
@@ -104,6 +104,7 @@ struct nf_conntrack_tuple_mask
 	struct {
 		union nf_inet_addr u3;
 		union nf_conntrack_man_proto u;
+		u_int8_t ctdir;
 	} src;
 };
 
@@ -112,9 +113,11 @@ struct nf_conntrack_tuple_mask
 static inline void nf_ct_dump_tuple_ip(const struct nf_conntrack_tuple *t)
 {
 #ifdef DEBUG
-	printk("tuple %p: %u %pI4:%hu -> %pI4:%hu\n",
+	printk("tuple %p: %s %u %pI4:%hu -> %s %pI4:%hu\n",
 	       t, t->dst.protonum,
+	       (t->dst.ctdir & IP_CT_LOCAL_SRC) ? "local" : "remote",
 	       &t->src.u3.ip, ntohs(t->src.u.all),
+	       (t->dst.ctdir & IP_CT_LOCAL_DST) ? "local" : "remote",
 	       &t->dst.u3.ip, ntohs(t->dst.u.all));
 #endif
 }
@@ -124,7 +127,9 @@ static inline void nf_ct_dump_tuple_ipv6
 #ifdef DEBUG
 	printk("tuple %p: %u %pI6 %hu -> %pI6 %hu\n",
 	       t, t->dst.protonum,
+	       (t->dst.ctdir & IP_CT_LOCAL_SRC) ? "local" : "remote",
 	       t->src.u3.all, ntohs(t->src.u.all),
+	       (t->dst.ctdir & IP_CT_LOCAL_DST) ? "local" : "remote",
 	       t->dst.u3.all, ntohs(t->dst.u.all));
 #endif
 }
@@ -143,7 +148,7 @@ static inline void nf_ct_dump_tuple(cons
 
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
-	((enum ip_conntrack_dir)(h)->tuple.dst.dir)
+	((enum ip_conntrack_dir)((h)->tuple.dst.ctdir & IP_CT_DIR_REPLY))
 
 /* Connections have two entries in the hash table: one for each way */
 struct nf_conntrack_tuple_hash
@@ -159,12 +164,15 @@ static inline bool __nf_ct_tuple_src_equ
 { 
 	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
 		t1->src.u.all == t2->src.u.all &&
-		t1->src.l3num == t2->src.l3num);
+		t1->src.l3num == t2->src.l3num &&
+		!((t1->dst.ctdir ^ t2->dst.ctdir) & IP_CT_LOCAL_SRC));
 }
 
 static inline bool __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
 {
+	/* Don't compare IP_CT_LOCAL_DST because it is undetermined for
+	 * incoming packets. */
 	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
 		t1->dst.u.all == t2->dst.u.all &&
 		t1->dst.protonum == t2->dst.protonum);
@@ -182,7 +190,8 @@ nf_ct_tuple_mask_equal(const struct nf_c
 		       const struct nf_conntrack_tuple_mask *m2)
 {
 	return (nf_inet_addr_cmp(&m1->src.u3, &m2->src.u3) &&
-		m1->src.u.all == m2->src.u.all);
+		m1->src.u.all == m2->src.u.all &&
+		m1->src.ctdir == m2->src.ctdir);
 }
 
 static inline bool
@@ -201,6 +210,9 @@ nf_ct_tuple_src_mask_cmp(const struct nf
 	if ((t1->src.u.all ^ t2->src.u.all) & mask->src.u.all)
 		return false;
 
+	if ((t1->dst.ctdir ^ t2->dst.ctdir) & mask->src.ctdir)
+		return false;
+
 	if (t1->src.l3num != t2->src.l3num ||
 	    t1->dst.protonum != t2->dst.protonum)
 		return false;
Index: linux-2.6.x/net/netfilter/nf_conntrack_core.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nf_conntrack_core.c,v
retrieving revision 1.8
diff -u -p -r1.8 nf_conntrack_core.c
--- linux-2.6.x/net/netfilter/nf_conntrack_core.c	25 Mar 2009 06:28:29 -0000	1.8
+++ linux-2.6.x/net/netfilter/nf_conntrack_core.c	26 Jun 2009 06:32:02 -0000
@@ -73,12 +73,13 @@ static u_int32_t __hash_conntrack(const 
 
 	/* The direction must be ignored, so we hash everything up to the
 	 * destination ports (which is a multiple of 4) and treat the last
-	 * three bytes manually.
+	 * four bytes manually.
 	 */
 	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
 	h = jhash2((u32 *)tuple, n,
 		   rnd ^ (((__force __u16)tuple->dst.u.all << 16) |
-			  tuple->dst.protonum));
+			  tuple->dst.protonum |
+			  (tuple->dst.ctdir & IP_CT_LOCAL_SRC)));
 
 	return ((u64)h * size) >> 32;
 }
@@ -93,6 +94,7 @@ bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
 		unsigned int dataoff,
+		unsigned int hooknum,
 		u_int16_t l3num,
 		u_int8_t protonum,
 		struct nf_conntrack_tuple *tuple,
@@ -106,14 +108,17 @@ nf_ct_get_tuple(const struct sk_buff *sk
 		return false;
 
 	tuple->dst.protonum = protonum;
-	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
+	tuple->dst.ctdir = IP_CT_DIR_ORIGINAL;
+	if (l3proto->local_hook(hooknum))
+		tuple->dst.ctdir |= IP_CT_LOCAL_SRC;
 
 	return l4proto->pkt_to_tuple(skb, dataoff, tuple);
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuple);
 
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
-		       u_int16_t l3num, struct nf_conntrack_tuple *tuple)
+		       unsigned int hooknum, u_int16_t l3num,
+		       struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
@@ -132,8 +137,8 @@ bool nf_ct_get_tuplepr(const struct sk_b
 
 	l4proto = __nf_ct_l4proto_find(l3num, protonum);
 
-	ret = nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, tuple,
-			      l3proto, l4proto);
+	ret = nf_ct_get_tuple(skb, nhoff, protoff, hooknum, l3num, protonum,
+			      tuple, l3proto, l4proto);
 
 	rcu_read_unlock();
 	return ret;
@@ -152,7 +157,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 	if (l3proto->invert_tuple(inverse, orig) == 0)
 		return false;
 
-	inverse->dst.dir = !orig->dst.dir;
+	inverse->dst.ctdir = nf_ct_invert_dir(orig->dst.ctdir);
 
 	inverse->dst.protonum = orig->dst.protonum;
 	return l4proto->invert_tuple(inverse, orig);
@@ -320,8 +325,11 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash_inse
 
 /* Confirm a connection given skb; places it in hash table */
 int
-__nf_conntrack_confirm(struct sk_buff *skb)
+__nf_conntrack_confirm(struct sk_buff *skb, unsigned int hooknum)
 {
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_tuple *orig;
+	struct nf_conntrack_tuple *repl;
 	unsigned int hash, repl_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -340,8 +348,17 @@ __nf_conntrack_confirm(struct sk_buff *s
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
-	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	orig = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	repl = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
+	if (l3proto->local_hook(hooknum)) {
+		orig->dst.ctdir |= IP_CT_LOCAL_DST;
+		repl->dst.ctdir |= IP_CT_LOCAL_SRC;
+	}
+
+	hash = hash_conntrack(orig);
+	repl_hash = hash_conntrack(repl);
 
 	/* We're not in hash table, and we refuse to set up related
 	   connections for unconfirmed conns.  But packet copies and
@@ -359,12 +376,10 @@ __nf_conntrack_confirm(struct sk_buff *s
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
 	hlist_for_each_entry(h, n, &net->ct.hash[hash], hnode)
-		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				      &h->tuple))
+		if (nf_ct_tuple_equal(orig, &h->tuple))
 			goto out;
 	hlist_for_each_entry(h, n, &net->ct.hash[repl_hash], hnode)
-		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-				      &h->tuple))
+		if (nf_ct_tuple_equal(repl, &h->tuple))
 			goto out;
 
 	/* Remove from unconfirmed list */
@@ -619,6 +634,7 @@ static inline struct nf_conn *
 resolve_normal_ct(struct net *net,
 		  struct sk_buff *skb,
 		  unsigned int dataoff,
+		  unsigned int hooknum,
 		  u_int16_t l3num,
 		  u_int8_t protonum,
 		  struct nf_conntrack_l3proto *l3proto,
@@ -631,7 +647,7 @@ resolve_normal_ct(struct net *net,
 	struct nf_conn *ct;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
-			     dataoff, l3num, protonum, &tuple, l3proto,
+			     dataoff, hooknum, l3num, protonum, &tuple, l3proto,
 			     l4proto)) {
 		pr_debug("resolve_normal_ct: Can't get tuple\n");
 		return NULL;
@@ -717,7 +733,7 @@ nf_conntrack_in(struct net *net, u_int8_
 		}
 	}
 
-	ct = resolve_normal_ct(net, skb, dataoff, pf, protonum,
+	ct = resolve_normal_ct(net, skb, dataoff, hooknum, pf, protonum,
 			       l3proto, l4proto, &set_reply, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
Index: linux-2.6.x/net/netfilter/nf_conntrack_expect.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nf_conntrack_expect.c,v
retrieving revision 1.1.1.8
diff -u -p -r1.1.1.8 nf_conntrack_expect.c
--- linux-2.6.x/net/netfilter/nf_conntrack_expect.c	25 Mar 2009 01:16:19 -0000	1.1.1.8
+++ linux-2.6.x/net/netfilter/nf_conntrack_expect.c	26 Jun 2009 06:32:02 -0000
@@ -189,6 +189,7 @@ static inline int expect_clash(const str
 	int count;
 
 	intersect_mask.src.u.all = a->mask.src.u.all & b->mask.src.u.all;
+	intersect_mask.src.ctdir = a->mask.src.ctdir & b->mask.src.ctdir;
 
 	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
 		intersect_mask.src.u3.all[count] =
Index: linux-2.6.x/net/netfilter/nf_conntrack_netlink.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nf_conntrack_netlink.c,v
retrieving revision 1.8
diff -u -p -r1.8 nf_conntrack_netlink.c
--- linux-2.6.x/net/netfilter/nf_conntrack_netlink.c	25 Mar 2009 06:28:29 -0000	1.8
+++ linux-2.6.x/net/netfilter/nf_conntrack_netlink.c	26 Jun 2009 06:32:02 -0000
@@ -128,6 +128,17 @@ nla_put_failure:
 }
 
 static inline int
+ctnetlink_dump_dir(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	NLA_PUT_U8(skb, CTA_DIR,
+		   ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ctdir);
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static inline int
 ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	long timeout = (ct->timeout.expires - jiffies) / HZ;
@@ -381,6 +392,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	nla_nest_end(skb, nest_parms);
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
+	    ctnetlink_dump_dir(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
@@ -476,6 +488,9 @@ static int ctnetlink_conntrack_event(str
 	if (ctnetlink_dump_status(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_dir(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
@@ -679,10 +694,11 @@ ctnetlink_parse_tuple(struct nlattr *cda
 
 	/* orig and expect tuples get DIR_ORIGINAL */
 	if (type == CTA_TUPLE_REPLY)
-		tuple->dst.dir = IP_CT_DIR_REPLY;
+		tuple->dst.ctdir = IP_CT_DIR_REPLY;
 	else
-		tuple->dst.dir = IP_CT_DIR_ORIGINAL;
+		tuple->dst.ctdir = IP_CT_DIR_ORIGINAL;
 
+	/* FIXME: IP_CT_DIR_LOCAL_* */
 	return 0;
 }
 
@@ -707,6 +723,7 @@ static const struct nla_policy ct_nla_po
 	[CTA_MARK]		= { .type = NLA_U32 },
 	[CTA_USE]		= { .type = NLA_U32 },
 	[CTA_ID]		= { .type = NLA_U32 },
+	[CTA_DIR]		= { .type = NLA_U8 },
 };
 
 static int
Index: linux-2.6.x/net/netfilter/nf_conntrack_standalone.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nf_conntrack_standalone.c,v
retrieving revision 1.7
diff -u -p -r1.7 nf_conntrack_standalone.c
--- linux-2.6.x/net/netfilter/nf_conntrack_standalone.c	25 Mar 2009 06:28:29 -0000	1.7
+++ linux-2.6.x/net/netfilter/nf_conntrack_standalone.c	26 Jun 2009 06:32:02 -0000
@@ -35,6 +35,9 @@ print_tuple(struct seq_file *s, const st
             const struct nf_conntrack_l3proto *l3proto,
             const struct nf_conntrack_l4proto *l4proto)
 {
+	if (seq_printf(s, "dir=%u ", tuple->dst.ctdir))
+		return -ENOSPC;
+
 	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
 }
 EXPORT_SYMBOL_GPL(print_tuple);
Index: linux-2.6.x/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c,v
retrieving revision 1.4
diff -u -p -r1.4 nf_conntrack_l3proto_ipv4.c
--- linux-2.6.x/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	25 Mar 2009 06:28:29 -0000	1.4
+++ linux-2.6.x/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	26 Jun 2009 06:32:02 -0000
@@ -32,6 +32,11 @@ int (*nf_nat_seq_adjust_hook)(struct sk_
 			      enum ip_conntrack_info ctinfo);
 EXPORT_SYMBOL_GPL(nf_nat_seq_adjust_hook);
 
+static bool ipv4_local_hook(unsigned int hooknum)
+{
+	return hooknum == NF_IP_LOCAL_IN || hooknum == NF_IP_LOCAL_OUT;
+}
+
 static bool ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
 {
@@ -125,7 +130,7 @@ static unsigned int ipv4_confirm(unsigne
 	}
 out:
 	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return nf_conntrack_confirm(skb, hooknum);
 }
 
 static unsigned int ipv4_conntrack_in(unsigned int hooknum,
@@ -340,6 +345,7 @@ struct nf_conntrack_l3proto nf_conntrack
 	.l3proto	 = PF_INET,
 	.name		 = "ipv4",
 	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
+	.local_hook	 = ipv4_local_hook,
 	.invert_tuple	 = ipv4_invert_tuple,
 	.print_tuple	 = ipv4_print_tuple,
 	.get_l4proto	 = ipv4_get_l4proto,
Index: linux-2.6.x/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv4/netfilter/nf_conntrack_proto_icmp.c,v
retrieving revision 1.1.1.13
diff -u -p -r1.1.1.13 nf_conntrack_proto_icmp.c
--- linux-2.6.x/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	25 Mar 2009 01:16:17 -0000	1.1.1.13
+++ linux-2.6.x/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	26 Jun 2009 06:32:02 -0000
@@ -137,7 +137,7 @@ icmp_error_message(struct net *net, stru
 	if (!nf_ct_get_tuplepr(skb,
 			       skb_network_offset(skb) + ip_hdrlen(skb)
 						       + sizeof(struct icmphdr),
-			       PF_INET, &origtuple)) {
+			       hooknum, PF_INET, &origtuple)) {
 		pr_debug("icmp_error_message: failed to get tuple\n");
 		return -NF_ACCEPT;
 	}
Index: linux-2.6.x/net/ipv4/netfilter/nf_nat_core.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv4/netfilter/nf_nat_core.c,v
retrieving revision 1.1.1.8
diff -u -p -r1.1.1.8 nf_nat_core.c
--- linux-2.6.x/net/ipv4/netfilter/nf_nat_core.c	25 Mar 2009 01:16:17 -0000	1.1.1.8
+++ linux-2.6.x/net/ipv4/netfilter/nf_nat_core.c	26 Jun 2009 06:32:02 -0000
@@ -471,6 +471,7 @@ int nf_nat_icmp_reply_translation(struct
 			     ip_hdrlen(skb) + sizeof(struct icmphdr),
 			     (ip_hdrlen(skb) +
 			      sizeof(struct icmphdr) + inside->ip.ihl * 4),
+			     hooknum,
 			     (u_int16_t)AF_INET,
 			     inside->ip.protocol,
 			     &inner, l3proto, l4proto))
Index: linux-2.6.x/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c,v
retrieving revision 1.1.1.13
diff -u -p -r1.1.1.13 nf_conntrack_l3proto_ipv6.c
--- linux-2.6.x/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	25 Mar 2009 01:16:12 -0000	1.1.1.13
+++ linux-2.6.x/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	26 Jun 2009 06:32:02 -0000
@@ -27,6 +27,11 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
+static bool ipv6_local_hook(unsigned int hooknum)
+{
+	return hooknum == NF_IP_LOCAL_IN || hooknum == NF_IP_LOCAL_OUT;
+}
+
 static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
 {
@@ -179,7 +184,7 @@ static unsigned int ipv6_confirm(unsigne
 		return ret;
 out:
 	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return nf_conntrack_confirm(skb, hooknum);
 }
 
 static unsigned int ipv6_defrag(unsigned int hooknum,
@@ -346,6 +351,7 @@ static int ipv6_nlattr_to_tuple(struct n
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.l3proto		= PF_INET6,
 	.name			= "ipv6",
+	.local_hook		= ipv6_local_hook,
 	.pkt_to_tuple		= ipv6_pkt_to_tuple,
 	.invert_tuple		= ipv6_invert_tuple,
 	.print_tuple		= ipv6_print_tuple,

--------------030005020803050907060806--
