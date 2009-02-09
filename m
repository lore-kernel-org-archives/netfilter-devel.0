From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/16] libxtables: prefix/order - move parse_protocol to xtables.c
Date: Mon,  9 Feb 2009 18:34:59 +0100
Message-ID: <1234200900-5964-16-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51466 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZBIRfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:06 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c  |    2 +-
 extensions/libipt_policy.c   |    2 +-
 extensions/libxt_conntrack.c |    5 +-
 extensions/libxt_time.c      |    1 -
 include/xtables.h.in         |   21 +++++++++-
 ip6tables.c                  |   84 +++++-------------------------------------
 iptables.c                   |   75 +++++--------------------------------
 xtables.c                    |   52 ++++++++++++++++++++++++++
 8 files changed, 96 insertions(+), 146 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 83ee48e..7c1a1e7 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -244,7 +244,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
 
-		e->proto = parse_protocol(argv[optind-1]);
+		e->proto = xtables_parse_protocol(argv[optind-1]);
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 742eeba..6ae51e7 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -212,7 +212,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
 
-		e->proto = parse_protocol(argv[optind-1]);
+		e->proto = xtables_parse_protocol(argv[optind-1]);
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 914b253..45783f4 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -317,7 +317,8 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 			*protocol = tolower(*protocol);
 
 		protocol = argv[optind-1];
-		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = parse_protocol(protocol);
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum =
+			xtables_parse_protocol(protocol);
 
 		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
 		    && (sinfo->invflags & XT_INV_PROTO))
@@ -455,7 +456,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		/* Canonicalize into lower case */
 		for (p = optarg; *p != '\0'; ++p)
 			*p = tolower(*p);
-		info->l4proto = parse_protocol(optarg);
+		info->l4proto = xtables_parse_protocol(optarg);
 
 		if (info->l4proto == 0 && (info->invert_flags & XT_INV_PROTO))
 			exit_error(PARAMETER_PROBLEM, "conntrack: rule would "
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 989806d..41aa5c7 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -22,7 +22,6 @@
 
 #include <linux/netfilter/xt_time.h>
 #include <xtables.h>
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*x))
 
 enum { /* getopt "seen" bits */
 	F_DATE_START = 1 << 0,
diff --git a/include/xtables.h.in b/include/xtables.h.in
index c1bf6d5..07217d6 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -21,6 +21,9 @@
 #ifndef IPPROTO_DCCP
 #define IPPROTO_DCCP 33
 #endif
+#ifndef IPPROTO_MH
+#	define IPPROTO_MH 135
+#endif
 #ifndef IPPROTO_UDPLITE
 #define IPPROTO_UDPLITE	136
 #endif
@@ -151,6 +154,17 @@ struct xtables_rule_match {
 	bool completed;
 };
 
+/**
+ * struct xtables_pprot -
+ *
+ * A few hardcoded protocols for 'all' and in case the user has no
+ * /etc/protocols.
+ */
+struct xtables_pprot {
+	const char *name;
+	u_int8_t num;
+};
+
 enum xtables_tryload {
 	XTF_DONT_LOAD,
 	XTF_DURING_LOAD,
@@ -239,10 +253,13 @@ extern void xtables_save_string(const char *value);
 #	define _init __attribute__((constructor)) _INIT
 #endif
 
-/* Present in both iptables.c and ip6tables.c */
-extern u_int16_t parse_protocol(const char *s);
+extern const struct xtables_pprot xtables_chain_protos[];
+extern u_int16_t xtables_parse_protocol(const char *s);
 
 #ifdef XTABLES_INTERNAL
+#	ifndef ARRAY_SIZE
+#		define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+#	endif
 #	include <xtables/internal.h>
 #endif
 
diff --git a/ip6tables.c b/ip6tables.c
index 903e005..53163b7 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -208,34 +208,7 @@ struct afinfo afinfo = {
 	.so_rev_target	= IP6T_SO_GET_REVISION_TARGET,
 };
 
-/* Primitive headers... */
-/* defined in netinet/in.h */
-#if 0
-#ifndef IPPROTO_ESP
-#define IPPROTO_ESP 50
-#endif
-#ifndef IPPROTO_AH
-#define IPPROTO_AH 51
-#endif
-#endif
-#ifndef IPPROTO_MH
-#define IPPROTO_MH 135
-#endif
-
-static const struct pprot chain_protos[] = {
-	{ "tcp", IPPROTO_TCP },
-	{ "udp", IPPROTO_UDP },
-	{ "udplite", IPPROTO_UDPLITE },
-	{ "icmpv6", IPPROTO_ICMPV6 },
-	{ "ipv6-icmp", IPPROTO_ICMPV6 },
-	{ "esp", IPPROTO_ESP },
-	{ "ah", IPPROTO_AH },
-	{ "ipv6-mh", IPPROTO_MH },
-	{ "mh", IPPROTO_MH },
-	{ "all", 0 },
-};
-
-static char *
+static const char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
 	unsigned int i;
@@ -246,9 +219,9 @@ proto_to_name(u_int8_t proto, int nolookup)
 			return pent->p_name;
 	}
 
-	for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-		if (chain_protos[i].num == proto)
-			return chain_protos[i].name;
+	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+		if (xtables_chain_protos[i].num == proto)
+			return xtables_chain_protos[i].name;
 
 	return NULL;
 }
