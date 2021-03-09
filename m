Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA2FC4332E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E8E64FB8
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhCIPqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhCIPqU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:46:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3747CC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:46:20 -0800 (PST)
Received: from localhost ([::1]:56700 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYs-00017L-Qw; Tue, 09 Mar 2021 16:46:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 04/10] object: Fix for wrong parameter passed to snprintf callback
Date:   Tue,  9 Mar 2021 16:45:10 +0100
Message-Id: <20210309154516.4987-5-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the remaining buffer length, the used buffer length was
passed to object's snprintf callback (and the final snprintf call).

Fixes: 5573d0146c1ae ("src: support for stateful objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/object.c b/src/object.c
index 008badeea9b66..46e79168daa76 100644
--- a/src/object.c
+++ b/src/object.c
@@ -396,11 +396,11 @@ static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (obj->ops) {
-		ret = obj->ops->snprintf(buf + offset, offset, type, flags,
+		ret = obj->ops->snprintf(buf + offset, remain, type, flags,
 					 obj);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
-	ret = snprintf(buf + offset, offset, "]");
+	ret = snprintf(buf + offset, remain, "]");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
-- 
2.30.1

