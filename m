From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/8] netfilter: nfnetlink_osf: add missing enum in nfnetlink_osf uapi header
Date: Fri, 10 Aug 2018 13:16:21 +0200
Message-ID: <20180810111622.3981-8-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

xt_osf_window_size_options was originally part of
include/uapi/linux/netfilter/xt_osf.h, restore it.

Fixes: bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure from xt_osf")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_osf.h      | 12 ------------
 include/uapi/linux/netfilter/nfnetlink_osf.h | 12 ++++++++++++
 include/uapi/linux/netfilter/xt_osf.h        |  1 +
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
index a7311bc03d3a..ecf7dab81e9e 100644
--- a/include/linux/netfilter/nfnetlink_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -4,18 +4,6 @@
 
 #include <uapi/linux/netfilter/nfnetlink_osf.h>
 
-/* Initial window size option state machine: multiple of mss, mtu or
- * plain numeric value. Can also be made as plain numeric value which
- * is not a multiple of specified value.
- */
-enum nf_osf_window_size_options {
-	OSF_WSS_PLAIN   = 0,
-	OSF_WSS_MSS,
-	OSF_WSS_MTU,
-	OSF_WSS_MODULO,
-	OSF_WSS_MAX,
-};
-
 enum osf_fmatch_states {
 	/* Packet does not match the fingerprint */
 	FMATCH_WRONG = 0,
diff --git a/include/uapi/linux/netfilter/nfnetlink_osf.h b/include/uapi/linux/netfilter/nfnetlink_osf.h
index 3b93fbb9fc24..76a3527df5dd 100644
--- a/include/uapi/linux/netfilter/nfnetlink_osf.h
+++ b/include/uapi/linux/netfilter/nfnetlink_osf.h
@@ -88,6 +88,18 @@ enum iana_options {
 	OSFOPT_EMPTY = 255,
 };
 
+/* Initial window size option state machine: multiple of mss, mtu or
+ * plain numeric value. Can also be made as plain numeric value which
+ * is not a multiple of specified value.
+ */
+enum nf_osf_window_size_options {
+	OSF_WSS_PLAIN	= 0,
+	OSF_WSS_MSS,
+	OSF_WSS_MTU,
+	OSF_WSS_MODULO,
+	OSF_WSS_MAX,
+};
+
 enum nf_osf_attr_type {
 	OSF_ATTR_UNSPEC,
 	OSF_ATTR_FINGER,
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index c56c59605c2b..24102b5286ec 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -46,6 +46,7 @@
 #define xt_osf_finger		nf_osf_finger
 #define xt_osf_nlmsg		nf_osf_nlmsg
 
+#define xt_osf_window_size_options	nf_osf_window_size_options
 #define xt_osf_attr_type	nf_osf_attr_type
 #define xt_osf_msg_types	nf_osf_msg_types
 
-- 
2.11.0
