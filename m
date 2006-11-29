From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/33]: nfnetlink_log: remove useless prefix length
	limitation
Date: Wed, 29 Nov 2006 03:09:25 +0100 (MET)
Message-ID: <20061129020925.21082.61358.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: remove useless prefix length limitation

There is no reason for limiting netlink attributes in size.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bbdbeb2dc5f53eb0ce24e8f78edda1671ef4e54a
tree d6841f882b2e9fa6003fc672c7815771b63f59ab
parent ffbf4d47cf2bcd15709396b97b609346be6cc7fd
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:11 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:52 +0100

 include/linux/netfilter/nfnetlink_log.h |    2 --
 net/netfilter/nfnetlink_log.c           |   19 ++++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index 55a2a2b..5966afa 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -32,8 +32,6 @@ struct nfulnl_msg_packet_timestamp {
 	aligned_be64	usec;
 };
 
-#define NFULNL_PREFIXLEN	30	/* just like old log target */
-
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index bd3ffa6..d1505dd 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -408,7 +408,7 @@ __build_packet_message(struct nfulnl_ins
 			const struct net_device *indev,
 			const struct net_device *outdev,
 			const struct nf_loginfo *li,
-			const char *prefix)
+			const char *prefix, unsigned int plen)
 {
 	unsigned char *old_tail;
 	struct nfulnl_msg_packet_hdr pmsg;
@@ -432,12 +432,8 @@ __build_packet_message(struct nfulnl_ins
 
 	NFA_PUT(inst->skb, NFULA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
-	if (prefix) {
-		int slen = strlen(prefix);
-		if (slen > NFULNL_PREFIXLEN)
-			slen = NFULNL_PREFIXLEN;
-		NFA_PUT(inst->skb, NFULA_PREFIX, slen, prefix);
-	}
+	if (prefix)
+		NFA_PUT(inst->skb, NFULA_PREFIX, plen, prefix);
 
 	if (indev) {
 		tmp_uint = htonl(indev->ifindex);
@@ -601,6 +597,7 @@ nfulnl_log_packet(unsigned int pf,
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
 	unsigned int nlbufsiz;
+	unsigned int plen;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG) 
 		li = li_user;
@@ -616,6 +613,10 @@ nfulnl_log_packet(unsigned int pf,
 		return;
 	}
 
+	plen = 0;
+	if (prefix)
+		plen = strlen(prefix);
+
 	/* all macros expand to constant values at compile time */
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
@@ -630,7 +631,7 @@ #ifdef CONFIG_BRIDGE_NETFILTER
 #endif
 		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
 		+ NFA_SPACE(sizeof(u_int32_t))	/* uid */
-		+ NFA_SPACE(NFULNL_PREFIXLEN)	/* prefix */
+		+ NFA_SPACE(plen)		/* prefix */
 		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_hw))
 		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_timestamp));
 
@@ -701,7 +702,7 @@ #endif
 	inst->qlen++;
 
 	__build_packet_message(inst, skb, data_len, pf,
-				hooknum, in, out, li, prefix);
+				hooknum, in, out, li, prefix, plen);
 
 	/* timer_pending always called within inst->lock, so there
 	 * is no chance of a race here */
