From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/17] libxtables: do not overlay addr and mask parts, and cleanup
Date: Mon,  9 May 2011 21:54:58 +0200
Message-ID: <1304970912-11520-5-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49337 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1EITzV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:21 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

XTTYPE_HOSTMASK will require that what has now become haddr,
hmask/hlen are not overlays of another. Thus relax the structure and
always set all members of the {haddr, hmask, hlen} triplet now for all
types that touch any of the members.

Add some more comments and clean out ONEHOST.
---
 extensions/libxt_TEE.c    |    2 +-
 extensions/libxt_TPROXY.c |    6 ++--
 include/xtables.h.in      |   17 +++++++++++---
 xtoptions.c               |   50 +++++++++++++++++++++++++++-----------------
 4 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index fd9a1b2..c89e580 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -31,7 +31,7 @@ enum {
 
 #define s struct xt_tee_tginfo
 static const struct xt_option_entry tee_tg_opts[] = {
-	{.name = "gateway", .id = O_GATEWAY, .type = XTTYPE_ONEHOST,
+	{.name = "gateway", .id = O_GATEWAY, .type = XTTYPE_HOST,
 	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, gw)},
 	{.name = "oif", .id = O_OIF, .type = XTTYPE_STRING,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, oif)},
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 5264ea7..61646c9 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -22,7 +22,7 @@ enum {
 static const struct xt_option_entry tproxy_tg0_opts[] = {
 	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
 	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
-	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_ONEHOST},
+	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_HOST},
 	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
 	XTOPT_TABLEEND,
 };
@@ -31,7 +31,7 @@ static const struct xt_option_entry tproxy_tg0_opts[] = {
 static const struct xt_option_entry tproxy_tg1_opts[] = {
 	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
 	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
-	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_ONEHOST,
+	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_HOST,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, laddr)},
 	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
 	XTOPT_TABLEEND,
@@ -129,7 +129,7 @@ static void tproxy_tg0_parse(struct xt_option_call *cb)
 		info->mark_mask  = cb->val.mask;
 		break;
 	case P_ADDR:
-		info->laddr = cb->val.inetaddr.ip;
+		info->laddr = cb->val.haddr.ip;
 		break;
 	}
 }
diff --git a/include/xtables.h.in b/include/xtables.h.in
index a760755..c9ad523 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -46,6 +46,12 @@ struct in_addr;
 #define XTOPT_TABLEEND {.name = NULL}
 
 /**
+ * Select the format the input has to conform to, as well as the target type
+ * (area pointed to with XTOPT_POINTER). Note that the storing is not always
+ * uniform. @cb->val will be populated with as much as there is space, i.e.
+ * exactly 2 items for ranges, but the target area can receive more values
+ * (e.g. in case of ranges), or less values (e.g. %XTTYPE_HOSTMASK).
+ *
  * %XTTYPE_NONE:	option takes no argument
  * %XTTYPE_UINT*:	standard integer
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
@@ -54,12 +60,12 @@ struct in_addr;
  * %XTTYPE_TOSMASK:	8-bit TOS value with optional mask
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
- * %XTTYPE_ONEHOST:	one host or address (union nf_inet_addr)
+ * %XTTYPE_HOST:	one host or address (ptr: union nf_inet_addr)
  * %XTTYPE_PORT:	16-bit port name or number
  * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  * %XTTYPE_PORTRC:	colon-separated port range (names acceptable)
  * %XTTYPE_PORTRC_NE:	same as %XTTYPE_PORTRC, stored in network-endian
- * %XTTYPE_PLENMASK:	prefix len stored as union nf_inet_addr
+ * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -76,7 +82,7 @@ enum xt_option_type {
 	XTTYPE_TOSMASK,
 	XTTYPE_MARKMASK32,
 	XTTYPE_SYSLOGLEVEL,
-	XTTYPE_ONEHOST,
+	XTTYPE_HOST,
 	XTTYPE_PORT,
 	XTTYPE_PORT_NE,
 	XTTYPE_PORTRC,
@@ -141,7 +147,10 @@ struct xt_option_call {
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		double dbl;
-		union nf_inet_addr inetaddr, inetmask;
+		struct {
+			union nf_inet_addr haddr, hmask;
+			uint8_t hlen;
+		};
 		struct {
 			uint8_t tos_value, tos_mask;
 		};
diff --git a/xtoptions.c b/xtoptions.c
index 2bd66f9..f8031bb 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -419,9 +419,11 @@ static socklen_t xtables_sa_hostlen(unsigned int afproto)
 }
 
 /**
- * Accepts: a hostname (DNS), or a single inetaddr.
+ * Accepts: a hostname (DNS), or a single inetaddr - without any mask. The
+ * result is stored in @cb->val.haddr. Additionally, @cb->val.hmask and
+ * @cb->val.hlen are set for completeness to the appropriate values.
  */
