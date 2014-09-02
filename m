From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 3/6 v5] netfilter: nf_tables: rename nf_table_delrule_by_chain()
Date: Tue,  2 Sep 2014 16:42:24 +0200
Message-ID: <1409668946-8168-4-git-send-email-arturo.borrero.glez@gmail.com>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:49433 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753935AbaIBOmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:42:52 -0400
In-Reply-To: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the sake of homogenize the function naming scheme, let's rename
nf_table_delrule_by_chain() to nft_delrule_by_chain().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: no changes, resending the series.
v3: no changes, resending the series.
v4: no changes, resending the series, v3 series was invalid.
v5: no changes, resending the series.

 net/netfilter/nf_tables_api.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90e3496..eac4fab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1902,7 +1902,7 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	return 0;
 }
 
-static int nf_table_delrule_by_chain(struct nft_ctx *ctx)
+static int nft_delrule_by_chain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule;
 	int err;
@@ -1955,12 +1955,12 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 			err = nft_delrule(&ctx, rule);
 		} else {
-			err = nf_table_delrule_by_chain(&ctx);
+			err = nft_delrule_by_chain(&ctx);
 		}
 	} else {
 		list_for_each_entry(chain, &table->chains, list) {
 			ctx.chain = chain;
-			err = nf_table_delrule_by_chain(&ctx);
+			err = nft_delrule_by_chain(&ctx);
 			if (err < 0)
 				break;
 		}
-- 
1.7.10.4

