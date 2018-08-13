From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] uapi: fix linux/netfilter/nf_osf.h userspace compilation
 errors
Date: Mon, 13 Aug 2018 18:43:36 +0300
Message-ID: <20180813154335.GA22820@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
Cc: <stable@vger.kernel.org> # v4.18
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/linux/netfilter/nf_osf.h | 2 ++
 include/uapi/linux/netfilter/xt_osf.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
index 8f2f2f403183..eb5c4e20bec0 100644
--- a/include/uapi/linux/netfilter/nf_osf.h
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -2,6 +2,8 @@
 #define _NF_OSF_H
 
 #include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
 
 #define MAXGENRELEN	32
 
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index 72956eceeb09..f1abe4c6f59d 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -21,8 +21,6 @@
 #define _XT_OSF_H
 
 #include <linux/types.h>
-#include <linux/ip.h>
-#include <linux/tcp.h>
 #include <linux/netfilter/nf_osf.h>
 
 #define XT_OSF_GENRE		NF_OSF_GENRE
-- 
ldv
