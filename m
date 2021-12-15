Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EFEC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhLOXgP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:36:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56554 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhLOXgN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:36:13 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 649E1607E0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 00:33:43 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] proto: revisit short-circuit loops over upper protocols
Date:   Thu, 16 Dec 2021 00:36:06 +0100
Message-Id: <20211215233607.170171-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the check for NULL protocol description away from the loop to avoid
too long line.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 31a2f38065ad..a013a00d2c7b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -59,8 +59,9 @@ proto_find_upper(const struct proto_desc *base, unsigned int num)
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
-	     i++) {
+	for (i = 0; i < array_size(base->protocols); i++) {
+		if (!base->protocols[i].desc)
+			break;
 		if (base->protocols[i].num == num)
 			return base->protocols[i].desc;
 	}
@@ -78,8 +79,9 @@ int proto_find_num(const struct proto_desc *base,
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
-	     i++) {
+	for (i = 0; i < array_size(base->protocols); i++) {
+		if (!base->protocols[i].desc)
+			break;
 		if (base->protocols[i].desc == desc)
 			return base->protocols[i].num;
 	}
@@ -107,9 +109,9 @@ int proto_dev_type(const struct proto_desc *desc, uint16_t *res)
 			*res = dev_proto_desc[i].type;
 			return 0;
 		}
-		for (j = 0; j < array_size(base->protocols) &&
-			     base->protocols[j].desc;
-		     j++) {
+		for (j = 0; j < array_size(base->protocols); j++) {
+			if (!base->protocols[j].desc)
+				break;
 			if (base->protocols[j].desc == desc) {
 				*res = dev_proto_desc[i].type;
 				return 0;
-- 
2.30.2

