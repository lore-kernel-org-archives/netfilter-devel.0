From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH] netfilter: nf_tables: invert chain deletion abort
 path
Date: Fri, 08 Apr 2016 12:56:10 +0200
Message-ID: <146011296985.3580.3314850969369156279.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51569 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755900AbcDHK4Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:56:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, chain deletetion abort path re-add chains in reverse
order of what was originally in the ruleset.
Invert the order, so the ruleset is exactly the same after abort.

Example, using 2 config files:

ruleset_good.nft:
==== 8< ====
flush ruleset
table ip t {
	chain c1 {
	}
	chain c2 {
	}
	chain c3 {
	}
}
==== 8< ====

ruleset_bad.nft:
==== 8< ====
flush ruleset
table ip t {
	chain c1 {
	}
	chain c2 {
		jump c6
	}
	chain c3 {
	}
}
==== 8< ====


before this patch:

% nft -f ruleset_good.nft
% nft -f ruleset_bad.nft
% nft list ruleset
table ip t {
	chain c3 {
	}

	chain c2 {
	}

	chain c1 {
	}
}

[ note, inverse order of chain listing ]

after this patch:

% nft -f ruleset_good.nft
% nft -f ruleset_bad.nft
% nft list ruleset
table ip t {
	chain c1 {
	}

	chain c2 {
	}

	chain c3 {
	}
}

[ note, same order of chain listing ]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2011977..8578cc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4060,8 +4060,8 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELCHAIN:
 			trans->ctx.table->use++;
-			list_add_tail_rcu(&trans->ctx.chain->list,
-					  &trans->ctx.table->chains);
+			list_add_rcu(&trans->ctx.chain->list,
+				     &trans->ctx.table->chains);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWRULE:

