From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [libnftnl PATCH] buffer: include stdarg header
Date: Thu, 20 Nov 2014 13:15:57 +0100
Message-ID: <1416485757-27046-1-git-send-email-giuseppelng@gmail.com>
Cc: pablo@netfilter.org, Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45049 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKTMQF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:16:05 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so8499486wiv.6
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2014 04:16:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes the following warnings:

buffer.c: In function 'nft_buf_put':
buffer.c:53:2: warning: implicit declaration of function 'va_start' [-Wimplicit-function-declaration]
  va_start(ap, fmt);
  ^
buffer.c:56:2: warning: implicit declaration of function 'va_end' [-Wimplicit-function-declaration]
  va_end(ap);
  ^

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 src/buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/buffer.c b/src/buffer.c
index 4fac110..d64f944 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -9,6 +9,7 @@
 
 #include <stdio.h>
 #include <stdint.h>
+#include <stdarg.h>
 #include <inttypes.h>
 #include <string.h>
 #include <buffer.h>
-- 
1.9.1

