From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [xtables-addons][PATCH 1/2] build: support for Linux 4.14
Date: Thu,  4 Jan 2018 15:50:49 -0200
Message-ID: <1515088250-32295-2-git-send-email-marcelo.cerri@canonical.com>
References: <1515088250-32295-1-git-send-email-marcelo.cerri@canonical.com>
Cc: jengelh@inai.de,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58325 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbeADRvL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 12:51:11 -0500
Received: from mail-qk0-f197.google.com ([209.85.220.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1eX9fa-0005vx-76
        for netfilter-devel@vger.kernel.org; Thu, 04 Jan 2018 17:51:10 +0000
Received: by mail-qk0-f197.google.com with SMTP id y12so1506430qka.11
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jan 2018 09:51:10 -0800 (PST)
In-Reply-To: <1515088250-32295-1-git-send-email-marcelo.cerri@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Seth Forshee <seth.forshee@canonical.com>

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 extensions/compat_xtables.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/compat_xtables.h b/extensions/compat_xtables.h
index d8882ac7670a..354884e15e1a 100644
--- a/extensions/compat_xtables.h
+++ b/extensions/compat_xtables.h
@@ -93,4 +93,8 @@ static inline struct net *par_net(const struct xt_action_param *par)
 #endif
 }
 
+#ifndef NF_CT_ASSERT
+#	define NF_CT_ASSERT(x)	WARN_ON(!(x))
+#endif
+
 #endif /* _XTABLES_COMPAT_H */
-- 
2.7.4

