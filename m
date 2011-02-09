From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/11] src: deduplicate find_proto function
Date: Wed,  9 Feb 2011 02:48:49 +0100
Message-ID: <1297216137-18505-5-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38717 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab1BIBtG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:06 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   36 ------------------------------------
 iptables.c  |   35 -----------------------------------
 xshared.c   |   37 +++++++++++++++++++++++++++++++++++++
 xshared.h   |    4 ++++
 4 files changed, 41 insertions(+), 71 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index dac0c52..ac376e2 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -205,24 +205,6 @@ struct pprot {
 	uint8_t num;
 };
 
-static const char *
-proto_to_name(uint8_t proto, int nolookup)
-{
-	unsigned int i;
-
-	if (proto && !nolookup) {
-		const struct protoent *pent = getprotobynumber(proto);
-		if (pent)
-			return pent->p_name;
-	}
-
-	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
-		if (xtables_chain_protos[i].num == proto)
-			return xtables_chain_protos[i].name;
-
-	return NULL;
-}
-
 static void __attribute__((noreturn))
 exit_tryhelp(int status)
 {
@@ -406,24 +388,6 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
  *	return global static data.
 */
 
-/* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
-static struct xtables_match *
-find_proto(const char *pname, enum xtables_tryload tryload,
-	   int nolookup, struct xtables_rule_match **matches)
-{
-	unsigned int proto;
-
-	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
-		const char *protoname = proto_to_name(proto, nolookup);
-
-		if (protoname)
-			return xtables_find_match(protoname, tryload, matches);
-	} else
-		return xtables_find_match(pname, tryload, matches);
-
-	return NULL;
-}
-
 /* These are invalid numbers as upper layer protocol */
 static int is_exthdr(uint16_t proto)
 {
diff --git a/iptables.c b/iptables.c
index 6881981..9d4f10c 100644
--- a/iptables.c
+++ b/iptables.c
@@ -213,24 +213,6 @@ int kernel_version;
 #endif
 #endif
 
-static const char *
-proto_to_name(uint8_t proto, int nolookup)
-{
-	unsigned int i;
-
-	if (proto && !nolookup) {
-		struct protoent *pent = getprotobynumber(proto);
-		if (pent)
-			return pent->p_name;
-	}
-
-	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
-		if (xtables_chain_protos[i].num == proto)
-			return xtables_chain_protos[i].name;
-
-	return NULL;
-}
-
 enum {
 	IPT_DOTTED_ADDR = 0,
 	IPT_DOTTED_MASK
@@ -420,23 +402,6 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 */
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
-static struct xtables_match *
-find_proto(const char *pname, enum xtables_tryload tryload,
-	   int nolookup, struct xtables_rule_match **matches)
-{
-	unsigned int proto;
-
-	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
-		const char *protoname = proto_to_name(proto, nolookup);
-
-		if (protoname)
-			return xtables_find_match(protoname, tryload, matches);
-	} else
-		return xtables_find_match(pname, tryload, matches);
-
-	return NULL;
-}
-
 /* Can't be zero. */
 static int
 parse_rulenumber(const char *rule)
diff --git a/xshared.c b/xshared.c
index 21b5b2c..40b6b56 100644
--- a/xshared.c
+++ b/xshared.c
@@ -1,3 +1,5 @@
+#include <netdb.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <xtables.h>
 #include "xshared.h"
@@ -29,3 +31,38 @@ void print_extension_helps(const struct xtables_target *t,
 			m->match->help();
 	}
 }
+
+const char *
+proto_to_name(uint8_t proto, int nolookup)
+{
+	unsigned int i;
+
+	if (proto && !nolookup) {
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent)
+			return pent->p_name;
+	}
+
+	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+		if (xtables_chain_protos[i].num == proto)
+			return xtables_chain_protos[i].name;
+
+	return NULL;
+}
+
+struct xtables_match *
+find_proto(const char *pname, enum xtables_tryload tryload,
+	   int nolookup, struct xtables_rule_match **matches)
+{
+	unsigned int proto;
+
+	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
+		const char *protoname = proto_to_name(proto, nolookup);
+
+		if (protoname)
+			return xtables_find_match(protoname, tryload, matches);
+	} else
+		return xtables_find_match(pname, tryload, matches);
+
+	return NULL;
+}
diff --git a/xshared.h b/xshared.h
index 4a7f96f..11d95fe 100644
--- a/xshared.h
+++ b/xshared.h
@@ -1,6 +1,7 @@
 #ifndef IPTABLES_XSHARED_H
 #define IPTABLES_XSHARED_H 1
 
+#include <stdint.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
@@ -28,5 +29,8 @@ enum {
 
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
+extern const char *proto_to_name(uint8_t, int);
+extern struct xtables_match *find_proto(const char *, enum xtables_tryload,
+	int, struct xtables_rule_match **);
 
 #endif /* IPTABLES_XSHARED_H */
-- 
1.7.1

