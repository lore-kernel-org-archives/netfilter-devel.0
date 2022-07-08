Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4888C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 11:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiGHLSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiGHLSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 07:18:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69B8BE0E3
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 04:18:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@ionos.com
Subject: [PATCH conntrack-tools 3/3] conntrack: slightly simplify parse_proto_num() by using strtoul()
Date:   Fri,  8 Jul 2022 13:18:21 +0200
Message-Id: <20220708111821.37783-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708111821.37783-1-pablo@netfilter.org>
References: <20220708111821.37783-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use strtoul() instead and remove check for negative value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 4afccde4b027..859a4835580b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -836,12 +836,11 @@ extern struct ctproto_handler ct_proto_unknown;
 
 static int parse_proto_num(const char *str)
 {
+	unsigned long val;
 	char *endptr;
-	long val;
 
-	val = strtol(str, &endptr, 0);
+	val = strtoul(str, &endptr, 0);
 	if (val > IPPROTO_RAW ||
-	    val < 0 ||
 	    endptr == str ||
 	    *endptr != '\0')
 		return -1;
-- 
2.30.2

