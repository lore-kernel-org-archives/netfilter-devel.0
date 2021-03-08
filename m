Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8E6C43333
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A4F651DD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCHOLw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhCHOLk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A31C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:11:40 -0800 (PST)
Received: from localhost ([::1]:53490 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJGbi-0003Rn-UR; Mon, 08 Mar 2021 15:11:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 5/5] expr: data_reg: Reduce indenting level a bit
Date:   Mon,  8 Mar 2021 15:11:19 +0100
Message-Id: <20210308141119.17809-6-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308141119.17809-1-phil@nwl.cc>
References: <20210308141119.17809-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Given there's only a single valid output_format left, catch other values
early to help a bit with those calls to overlong function names.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d3ccc612ce812..60dc9b81cb4d3 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -66,35 +66,20 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    uint32_t output_format, uint32_t flags,
 			    int reg_type)
 {
+	if (output_format != NFTNL_OUTPUT_DEFAULT)
+		return -1;
+
 	switch(reg_type) {
 	case DATA_VALUE:
-		switch(output_format) {
-		case NFTNL_OUTPUT_DEFAULT:
-			return nftnl_data_reg_value_snprintf_default(buf, size,
-								   reg, flags);
-		case NFTNL_OUTPUT_JSON:
-		case NFTNL_OUTPUT_XML:
-		default:
-			break;
-		}
-		break;
+		return nftnl_data_reg_value_snprintf_default(buf, size, reg,
+							     flags);
 	case DATA_VERDICT:
 	case DATA_CHAIN:
-		switch(output_format) {
-		case NFTNL_OUTPUT_DEFAULT:
-			return nftnl_data_reg_verdict_snprintf_def(buf, size,
-								 reg, flags);
-		case NFTNL_OUTPUT_JSON:
-		case NFTNL_OUTPUT_XML:
-		default:
-			break;
-		}
-		break;
+		return nftnl_data_reg_verdict_snprintf_def(buf, size, reg,
+							   flags);
 	default:
-		break;
+		return -1;
 	}
-
-	return -1;
 }
 
 static int nftnl_data_parse_cb(const struct nlattr *attr, void *data)
-- 
2.30.1

