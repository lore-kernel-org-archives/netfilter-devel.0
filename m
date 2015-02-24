From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] ruleset: crash in path error when we build the xml tree
Date: Tue, 24 Feb 2015 09:10:33 +0100
Message-ID: <1424765433-4975-2-git-send-email-alvaroneay@gmail.com>
References: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46951 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbBXIK1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 03:10:27 -0500
Received: by wggy19 with SMTP id y19so3573437wgg.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2015 00:10:26 -0800 (PST)
Received: from localhost.localdomain ([77.231.217.213])
        by mx.google.com with ESMTPSA id mb20sm19357878wic.18.2015.02.24.00.10.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Feb 2015 00:10:26 -0800 (PST)
In-Reply-To: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Crash when we try to release a tree that is not initialized.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 9e8965c..8549130 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -669,8 +669,10 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
-	if (tree == NULL)
-		goto err;
+	if (tree == NULL) {
+		nft_set_list_free(ctx.set_list);
+		return -1;
+	}
 
 	ctx.xml = tree;
 
-- 
1.7.10.4

