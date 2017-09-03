From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/5] netfilter: nf_tables: use NLM_F_NONREC for deletion requests
Date: Sun,  3 Sep 2017 23:56:00 +0200
Message-ID: <1504475761-11454-2-git-send-email-pablo@netfilter.org>
References: <1504475761-11454-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504475761-11454-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Bail out if user requests non-recursive deletion for tables and sets.
This new flags tells nf_tables netlink interface to reject deletions if
tables and sets have content.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b86acbb9770..2ea043e5b344 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -860,6 +860,10 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
+	if (nlh->nlmsg_flags & NLM_F_NONREC &&
+	    table->use > 0)
+		return -EBUSY;
+
 	ctx.afi = afi;
 	ctx.table = table;
 
@@ -3225,7 +3229,9 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (!list_empty(&set->bindings))
+
+	if (!list_empty(&set->bindings) ||
+	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0))
 		return -EBUSY;
 
 	return nft_delset(&ctx, set);
-- 
2.1.4
