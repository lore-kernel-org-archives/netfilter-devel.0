Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD382C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B402073C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfLBWYR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:24:17 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54606 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBWYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 17:24:17 -0500
Received: from localhost ([::1]:39464 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ibu75-0000Dw-Ln; Mon, 02 Dec 2019 23:24:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/4] chain: Correctly check realloc() call
Date:   Mon,  2 Dec 2019 23:24:01 +0100
Message-Id: <20191202222401.867-5-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202222401.867-1-phil@nwl.cc>
References: <20191202222401.867-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If realloc() fails, it returns NULL but the original pointer is
untouchted and therefore still has to be freed. Unconditionally
overwriting the old pointer is therefore a bad idea, use a temporary
variable instead.

Fixes: e3ac19b5ec162 ("chain: multi-device support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 9cc8735a4936f..b9a16fc9b42df 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -605,7 +605,7 @@ static int nftnl_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 
 static int nftnl_chain_parse_devs(struct nlattr *nest, struct nftnl_chain *c)
 {
-	const char **dev_array;
+	const char **dev_array, **tmp;
 	int len = 0, size = 8;
 	struct nlattr *attr;
 
@@ -618,14 +618,13 @@ static int nftnl_chain_parse_devs(struct nlattr *nest, struct nftnl_chain *c)
 			goto err;
 		dev_array[len++] = strdup(mnl_attr_get_str(attr));
 		if (len >= size) {
-			dev_array = realloc(dev_array,
-					    size * 2 * sizeof(char *));
-			if (!dev_array)
+			tmp = realloc(dev_array, size * 2 * sizeof(char *));
+			if (!tmp)
 				goto err;
 
 			size *= 2;
-			memset(&dev_array[len], 0,
-			       (size - len) * sizeof(char *));
+			memset(&tmp[len], 0, (size - len) * sizeof(char *));
+			dev_array = tmp;
 		}
 	}
 
-- 
2.24.0

