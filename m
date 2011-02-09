From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/11] src: deduplicate and simplify implicit protocol extension loading
Date: Wed,  9 Feb 2011 02:48:52 +0100
Message-ID: <1297216137-18505-8-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38729 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab1BIBtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:09 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   34 +---------------------------------
 iptables.c  |   34 +---------------------------------
 xshared.c   |   35 ++++++++++++++++++++++++++++++++++-
 xshared.h   |    3 +--
 4 files changed, 37 insertions(+), 69 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 7f8a8df..3330420 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1268,39 +1268,7 @@ static void command_default(struct iptables_command_state *cs)
 		}
 		m = matchp ? matchp->match : NULL;
 
-		/* If you listen carefully, you can
-		   actually hear this code suck. */
-
-		/* some explanations (after four different bugs
-		 * in 3 different releases): If we encounter a
-		 * parameter, that has not been parsed yet,
-		 * it's not an option of an explicitly loaded
-		 * match or a target.  However, we support
-		 * implicit loading of the protocol match
-		 * extension.  '-p tcp' means 'l4 proto 6' and
-		 * at the same time 'load tcp protocol match on
-		 * demand if we specify --dport'.
-		 *
-		 * To make this work, we need to make sure:
-		 * - the parameter has not been parsed by
-		 *   a match (m above)
-		 * - a protocol has been specified
-		 * - the protocol extension has not been
-		 *   loaded yet, or is loaded and unused
-		 *   [think of ip6tables-restore!]
-		 * - the protocol extension can be successively
-		 *   loaded
-		 */
-		if (m == NULL
-		    && cs->protocol
-		    && (!find_proto(cs->protocol, XTF_DONT_LOAD,
-				   cs->options&OPT_NUMERIC, NULL)
-			|| (find_proto(cs->protocol, XTF_DONT_LOAD,
-					cs->options&OPT_NUMERIC, NULL)
-			    && (cs->proto_used == 0))
-		       )
-		    && (m = find_proto(cs->protocol, XTF_TRY_LOAD,
-				       cs->options&OPT_NUMERIC, &cs->matches))) {
+		if (m == NULL && (m = load_proto(cs)) != NULL) {
 			/* Try loading protocol */
 			size_t size;
 
diff --git a/iptables.c b/iptables.c
index 0de656e..bae14af 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1292,39 +1292,7 @@ static void command_default(struct iptables_command_state *cs)
 		}
 		m = matchp ? matchp->match : NULL;
 
-		/* If you listen carefully, you can
-		   actually hear this code suck. */
-
-		/* some explanations (after four different bugs
-		 * in 3 different releases): If we encounter a
-		 * parameter, that has not been parsed yet,
-		 * it's not an option of an explicitly loaded
-		 * match or a target.  However, we support
-		 * implicit loading of the protocol match
-		 * extension.  '-p tcp' means 'l4 proto 6' and
-		 * at the same time 'load tcp protocol match on
-		 * demand if we specify --dport'.
-		 *
-		 * To make this work, we need to make sure:
-		 * - the parameter has not been parsed by
-		 *   a match (m above)
-		 * - a protocol has been specified
-		 * - the protocol extension has not been
-		 *   loaded yet, or is loaded and unused
-		 *   [think of iptables-restore!]
-		 * - the protocol extension can be successively
-		 *   loaded
-		 */
-		if (m == NULL
-		    && cs->protocol
-		    && (!find_proto(cs->protocol, XTF_DONT_LOAD,
-				   cs->options&OPT_NUMERIC, NULL)
-			|| (find_proto(cs->protocol, XTF_DONT_LOAD,
-					cs->options&OPT_NUMERIC, NULL)
-			    && (cs->proto_used == 0))
-		       )
-		    && (m = find_proto(cs->protocol, XTF_TRY_LOAD,
-				       cs->options&OPT_NUMERIC, &cs->matches))) {
+		if (m == NULL && (m = load_proto(cs)) != NULL) {
 			/* Try loading protocol */
 			size_t size;
 
diff --git a/xshared.c b/xshared.c
index 40b6b56..b47beb1 100644
--- a/xshared.c
+++ b/xshared.c
@@ -1,4 +1,5 @@
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
 #include <xtables.h>
@@ -50,7 +51,7 @@ proto_to_name(uint8_t proto, int nolookup)
 	return NULL;
 }
 
-struct xtables_match *
+static struct xtables_match *
 find_proto(const char *pname, enum xtables_tryload tryload,
 	   int nolookup, struct xtables_rule_match **matches)
 {
@@ -66,3 +67,35 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 
 	return NULL;
 }
+
+/*
+ * Some explanations (after four different bugs in 3 different releases): If
+ * we encounter a parameter, that has not been parsed yet, it's not an option
+ * of an explicitly loaded match or a target. However, we support implicit
+ * loading of the protocol match extension. '-p tcp' means 'l4 proto 6' and at
+ * the same time 'load tcp protocol match on demand if we specify --dport'.
+ *
+ * To make this work, we need to make sure:
+ * - the parameter has not been parsed by a match (m above)
+ * - a protocol has been specified
+ * - the protocol extension has not been loaded yet, or is loaded and unused
+ *   [think of ip6tables-restore!]
+ * - the protocol extension can be successively loaded
+ */
+static bool should_load_proto(struct iptables_command_state *cs)
+{
+	if (cs->protocol == NULL)
+		return false;
+	if (find_proto(cs->protocol, XTF_DONT_LOAD,
+	    cs->options & OPT_NUMERIC, NULL) != NULL)
+		return true;
+	return cs->proto_used;
+}
+
+struct xtables_match *load_proto(struct iptables_command_state *cs)
+{
+	if (!should_load_proto(cs))
+		return NULL;
+	return find_proto(cs->protocol, XTF_TRY_LOAD,
+			  cs->options & OPT_NUMERIC, &cs->matches);
+}
diff --git a/xshared.h b/xshared.h
index 06d73ab..d0cb516 100644
--- a/xshared.h
+++ b/xshared.h
@@ -45,7 +45,6 @@ enum {
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern const char *proto_to_name(uint8_t, int);
-extern struct xtables_match *find_proto(const char *, enum xtables_tryload,
-	int, struct xtables_rule_match **);
+extern struct xtables_match *load_proto(struct iptables_command_state *);
 
 #endif /* IPTABLES_XSHARED_H */
-- 
1.7.1

