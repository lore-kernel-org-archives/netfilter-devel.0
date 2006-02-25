From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/6]: nf_queue: remove unnecessary check for outfn
Date: Sat, 25 Feb 2006 14:18:22 +0100 (MET)
Message-ID: <20060225131641.7400.28387.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_queue: remove unnecessary check for outfn

The only point of registering a queue handler is to provide an outfn,
so there is no need to check for it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 021fe2cbea0df98012b8c96e55855622f885817d
tree 52085a0216748ef3f915c8869b4ea8e0933a8cf2
parent 5409613c1733e5162fb884865637d1607afcfbc9
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:46 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:46 +0100

 net/netfilter/nf_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index c61f723..913df7d 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -120,7 +120,7 @@ int nf_queue(struct sk_buff **skb, 
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	read_lock(&queue_handler_lock);
-	if (!queue_handler[pf] || !queue_handler[pf]->outfn) {
+	if (!queue_handler[pf]) {
 		read_unlock(&queue_handler_lock);
 		kfree_skb(*skb);
 		return 1;
