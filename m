From: pablo@netfilter.org
Subject: [PATCH 2/3] libxtables: add xtables_rule_matches_free
Date: Thu, 27 Dec 2012 01:20:04 +0100
Message-ID: <1356567605-3246-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40011 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab2L0AU1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:20:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This function is shared by iptables and ip6tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac         |    4 ++--
 include/xtables.h    |    2 ++
 iptables/ip6tables.c |   23 +----------------------
 iptables/iptables.c  |   23 +----------------------
 libxtables/xtables.c |   22 ++++++++++++++++++++++
 5 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/configure.ac b/configure.ac
index c3b253a..e644308 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.4.16.3])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=9
-libxtables_vage=0
+libxtables_vcurrent=10
+libxtables_vage=1
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h b/include/xtables.h
index 2cc1a02..add76ae 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -417,6 +417,8 @@ extern struct xtables_match *xtables_find_match(const char *name,
 extern struct xtables_target *xtables_find_target(const char *name,
 	enum xtables_tryload);
 
+extern void xtables_rule_matches_free(struct xtables_rule_match **matches);
+
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_matches(struct xtables_match *, unsigned int);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 0e11a9e..e9e753a 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1249,27 +1249,6 @@ generate_entry(const struct ip6t_entry *fw,
 	return e;
 }
 
-static void clear_rule_matches(struct xtables_rule_match **matches)
-{
-	struct xtables_rule_match *matchp, *tmp;
-
-	for (matchp = *matches; matchp;) {
-		tmp = matchp->next;
-		if (matchp->match->m) {
-			free(matchp->match->m);
-			matchp->match->m = NULL;
-		}
-		if (matchp->match == matchp->match->next) {
-			free(matchp->match);
-			matchp->match = NULL;
-		}
-		free(matchp);
-		matchp = tmp;
-	}
-
-	*matches = NULL;
-}
-
 static void command_jump(struct iptables_command_state *cs)
 {
 	size_t size;
@@ -1963,7 +1942,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 	if (verbose > 1)
 		dump_entries6(*handle);
 
-	clear_rule_matches(&cs.matches);
+	xtables_rule_matches_free(&cs.matches);
 
 	if (e != NULL) {
 		free(e);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 760cb16..7cc8251 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1241,27 +1241,6 @@ generate_entry(const struct ipt_entry *fw,
 	return e;
 }
 
-static void clear_rule_matches(struct xtables_rule_match **matches)
-{
-	struct xtables_rule_match *matchp, *tmp;
-
-	for (matchp = *matches; matchp;) {
-		tmp = matchp->next;
-		if (matchp->match->m) {
-			free(matchp->match->m);
-			matchp->match->m = NULL;
-		}
-		if (matchp->match == matchp->match->next) {
-			free(matchp->match);
-			matchp->match = NULL;
-		}
-		free(matchp);
-		matchp = tmp;
-	}
-
-	*matches = NULL;
-}
-
 static void command_jump(struct iptables_command_state *cs)
 {
 	size_t size;
@@ -1963,7 +1942,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 	if (verbose > 1)
 		dump_entries(*handle);
 
-	clear_rule_matches(&cs.matches);
+	xtables_rule_matches_free(&cs.matches);
 
 	if (e != NULL) {
 		free(e);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 4c91286..da174e2 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1075,6 +1075,28 @@ void xtables_register_targets(struct xtables_target *target, unsigned int n)
 	} while (n > 0);
 }
 
+/* receives a list of xtables_rule_match, release them */
+void xtables_rule_matches_free(struct xtables_rule_match **matches)
+{
+	struct xtables_rule_match *matchp, *tmp;
+
+	for (matchp = *matches; matchp;) {
+		tmp = matchp->next;
+		if (matchp->match->m) {
+			free(matchp->match->m);
+			matchp->match->m = NULL;
+		}
+		if (matchp->match == matchp->match->next) {
+			free(matchp->match);
+			matchp->match = NULL;
+		}
+		free(matchp);
+		matchp = tmp;
+	}
+
+	*matches = NULL;
+}
+
 /**
  * xtables_param_act - act on condition
  * @status:	a constant from enum xtables_exittype
-- 
1.7.10.4

