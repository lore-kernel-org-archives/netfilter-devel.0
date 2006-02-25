From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/6]: nf_queue: check if rerouter is present before
	using it
Date: Sat, 25 Feb 2006 14:17:55 +0100 (MET)
Message-ID: <20060225131612.7400.30580.sendpatchset@localhost.localdomain>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_queue: check if rerouter is present before using it

Every rerouter needs to provide a save and a reroute function, we don't
need to check for them. But we do need to check if a rerouter is registered
at all for the current family, with bridging for example packets of
unregistered families can hit nf_queue.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ef7e9ed0e79dcb31560fc7d669a23ca2f230e09
tree 1b9fbb5833e5bac3d2bcd4a37cb7440b460988f2
parent 139a39bf3a1cc347d77582bea8cdabe7d3a25021
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:44 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:44 +0100

 net/netfilter/nf_queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 24ad41e..1fc7152 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -155,13 +155,13 @@ int nf_queue(struct sk_buff **skb, 
 		if (physoutdev) dev_hold(physoutdev);
 	}
 #endif
-	if (queue_rerouter[pf]->save)
+	if (queue_rerouter[pf])
 		queue_rerouter[pf]->save(*skb, info);
 
 	status = queue_handler[pf]->outfn(*skb, info, queuenum,
 					  queue_handler[pf]->data);
 
-	if (status >= 0 && queue_rerouter[pf]->reroute)
+	if (status >= 0 && queue_rerouter[pf])
 		status = queue_rerouter[pf]->reroute(skb, info);
 
 	read_unlock(&queue_handler_lock);
