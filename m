From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/21] netfilter: nfnetlink_osf: rename nf_osf header file to nfnetlink_osf
Date: Sun,  5 Aug 2018 23:21:30 +0200
Message-ID: <20180805212141.3033-11-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

The first client of the nf_osf.h userspace header is nft_osf, coming in
this batch, rename it to nfnetlink_osf.h as there are no userspace
clients for this yet, hence this looks consistent with other nfnetlink
subsystem.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/{nf_osf.h => nfnetlink_osf.h}      | 2 +-
 include/uapi/linux/netfilter/{nf_osf.h => nfnetlink_osf.h} | 0
 include/uapi/linux/netfilter/xt_osf.h                      | 2 +-
 net/netfilter/nfnetlink_osf.c                              | 2 +-
 net/netfilter/nft_osf.c                                    | 2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename include/linux/netfilter/{nf_osf.h => nfnetlink_osf.h} (95%)
 rename include/uapi/linux/netfilter/{nf_osf.h => nfnetlink_osf.h} (100%)

diff --git a/include/linux/netfilter/nf_osf.h b/include/linux/netfilter/nfnetlink_osf.h
similarity index 95%
rename from include/linux/netfilter/nf_osf.h
rename to include/linux/netfilter/nfnetlink_osf.h
index 3e455d6f94d5..a7311bc03d3a 100644
--- a/include/linux/netfilter/nf_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -2,7 +2,7 @@
 #ifndef _NFOSF_H
 #define _NFOSF_H
 
-#include <uapi/linux/netfilter/nf_osf.h>
+#include <uapi/linux/netfilter/nfnetlink_osf.h>
 
 /* Initial window size option state machine: multiple of mss, mtu or
  * plain numeric value. Can also be made as plain numeric value which
diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nfnetlink_osf.h
similarity index 100%
rename from include/uapi/linux/netfilter/nf_osf.h
rename to include/uapi/linux/netfilter/nfnetlink_osf.h
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index a90e90c27cef..c56c59605c2b 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -23,7 +23,7 @@
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/netfilter/nf_osf.h>
+#include <linux/netfilter/nfnetlink_osf.h>
 
 #define XT_OSF_GENRE		NF_OSF_GENRE
 #define XT_OSF_INVERT		NF_OSF_INVERT
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index ba0fa11869ce..f9dba62c450f 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_log.h>
-#include <linux/netfilter/nf_osf.h>
+#include <linux/netfilter/nfnetlink_osf.h>
 
 /*
  * Indexed by dont-fragment bit.
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index bdacc4cffba4..9b2f3de7be4f 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -2,7 +2,7 @@
 #include <net/tcp.h>
 
 #include <net/netfilter/nf_tables.h>
-#include <linux/netfilter/nf_osf.h>
+#include <linux/netfilter/nfnetlink_osf.h>
 
 #define OSF_GENRE_SIZE		32
 
-- 
2.11.0
