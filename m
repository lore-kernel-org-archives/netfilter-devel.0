From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/2] ruleset: refactor ruleset element parsing function calls to nft_ruleset_*_parse_ruleset()
Date: Mon, 12 Jan 2015 14:46:15 +0100
Message-ID: <1421070375-1057-2-git-send-email-alvaroneay@gmail.com>
References: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52523 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbALNqD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:46:03 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so13938483wib.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 05:46:01 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id jp3sm10288322wid.9.2015.01.12.05.46.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2015 05:46:01 -0800 (PST)
In-Reply-To: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refactor the parsing ruleset element functions calls in xml/json to do that
calls in the functions nft_ruleset_*_parse_ruleset. This patch is used in follow
up patches.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |   59 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index a397824..6488d72 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -332,6 +332,24 @@ err:
 
 #endif
 
+static int nft_ruleset_json_parse_ruleset(struct nft_ruleset *rs, json_t *array,
+					  struct nft_parse_err *err)
+{
+	if (nft_ruleset_json_parse_tables(rs, array, err) != 0)
+		return -1;
+
+	if (nft_ruleset_json_parse_chains(rs, array, err) != 0)
+		return -1;
+
+	if (nft_ruleset_json_parse_sets(rs, array, err) != 0)
+		return -1;
+
+	if (nft_ruleset_json_parse_rules(rs, array, err) != 0)
+		return -1;
+
+	return 0;
+}
+
 static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
 				  struct nft_parse_err *err, enum nft_parse_input input)
 {
@@ -349,16 +367,7 @@ static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
 		goto err;
 	}
 
-	if (nft_ruleset_json_parse_tables(rs, array, err) != 0)
-		goto err;
-
-	if (nft_ruleset_json_parse_chains(rs, array, err) != 0)
-		goto err;
-
-	if (nft_ruleset_json_parse_sets(rs, array, err) != 0)
-		goto err;
-
-	if (nft_ruleset_json_parse_rules(rs, array, err) != 0)
+	if (nft_ruleset_json_parse_ruleset(rs, array, err) != 0)
 		goto err;
 
 	nft_jansson_free_root(root);
@@ -539,6 +548,25 @@ err_free:
 }
 #endif
 
+static int nft_ruleset_xml_parse_ruleset(struct nft_ruleset *rs,
+					 mxml_node_t *tree,
+					 struct nft_parse_err *err)
+{
+	if (nft_ruleset_xml_parse_tables(rs, tree, err) != 0)
+		return -1;
+
+	if (nft_ruleset_xml_parse_chains(rs, tree, err) != 0)
+		return -1;
+
+	if (nft_ruleset_xml_parse_sets(rs, tree, err) != 0)
+		return -1;
+
+	if (nft_ruleset_xml_parse_rules(rs, tree, err, rs->set_list) != 0)
+		return -1;
+
+	return 0;
+}
+
 static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const void *xml,
 				 struct nft_parse_err *err, enum nft_parse_input input)
 {
@@ -549,16 +577,7 @@ static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const void *xml,
 	if (tree == NULL)
 		return -1;
 
-	if (nft_ruleset_xml_parse_tables(rs, tree, err) != 0)
-		goto err;
-
-	if (nft_ruleset_xml_parse_chains(rs, tree, err) != 0)
-		goto err;
-
-	if (nft_ruleset_xml_parse_sets(rs, tree, err) != 0)
-		goto err;
-
-	if (nft_ruleset_xml_parse_rules(rs, tree, err, rs->set_list) != 0)
+	if (nft_ruleset_xml_parse_ruleset(rs, tree, err) != 0)
 		goto err;
 
 	mxmlDelete(tree);
-- 
1.7.10.4

