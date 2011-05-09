From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/17] libxtables: XTTYPE_PLEN support
Date: Mon,  9 May 2011 21:55:00 +0200
Message-ID: <1304970912-11520-7-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49337 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab1EITzW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:22 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtoptions.c          |   41 +++++++++++++++++++++++++++--------------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index c9ad523..9bb4235 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -65,6 +65,7 @@ struct in_addr;
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
  * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
+ * %XTTYPE_PLEN:	prefix length
  * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
  */
 enum xt_option_type {
@@ -87,6 +88,7 @@ enum xt_option_type {
 	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
 	XTTYPE_PORTRC_NE,
+	XTTYPE_PLEN,
 	XTTYPE_PLENMASK,
 };
 
diff --git a/xtoptions.c b/xtoptions.c
index 29d05d5..3cc2e0c 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -569,14 +569,12 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 
 /**
  * Parse an integer and ensure it is within the address family's prefix length
- * limits. The result is stored in @cb->val.hmask and @cb->val.hlen. If
- * %XTOPT_PUT is used, hmask will be copied to the pointed-to area.
+ * limits. The result is stored in @cb->val.hlen.
  */
-static void xtopt_parse_plenmask(struct xt_option_call *cb)
+static void xtopt_parse_plen(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
-	uint32_t *mask = cb->val.hmask.all;
-	unsigned int prefix_len = 128;
+	unsigned int prefix_len = 128; /* happiness is a warm gcc */
 
 	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
 	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, cb->val.hlen))
@@ -586,21 +584,35 @@ static void xtopt_parse_plenmask(struct xt_option_call *cb)
 			cb->ext_name, entry->name, 0, cb->val.hlen);
 
 	cb->val.hlen = prefix_len;
+}
+
+/**
+ * Reuse xtopt_parse_plen for testing the integer. Afterwards convert this to
+ * a bitmask, and make it available through @cb->val.hmask (hlen remains
+ * valid). If %XTOPT_PUT is used, hmask will be copied to the target area.
+ */
+static void xtopt_parse_plenmask(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	uint32_t *mask = cb->val.hmask.all;
+
+	xtopt_parse_plen(cb);
+
 	memset(mask, 0xFF, sizeof(union nf_inet_addr));
 	/* This shifting is AF-independent. */
-	if (prefix_len == 0) {
+	if (cb->val.hlen == 0) {
 		mask[0] = mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 32) {
-		mask[0] <<= 32 - prefix_len;
+	} else if (cb->val.hlen <= 32) {
+		mask[0] <<= 32 - cb->val.hlen;
 		mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 64) {
-		mask[1] <<= 32 - (prefix_len - 32);
+	} else if (cb->val.hlen <= 64) {
+		mask[1] <<= 32 - (cb->val.hlen - 32);
 		mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 96) {
-		mask[2] <<= 32 - (prefix_len - 64);
+	} else if (cb->val.hlen <= 96) {
+		mask[2] <<= 32 - (cb->val.hlen - 64);
 		mask[3] = 0;
-	} else if (prefix_len <= 128) {
-		mask[3] <<= 32 - (prefix_len - 96);
+	} else if (cb->val.hlen <= 128) {
+		mask[3] <<= 32 - (cb->val.hlen - 96);
 	}
 	mask[0] = htonl(mask[0]);
 	mask[1] = htonl(mask[1]);
@@ -629,6 +641,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
 	[XTTYPE_PORTRC_NE]   = xtopt_parse_mport,
+	[XTTYPE_PLEN]        = xtopt_parse_plen,
 	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
 };
 
-- 
1.7.1

