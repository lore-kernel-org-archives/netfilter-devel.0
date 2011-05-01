From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] libxtables: XTTYPE_PORTRC support
Date: Sun,  1 May 2011 13:50:27 +0200
Message-ID: <1304250630-6150-8-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50019 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab1EALum (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:42 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    6 ++++-
 xtoptions.c          |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index b06ab61..0cd9f9f 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -56,6 +56,8 @@ struct in_addr;
  * %XTTYPE_ONEHOST:	one host or address (union nf_inet_addr)
  * %XTTYPE_PORT:	16-bit port name or number
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
+ * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
+ * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -74,6 +76,8 @@ enum xt_option_type {
 	XTTYPE_ONEHOST,
 	XTTYPE_PORT,
 	XTTYPE_PORT_NE,
+	XTTYPE_PORTRC,
+	XTTYPE_PORTRC_NE,
 };
 
 /**
@@ -129,7 +133,7 @@ struct xt_option_call {
 	uint8_t nvals;
 	union {
 		uint8_t u8, u8_range[2], syslog_level;
-		uint16_t u16, u16_range[2], port;
+		uint16_t u16, u16_range[2], port, port_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		union nf_inet_addr inetaddr;
diff --git a/xtoptions.c b/xtoptions.c
index 69e43e9..7a7d706 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -483,6 +483,61 @@ static void xtopt_parse_port(struct xt_option_call *cb)
 		*(uint16_t *)XTOPT_MKPTR(cb) = cb->val.port;
 }
 
+static void xtopt_parse_mport(struct xt_option_call *cb)
+{
+	static const size_t esize = sizeof(uint16_t);
+	const struct xt_option_entry *entry = cb->entry;
+	char *arg, *lo_arg = strdup(cb->arg);
+	char *put = XTOPT_MKPTR(cb);
+	unsigned int maxiter;
+	char *end = "";
+	char sep = ':';
+	int value;
+
+	if (lo_arg == NULL)
+		xt_params->exit_err(RESOURCE_PROBLEM, "strdup");
+
+	maxiter = entry->size / esize;
+	if (maxiter == 0)
+		maxiter = 2; /* ARRAY_SIZE(cb->val.port_range) */
+	if (entry->size % esize != 0)
+		xt_params->exit_err(OTHER_PROBLEM, "%s: memory block does "
+			"not have proper size\n", __func__);
+
+	cb->nvals = 0;
+	for (arg = lo_arg; ; arg = end + 1) {
+		if (cb->nvals == maxiter)
+			xt_params->exit_err(PARAMETER_PROBLEM, "%s: Too many "
+				"components for option \"--%s\" (max: %u)\n",
+				cb->ext_name, entry->name, maxiter);
+		//arg contains :??
+		end = strchr(arg, ':');
+		if (end != NULL)
+			*end = '\0';
+		value = xtables_getportbyname(arg);
+		if (value < 0)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"Port \"%s\" does not resolve to anything.\n",
+				arg);
+		if (entry->type == XTTYPE_PORTRC_NE)
+			value = htons(value);
+		if (end != NULL && *end != '\0' && *end != sep)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"%s: Argument to \"--%s\" has unexpected "
+				"characters.\n", cb->ext_name, entry->name);
+		++cb->nvals;
+		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range))
+			cb->val.port_range[cb->nvals] = value;
+		if (entry->flags & XTOPT_PUT) {
+			*(uint16_t *)put = value;
+			put += esize;
+		}
+		if (end == NULL || *end == '\0')
+			break;
+	}
+	free(lo_arg);
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -499,6 +554,8 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_ONEHOST]     = xtopt_parse_onehost,
 	[XTTYPE_PORT]        = xtopt_parse_port,
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
+	[XTTYPE_PORTRC]      = xtopt_parse_mport,
+	[XTTYPE_PORTRC_NE]   = xtopt_parse_mport,
 };
 
 static const size_t xtopt_psize[] = {
@@ -515,6 +572,8 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_ONEHOST]     = sizeof(union nf_inet_addr),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
 	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
+	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
+	[XTTYPE_PORTRC_NE]   = sizeof(uint16_t[2]),
 };
 
 /**
-- 
1.7.1

