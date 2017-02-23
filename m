From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] uapi: stop including linux/sysctl.h in uapi/linux/netfilter.h
Date: Thu, 23 Feb 2017 05:49:28 +0300
Message-ID: <20170223024928.GA17115@altlinux.org>
References: <20170222230652.GA14373@altlinux.org> <87poi93d19.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87poi93d19.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

linux/netfilter.h is the last uapi header file that includes
linux/sysctl.h but it does not depend on definitions provided
by this essentially dead header file.

Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/linux/netfilter.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index 7550e91..c111a91 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/sysctl.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 
-- 
ldv
