From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/20] netfilter: nfnetlink: allow commit to fail
Date: Sat,  2 Jun 2018 02:22:43 +0200
Message-ID: <20180602002259.4024-5-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

->commit() cannot fail at the moment.

Followup-patch adds kmalloc calls in the commit phase, so we'll need
to be able to handle errors.

Make it so that -EGAIN causes a full replay, and make other errors
cause the transaction to fail.

Failing is ok from a consistency point of view as long as we
perform all actions that could return an error before
we increment the generation counter and the base seq.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 03ead8a9e90c..88c9e222b670 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -441,7 +441,14 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		kfree_skb(skb);
 		goto replay;
 	} else if (status == NFNL_BATCH_DONE) {
-		ss->commit(net, oskb);
+		err = ss->commit(net, oskb);
+		if (err == -EAGAIN) {
+			status |= NFNL_BATCH_REPLAY;
+			goto done;
+		} else if (err) {
+			ss->abort(net, oskb);
+			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
+		}
 	} else {
 		ss->abort(net, oskb);
 	}
-- 
2.11.0
