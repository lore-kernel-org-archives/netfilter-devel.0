Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158A6C433E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17E620716
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbgFWMe5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732553AbgFWMeq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 08:34:46 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CDEC061755
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 05:34:46 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 23 Jun 2020 14:34:44 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
Subject: [libnf_ct resend PATCH 5/8] Add asizeof() macro
Date:   Tue, 23 Jun 2020 14:34:00 +0200
Message-Id: <20200623123403.31676-6-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623123403.31676-1-dxld@darkboxed.org>
References: <20200623123403.31676-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 include/internal/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/internal/internal.h b/include/internal/internal.h
index 859724b..68c5ef0 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -40,6 +40,8 @@
 #define IPPROTO_DCCP 33
 #endif
 
+#define asizeof(x) (sizeof(x) / sizeof(*x))
+
 #define BUFFER_SIZE(ret, size, len, offset)		\
 	if(ret < 0)					\
 		return -1;				\
-- 
2.20.1

