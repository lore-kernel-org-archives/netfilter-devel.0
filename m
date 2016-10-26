From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] utils: provide snprintf helper macro
Date: Thu, 27 Oct 2016 00:36:06 +0200
Message-ID: <1477521368-12696-2-git-send-email-fw@strlen.de>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58156 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754096AbcJZWfz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 18:35:55 -0400
In-Reply-To: <1477521368-12696-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

lifted from libnftnl, except that we will abort on snprintf errors.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/utils.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index d88676476efb..bb58ba424165 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -83,6 +83,16 @@
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
+	if (ret < 0)					\
+		abort();				\
+	offset += ret;					\
+	assert(ret < len);				\
+	if (ret > len)					\
+		ret = len;				\
+	size += ret;					\
+	len -= ret;
+
 #define MSEC_PER_SEC	1000L
 
 /**
-- 
2.7.3

