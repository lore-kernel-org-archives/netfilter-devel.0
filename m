From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/11] libxtables: XTTYPE_ETHERMAC support
Date: Wed, 11 May 2011 15:52:48 +0200
Message-ID: <1305121977-4361-4-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60363 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab1EKPsS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:18 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 +++
 xtoptions.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index c3996a0..0fe4b90 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -70,6 +70,7 @@ struct in_addr;
  * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
  * %XTTYPE_PLEN:	prefix length
  * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
+ * %XTTYPE_ETHERMAC:	Ethernet MAC address in hex form
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -95,6 +96,7 @@ enum xt_option_type {
 	XTTYPE_PORTRC_NE,
 	XTTYPE_PLEN,
 	XTTYPE_PLENMASK,
+	XTTYPE_ETHERMAC,
 };
 
 /**
@@ -164,6 +166,7 @@ struct xt_option_call {
 		struct {
 			uint32_t mark, mask;
 		};
+		uint8_t ethermac[6];
 	} val;
 	/* Wished for a world where the ones below were gone: */
 	union {
diff --git a/xtoptions.c b/xtoptions.c
index 70370ed..8d54dd8 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -672,6 +672,30 @@ static void xtopt_parse_hostmask(struct xt_option_call *cb)
 	cb->arg = orig_arg;
 }
 
+static void xtopt_parse_ethermac(struct xt_option_call *cb)
+{
+	const char *arg = cb->arg;
+	unsigned int i;
+	char *end;
+
+	for (i = 0; i < ARRAY_SIZE(cb->val.ethermac) - 1; ++i) {
+		cb->val.ethermac[i] = strtoul(arg, &end, 16);
+		if (cb->val.ethermac[i] > UINT8_MAX || *end != ':')
+			goto out;
+		arg = end + 1;
+	}
+	i = ARRAY_SIZE(cb->val.ethermac) - 1;
+	cb->val.ethermac[i] = strtoul(arg, &end, 16);
+	if (cb->val.ethermac[i] > UINT8_MAX || *end != '\0')
+		goto out;
+	if (cb->entry->flags & XTOPT_PUT)
+		memcpy(XTOPT_MKPTR(cb), cb->val.ethermac,
+		       sizeof(cb->val.ethermac));
+	return;
+ out:
+	xt_params->exit_err(PARAMETER_PROBLEM, "ether");
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -695,6 +719,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_PORTRC_NE]   = xtopt_parse_mport,
 	[XTTYPE_PLEN]        = xtopt_parse_plen,
 	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
+	[XTTYPE_ETHERMAC]    = xtopt_parse_ethermac,
 };
 
 static const size_t xtopt_psize[] = {
@@ -721,6 +746,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
 	[XTTYPE_PORTRC_NE]   = sizeof(uint16_t[2]),
 	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
+	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
 };
 
 /**
-- 
1.7.1

