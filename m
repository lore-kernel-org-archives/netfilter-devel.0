From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/13] libxtables: retract _NE types and use a flag instead
Date: Mon, 23 May 2011 16:39:11 +0200
Message-ID: <1306161564-4370-2-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44606 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1EWOj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:27 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TPROXY.c |    8 ++++----
 include/xtables.h.in      |   12 ++++++------
 xtoptions.c               |   13 +++++--------
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 61646c9..d13ec85 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -20,8 +20,8 @@ enum {
 
 #define s struct xt_tproxy_target_info
 static const struct xt_option_entry tproxy_tg0_opts[] = {
-	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
-	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
+	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_MAND | XTOPT_NBO | XTOPT_PUT, XTOPT_POINTER(s, lport)},
 	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_HOST},
 	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
 	XTOPT_TABLEEND,
@@ -29,8 +29,8 @@ static const struct xt_option_entry tproxy_tg0_opts[] = {
 #undef s
 #define s struct xt_tproxy_target_info_v1
 static const struct xt_option_entry tproxy_tg1_opts[] = {
-	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
-	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
+	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_MAND | XTOPT_NBO | XTOPT_PUT, XTOPT_POINTER(s, lport)},
 	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_HOST,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, laddr)},
 	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 38c0e5e..f88813f 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -64,10 +64,9 @@ struct in_addr;
  * %XTTYPE_HOSTMASK:	one host or address, with an optional prefix length
  * 			(ptr: union nf_inet_addr; only host portion is stored)
  * %XTTYPE_PROTOCOL:	protocol number/name from /etc/protocols (ptr: uint8_t)
- * %XTTYPE_PORT:	16-bit port name or number
- * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
- * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
- * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
+ * %XTTYPE_PORT:	16-bit port name or number (supports %XTOPT_NBO)
+ * %XTTYPE_PORTRC:	colon-separated port range (names acceptable),
+ * 			(supports %XTOPT_NBO)
  * %XTTYPE_PLEN:	prefix length
  * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
  * %XTTYPE_ETHERMAC:	Ethernet MAC address in hex form
@@ -91,9 +90,7 @@ enum xt_option_type {
 	XTTYPE_HOSTMASK,
 	XTTYPE_PROTOCOL,
 	XTTYPE_PORT,
-	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
-	XTTYPE_PORTRC_NE,
 	XTTYPE_PLEN,
 	XTTYPE_PLENMASK,
 	XTTYPE_ETHERMAC,
@@ -104,12 +101,15 @@ enum xt_option_type {
  * %XTOPT_MAND:		option is mandatory
  * %XTOPT_MULTI:	option may be specified multiple times
  * %XTOPT_PUT:		store value into memory at @ptroff
+ * %XTOPT_NBO:		store value in network-byte order
+ * 			(only certain XTTYPEs recognize this)
  */
 enum xt_option_flags {
 	XTOPT_INVERT = 1 << 0,
 	XTOPT_MAND   = 1 << 1,
 	XTOPT_MULTI  = 1 << 2,
 	XTOPT_PUT    = 1 << 3,
+	XTOPT_NBO    = 1 << 4,
 };
 
 /**
diff --git a/xtoptions.c b/xtoptions.c
index eb9e4e6..3c3ce5f 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -509,6 +509,7 @@ static void xtopt_parse_protocol(struct xt_option_call *cb)
  */
 static void xtopt_parse_port(struct xt_option_call *cb)
 {
+	const struct xt_option_entry *entry = cb->entry;
 	int ret;
 
 	ret = xtables_getportbyname(cb->arg);
@@ -516,10 +517,10 @@ static void xtopt_parse_port(struct xt_option_call *cb)
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"Port \"%s\" does not resolve to anything.\n",
 			cb->arg);
+	if (entry->flags & XTOPT_NBO)
+		ret = htons(ret);
 	cb->val.port = ret;
-	if (cb->entry->type == XTTYPE_PORT_NE)
-		cb->val.port = htons(cb->val.port);
-	if (cb->entry->flags & XTOPT_PUT)
+	if (entry->flags & XTOPT_PUT)
 		*(uint16_t *)XTOPT_MKPTR(cb) = cb->val.port;
 }
 
@@ -561,7 +562,7 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"Port \"%s\" does not resolve to "
 				"anything.\n", arg);
-		if (entry->type == XTTYPE_PORTRC_NE)
+		if (entry->flags & XTOPT_NBO)
 			value = htons(value);
 		if (cb->nvals < ARRAY_SIZE(cb->val.port_range))
 			cb->val.port_range[cb->nvals] = value;
@@ -702,9 +703,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_HOSTMASK]    = xtopt_parse_hostmask,
 	[XTTYPE_PROTOCOL]    = xtopt_parse_protocol,
 	[XTTYPE_PORT]        = xtopt_parse_port,
-	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
-	[XTTYPE_PORTRC_NE]   = xtopt_parse_mport,
 	[XTTYPE_PLEN]        = xtopt_parse_plen,
 	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
 	[XTTYPE_ETHERMAC]    = xtopt_parse_ethermac,
@@ -730,9 +729,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
 	[XTTYPE_PROTOCOL]    = sizeof(uint8_t),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
-	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-	[XTTYPE_PORTRC_NE]   = sizeof(uint16_t[2]),
 	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
 	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
 };
-- 
1.7.3.4