-static void xtopt_parse_onehost(struct xt_option_call *cb)
+static void xtopt_parse_host(struct xt_option_call *cb)
 {
 	struct addrinfo hints = {.ai_family = afinfo->family};
 	unsigned int adcount = 0;
@@ -433,16 +435,19 @@ static void xtopt_parse_onehost(struct xt_option_call *cb)
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"getaddrinfo: %s\n", gai_strerror(ret));
 
+	memset(&cb->val.hmask, 0xFF, sizeof(cb->val.hmask));
+	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
+
 	for (p = res; p != NULL; p = p->ai_next) {
 		if (adcount == 0) {
-			memset(&cb->val.inetaddr, 0, sizeof(cb->val.inetaddr));
-			memcpy(&cb->val.inetaddr,
+			memset(&cb->val.haddr, 0, sizeof(cb->val.haddr));
+			memcpy(&cb->val.haddr,
 			       xtables_sa_host(p->ai_addr, p->ai_family),
 			       xtables_sa_hostlen(p->ai_family));
 			++adcount;
 			continue;
 		}
-		if (memcmp(&cb->val.inetaddr,
+		if (memcmp(&cb->val.haddr,
 		    xtables_sa_host(p->ai_addr, p->ai_family),
 		    xtables_sa_hostlen(p->ai_family)) != 0)
 			xt_params->exit_err(PARAMETER_PROBLEM,
@@ -453,8 +458,8 @@ static void xtopt_parse_onehost(struct xt_option_call *cb)
 	freeaddrinfo(res);
 	if (cb->entry->flags & XTOPT_PUT)
 		/* Validation in xtables_option_metavalidate */
-		memcpy(XTOPT_MKPTR(cb), &cb->val.inetaddr,
-		       sizeof(cb->val.inetaddr));
+		memcpy(XTOPT_MKPTR(cb), &cb->val.haddr,
+		       sizeof(cb->val.haddr));
 }
 
 /**
@@ -488,7 +493,8 @@ static int xtables_getportbyname(const char *name)
 }
 
 /**
- * Validate and parse a port specification and put the result into @cb.
+ * Validate and parse a port specification and put the result into
+ * @cb->val.port.
  */
 static void xtopt_parse_port(struct xt_option_call *cb)
 {
@@ -561,25 +567,27 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 	free(lo_arg);
 }
 
+/**
+ * Parse an integer and ensure it is within the address family's prefix length
+ * limits. The result is stored in @cb->val.hmask and @cb->val.hlen. If
+ * %XTOPT_PUT is used, hmask will be copied to the pointed-to area.
+ */
 static void xtopt_parse_plenmask(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
-	uint32_t *mask = cb->val.inetmask.all;
+	uint32_t *mask = cb->val.hmask.all;
 	unsigned int prefix_len = 128;
-	uint8_t max = 128;
 
-	if (afinfo->family == NFPROTO_IPV6)
-		max = 128;
-	else if (afinfo->family == NFPROTO_IPV4)
-		max = 32;
-
-	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, max))
+	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
+	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, cb->val.hlen))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
 			"or out of range (%u-%u).\n",
-			cb->ext_name, entry->name, 0, max);
+			cb->ext_name, entry->name, 0, cb->val.hlen);
 
+	cb->val.hlen = prefix_len;
 	memset(mask, 0xFF, sizeof(union nf_inet_addr));
+	/* This shifting is AF-independent. */
 	if (prefix_len == 0) {
 		mask[0] = mask[1] = mask[2] = mask[3] = 0;
 	} else if (prefix_len <= 32) {
@@ -616,7 +624,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_TOSMASK]     = xtopt_parse_tosmask,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
-	[XTTYPE_ONEHOST]     = xtopt_parse_onehost,
+	[XTTYPE_HOST]        = xtopt_parse_host,
 	[XTTYPE_PORT]        = xtopt_parse_port,
 	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 	[XTTYPE_PORTRC]      = xtopt_parse_mport,
@@ -625,6 +633,10 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 };
 
 static const size_t xtopt_psize[] = {
+	/*
+	 * All types not listed here, and thus essentially being initialized to
+	 * zero have zero on purpose.
+	 */
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT16]      = sizeof(uint16_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
@@ -636,7 +648,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_DOUBLE]      = sizeof(double),
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
-	[XTTYPE_ONEHOST]     = sizeof(union nf_inet_addr),
+	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
 	[XTTYPE_PORT]        = sizeof(uint16_t),
 	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-- 
1.7.1

