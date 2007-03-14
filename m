From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/22]: nfnetlink: use netlink_run_queue()
Date: Wed, 14 Mar 2007 09:50:25 +0100 (MET)
Message-ID: <20070314085010.15282.15770.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: use netlink_run_queue()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a256881f5e3027a9833ad87b1fe36c0be0c20fb
tree 756d0b3c3f1905fc3f441c650551e334e670f4ff
parent d61dcfb467bf886f404643585b36317fc2be7254
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:24:55 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:30:30 +0100

 net/netfilter/nfnetlink.c |   51 ++++-----------------------------------------
 1 files changed, 4 insertions(+), 47 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7865a47..5be6ac4 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -301,59 +301,16 @@ err_inval:
 	return -1;
 }
 
-/* Process one packet of messages. */
-static inline int nfnetlink_rcv_skb(struct sk_buff *skb)
-{
-	int err;
-	struct nlmsghdr *nlh;
-
-	while (skb->len >= NLMSG_SPACE(0)) {
-		u32 rlen;
-
-		nlh = (struct nlmsghdr *)skb->data;
-		if (nlh->nlmsg_len < sizeof(struct nlmsghdr)
-		    || skb->len < nlh->nlmsg_len)
-			return 0;
-		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
-		if (rlen > skb->len)
-			rlen = skb->len;
-		if (nfnetlink_rcv_msg(skb, nlh, &err)) {
-			if (!err)
-				return -1;
-			netlink_ack(skb, nlh, err);
-		} else
-			if (nlh->nlmsg_flags & NLM_F_ACK)
-				netlink_ack(skb, nlh, 0);
-		skb_pull(skb, rlen);
-	}
-
-	return 0;
-}
-
 static void nfnetlink_rcv(struct sock *sk, int len)
 {
-	do {
-		struct sk_buff *skb;
+	unsigned int qlen = 0;
 
+	do {
 		if (nfnl_trylock())
 			return;
-
-		while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-			if (nfnetlink_rcv_skb(skb)) {
-				if (skb->len)
-					skb_queue_head(&sk->sk_receive_queue,
-						       skb);
-				else
-					kfree_skb(skb);
-				break;
-			}
-			kfree_skb(skb);
-		}
-
-		/* don't call nfnl_unlock, since it would reenter
-		 * with further packet processing */
+		netlink_run_queue(sk, &qlen, nfnetlink_rcv_msg);
 		__nfnl_unlock();
-	} while(nfnl && nfnl->sk_receive_queue.qlen);
+	} while (qlen);
 }
 
 static void __exit nfnetlink_exit(void)
