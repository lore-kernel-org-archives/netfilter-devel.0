From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] mxml: test if the root node name is initialized before to compare it.
Date: Mon,  2 Mar 2015 20:58:38 +0100
Message-ID: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39707 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbbCBT6U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 14:58:20 -0500
Received: by widex7 with SMTP id ex7so17678002wid.4
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2015 11:58:19 -0800 (PST)
Received: from localhost.localdomain ([77.231.225.145])
        by mx.google.com with ESMTPSA id n1sm17450796wib.11.2015.03.02.11.58.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2015 11:58:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the root node name is not correctly initialized, we have a crash.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/mxml.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/mxml.c b/src/mxml.c
index 0001ba0..b68f86f 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -43,7 +43,8 @@ mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 		goto err;
 	}
 
-	if (strcmp(tree->value.opaque, treename) == 0)
+	if (tree->value.opaque != NULL &&
+	    strcmp(tree->value.opaque, treename) == 0)
 		return tree;
 
 	err->error = NFT_PARSE_EMISSINGNODE;
-- 
1.7.10.4

