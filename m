From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/13] extensions: const annotations
Date: Mon,  9 May 2011 11:37:05 +0200
Message-ID: <1304933832-16412-8-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51677 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1EIJhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:23 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ipv6header.c |    6 +++---
 extensions/libip6t_rt.c         |    4 ++--
 extensions/libxt_dccp.c         |    6 +++---
 extensions/libxt_multiport.c    |   10 +++++-----
 extensions/libxt_policy.c       |    4 ++--
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_tcp.c          |    6 +++---
 extensions/libxt_udp.c          |    6 +++---
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index fca6f32..00d5d5b 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -61,13 +61,13 @@ static const struct numflag chain_flags[] = {
 	{ IPPROTO_RAW, MASK_PROTO },
 };
 
-static char *
+static const char *
 proto_to_name(uint8_t proto, int nolookup)
 {
         unsigned int i;
 
         if (proto && !nolookup) {
-                struct protoent *pent = getprotobynumber(proto);
+		const struct protoent *pent = getprotobynumber(proto);
                 if (pent)
                         return pent->p_name;
         }
@@ -83,7 +83,7 @@ static uint16_t
 name_to_proto(const char *s)
 {
         unsigned int proto=0;
-        struct protoent *pent;
+	const struct protoent *pent;
 
         if ((pent = getprotobyname(s)))
         	proto = pent->p_proto;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 333350d..1c57dbd 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -81,11 +81,11 @@ parse_rt_segsleft(const char *idstring, uint32_t *ids)
 	free(buffer);
 }
 
-static char *
+static const char *
 addr_to_numeric(const struct in6_addr *addrp)
 {
 	static char buf[50+1];
-	return (char *)inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
+	return inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
 }
 
 static struct in6_addr *
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 5aff262..28c59b9 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -126,10 +126,10 @@ static void dccp_parse(struct xt_option_call *cb)
 	}
 }
 
-static char *
+static const char *
 port_to_service(int port)
 {
-	struct servent *service;
+	const struct servent *service;
 
 	if ((service = getservbyport(htons(port), "dccp")))
 		return service->s_name;
@@ -140,7 +140,7 @@ port_to_service(int port)
 static void
 print_port(uint16_t port, int numeric)
 {
-	char *service;
+	const char *service;
 
 	if (numeric || (service = port_to_service(port)) == NULL)
 		printf("%u", port);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 163c7dc..7fa537e 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -53,7 +53,7 @@ static const struct option multiport_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static char *
+static const char *
 proto_to_name(uint8_t proto)
 {
 	switch (proto) {
@@ -135,7 +135,7 @@ parse_multi_ports_v1(const char *portstring,
 static const char *
 check_proto(uint16_t pnum, uint8_t invflags)
 {
-	char *proto;
+	const char *proto;
 
 	if (invflags & XT_INV_PROTO)
 		xtables_error(PARAMETER_PROBLEM,
@@ -285,10 +285,10 @@ static void multiport_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, "multiport expection an option");
 }
 
-static char *
+static const char *
 port_to_service(int port, uint8_t proto)
 {
-	struct servent *service;
+	const struct servent *service;
 
 	if ((service = getservbyport(htons(port), proto_to_name(proto))))
 		return service->s_name;
@@ -299,7 +299,7 @@ port_to_service(int port, uint8_t proto)
 static void
 print_port(uint16_t port, uint8_t protocol, int numeric)
 {
-	char *service;
+	const char *service;
 
 	if (numeric || (service = port_to_service(port, protocol)) == NULL)
 		printf("%u", port);
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 646d333..16e8c53 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -347,7 +347,7 @@ static void print_mode(const char *prefix, uint8_t mode, int numeric)
 
 static void print_proto(const char *prefix, uint8_t proto, int numeric)
 {
-	struct protoent *p = NULL;
+	const struct protoent *p = NULL;
 
 	printf(" %sproto ", prefix);
 	if (!numeric)
@@ -407,7 +407,7 @@ static void print_entry(const char *prefix, const struct xt_policy_elem *e,
 	}
 }
 
-static void print_flags(char *prefix, const struct xt_policy_info *info)
+static void print_flags(const char *prefix, const struct xt_policy_info *info)
 {
 	if (info->flags & XT_POLICY_MATCH_IN)
 		printf(" %sdir in", prefix);
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index d3379d3..5dbc36f 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -298,10 +298,10 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static char *
+static const char *
 port_to_service(int port)
 {
-	struct servent *service;
+	const struct servent *service;
 
 	if ((service = getservbyport(htons(port), "sctp")))
 		return service->s_name;
@@ -312,7 +312,7 @@ port_to_service(int port)
 static void
 print_port(uint16_t port, int numeric)
 {
-	char *service;
+	const char *service;
 
 	if (numeric || (service = port_to_service(port)) == NULL)
 		printf("%u", port);
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index d9bcbd0..4d914e3 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -208,10 +208,10 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static char *
+static const char *
 port_to_service(int port)
 {
-	struct servent *service;
+	const struct servent *service;
 
 	if ((service = getservbyport(htons(port), "tcp")))
 		return service->s_name;
@@ -222,7 +222,7 @@ port_to_service(int port)
 static void
 print_port(uint16_t port, int numeric)
 {
-	char *service;
+	const char *service;
 
 	if (numeric || (service = port_to_service(port)) == NULL)
 		printf("%u", port);
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index d493072..b9f39ee 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -60,10 +60,10 @@ static void udp_parse(struct xt_option_call *cb)
 	}
 }
 
-static char *
+static const char *
 port_to_service(int port)
 {
-	struct servent *service;
+	const struct servent *service;
 
 	if ((service = getservbyport(htons(port), "udp")))
 		return service->s_name;
@@ -74,7 +74,7 @@ port_to_service(int port)
 static void
 print_port(uint16_t port, int numeric)
 {
-	char *service;
+	const char *service;
 
 	if (numeric || (service = port_to_service(port)) == NULL)
 		printf("%u", port);
-- 
1.7.1

