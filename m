Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ED8C433E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B36F20716
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgFWMex (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729574AbgFWMeq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 08:34:46 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC3C061797
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 05:34:45 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 23 Jun 2020 14:34:44 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
Subject: [libnf_ct resend PATCH 4/8] Fix incorrect snprintf size calculation
Date:   Tue, 23 Jun 2020 14:33:59 +0200
Message-Id: <20200623123403.31676-5-dxld@darkboxed.org>
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

The previous BUFFER_SIZE() call already updated the remaining 'len'. So
there is no need to subtract 'size' again. While this just makes the buffer
appear smaller than it is, which is mostly harmless, the subtraction might
underflow as 'size > len' is not checked like BUFFER_SIZE() does.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/conntrack/snprintf_default.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 2f2f918..d00c5cb 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -108,7 +108,7 @@ static int __snprintf_address_ipv6(char *buf,
 	if (!inet_ntop(AF_INET6, &dst, tmp, sizeof(tmp)))
 		return -1;
 
-	ret = snprintf(buf+offset, len-size, "%s=%s ", dst_tag, tmp);
+	ret = snprintf(buf+offset, len, "%s=%s ", dst_tag, tmp);
 	BUFFER_SIZE(ret, size, len, offset);
 
 	return size;
-- 
2.20.1

