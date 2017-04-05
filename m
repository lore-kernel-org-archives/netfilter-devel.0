From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: Remove useless variable timeouts in init_conntrack
Date: Wed,  5 Apr 2017 12:49:14 +0800
Message-ID: <1491367754-16976-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:50369 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbdDEEte (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2017 00:49:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

All l4_proto->new callbacks don't use the param timeouts currently,
so remove it from param list. Then the variable timeouts isn't used
as right value in init_conntrack, so remove it too.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |  2 +-
 net/netfilter/nf_conntrack_core.c            | 13 ++-----------
 net/netfilter/nf_conntrack_proto_dccp.c      |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c      |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c       |  2 +-
 net/netfilter/nf_conntrack_proto_udp.c       |  2 +-
 7 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 85e993e..fafe65a 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -49,7 +49,7 @@ struct nf_conntrack_l4proto {
 	/* Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next. */
 	bool (*new)(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff, unsigned int *timeouts);
+		    unsigned int dataoff);
 
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 73c591d..5bb8c12 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -105,7 +105,7 @@ static int icmp_packet(struct nf_conn *ct,
 
 /* Called when a new connection for this protocol found. */
 static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff, unsigned int *timeouts)
+		     unsigned int dataoff)
 {
 	static const u_int8_t valid_new[] = {
 		[ICMP_ECHO] = 1,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b0f2e8e..1fac417 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1145,7 +1145,6 @@ void nf_conntrack_free(struct nf_conn *ct)
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn_timeout *timeout_ext;
 	struct nf_conntrack_zone tmp;
-	unsigned int *timeouts;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
 		pr_debug("Can't invert tuple.\n");
@@ -1163,21 +1162,13 @@ void nf_conntrack_free(struct nf_conn *ct)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
-	if (timeout_ext) {
-		timeouts = nf_ct_timeout_data(timeout_ext);
-		if (unlikely(!timeouts))
-			timeouts = l4proto->get_timeouts(net);
-	} else {
-		timeouts = l4proto->get_timeouts(net);
-	}
-
-	if (!l4proto->new(ct, skb, dataoff, timeouts)) {
+	if (!l4proto->new(ct, skb, dataoff)) {
 		nf_conntrack_free(ct);
 		pr_debug("can't track with proto module\n");
 		return NULL;
 	}
 
+	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
 	if (timeout_ext)
 		nf_ct_timeout_ext_add(ct, rcu_dereference(timeout_ext->timeout),
 				      GFP_ATOMIC);
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 93dd1c5..52f2ce4 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -412,7 +412,7 @@ static bool dccp_invert_tuple(struct nf_conntrack_tuple *inv,
 }
 
 static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff, unsigned int *timeouts)
+		     unsigned int dataoff)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_dccp_net *dn;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 33279aa..102ab80 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -432,7 +432,7 @@ static int sctp_packet(struct nf_conn *ct,
 
 /* Called when a new connection for this protocol found. */
 static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff, unsigned int *timeouts)
+		     unsigned int dataoff)
 {
 	enum sctp_conntrack new_state;
 	const struct sctphdr *sh;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b122e9d..aebaf7d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1098,7 +1098,7 @@ static int tcp_packet(struct nf_conn *ct,
 
 /* Called when a new connection for this protocol found. */
 static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff, unsigned int *timeouts)
+		    unsigned int dataoff)
 {
 	enum tcp_conntrack new_state;
 	const struct tcphdr *th;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index f6ebce6..8b30d51 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -103,7 +103,7 @@ static int udp_packet(struct nf_conn *ct,
 
 /* Called when a new connection for this protocol found. */
 static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff, unsigned int *timeouts)
+		    unsigned int dataoff)
 {
 	return true;
 }
-- 
1.9.1




