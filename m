From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] uapi: fix linux/netfilter/xt_hashlimit.h userspace compilation error
Date: Fri, 24 Feb 2017 03:23:20 +0300
Message-ID: <20170224002320.GA31010@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Include <linux/limits.h> like some of uapi/linux/netfilter/xt_*.h
headers do to fix the following linux/netfilter/xt_hashlimit.h
userspace compilation error:

/usr/include/linux/netfilter/xt_hashlimit.h:90:12: error: 'NAME_MAX' undeclared here (not in a function)
  char name[NAME_MAX];

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/linux/netfilter/xt_hashlimit.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_hashlimit.h b/include/uapi/linux/netfilter/xt_hashlimit.h
index 3efc0ca..79da349 100644
--- a/include/uapi/linux/netfilter/xt_hashlimit.h
+++ b/include/uapi/linux/netfilter/xt_hashlimit.h
@@ -2,6 +2,7 @@
 #define _UAPI_XT_HASHLIMIT_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #include <linux/if.h>
 
 /* timings are in milliseconds. */
-- 
ldv
