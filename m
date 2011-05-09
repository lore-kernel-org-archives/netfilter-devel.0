From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/17] libxtables: XTTYPE_HOSTMASK support
Date: Mon,  9 May 2011 21:55:02 +0200
Message-ID: <1304970912-11520-9-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49352 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1EITzZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:25 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 +++
 xtoptions.c          |   29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 9bb4235..caaec2f 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -61,6 +61,8 @@ struct in_addr;
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
  * %XTTYPE_HOST:	one host or address (ptr: union nf_inet_addr)
+ * %XTTYPE_HOSTMASK:	one host or address, with an optional prefix length
+ * 			(ptr: union nf_inet_addr; only host portion is stored)
  * %XTTYPE_PORT:	16-bit port name or number
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
@@ -84,6 +86,7 @@ enum xt_option_type {
 	XTTYPE_MARKMASK32,
 	XTTYPE_SYSLOGLEVEL,
 	XTTYPE_HOST,
+	XTTYPE_HOSTMASK,
 	XTTYPE_PORT,
 	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
diff --git a/xtoptions.c b/xtoptions.c
index 3cc2e0c..36f90e4 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -622,6 +622,33 @@ static void xtopt_parse_plenmask(struct xt_option_call *cb)
 		memcpy(XTOPT_MKPTR(cb), mask, sizeof(union nf_inet_addr));
 }
 
+static void xtopt_parse_hostmask(struct xt_option_call *cb)
+{
+	const char *orig_arg = cb->arg;
+	char *work, *p;
+
+	if (strchr(cb->arg, '/') == NULL) {
+		xtopt_parse_host(cb);
+		return;
+	}
+	work = strdup(orig_arg);
+	if (work == NULL)
+		xt_params->exit_err(PARAMETER_PROBLEM, "strdup");
+	p = strchr(work, '/'); /* by def this can't be NULL now */
+	*p++ = '\0';
+	/*
+	 * Because xtopt_parse_host and xtopt_parse_plenmask would store
+	 * different things in the same target area, XTTYPE_HOSTMASK must
+	 * disallow XTOPT_PUT, which it does by forcing its absence,
+	 * cf. not being listed in xtopt_psize.
+	 */
+	cb->arg = work;
+	xtopt_parse_host(cb);
+	cb->arg = p;
+	xtopt_parse_plenmask(cb);
+	cb->arg = orig_arg;
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -637,6 +664,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
 	[XTTYPE_HOST]        = xtopt_parse_host,
+	[XTTYPE_HOSTMASK]    = xtopt_parse_hostmask,
 	[XTTYPE_PORT]        = xtopt_parse_port,
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
@@ -662,6 +690,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
+	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
 	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-- 
1.7.1

