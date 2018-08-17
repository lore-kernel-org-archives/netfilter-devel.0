From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/15] netfilter: uapi: fix linux/netfilter/nf_osf.h userspace compilation errors
Date: Fri, 17 Aug 2018 21:41:04 +0200
Message-ID: <20180817194106.2878-4-pablo@netfilter.org>
References: <20180817194106.2878-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817194106.2878-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

Move inclusion of <linux/ip.h> and <linux/tcp.h> from
linux/netfilter/xt_osf.h to linux/netfilter/nf_osf.h to fix
the following linux/netfilter/nf_osf.h userspace compilation errors:

/usr/include/linux/netfilter/nf_osf.h:59:24: error: 'MAX_IPOPTLEN' undeclared here (not in a function)
  struct nf_osf_opt opt[MAX_IPOPTLEN];
/usr/include/linux/netfilter/nf_osf.h:64:17: error: field 'ip' has incomplete type
  struct iphdr   ip;
/usr/include/linux/netfilter/nf_osf.h:65:18: error: field 'tcp' has incomplete type
  struct tcphdr   tcp;

Fixes: bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure from xt_osf")
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_osf.h | 2 ++
 include/uapi/linux/netfilter/xt_osf.h        | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_osf.h b/include/uapi/linux/netfilter/nfnetlink_osf.h
index 76a3527df5dd..272bc3195f2d 100644
--- a/include/uapi/linux/netfilter/nfnetlink_osf.h
+++ b/include/uapi/linux/netfilter/nfnetlink_osf.h
@@ -2,6 +2,8 @@
 #define _NF_OSF_H
 
 #include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
 
 #define MAXGENRELEN	32
 
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index 24102b5286ec..6e466236ca4b 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -21,8 +21,6 @@
 #define _XT_OSF_H
 
 #include <linux/types.h>
-#include <linux/ip.h>
-#include <linux/tcp.h>
 #include <linux/netfilter/nfnetlink_osf.h>
 
 #define XT_OSF_GENRE		NF_OSF_GENRE
-- 
2.11.0
