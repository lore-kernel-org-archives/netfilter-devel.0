From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3] nfctnetlink: use invmap to check trackable ICMP type
Date: Fri, 09 Dec 2005 11:47:01 +0900 (JST)
Message-ID: <200512090247.jB92l11X002522@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
Content-Disposition: inline; filename="03-nfctnetlink-check-icmp.patch"
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

[NETFILTER] nfctnetlink: use invmap to check trackable ICMP type

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit cc3ae3971b05f0f92ce1b199f49c859dad992696
tree 8f89c57a1e918be793880d31f3786cd68854f0c6
parent f8292e30683470bda8611925ee256ddc3262dae2
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 11:05:11 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 11:05:11 +0900

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   40 ++++++++++++++------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 973e653..52dc175 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -50,20 +50,21 @@ static int icmp_pkt_to_tuple(const struc
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
 static int icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
 			     const struct nf_conntrack_tuple *orig)
 {
-	/* Add 1; spaces filled with 0. */
-	static u_int8_t invmap[]
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
@@ -116,16 +117,17 @@ static int icmp_packet(struct nf_conn *c
 	return NF_ACCEPT;
 }
 
-static u_int8_t valid_new[]
-	= { [ICMP_ECHO] = 1,
-	    [ICMP_TIMESTAMP] = 1,
-	    [ICMP_INFO_REQUEST] = 1,
-	    [ICMP_ADDRESS] = 1 };
-
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct nf_conn *conntrack,
 		    const struct sk_buff *skb, unsigned int dataoff)
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
@@ -327,8 +329,8 @@ static int icmp_nfattr_to_tuple(struct n
 	tuple->src.u.icmp.id =
 			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 
-	if (tuple->dst.u.icmp.type >= sizeof(valid_new)
-	    || !valid_new[tuple->dst.u.icmp.type])
+	if (tuple->dst.u.icmp.type >= sizeof(invmap)
+	    || !invmap[tuple->dst.u.icmp.type])
 		return -EINVAL;
 
 	return 0;
