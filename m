From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: nf_queue: handle NF_STOP and unknown verdicts in
	nf_reinject
Date: Tue, 25 Jul 2006 05:26:55 +0200 (MEST)
Message-ID: <20060725032655.25063.6835.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_queue: handle NF_STOP and unknown verdicts in nf_reinject

In case of an unknown verdict or NF_STOP the packet leaks. Unknown verdicts
can happen when userspace is buggy. Reinject the packet in case of NF_STOP,
drop on unknown verdicts.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 559fa54b6c0d2813de1d4753964587fc3655bbf1
tree b160176d29bdf8ff93cf6491533e41104fa19f93
parent 440848a8e33fc1927bab45bd73f6c8e042ea7abd
author Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:02:11 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:02:11 +0200

 net/netfilter/nf_queue.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bb6fcee..662a869 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -219,21 +219,20 @@ #endif
 
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
+	case NF_STOP:
 		info->okfn(skb);
+	case NF_STOLEN:
 		break;
-
 	case NF_QUEUE:
 		if (!nf_queue(&skb, elem, info->pf, info->hook, 
 			      info->indev, info->outdev, info->okfn,
 			      verdict >> NF_VERDICT_BITS))
 			goto next_hook;
 		break;
+	default:
+		kfree_skb(skb);
 	}
 	rcu_read_unlock();
-
-	if (verdict == NF_DROP)
-		kfree_skb(skb);
-
 	kfree(info);
 	return;
 }