@@ -467,7 +440,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 	unsigned int proto;
 
 	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
-		char *protoname = proto_to_name(proto, nolookup);
+		const char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
 			return xtables_find_match(protoname, tryload, matches);
@@ -477,43 +450,6 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 	return NULL;
 }
 
-u_int16_t
-parse_protocol(const char *s)
-{
-	unsigned int proto;
-
-	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
-		struct protoent *pent;
-
-		/* first deal with the special case of 'all' to prevent
-		 * people from being able to redefine 'all' in nsswitch
-		 * and/or provoke expensive [not working] ldap/nis/...
-		 * lookups */
-		if (!strcmp(s, "all"))
-			return 0;
-
-		if ((pent = getprotobyname(s)))
-			proto = pent->p_proto;
-		else {
-			unsigned int i;
-			for (i = 0;
-			     i < sizeof(chain_protos)/sizeof(struct pprot);
-			     i++) {
-				if (strcmp(s, chain_protos[i].name) == 0) {
-					proto = chain_protos[i].num;
-					break;
-				}
-			}
-			if (i == sizeof(chain_protos)/sizeof(struct pprot))
-				exit_error(PARAMETER_PROBLEM,
-					   "unknown protocol `%s' specified",
-					   s);
-		}
-	}
-
-	return (u_int16_t)proto;
-}
-
 /* These are invalid numbers as upper layer protocol */
 static int is_exthdr(u_int16_t proto)
 {
@@ -738,7 +674,7 @@ print_firewall(const struct ip6t_entry *fw,
 
 	fputc(fw->ipv6.invflags & IP6T_INV_PROTO ? '!' : ' ', stdout);
 	{
-		char *pname = proto_to_name(fw->ipv6.proto, format&FMT_NUMERIC);
+		const char *pname = proto_to_name(fw->ipv6.proto, format&FMT_NUMERIC);
 		if (pname)
 			printf(FMT("%-5s", "%s "), pname);
 		else
@@ -1144,10 +1080,10 @@ static void print_proto(u_int16_t proto, int invert)
 			return;
 		}
 
-		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-			if (chain_protos[i].num == proto) {
+		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+			if (xtables_chain_protos[i].num == proto) {
 				printf("-p %s%s ",
-				       invertstr, chain_protos[i].name);
+				       invertstr, xtables_chain_protos[i].name);
 				return;
 			}
 
@@ -1607,7 +1543,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				*protocol = tolower(*protocol);
 
 			protocol = argv[optind-1];
-			fw.ipv6.proto = parse_protocol(protocol);
+			fw.ipv6.proto = xtables_parse_protocol(protocol);
 			fw.ipv6.flags |= IP6T_F_PROTO;
 
 			if (fw.ipv6.proto == 0
diff --git a/iptables.c b/iptables.c
index ea765b0..b43aadf 100644
--- a/iptables.c
+++ b/iptables.c
@@ -194,13 +194,6 @@ const char *program_name;
 
 int kernel_version;
 
-/* A few hardcoded protocols for 'all' and in case the user has no
-   /etc/protocols */
-struct pprot {
-	char *name;
-	u_int8_t num;
-};
-
 struct afinfo afinfo = {
 	.family		= NFPROTO_IPV4,
 	.libprefix	= "libipt_",
@@ -221,18 +214,7 @@ struct afinfo afinfo = {
 #endif
 #endif
 
-static const struct pprot chain_protos[] = {
-	{ "tcp", IPPROTO_TCP },
-	{ "udp", IPPROTO_UDP },
-	{ "udplite", IPPROTO_UDPLITE },
-	{ "icmp", IPPROTO_ICMP },
-	{ "esp", IPPROTO_ESP },
-	{ "ah", IPPROTO_AH },
-	{ "sctp", IPPROTO_SCTP },
-	{ "all", 0 },
-};
-
-static char *
+static const char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
 	unsigned int i;
@@ -243,9 +225,9 @@ proto_to_name(u_int8_t proto, int nolookup)
 			return pent->p_name;
 	}
 
-	for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-		if (chain_protos[i].num == proto)
-			return chain_protos[i].name;
+	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+		if (xtables_chain_protos[i].num == proto)
+			return xtables_chain_protos[i].name;
 
 	return NULL;
 }
@@ -469,7 +451,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 	unsigned int proto;
 
 	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
-		char *protoname = proto_to_name(proto, nolookup);
+		const char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
 			return xtables_find_match(protoname, tryload, matches);
@@ -479,43 +461,6 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 	return NULL;
 }
 
-u_int16_t
-parse_protocol(const char *s)
-{
-	unsigned int proto;
-
-	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
-		struct protoent *pent;
-
-		/* first deal with the special case of 'all' to prevent
-		 * people from being able to redefine 'all' in nsswitch
-		 * and/or provoke expensive [not working] ldap/nis/... 
-		 * lookups */
-		if (!strcmp(s, "all"))
-			return 0;
-
-		if ((pent = getprotobyname(s)))
-			proto = pent->p_proto;
-		else {
-			unsigned int i;
-			for (i = 0;
-			     i < sizeof(chain_protos)/sizeof(struct pprot);
-			     i++) {
-				if (strcmp(s, chain_protos[i].name) == 0) {
-					proto = chain_protos[i].num;
-					break;
-				}
-			}
-			if (i == sizeof(chain_protos)/sizeof(struct pprot))
-				exit_error(PARAMETER_PROBLEM,
-					   "unknown protocol `%s' specified",
-					   s);
-		}
-	}
-
-	return (u_int16_t)proto;
-}
-
 /* Can't be zero. */
 static int
 parse_rulenumber(const char *rule)
@@ -733,7 +678,7 @@ print_firewall(const struct ipt_entry *fw,
 
 	fputc(fw->ip.invflags & IPT_INV_PROTO ? '!' : ' ', stdout);
 	{
-		char *pname = proto_to_name(fw->ip.proto, format&FMT_NUMERIC);
+		const char *pname = proto_to_name(fw->ip.proto, format&FMT_NUMERIC);
 		if (pname)
 			printf(FMT("%-5s", "%s "), pname);
 		else
@@ -1107,10 +1052,10 @@ static void print_proto(u_int16_t proto, int invert)
 			return;
 		}
 
-		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-			if (chain_protos[i].num == proto) {
+		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+			if (xtables_chain_protos[i].num == proto) {
 				printf("-p %s%s ",
-				       invertstr, chain_protos[i].name);
+				       invertstr, xtables_chain_protos[i].name);
 				return;
 			}
 
@@ -1620,7 +1565,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				*protocol = tolower(*protocol);
 
 			protocol = argv[optind-1];
-			fw.ip.proto = parse_protocol(protocol);
+			fw.ip.proto = xtables_parse_protocol(protocol);
 
 			if (fw.ip.proto == 0
 			    && (fw.ip.invflags & IPT_INV_PROTO))
diff --git a/xtables.c b/xtables.c
index 19e746c..cf64352 100644
--- a/xtables.c
+++ b/xtables.c
@@ -32,6 +32,7 @@
 #include <arpa/inet.h>
 
 #include <xtables.h>
+#include <ip6tables.h>
 #include <libiptc/libxtc.h>
 
 #ifndef NO_SHARED_LIBS
@@ -1285,3 +1286,54 @@ int xtables_check_inverse(const char option[], int *invert,
 	}
 	return false;
 }
+
+const struct xtables_pprot xtables_chain_protos[] = {
+	{"tcp",       IPPROTO_TCP},
+	{"sctp",      IPPROTO_SCTP},
+	{"udp",       IPPROTO_UDP},
+	{"udplite",   IPPROTO_UDPLITE},
+	{"icmp",      IPPROTO_ICMP},
+	{"icmpv6",    IPPROTO_ICMPV6},
+	{"ipv6-icmp", IPPROTO_ICMPV6},
+	{"esp",       IPPROTO_ESP},
+	{"ah",        IPPROTO_AH},
+	{"ipv6-mh",   IPPROTO_MH},
+	{"mh",        IPPROTO_MH},
+	{"all",       0},
+	{NULL},
+};
+
+u_int16_t
+xtables_parse_protocol(const char *s)
+{
+	unsigned int proto;
+
+	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
+		struct protoent *pent;
+
+		/* first deal with the special case of 'all' to prevent
+		 * people from being able to redefine 'all' in nsswitch
+		 * and/or provoke expensive [not working] ldap/nis/...
+		 * lookups */
+		if (!strcmp(s, "all"))
+			return 0;
+
+		if ((pent = getprotobyname(s)))
+			proto = pent->p_proto;
+		else {
+			unsigned int i;
+			for (i = 0; i < ARRAY_SIZE(xtables_chain_protos); ++i) {
+				if (strcmp(s, xtables_chain_protos[i].name) == 0) {
+					proto = xtables_chain_protos[i].num;
+					break;
+				}
+			}
+			if (i == ARRAY_SIZE(xtables_chain_protos))
+				exit_error(PARAMETER_PROBLEM,
+					   "unknown protocol `%s' specified",
+					   s);
+		}
+	}
+
+	return proto;
+}
-- 
1.6.1.2

