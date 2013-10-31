From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 5/6] test: style cleanup
Date: Thu, 31 Oct 2013 13:36:39 +0100
Message-ID: <20131031123639.32572.83332.stgit@nfdev.cica.es>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57610 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753480Ab3JaMgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:43 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id DF0BA51EEAA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0ObTTw6P9xu5 for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:41 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id BC5E651EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:41 +0100 (CET)
In-Reply-To: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some style cleanups.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 3d26c3a..e147e79 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -193,8 +193,10 @@ static int test_json(const char *filename)
 	if (json_object_get(root, "table") != NULL) {
 		t = nft_table_alloc();
 		if (t != NULL) {
-			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_TABLE, t, filename);
+			if (nft_table_parse(t,
+					    NFT_TABLE_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_TABLE,
+						   t, filename);
 			else
 				goto failparsing;
 
@@ -203,8 +205,10 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "chain") != NULL) {
 		c = nft_chain_alloc();
 		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_CHAIN, c, filename);
+			if (nft_chain_parse(c,
+					    NFT_CHAIN_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_CHAIN,
+						   c, filename);
 			else
 				goto failparsing;
 
@@ -213,8 +217,10 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "rule") != NULL) {
 		r = nft_rule_alloc();
 		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_RULE, r, filename);
+			if (nft_rule_parse(r,
+					   NFT_RULE_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_RULE,
+						   r, filename);
 			else
 				goto failparsing;
 
@@ -229,17 +235,19 @@ static int test_json(const char *filename)
 				goto failparsing;
 
 			nft_set_free(s);
-			}
+		}
 	} else if (json_object_get(root, "nftables") != NULL) {
 		rs = nft_ruleset_alloc();
 		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_RULESET, rs, filename);
+			if (nft_ruleset_parse(rs,
+					      NFT_RULESET_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_RULESET,
+						   rs, filename);
 			else
 				goto failparsing;
 
 			nft_ruleset_free(rs);
-			}
+		}
 	}
 
 	free(json);
@@ -292,7 +300,8 @@ static int test_xml(const char *filename)
 		t = nft_table_alloc();
 		if (t != NULL) {
 			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_TABLE, t, filename);
+				ret = compare_test(TEST_XML_TABLE,
+						   t, filename);
 			else
 				goto failparsing;
 
@@ -302,7 +311,8 @@ static int test_xml(const char *filename)
 		c = nft_chain_alloc();
 		if (c != NULL) {
 			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_CHAIN, c, filename);
+				ret = compare_test(TEST_XML_CHAIN,
+						   c, filename);
 			else
 				goto failparsing;
 

