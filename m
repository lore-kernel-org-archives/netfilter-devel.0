From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] netfilter: xt_SYNPROXY: include missing <linux/types.h>
Date: Fri, 17 Jun 2016 20:25:19 +0200
Message-ID: <1466187919-12800-8-git-send-email-pablo@netfilter.org>
References: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

./usr/include/linux/netfilter/xt_SYNPROXY.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_SYNPROXY.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_SYNPROXY.h b/include/uapi/linux/netfilter/xt_SYNPROXY.h
index 2d59fba..ca67e61 100644
--- a/include/uapi/linux/netfilter/xt_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/xt_SYNPROXY.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SYNPROXY_H
 #define _XT_SYNPROXY_H
 
+#include <linux/types.h>
+
 #define XT_SYNPROXY_OPT_MSS		0x01
 #define XT_SYNPROXY_OPT_WSCALE		0x02
 #define XT_SYNPROXY_OPT_SACK_PERM	0x04
-- 
2.1.4
