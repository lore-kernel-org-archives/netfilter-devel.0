From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/17] libxtables: support for XTTYPE_PLENMASK
Date: Mon,  9 May 2011 21:54:55 +0200
Message-ID: <1304970912-11520-2-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49331 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1EITzR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:17 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 +++-
 xtoptions.c          |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 47f797b..a760755 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -59,6 +59,7 @@ struct in_addr;
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
  * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
+ * %XTTYPE_PLENMASK:	prefix len stored as union nf_inet_addr
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -80,6 +81,7 @@ enum xt_option_type {
 	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
 	XTTYPE_PORTRC_NE,
+	XTTYPE_PLENMASK,
 };
 
 /**
@@ -139,7 +141,7 @@ struct xt_option_call {
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		double dbl;
-		union nf_inet_addr inetaddr;
+		union nf_inet_addr inetaddr, inetmask;
 		struct {
 			uint8_t tos_value, tos_mask;
 		};
diff --git a/xtoptions.c b/xtoptions.c
index 86498a9..2bd66f9 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -561,6 +561,47 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 	free(lo_arg);
 }
 
+static void xtopt_parse_plenmask(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	uint32_t *mask = cb->val.inetmask.all;
+	unsigned int prefix_len = 128;
+	uint8_t max = 128;
+
+	if (afinfo->family == NFPROTO_IPV6)
+		max = 128;
+	else if (afinfo->family == NFPROTO_IPV4)
+		max = 32;
+
+	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, max))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: bad value for option \"--%s\", "
+			"or out of range (%u-%u).\n",
+			cb->ext_name, entry->name, 0, max);
+
+	memset(mask, 0xFF, sizeof(union nf_inet_addr));
+	if (prefix_len == 0) {
+		mask[0] = mask[1] = mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 32) {
+		mask[0] <<= 32 - prefix_len;
+		mask[1] = mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 64) {
+		mask[1] <<= 32 - (prefix_len - 32);
+		mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 96) {
+		mask[2] <<= 32 - (prefix_len - 64);
+		mask[3] = 0;
+	} else if (prefix_len <= 128) {
+		mask[3] <<= 32 - (prefix_len - 96);
+	}
+	mask[0] = htonl(mask[0]);
+	mask[1] = htonl(mask[1]);
+	mask[2] = htonl(mask[2]);
+	mask[3] = htonl(mask[3]);
+	if (entry->flags & XTOPT_PUT)
+		memcpy(XTOPT_MKPTR(cb), mask, sizeof(union nf_inet_addr));
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -580,6 +621,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
 	[XTTYPE_PORTRC_NE]   = xtopt_parse_mport,
+	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
 };
 
 static const size_t xtopt_psize[] = {
@@ -599,6 +641,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
 	[XTTYPE_PORTRC_NE]   = sizeof(uint16_t[2]),
+	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
 };
 
 /**
-- 
1.7.1

