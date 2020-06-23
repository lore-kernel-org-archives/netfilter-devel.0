Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F1CC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D1D20716
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbgFWMet (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732502AbgFWMep (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 08:34:45 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99988C061573
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 05:34:44 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 23 Jun 2020 14:34:42 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
Subject: [libnf_ct resend PATCH 1/8] Handle negative snprintf return values properly
Date:   Tue, 23 Jun 2020 14:33:56 +0200
Message-Id: <20200623123403.31676-2-dxld@darkboxed.org>
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

Currently the BUFFER_SIZE macro doesn't take negative 'ret' values into
account. A negative return should just be passed through to the caller,
snprintf will already have set 'errno' properly.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 include/internal/internal.h | 2 ++
 src/conntrack/api.c         | 6 +++---
 src/conntrack/snprintf.c    | 3 +++
 src/expect/snprintf.c       | 3 +++
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/internal/internal.h b/include/internal/internal.h
index bb44e12..859724b 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -41,6 +41,8 @@
 #endif
 
 #define BUFFER_SIZE(ret, size, len, offset)		\
+	if(ret < 0)					\
+		return -1;				\
 	size += ret;					\
 	if (ret > len)					\
 		ret = len;				\
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index ffa5216..78d7d61 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1099,9 +1099,9 @@ int nfct_catch(struct nfct_handle *h)
  * print the message just after you receive the destroy event. If you want
  * more accurate timestamping, use NFCT_OF_TIMESTAMP.
  *
- * This function returns the size of the information that _would_ have been 
- * written to the buffer, even if there was no room for it. Thus, the
- * behaviour is similar to snprintf.
+ * On error, -1 is returned and errno is set appropiately. Otherwise the
+ * size of what _would_ be written is returned, even if the size of the
+ * buffer is insufficient. This behaviour is similar to snprintf.
  */
 int nfct_snprintf(char *buf,
 		  unsigned int size,
diff --git a/src/conntrack/snprintf.c b/src/conntrack/snprintf.c
index 17ad885..a87c0c9 100644
--- a/src/conntrack/snprintf.c
+++ b/src/conntrack/snprintf.c
@@ -85,6 +85,9 @@ int __snprintf_conntrack(char *buf,
 		return -1;
 	}
 
+        if(size < 0)
+                return size;
+
 	/* NULL terminated string */
 	buf[size+1 > len ? len-1 : size] = '\0';
 
diff --git a/src/expect/snprintf.c b/src/expect/snprintf.c
index 3a104b5..b28ac62 100644
--- a/src/expect/snprintf.c
+++ b/src/expect/snprintf.c
@@ -30,6 +30,9 @@ int __snprintf_expect(char *buf,
 		return -1;
 	}
 
+	if(size < 0)
+		return size;
+
 	/* NULL terminated string */
 	buf[size+1 > len ? len-1 : size] = '\0';
 
-- 
2.20.1

