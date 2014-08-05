From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: don't update chain with unset counters
Date: Tue,  5 Aug 2014 17:30:35 +0200
Message-ID: <1407252636-3459-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, technoboy85@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55083 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaHEPaT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:30:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix possible replacemen of the per-cpu chain counters by null
pointer when updating an existing chain in the commit path.

Reported-by: Matteo Croce <technoboy85@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f95dc95..f7dce2b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -899,6 +899,9 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 static void nft_chain_stats_replace(struct nft_base_chain *chain,
 				    struct nft_stats __percpu *newstats)
 {
+	if (newstats == NULL)
+		return;
+
 	if (chain->stats) {
 		struct nft_stats __percpu *oldstats =
 				nft_dereference(chain->stats);
-- 
1.7.10.4

