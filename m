Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CC4CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25BD2070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJZLBz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:01:55 -0400
Received: from correo.us.es ([193.147.175.20]:38744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfJZLBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:01:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1183F5E4780
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:01:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0409F21FF7
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:01:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDF52DA4D0; Sat, 26 Oct 2019 13:01:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED5D9CA0F1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:01:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:01:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D0AA742EE395
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:01:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl,v2] flowtable: device array dynamic allocation
Date:   Sat, 26 Oct 2019 13:01:46 +0200
Message-Id: <20191026110146.28391-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove artificial upper limit of 8 devices per flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix incorrect size in reallocation.

 src/flowtable.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/src/flowtable.c b/src/flowtable.c
index 1f7ba3052d4f..020f10289644 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -358,30 +358,33 @@ static int nftnl_flowtable_parse_hook_cb(const struct nlattr *attr, void *data)
 static int nftnl_flowtable_parse_devs(struct nlattr *nest,
 				      struct nftnl_flowtable *c)
 {
+	const char **dev_array;
+	int len = 0, size = 8;
 	struct nlattr *attr;
-	char *dev_array[8];
-	int len = 0, i;
+
+	dev_array = calloc(8, sizeof(char *));
+	if (!dev_array)
+		return -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
 			goto err;
 		dev_array[len++] = strdup(mnl_attr_get_str(attr));
-		if (len >= 8)
-			break;
+		if (len >= size) {
+			dev_array = realloc(dev_array,
+					    size * 2 * sizeof(char *));
+			if (!dev_array)
+				goto err;
+
+			size *= 2;
+			memset(&dev_array[len], 0,
+			       (size - len) * sizeof(char *));
+		}
 	}
 
-	if (!len)
-		return -1;
-
-	c->dev_array = calloc(len + 1, sizeof(char *));
-	if (!c->dev_array)
-		goto err;
-
+	c->dev_array = dev_array;
 	c->dev_array_len = len;
 
-	for (i = 0; i < len; i++)
-		c->dev_array[i] = dev_array[i];
-
 	return 0;
 err:
 	while (len--)
-- 
2.11.0

