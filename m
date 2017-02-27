From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] uapi: stop including linux/sysctl.h in uapi/linux/netfilter.h
Date: Mon, 27 Feb 2017 12:35:38 +0100
Message-ID: <1488195342-2678-3-git-send-email-pablo@netfilter.org>
References: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

linux/netfilter.h is the last uapi header file that includes
linux/sysctl.h but it does not depend on definitions provided
by this essentially dead header file.

Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index 7550e9176a54..c111a91adcc0 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/sysctl.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 
-- 
2.1.4
