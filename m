From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v2 3/5] netfilter: nf_tables: rename
 nf_table_delrule_by_chain()
Date: Tue, 26 Aug 2014 16:13:08 +0200
Message-ID: <20140826141253.3008.20084.stgit@nfdev.cica.es>
References: <20140826140908.3008.13225.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48391 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758274AbaHZONT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:13:19 -0400
In-Reply-To: <20140826140908.3008.13225.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the sake of homogenize the function naming scheme, let's rename
nf_table_delrule_by_chain() to nft_delrule_by_chain().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: no changes, resending the series.

 net/netfilter/nf_tables_api.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b35f52..2b71fe1 100644
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

