From: jengelh@medozas.de
Subject: [PATCH 5/8] src: remove iptables_rule_match indirection macro
Date: Wed, 11 Feb 2009 16:03:33 +0100
Message-ID: <1234364616-19974-6-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48694 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZBKPDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:40 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h |    1 -
 include/iptables.h  |    1 -
 ip6tables.c         |   24 ++++++++++++------------
 iptables.c          |   24 ++++++++++++------------
 4 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 663da9c..52e290c 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -11,7 +11,6 @@
 #define IP6T_SO_GET_REVISION_TARGET	69
 #endif /* IP6T_SO_GET_REVISION_MATCH   Old kernel source */
 
-#define ip6tables_rule_match	xtables_rule_match
 #define ip6t_tryload		xt_tryload
 
 extern int line;
diff --git a/include/iptables.h b/include/iptables.h
index ee769a5..74b244e 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -11,7 +11,6 @@
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
 #endif /* IPT_SO_GET_REVISION_MATCH   Old kernel source */
 
-#define iptables_rule_match	xtables_rule_match
 #define ipt_tryload		xt_tryload
 
 extern int line;
diff --git a/ip6tables.c b/ip6tables.c
index 233974f..7fff492 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -239,9 +239,9 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(struct ip6tables_rule_match *matches)
+exit_printhelp(struct xtables_rule_match *matches)
 {
-	struct ip6tables_rule_match *matchp = NULL;
+	struct xtables_rule_match *matchp = NULL;
 	struct xtables_target *t = NULL;
 
 	printf("%s v%s\n\n"
@@ -426,7 +426,7 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct xtables_match *
 find_proto(const char *pname, enum xtables_tryload tryload,
-	   int nolookup, struct ip6tables_rule_match **matches)
+	   int nolookup, struct xtables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -839,11 +839,11 @@ insert_entry(const ip6t_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct ip6t_entry *fw, struct ip6tables_rule_match *matches)
+make_delete_mask(struct ip6t_entry *fw, struct xtables_rule_match *matches)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
-	struct ip6tables_rule_match *matchp;
+	struct xtables_rule_match *matchp;
 	unsigned char *mask, *mptr;
 
 	size = sizeof(struct ip6t_entry);
@@ -880,7 +880,7 @@ delete_entry(const ip6t_chainlabel chain,
 	     const struct in6_addr daddrs[],
 	     int verbose,
 	     struct ip6tc_handle *handle,
-	     struct ip6tables_rule_match *matches)
+	     struct xtables_rule_match *matches)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -1271,11 +1271,11 @@ list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
 
 static struct ip6t_entry *
 generate_entry(const struct ip6t_entry *fw,
-	       struct ip6tables_rule_match *matches,
+	       struct xtables_rule_match *matches,
 	       struct ip6t_entry_target *target)
 {
 	unsigned int size;
-	struct ip6tables_rule_match *matchp;
+	struct xtables_rule_match *matchp;
 	struct ip6t_entry *e;
 
 	size = sizeof(struct ip6t_entry);
@@ -1297,9 +1297,9 @@ generate_entry(const struct ip6t_entry *fw,
 	return e;
 }
 
-static void clear_rule_matches(struct ip6tables_rule_match **matches)
+static void clear_rule_matches(struct xtables_rule_match **matches)
 {
-	struct ip6tables_rule_match *matchp, *tmp;
+	struct xtables_rule_match *matchp, *tmp;
 
 	for (matchp = *matches; matchp;) {
 		tmp = matchp->next;
@@ -1342,8 +1342,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct xtables_match *m;
-	struct ip6tables_rule_match *matches = NULL;
-	struct ip6tables_rule_match *matchp;
+	struct xtables_rule_match *matches = NULL;
+	struct xtables_rule_match *matchp;
 	struct xtables_target *target = NULL;
 	struct xtables_target *t;
 	const char *jumpto = "";
diff --git a/iptables.c b/iptables.c
index f1a5d33..b063823 100644
--- a/iptables.c
+++ b/iptables.c
@@ -250,9 +250,9 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(struct iptables_rule_match *matches)
+exit_printhelp(struct xtables_rule_match *matches)
 {
-	struct iptables_rule_match *matchp = NULL;
+	struct xtables_rule_match *matchp = NULL;
 	struct xtables_target *t = NULL;
 
 	printf("%s v%s\n\n"
@@ -437,7 +437,7 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct xtables_match *
 find_proto(const char *pname, enum xtables_tryload tryload,
-	   int nolookup, struct iptables_rule_match **matches)
+	   int nolookup, struct xtables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -841,11 +841,11 @@ insert_entry(const ipt_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct ipt_entry *fw, struct iptables_rule_match *matches)
+make_delete_mask(struct ipt_entry *fw, struct xtables_rule_match *matches)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
-	struct iptables_rule_match *matchp;
+	struct xtables_rule_match *matchp;
 	unsigned char *mask, *mptr;
 
 	size = sizeof(struct ipt_entry);
@@ -882,7 +882,7 @@ delete_entry(const ipt_chainlabel chain,
 	     const struct in_addr daddrs[],
 	     int verbose,
 	     struct iptc_handle *handle,
-	     struct iptables_rule_match *matches)
+	     struct xtables_rule_match *matches)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -1279,11 +1279,11 @@ list_rules(const ipt_chainlabel chain, int rulenum, int counters,
 
 static struct ipt_entry *
 generate_entry(const struct ipt_entry *fw,
-	       struct iptables_rule_match *matches,
+	       struct xtables_rule_match *matches,
 	       struct ipt_entry_target *target)
 {
 	unsigned int size;
-	struct iptables_rule_match *matchp;
+	struct xtables_rule_match *matchp;
 	struct ipt_entry *e;
 
 	size = sizeof(struct ipt_entry);
@@ -1305,9 +1305,9 @@ generate_entry(const struct ipt_entry *fw,
 	return e;
 }
 
-static void clear_rule_matches(struct iptables_rule_match **matches)
+static void clear_rule_matches(struct xtables_rule_match **matches)
 {
-	struct iptables_rule_match *matchp, *tmp;
+	struct xtables_rule_match *matchp, *tmp;
 
 	for (matchp = *matches; matchp;) {
 		tmp = matchp->next;
@@ -1364,8 +1364,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct xtables_match *m;
-	struct iptables_rule_match *matches = NULL;
-	struct iptables_rule_match *matchp;
+	struct xtables_rule_match *matches = NULL;
+	struct xtables_rule_match *matchp;
 	struct xtables_target *target = NULL;
 	struct xtables_target *t;
 	const char *jumpto = "";
-- 
1.6.1.2

