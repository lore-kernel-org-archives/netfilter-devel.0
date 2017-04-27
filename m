From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] masquerade: Complain if no prerouting chain exists
Date: Thu, 27 Apr 2017 15:24:39 +0200
Message-ID: <20170427132439.9443-2-phil@nwl.cc>
References: <20170427132439.9443-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37247 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034237AbdD0NYw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 09:24:52 -0400
In-Reply-To: <20170427132439.9443-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As reported in netfilter bz#1105, masquerading won't work if there isn't
at least an empty base chain hooked into prerouting. In order to raise
awareness of this problem at the user, complain if a masquerading
statement is added and the table does not contain an appropriate
prerouting chain already.

To not break user scripts which add the required chain at a later point,
accept the command anyway.

A better solution would be to create the required chain as a dependency
and drop it again on return path or if the user adds his own one later,
though I doubt the extra effort is feasible here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 49c5953ae1687..a89ada19298a5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2379,6 +2379,8 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct table *table;
+	struct chain *chain;
 	int err;
 
 	err = nat_evaluate_family(ctx, stmt);
@@ -2392,7 +2394,23 @@ static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 
 	stmt->flags |= STMT_F_TERMINAL;
-	return 0;
+
+	err = cache_update(CMD_INVALID, ctx->msgs);
+	if (err < 0)
+		return err;
+
+	table = table_lookup_global(ctx);
+	if (!table)
+		return stmt_error(ctx, stmt, "referenced table not found");
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (!strcmp(chain->type, "nat") &&
+		    chain->hooknum == NF_INET_PRE_ROUTING)
+			return 0;
+	}
+
+	return stmt_warning(ctx, stmt,
+			    "this requires at least an empty prerouting chain");
 }
 
 static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
-- 
2.11.0

