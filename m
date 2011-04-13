From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 24/26] libxtables: XTTYPE_PORT support
Date: Wed, 13 Apr 2011 18:13:45 +0200
Message-ID: <1302711228-15947-25-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42487 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab1DMQOQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:16 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    6 ++++-
 xtoptions.c          |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index d8a3124..a9a9ffa 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -53,6 +53,8 @@ struct in_addr;
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
  * %XTTYPE_ONEHOST:	one host or address (union nf_inet_addr)
+ * %XTTYPE_PORT:	16-bit port name or number
+ * %XTTYPE_PORT_NE:	16-bit port name or number, stored as network-endian
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -68,6 +70,8 @@ enum xt_option_type {
 	XTTYPE_MARKMASK32,
 	XTTYPE_SYSLOGLEVEL,
 	XTTYPE_ONEHOST,
+	XTTYPE_PORT,
+	XTTYPE_PORT_NE,
 };
 
 /**
@@ -123,7 +127,7 @@ struct xt_option_call {
 	uint8_t nvals;
 	union {
 		uint8_t u8, u8_range[2], syslog_level;
-		uint16_t u16, u16_range[2];
+		uint16_t u16, u16_range[2], port;
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		union nf_inet_addr inetaddr;
diff --git a/xtoptions.c b/xtoptions.c
index e0c3213..c3cc40e 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -354,6 +354,53 @@ static void xtopt_parse_onehost(struct xt_option_call *cb)
 		       sizeof(cb->val.inetaddr));
 }
 
+/**
+ * @name:	port name, or number as a string (e.g. "http" or "80")
+ *
+ * Resolve a port name to a number. Returns the port number in integral
+ * form on success, or <0 on error. (errno will not be set.)
+ */
+static int xtables_getportbyname(const char *name)
+{
+	struct addrinfo *res = NULL, *p;
+	int ret;
+
+	ret = getaddrinfo(NULL, name, NULL, &res);
+	if (ret < 0)
+		return -1;
+	ret = -1;
+	for (p = res; p != NULL; p = p->ai_next) {
+		if (p->ai_family == AF_INET6) {
+			ret = ((struct sockaddr_in6 *)p->ai_addr)->sin6_port;
+			break;
+		} else if (p->ai_family == AF_INET) {
+			ret = ((struct sockaddr_in *)p->ai_addr)->sin_port;
+			break;
+		}
+	}
+	freeaddrinfo(res);
+	return ntohs(ret);
+}
+
+/**
+ * Validate and parse a port specification and put the result into @cb.
+ */
+static void xtopt_parse_port(struct xt_option_call *cb)
+{
+	int ret;
+
+	ret = xtables_getportbyname(cb->arg);
+	if (ret < 0)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"Port \"%s\" does not resolve to anything.\n",
+			cb->arg);
+	cb->val.port = ret;
+	if (cb->entry->type == XTTYPE_PORT_NE)
+		cb->val.port = htons(cb->val.port);
+	if (cb->entry->flags & XTOPT_PUT)
+		*(uint16_t *)XTOPT_MKPTR(cb) = cb->val.port;
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -367,6 +414,8 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
 	[XTTYPE_ONEHOST]     = xtopt_parse_onehost,
+	[XTTYPE_PORT]        = xtopt_parse_port,
+	[XTTYPE_PORT_NE]     = xtopt_parse_port,
 };
 
 static const size_t xtopt_psize[] = {
@@ -381,6 +430,8 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 	[XTTYPE_ONEHOST]     = sizeof(union nf_inet_addr),
+	[XTTYPE_PORT]        = sizeof(uint16_t),
+	[XTTYPE_PORT_NE]     = sizeof(uint16_t),
 };
 
 /**
-- 
1.7.1

