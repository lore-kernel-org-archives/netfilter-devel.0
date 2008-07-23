From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 1/4] Make NFLOG export raw header and source raw address.
Date: Wed, 23 Jul 2008 23:20:45 +0200
Message-ID: <1216848048-13516-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39929 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754591AbYGWVUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:20:50 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the key structure of NFLOG. It solves the conflict
between ULOG and NFLOG by ensuring that keys have the same meaning:
 * raw.mac is the full hardware header
 * raw.mac.saddr is the source hardware address
Following Patrick suggestion, it adds a new key "raw.type" which is used
to store the type of hardware.

The configure.in file has been modified to autodetect the existence of the
required NFLOG functions.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in                      |    4 ++-
 input/packet/ulogd_inppkt_NFLOG.c |   43 ++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/configure.in b/configure.in
index 8e0f6a3..c25bbdb 100644
--- a/configure.in
+++ b/configure.in
@@ -41,8 +41,10 @@ PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_
 
 PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
 
-PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
+PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_NOTICE(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
 
+AC_CHECK_LIB([netfilter_log],[nflog_get_msg_packet_hwhdrlen],
+                        AC_DEFINE_UNQUOTED([HAVE_NFLOG_RAWHEADER],[1],[NFLOG userspace has raw header support]),,[-lnfnetlink])
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index cb58661..c2de88c 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -9,6 +9,8 @@
 #include <errno.h>
 
 #include <ulogd/ulogd.h>
+#include <config.h>
+
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 
@@ -133,6 +135,9 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_UID,
 	NFLOG_KEY_OOB_GID,
 	NFLOG_KEY_RAW_LABEL,
+	NFLOG_KEY_RAW_TYPE,
+	NFLOG_KEY_RAW_MAC_SADDR,
+	NFLOG_KEY_RAW_MAC_ADDRLEN,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -140,6 +145,11 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac",
+	},
+	[NFLOG_KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.saddr",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
@@ -240,6 +250,12 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac_len",
 	},
+	[NFLOG_KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.addrlen",
+	},
+
 	[NFLOG_KEY_OOB_SEQ_LOCAL] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
@@ -283,6 +299,11 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.label",
 	},
+	[NFLOG_KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
 
 };
 
@@ -290,9 +311,8 @@ static inline int
 interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 {
 	struct ulogd_key *ret = upi->output.keys;
-
-	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(ldata);
 	struct nfulnl_msg_packet_hw *hw = nflog_get_packet_hw(ldata);
+	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(ldata);
 	char *payload;
 	int payload_len = nflog_get_payload(ldata, &payload);
 	char *prefix = nflog_get_prefix(ldata);
@@ -318,11 +338,24 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 	}
 
-	if (hw) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = hw->hw_addr;
+#ifdef HAVE_NFLOG_RAWHEADER
+	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
+		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = nflog_get_msg_packet_hwhdr(ldata);
 		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
+			nflog_get_msg_packet_hwhdrlen(ldata);
 		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
+		ret[NFLOG_KEY_RAW_TYPE].u.value.ui16 =
+			nflog_get_hwtype(ldata);
+		ret[NFLOG_KEY_RAW_TYPE].flags |= ULOGD_RETF_VALID;
+	}
+#endif
+
+	if (hw) {
+		ret[NFLOG_KEY_RAW_MAC_SADDR].u.value.ptr = hw->hw_addr;
+		ret[NFLOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (payload_len >= 0) {
-- 
1.5.4.3

