Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E723C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E4EF2073C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLBWYM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:24:12 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54600 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBWYM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 17:24:12 -0500
Received: from localhost ([::1]:39458 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ibu70-0000DY-9L; Mon, 02 Dec 2019 23:24:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 3/4] flowtable: Correctly check realloc() call
Date:   Mon,  2 Dec 2019 23:24:00 +0100
Message-Id: <20191202222401.867-4-phil@nwl.cc>
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

Fixes: 7f99639dd9217 ("flowtable: device array dynamic allocation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/flowtable.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/flowtable.c b/src/flowtable.c
index db319434b51c0..9ba3b6d9a3404 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -388,7 +388,7 @@ static int nftnl_flowtable_parse_hook_cb(const struct nlattr *attr, void *data)
 static int nftnl_flowtable_parse_devs(struct nlattr *nest,
 				      struct nftnl_flowtable *c)
 {
-	const char **dev_array;
+	const char **dev_array, **tmp;
 	int len = 0, size = 8;
 	struct nlattr *attr;
 
@@ -401,14 +401,13 @@ static int nftnl_flowtable_parse_devs(struct nlattr *nest,
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

