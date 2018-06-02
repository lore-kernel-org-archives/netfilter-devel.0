From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/20] netfilter: nf_tables: fail batch if fatal signal is pending
Date: Sat,  2 Jun 2018 02:22:48 +0200
Message-ID: <20180602002259.4024-10-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

abort batch processing and return so task can exit faster.
Otherwise even SIGKILL has no immediate effect.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 88c9e222b670..5a1bd23af1a3 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <net/sock.h>
 #include <linux/init.h>
+#include <linux/sched/signal.h>
 
 #include <net/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -330,6 +331,13 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
 
+		if (fatal_signal_pending(current)) {
+			nfnl_err_reset(&err_list);
+			err = -EINTR;
+			status = NFNL_BATCH_FAILURE;
+			goto done;
+		}
+
 		memset(&extack, 0, sizeof(extack));
 		nlh = nlmsg_hdr(skb);
 		err = 0;
-- 
2.11.0
