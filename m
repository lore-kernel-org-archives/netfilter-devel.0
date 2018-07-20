From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 38/38] netfilter: nf_osf: add missing definitions to header file
Date: Fri, 20 Jul 2018 15:09:06 +0200
Message-ID: <20180720130906.27687-39-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add missing definitions from nf_osf.h in order to extract Passive OS
fingerprint infrastructure from xt_osf.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_osf.h | 11 +++++++++++
 include/uapi/linux/netfilter/xt_osf.h | 10 ++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
index 8f2f2f403183..3738116b2bbe 100644
--- a/include/uapi/linux/netfilter/nf_osf.h
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -16,9 +16,14 @@
 
 #define NF_OSF_TTL_TRUE			0	/* True ip and fingerprint TTL comparison */
 
+/* Check if ip TTL is less than fingerprint one */
+#define NF_OSF_TTL_LESS			1
+
 /* Do not compare ip and fingerprint TTL at all */
 #define NF_OSF_TTL_NOCHECK		2
 
+#define NF_OSF_FLAGMASK		(NF_OSF_GENRE | NF_OSF_TTL | \
+				 NF_OSF_LOG | NF_OSF_INVERT)
 /* Wildcard MSS (kind of).
  * It is used to implement a state machine for the different wildcard values
  * of the MSS and window sizes.
@@ -83,4 +88,10 @@ enum iana_options {
 	OSFOPT_EMPTY = 255,
 };
 
+enum nf_osf_attr_type {
+	OSF_ATTR_UNSPEC,
+	OSF_ATTR_FINGER,
+	OSF_ATTR_MAX,
+};
+
 #endif /* _NF_OSF_H */
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index 72956eceeb09..b189007f4f28 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -37,8 +37,7 @@
 
 #define XT_OSF_TTL_TRUE		NF_OSF_TTL_TRUE
 #define XT_OSF_TTL_NOCHECK	NF_OSF_TTL_NOCHECK
-
-#define XT_OSF_TTL_LESS	1	/* Check if ip TTL is less than fingerprint one */
+#define XT_OSF_TTL_LESS		NF_OSF_TTL_LESS
 
 #define xt_osf_wc		nf_osf_wc
 #define xt_osf_opt		nf_osf_opt
@@ -47,6 +46,7 @@
 #define xt_osf_finger		nf_osf_finger
 #define xt_osf_nlmsg		nf_osf_nlmsg
 
+#define xt_osf_attr_type	nf_osf_attr_type
 /*
  * Add/remove fingerprint from the kernel.
  */
@@ -56,10 +56,4 @@ enum xt_osf_msg_types {
 	OSF_MSG_MAX,
 };
 
-enum xt_osf_attr_type {
-	OSF_ATTR_UNSPEC,
-	OSF_ATTR_FINGER,
-	OSF_ATTR_MAX,
-};
-
 #endif				/* _XT_OSF_H */
-- 
2.11.0
