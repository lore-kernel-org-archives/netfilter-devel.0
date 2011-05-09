From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/17] libxtables: XTTYPE_PROTOCOL support
Date: Mon,  9 May 2011 21:55:09 +0200
Message-ID: <1304970912-11520-16-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49376 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1EITzd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:33 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 +++-
 xtoptions.c          |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 50aa414..c3996a0 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -63,6 +63,7 @@ struct in_addr;
  * %XTTYPE_HOST:	one host or address (ptr: union nf_inet_addr)
  * %XTTYPE_HOSTMASK:	one host or address, with an optional prefix length
  * 			(ptr: union nf_inet_addr; only host portion is stored)
+ * %XTTYPE_PROTOCOL:	protocol number/name from /etc/protocols (ptr: uint8_t)
  * %XTTYPE_PORT:	16-bit port name or number
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
@@ -87,6 +88,7 @@ enum xt_option_type {
 	XTTYPE_SYSLOGLEVEL,
 	XTTYPE_HOST,
 	XTTYPE_HOSTMASK,
+	XTTYPE_PROTOCOL,
 	XTTYPE_PORT,
 	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
@@ -147,7 +149,7 @@ struct xt_option_call {
 	bool invert;
 	uint8_t nvals;
 	union {
-		uint8_t u8, u8_range[2], syslog_level;
+		uint8_t u8, u8_range[2], syslog_level, protocol;
 		uint16_t u16, u16_range[2], port, port_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
diff --git a/xtoptions.c b/xtoptions.c
index 413de1b..70370ed 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -493,6 +493,29 @@ static int xtables_getportbyname(const char *name)
 }
 
 /**
+ * Validate and parse a protocol specification (number or name) by use of
+ * /etc/protocols and put the result into @cb->val.protocol.
+ */
+static void xtopt_parse_protocol(struct xt_option_call *cb)
+{
+	const struct protoent *entry;
+	unsigned int value = -1;
+
+	if (xtables_strtoui(cb->arg, NULL, &value, 0, UINT8_MAX)) {
+		cb->val.protocol = value;
+		return;
+	}
+	entry = getprotobyname(cb->arg);
+	if (entry == NULL)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"Protocol \"%s\" does not resolve to anything.\n",
+			cb->arg);
+	cb->val.protocol = entry->p_proto;
+	if (cb->entry->flags & XTOPT_PUT)
+		*(uint8_t *)XTOPT_MKPTR(cb) = cb->val.protocol;
+}
+
+/**
  * Validate and parse a port specification and put the result into
  * @cb->val.port.
  */
@@ -665,6 +688,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
 	[XTTYPE_HOST]        = xtopt_parse_host,
 	[XTTYPE_HOSTMASK]    = xtopt_parse_hostmask,
+	[XTTYPE_PROTOCOL]    = xtopt_parse_protocol,
 	[XTTYPE_PORT]        = xtopt_parse_port,
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
@@ -691,6 +715,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
 	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
+	[XTTYPE_PROTOCOL]    = sizeof(uint8_t),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
 	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-- 
1.7.1

