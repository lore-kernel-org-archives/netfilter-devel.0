From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH iptables] extensions: Add macro _DEFAULT_SOURCE.
Date: Thu, 21 Dec 2017 09:05:45 +0530
Message-ID: <20171221033545.2676-2-rvarsha016@gmail.com>
References: <20171221033545.2676-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37704 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756330AbdLUDgQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 22:36:16 -0500
Received: by mail-pg0-f68.google.com with SMTP id o13so2025652pgp.4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 19:36:16 -0800 (PST)
In-Reply-To: <20171221033545.2676-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Define _DEFAULT_SOURCE as _BSD_SOURCE is deprecated.
https://sourceware.org/glibc/wiki/Release/2.20#Packaging_Changes

This patch fixes the following warning:

warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use
_DEFAULT_SOURCE" [-Wcpp]
 # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use
 # _DEFAULT_SOURCE"

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 extensions/libxt_hashlimit.c | 1 +
 extensions/libxt_limit.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index e51ac1ae..ffe342a7 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -11,6 +11,7 @@
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
 #define _BSD_SOURCE 1
+#define _DEFAULT_SOURCE 1
 #define _ISOC99_SOURCE 1
 #include <inttypes.h>
 #include <math.h>
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 5cc95c2e..c8ddca87 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -4,6 +4,7 @@
  * Hervé Eychenne    <rv@wallfire.org>
  */
 #define _BSD_SOURCE 1
+#define _DEFAULT_SOURCE 1
 #define _ISOC99_SOURCE 1
 #include <math.h>
 #include <stdio.h>
-- 
2.14.3

