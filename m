Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F5CC433E9
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9348165287
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhCIPqc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbhCIPqJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:46:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504AC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:46:09 -0800 (PST)
Received: from localhost ([::1]:56688 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYi-00017B-8E; Tue, 09 Mar 2021 16:46:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 03/10] obj/ct_timeout: Fix snprintf buffer length updates
Date:   Tue,  9 Mar 2021 16:45:09 +0100
Message-Id: <20210309154516.4987-4-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have to pass shrinking 'remain' variable to consecutive snprintf calls
instead of the unchanged 'len' parameter.

Fixes: 0adceeab1597a ("src: add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/ct_timeout.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index 2662cac69438d..c3f577bdecd90 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -266,12 +266,12 @@ static int nftnl_obj_ct_timeout_snprintf_default(char *buf, size_t len,
 	struct nftnl_obj_ct_timeout *timeout = nftnl_obj_data(e);
 
 	if (e->flags & (1 << NFTNL_OBJ_CT_TIMEOUT_L3PROTO)) {
-		ret = snprintf(buf + offset, len, "family %d ",
+		ret = snprintf(buf + offset, remain, "family %d ",
 			       timeout->l3proto);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (e->flags & (1 << NFTNL_OBJ_CT_TIMEOUT_L4PROTO)) {
-		ret = snprintf(buf + offset, len, "protocol %d ",
+		ret = snprintf(buf + offset, remain, "protocol %d ",
 				timeout->l4proto);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
@@ -283,7 +283,7 @@ static int nftnl_obj_ct_timeout_snprintf_default(char *buf, size_t len,
 		if (timeout_protocol[timeout->l4proto].attr_max == 0)
 			l4num = IPPROTO_RAW;
 
-		ret = snprintf(buf + offset, len, "policy = {");
+		ret = snprintf(buf + offset, remain, "policy = {");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		for (i = 0; i < timeout_protocol[l4num].attr_max; i++) {
@@ -293,13 +293,13 @@ static int nftnl_obj_ct_timeout_snprintf_default(char *buf, size_t len,
 				"UNKNOWN";
 
 			if (timeout->timeout[i] != timeout_protocol[l4num].dflt_timeout[i]) {
-				ret = snprintf(buf + offset, len,
+				ret = snprintf(buf + offset, remain,
 					"%s = %u,", state_name, timeout->timeout[i]);
 				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 		}
 
-		ret = snprintf(buf + offset, len, "}");
+		ret = snprintf(buf + offset, remain, "}");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	buf[offset] = '\0';
-- 
2.30.1

