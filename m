From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2] ruleset: add the set_id to the parsed sets
Date: Fri,  3 Oct 2014 20:02:39 +0200
Message-ID: <1412359360-30695-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38183 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJCSC1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:02:27 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so2099464wgh.34
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Oct 2014 11:02:26 -0700 (PDT)
Received: from localhost.localdomain (152.88.221.87.dynamic.jazztel.es. [87.221.88.152])
        by mx.google.com with ESMTPSA id lf1sm8681623wjb.24.2014.10.03.11.02.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Oct 2014 11:02:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/ruleset.c b/src/ruleset.c
index a19cbc1..8cc0c40 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -234,6 +234,7 @@ static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
 				       struct nft_parse_err *err)
 {
 	int i, len;
+	uint32_t set_id = 0;
 	json_t *node;
 	struct nft_set *s = NULL;
 	struct nft_set_list *list = nft_set_list_alloc();
@@ -265,6 +266,7 @@ static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
 			goto err;
 		}
 
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, set_id++);
 		nft_set_list_add_tail(s, list);
 	}
 
@@ -457,6 +459,7 @@ static int
 nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
 			   struct nft_parse_err *err)
 {
+	uint32_t set_id = 0;
 	mxml_node_t *node;
 	struct nft_set *s;
 	struct nft_set_list *set_list = nft_set_list_alloc();
@@ -479,6 +482,7 @@ nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
 			goto err_free;
 		}
 
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, set_id++);
 		nft_set_list_add_tail(s, set_list);
 	}
 
-- 
1.7.10.4

