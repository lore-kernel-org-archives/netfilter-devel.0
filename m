From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/18]: ctnetlink: Add sanity checkings for ICMP
Date: Thu,  5 Jan 2006 05:06:35 +0100 (MET)
Message-ID: <20060105040559.23512.56695.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: Add sanity checkings for ICMP

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f067059d5e3d09c6679d860eb8c283df7f0f3420
tree 705f9f9add15dd8aff99e0ab45884c91af74348e
parent da3dc79a37546feb6572bff1a36b23830c799c58
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 05 Jan 2006 02:54:00 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:54:00 +0100

 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |   43 +++++++++++++++-----------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 19cc550..30fc21d 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -47,20 +47,21 @@ static int icmp_pkt_to_tuple(const struc
 	return 1;
 }
 
+/* Add 1; spaces filled with 0. */
+static const u_int8_t invmap[] = {
+	[ICMP_ECHO] = ICMP_ECHOREPLY + 1,
+	[ICMP_ECHOREPLY] = ICMP_ECHO + 1,
+	[ICMP_TIMESTAMP] = ICMP_TIMESTAMPREPLY + 1,
+	[ICMP_TIMESTAMPREPLY] = ICMP_TIMESTAMP + 1,
+	[ICMP_INFO_REQUEST] = ICMP_INFO_REPLY + 1,
+	[ICMP_INFO_REPLY] = ICMP_INFO_REQUEST + 1,
+	[ICMP_ADDRESS] = ICMP_ADDRESSREPLY + 1,
+	[ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1
+};
+
 static int icmp_invert_tuple(struct ip_conntrack_tuple *tuple,
 			     const struct ip_conntrack_tuple *orig)
 {
-	/* Add 1; spaces filled with 0. */
-	static const u_int8_t invmap[]
-		= { [ICMP_ECHO] = ICMP_ECHOREPLY + 1,
-		    [ICMP_ECHOREPLY] = ICMP_ECHO + 1,
-		    [ICMP_TIMESTAMP] = ICMP_TIMESTAMPREPLY + 1,
-		    [ICMP_TIMESTAMPREPLY] = ICMP_TIMESTAMP + 1,
-		    [ICMP_INFO_REQUEST] = ICMP_INFO_REPLY + 1,
-		    [ICMP_INFO_REPLY] = ICMP_INFO_REQUEST + 1,
-		    [ICMP_ADDRESS] = ICMP_ADDRESSREPLY + 1,
-		    [ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1};
-
 	if (orig->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[orig->dst.u.icmp.type])
 		return 0;
@@ -110,17 +111,17 @@ static int icmp_packet(struct ip_conntra
 	return NF_ACCEPT;
 }
 
-static const u_int8_t valid_new[] = { 
-	[ICMP_ECHO] = 1,
-	[ICMP_TIMESTAMP] = 1,
-	[ICMP_INFO_REQUEST] = 1,
-	[ICMP_ADDRESS] = 1 
-};
-
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct ip_conntrack *conntrack,
 		    const struct sk_buff *skb)
 {
+	static const u_int8_t valid_new[] = { 
+		[ICMP_ECHO] = 1,
+		[ICMP_TIMESTAMP] = 1,
+		[ICMP_INFO_REQUEST] = 1,
+		[ICMP_ADDRESS] = 1 
+	};
+
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -291,7 +292,7 @@ static int icmp_nfattr_to_tuple(struct n
 	if (!tb[CTA_PROTO_ICMP_TYPE-1]
 	    || !tb[CTA_PROTO_ICMP_CODE-1]
 	    || !tb[CTA_PROTO_ICMP_ID-1])
-		return -1;
+		return -EINVAL;
 
 	tuple->dst.u.icmp.type = 
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
@@ -300,6 +301,10 @@ static int icmp_nfattr_to_tuple(struct n
 	tuple->src.u.icmp.id =
 			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 
+	if (tuple->dst.u.icmp.type >= sizeof(invmap)
+	    || !invmap[tuple->dst.u.icmp.type])
+		return -EINVAL;
+
 	return 0;
 }
 #endif
