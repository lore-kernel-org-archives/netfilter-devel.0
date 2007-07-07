From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 48/50]: nfnetlink_queue: don't unregister handler of
	other subsystem
Date: Sat,  7 Jul 2007 14:24:09 +0200 (MEST)
Message-ID: <20070707122324.1589.38537.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_queue: don't unregister handler of other subsystem

The queue handlers registered by ip[6]_queue.ko at initialization should
not be unregistered according to requests from userland program
using nfnetlink_queue. If we allow that, there is no way to register
the handlers of built-in ip[6]_queue again.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 31358423dfcfd9d0ab6a6b5f168467ef03272562
tree 9d618779c6b1e056e4e79b5beb588c58ea062aa8
parent 6786c212c4a32dccc19cae256b36e80c26640b14
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:16:10 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:10 +0200

 include/linux/netfilter.h       |    3 ++-
 net/netfilter/nf_queue.c        |    7 ++++++-
 net/netfilter/nfnetlink_queue.c |    4 +---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 10b5c62..0eed0b7 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -275,7 +275,8 @@ struct nf_queue_handler {
 };
 extern int nf_register_queue_handler(int pf, 
                                      struct nf_queue_handler *qh);
-extern int nf_unregister_queue_handler(int pf);
+extern int nf_unregister_queue_handler(int pf,
+				       struct nf_queue_handler *qh);
 extern void nf_unregister_queue_handlers(struct nf_queue_handler *qh);
 extern void nf_reinject(struct sk_buff *skb,
 			struct nf_info *info,
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index b1f2ace..f402894 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -44,12 +44,17 @@ int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
 EXPORT_SYMBOL(nf_register_queue_handler);
 
 /* The caller must flush their queue before this */
-int nf_unregister_queue_handler(int pf)
+int nf_unregister_queue_handler(int pf, struct nf_queue_handler *qh)
 {
 	if (pf >= NPROTO)
 		return -EINVAL;
 
 	write_lock_bh(&queue_handler_lock);
+	if (queue_handler[pf] != qh) {
+		write_unlock_bh(&queue_handler_lock);
+		return -EINVAL;
+	}
+
 	queue_handler[pf] = NULL;
 	write_unlock_bh(&queue_handler_lock);
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7a97bec..7d47fc4 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -913,9 +913,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			QDEBUG("unregistering queue handler for pf=%u\n",
 				ntohs(cmd->pf));
-			/* This is a bug and a feature.  We can unregister
-			 * other handlers(!) */
-			ret = nf_unregister_queue_handler(ntohs(cmd->pf));
+			ret = nf_unregister_queue_handler(ntohs(cmd->pf), &nfqh);
 			break;
 		default:
 			ret = -EINVAL;
