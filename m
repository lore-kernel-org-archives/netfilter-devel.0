From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next v3 6/7] nf_queue_handler: whitespace cleanup
Date: Wed, 21 Sep 2016 11:35:06 -0400
Message-ID: <1474472107-12992-7-git-send-email-aconole@bytheb.org>
References: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

A future patch will modify the hook drop and outfn functions.  This will
cause the line lengths to take up too much space.  This is simply a
readability change.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/net/netfilter/nf_queue.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index cc8a11f..66b3f3f 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -22,10 +22,10 @@ struct nf_queue_entry {
 
 /* Packet queuing */
 struct nf_queue_handler {
-	int			(*outfn)(struct nf_queue_entry *entry,
-					 unsigned int queuenum);
-	void			(*nf_hook_drop)(struct net *net,
-						struct nf_hook_ops *ops);
+	int		(*outfn)(struct nf_queue_entry *entry,
+				 unsigned int queuenum);
+	void		(*nf_hook_drop)(struct net *net,
+					struct nf_hook_ops *ops);
 };
 
 void nf_register_queue_handler(struct net *net, const struct nf_queue_handler *qh);
-- 
2.7.4
