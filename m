Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A45BC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50D8320738
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403926AbgFXNaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391061AbgFXNaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:10 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529EFC061797
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:10 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:08 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 5/9] Add ARRAY_SIZE() macro
Date:   Wed, 24 Jun 2020 15:30:01 +0200
Message-Id: <20200624133005.22046-5-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
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
index b1fc670..0f59f1a 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -40,6 +40,8 @@
 #define IPPROTO_DCCP 33
 #endif
 
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+
 #define BUFFER_SIZE(ret, size, len, offset)		\
 	if (ret < 0)					\
 		return -1;				\
-- 
2.20.1

