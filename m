From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 5/8]: Fix HW checksum handling in nfnetlink_queue
Date: Tue, 06 Sep 2005 19:55:42 +0200
Message-ID: <431DD81E.4020505@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: Fix HW checksum handling in nfnetlink_queue

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 917240fdfb4a326d7488803be075e60e9fda6a3e
tree a069ad28c8f81b1792041f27985e7f3e9ad0877b
parent 92d69138354a34bf06d5429ffa485e3b43282b3f
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 18:25:32 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 18:25:32 +0200

 net/netfilter/nfnetlink_queue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -382,6 +382,12 @@ nfqnl_build_packet_message(struct nfqnl_
 		break;
 	
 	case NFQNL_COPY_PACKET:
+		if (entry->skb->ip_summed == CHECKSUM_HW &&
+		    (*errp = skb_checksum_help(entry->skb,
+		                               entry->info->outdev == NULL))) {
+			spin_unlock_bh(&queue->lock);
+			return NULL;
+		}
 		if (queue->copy_range == 0 
 		    || queue->copy_range > entry->skb->len)
 			data_len = entry->skb->len;
@@ -647,7 +653,7 @@ nfqnl_mangle(void *data, int data_len, s
 	if (!skb_make_writable(&e->skb, data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, data, data_len);
-
+	e->skb->ip_summed = CHECKSUM_NONE;
 	return 0;
 }
 
