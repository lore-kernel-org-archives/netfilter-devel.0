From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 23/26] libxtables: XTTYPE_ONEHOST support
Date: Wed, 13 Apr 2011 18:13:44 +0200
Message-ID: <1302711228-15947-24-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42482 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab1DMQOP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:15 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The bonus of the POSIX socket API is that it is almost protocol-agnostic
and that there are ready-made functions to take over the gist of address
parsing and packing.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 ++
 xtoptions.c          |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index afdac36..d8a3124 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -52,6 +52,7 @@ struct in_addr;
  * %XTTYPE_STRING:	arbitrary string
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
+ * %XTTYPE_ONEHOST:	one host or address (union nf_inet_addr)
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -66,6 +67,7 @@ enum xt_option_type {
 	XTTYPE_STRING,
 	XTTYPE_MARKMASK32,
 	XTTYPE_SYSLOGLEVEL,
+	XTTYPE_ONEHOST,
 };
 
 /**
@@ -124,6 +126,7 @@ struct xt_option_call {
 		uint16_t u16, u16_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
+		union nf_inet_addr inetaddr;
 		struct {
 			uint32_t mark, mask;
 		};
diff --git a/xtoptions.c b/xtoptions.c
index a6738c1..e0c3213 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -297,6 +297,63 @@ static void xtopt_parse_sysloglevel(struct xt_option_call *cb)
 		*(uint8_t *)XTOPT_MKPTR(cb) = num;
 }
 
+static void *xtables_sa_host(const void *sa, unsigned int afproto)
+{
+	if (afproto == AF_INET6)
+		return &((struct sockaddr_in6 *)sa)->sin6_addr;
+	else if (afproto == AF_INET)
+		return &((struct sockaddr_in *)sa)->sin_addr;
+	return (void *)sa;
+}
+
+static socklen_t xtables_sa_hostlen(unsigned int afproto)
+{
+	if (afproto == AF_INET6)
+		return sizeof(struct in6_addr);
+	else if (afproto == AF_INET)
+		return sizeof(struct in_addr);
+	return 0;
+}
+
+/**
+ * Accepts: a hostname (DNS), or a single inetaddr.
+ */
+static void xtopt_parse_onehost(struct xt_option_call *cb)
+{
+	struct addrinfo hints = {.ai_family = afinfo->family};
+	unsigned int adcount = 0;
+	struct addrinfo *res, *p;
+	int ret;
+
+	ret = getaddrinfo(cb->arg, NULL, &hints, &res);
+	if (ret < 0)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"getaddrinfo: %s\n", gai_strerror(ret));
+
+	for (p = res; p != NULL; p = p->ai_next) {
+		if (adcount == 0) {
+			memset(&cb->val.inetaddr, 0, sizeof(cb->val.inetaddr));
+			memcpy(&cb->val.inetaddr,
+			       xtables_sa_host(p->ai_addr, p->ai_family),
+			       xtables_sa_hostlen(p->ai_family));
+			++adcount;
+			continue;
+		}
+		if (memcmp(&cb->val.inetaddr,
+		    xtables_sa_host(p->ai_addr, p->ai_family),
+		    xtables_sa_hostlen(p->ai_family)) != 0)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"%s resolves to more than one address\n",
+				cb->arg);
+	}
+
+	freeaddrinfo(res);
+	if (cb->entry->flags & XTOPT_PUT)
+		/* Validation in xtables_option_metavalidate */
+		memcpy(XTOPT_MKPTR(cb), &cb->val.inetaddr,
+		       sizeof(cb->val.inetaddr));
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -309,6 +366,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
+	[XTTYPE_ONEHOST]     = xtopt_parse_onehost,
 };
 
 static const size_t xtopt_psize[] = {
@@ -322,6 +380,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
+	[XTTYPE_ONEHOST]     = sizeof(union nf_inet_addr),
 };
 
 /**
-- 
1.7.1

