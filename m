From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] mnl: immediately return on errors in mnl_nft_ruleset_dump()
Date: Sat, 12 Jul 2014 14:47:30 +0200
Message-ID: <1405169250-5254-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGLMrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:47:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If this fails to fetch any of the objects, stop handling inmediately.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index a816106..a843fdc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -908,41 +908,42 @@ struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 		memory_allocation_error();
 
 	t = mnl_nft_table_dump(nf_sock, family);
-	if (t != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
+	if (t == NULL)
+		goto err;
+
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
 
 	c = mnl_nft_chain_dump(nf_sock, family);
-	if (c != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
+	if (c == NULL)
+		goto err;
+
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
 
 	sl = mnl_nft_set_dump(nf_sock, family, NULL);
-	if (sl != NULL) {
-		i = nft_set_list_iter_create(sl);
-		s = nft_set_list_iter_next(i);
-		while (s != NULL) {
-			ret = mnl_nft_setelem_get(nf_sock, s);
-			if (ret != 0)
-				goto out;
+	if (sl == NULL)
+		goto err;
 
-			s = nft_set_list_iter_next(i);
-		}
-		nft_set_list_iter_destroy(i);
+	i = nft_set_list_iter_create(sl);
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = mnl_nft_setelem_get(nf_sock, s);
+		if (ret < 0)
+			goto err;
 
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
+		s = nft_set_list_iter_next(i);
 	}
+	nft_set_list_iter_destroy(i);
+
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
 
 	r = mnl_nft_rule_dump(nf_sock, family);
-	if (r != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+	if (r == NULL)
+		goto err;
 
-	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
-	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) &&
-	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) &&
-	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)))
-		goto out;
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
 
 	return rs;
-out:
+err:
 	nft_ruleset_free(rs);
 	return NULL;
 }
-- 
1.7.10.4

