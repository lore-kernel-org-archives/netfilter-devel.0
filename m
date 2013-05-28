From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] rule: fix table flag not being set at XML parsing
Date: Tue, 28 May 2013 17:06:08 +0200
Message-ID: <20130528150608.5236.81847.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53526 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934354Ab3E1PGM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 11:06:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This bug was introduced by me at commit:

	'src: add support for XML parsing'
	51370f0eedb1c8167ab2c340d2a53f0d9f02509c

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index 318ae07..4d56d5a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -479,6 +479,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 		free(r->table);
 
 	r->table = strdup(mxmlElementGetAttr(tree, "table"));
+	r->flags |= (1 << NFT_RULE_ATTR_TABLE);
 
 	/* get and set <rule ... chain=X ...> */
 	if (mxmlElementGetAttr(tree, "chain") == NULL) {

