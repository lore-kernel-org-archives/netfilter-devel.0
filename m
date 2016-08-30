From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/3] expr: numgen: add missing trailing whitespace
Date: Tue, 30 Aug 2016 12:41:08 +0200
Message-ID: <1472553669-1910-2-git-send-email-pablo@netfilter.org>
References: <1472553669-1910-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754327AbcH3KlV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 06:41:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07F5312A691
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDB91100A76
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D89F100A76
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:16 +0200 (CEST)
In-Reply-To: <1472553669-1910-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before patch:

  [ numgen reg 1 = inc(2)]

After patch:

  [ numgen reg 1 = inc(2) ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/numgen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 7be8270..e8fa9a1 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -191,12 +191,12 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = inc(%u)", ng->dreg,
+		ret = snprintf(buf, len, "reg %u = inc(%u) ", ng->dreg,
 			       ng->until);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
-		ret = snprintf(buf, len, "reg %u = random(%u)", ng->dreg,
+		ret = snprintf(buf, len, "reg %u = random(%u) ", ng->dreg,
 			       ng->until);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
-- 
2.1.4

