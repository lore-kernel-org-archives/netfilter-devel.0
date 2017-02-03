From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/27] netfilter: nf_tables: eliminate useless condition checks
Date: Fri,  3 Feb 2017 13:25:28 +0100
Message-ID: <1486124738-3013-18-git-send-email-pablo@netfilter.org>
References: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

The return value of nf_tables_table_lookup() is valid pointer or one
pointer error. There are two cases:

1) IS_ERR(table) is true, it would return the error or reset the
   table as NULL, it is unnecessary to perform the latter check
   "table != NULL".

2) IS_ERR(obj) is false, the table is one valid pointer. It is also
   unnecessary to perform that check.

The nf_tables_newset() and nf_tables_newobj() have same logic codes.

In summary, we could move the block of condition check "table != NULL"
in the else block to eliminate the original condition checks.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87e58ee..6e07c214c208 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -696,10 +696,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
-		table = NULL;
-	}
-
-	if (table != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -2963,10 +2960,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set)) {
 		if (PTR_ERR(set) != -ENOENT)
 			return PTR_ERR(set);
-		set = NULL;
-	}
-
-	if (set != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -4153,10 +4147,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		if (err != -ENOENT)
 			return err;
 
-		obj = NULL;
-	}
-
-	if (obj != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 
-- 
2.1.4
