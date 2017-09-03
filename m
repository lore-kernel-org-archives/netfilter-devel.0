From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/47] netfilter: remove prototype of netfilter_queue_init
Date: Mon,  4 Sep 2017 00:40:13 +0200
Message-ID: <1504478435-13160-3-git-send-email-pablo@netfilter.org>
References: <1504478435-13160-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504478435-13160-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The netfilter_queue_init() has been removed.
so we can remove the prototype of that.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_internals.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index bfa742da83af..19f00a47a710 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -15,7 +15,6 @@
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     struct nf_hook_entry **entryp, unsigned int verdict);
 unsigned int nf_queue_nf_hook_drop(struct net *net);
-int __init netfilter_queue_init(void);
 
 /* nf_log.c */
 int __init netfilter_log_init(void);
-- 
2.1.4
