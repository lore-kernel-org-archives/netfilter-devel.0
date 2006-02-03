From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/14]: nfnetlink_queue: fix packet marking over netlink
Date: Fri,  3 Feb 2006 14:44:07 +0100 (MET)
Message-ID: <20060203134407.2141.37193.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_queue: fix packet marking over netlink

The packet marked is the netlink skb, not the queued skb.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 27a0e70cdd3fdf3988c94739ad75f6fc5d89c326
tree e74e0da1d1d65bcaafb9a5c5864b059afb688c2b
parent c99461f9ce0d7050da0af3d9975769d65431e440
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:38:39 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:38:39 +0100

 net/netfilter/nfnetlink_queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 18ed9c5..cac38b2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -825,7 +825,8 @@ nfqnl_recv_verdict(struct sock *ctnl, st
 	}
 
 	if (nfqa[NFQA_MARK-1])
-		skb->nfmark = ntohl(*(u_int32_t *)NFA_DATA(nfqa[NFQA_MARK-1]));
+		entry->skb->nfmark = ntohl(*(u_int32_t *)
+		                           NFA_DATA(nfqa[NFQA_MARK-1]));
 		
 	issue_verdict(entry, verdict);
 	instance_put(queue);
