From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2] nfnetlink_queue: Don't unregister handler of other
 subsystem
Date: Mon, 02 Jul 2007 09:38:58 +0900 (JST)
Message-ID: <200707020038.l620cx6S008717@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


The queue handlers registered by ip[6]_queue.ko at initialization should
not be unregistered according to requests from userland program
using nfnetlink_queue. If we allow that, there is no way to register
the handlers of built-in ip[6]_queue again.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
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
-- 
1.5.2.2
