From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/14]: Fix undersized skb allocation in
	ipt_ULOG/ebt_ulog/nfnetlink_log
Date: Fri,  3 Feb 2006 14:44:06 +0100 (MET)
Message-ID: <20060203134406.2141.10703.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix undersized skb allocation in ipt_ULOG/ebt_ulog/nfnetlink_log

The skb allocated is always of size nlbufsize, even if that is smaller than
the size needed for the current packet.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c99461f9ce0d7050da0af3d9975769d65431e440
tree 5a04b78b7d8afad833e60f3884d2711b9cd76692
parent 5974aa1e67cc9139557471d57aa6b54c7fb6aed5
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:37:55 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:37:55 +0100

 net/bridge/netfilter/ebt_ulog.c |    8 +++++---
 net/ipv4/netfilter/ipt_ULOG.c   |   22 +++++++++++++---------
 net/netfilter/nfnetlink_log.c   |   20 ++++++++++++--------
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index dbbf9f6..802baf7 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -98,12 +98,14 @@ static void ulog_timer(unsigned long dat
 static struct sk_buff *ulog_alloc_skb(unsigned int size)
 {
 	struct sk_buff *skb;
+	unsigned int n;
 
-	skb = alloc_skb(nlbufsiz, GFP_ATOMIC);
+	n = max(size, nlbufsiz);
+	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
 		PRINTR(KERN_ERR "ebt_ulog: can't alloc whole buffer "
-		       "of size %ub!\n", nlbufsiz);
-		if (size < nlbufsiz) {
+		       "of size %ub!\n", n);
+		if (n > size) {
 			/* try to allocate only as much as we need for
 			 * current packet */
 			skb = alloc_skb(size, GFP_ATOMIC);
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 2fe6413..180a9ea 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -147,22 +147,26 @@ static void ulog_timer(unsigned long dat
 static struct sk_buff *ulog_alloc_skb(unsigned int size)
 {
 	struct sk_buff *skb;
+	unsigned int n;
 
 	/* alloc skb which should be big enough for a whole
 	 * multipart message. WARNING: has to be <= 131000
 	 * due to slab allocator restrictions */
 
-	skb = alloc_skb(nlbufsiz, GFP_ATOMIC);
+	n = max(size, nlbufsiz);
+	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
-		PRINTR("ipt_ULOG: can't alloc whole buffer %ub!\n",
-			nlbufsiz);
+		PRINTR("ipt_ULOG: can't alloc whole buffer %ub!\n", n);
 
-		/* try to allocate only as much as we need for 
-		 * current packet */
-
-		skb = alloc_skb(size, GFP_ATOMIC);
-		if (!skb)
-			PRINTR("ipt_ULOG: can't even allocate %ub\n", size);
+		if (n > size) {
+			/* try to allocate only as much as we need for 
+			 * current packet */
+
+			skb = alloc_skb(size, GFP_ATOMIC);
+			if (!skb)
+				PRINTR("ipt_ULOG: can't even allocate %ub\n",
+				       size);
+		}
 	}
 
 	return skb;
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 50787af..3b3c781 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -314,24 +314,28 @@ static struct sk_buff *nfulnl_alloc_skb(
 					unsigned int pkt_size)
 {
 	struct sk_buff *skb;
+	unsigned int n;
 
 	UDEBUG("entered (%u, %u)\n", inst_size, pkt_size);
 
 	/* alloc skb which should be big enough for a whole multipart
 	 * message.  WARNING: has to be <= 128k due to slab restrictions */
 
-	skb = alloc_skb(inst_size, GFP_ATOMIC);
+	n = max(inst_size, pkt_size);
+	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
 		PRINTR("nfnetlink_log: can't alloc whole buffer (%u bytes)\n",
 			inst_size);
 
-		/* try to allocate only as much as we need for current
-		 * packet */
-
-		skb = alloc_skb(pkt_size, GFP_ATOMIC);
-		if (!skb)
-			PRINTR("nfnetlink_log: can't even alloc %u bytes\n",
-				pkt_size);
+		if (n > pkt_size) {
+			/* try to allocate only as much as we need for current
+			 * packet */
+
+			skb = alloc_skb(pkt_size, GFP_ATOMIC);
+			if (!skb)
+				PRINTR("nfnetlink_log: can't even alloc %u "
+				       "bytes\n", pkt_size);
+		}
 	}
 
 	return skb;
