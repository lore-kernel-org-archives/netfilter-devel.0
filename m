From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 07/17] iptables: implement --line-numbers for iptables -S
Date: Sun, 30 Sep 2012 12:22:10 +0200
Message-ID: <1349000540-17508-8-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38814 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2I3KW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:27 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow use of --line-numbers for -S, the latter of which is the preferred
output style for rules.

References: http://bugs.debian.org/642173
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/ip6tables.h       |    3 ++-
 include/iptables.h        |    3 ++-
 iptables/ip6tables-save.c |    2 +-
 iptables/ip6tables.c      |   23 +++++++++++++----------
 iptables/iptables-save.c  |    2 +-
 iptables/iptables.c       |   23 +++++++++++++----------
 6 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 37d2e0a..cb50a3c 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -13,7 +13,8 @@ extern int do_command6(int argc, char *argv[], char **table,
 extern int for_each_chain6(int (*fn)(const xt_chainlabel, int, struct xtc_handle *), int verbose, int builtinstoo, struct xtc_handle *handle);
 extern int flush_entries6(const xt_chainlabel chain, int verbose, struct xtc_handle *handle);
 extern int delete_chain6(const xt_chainlabel chain, int verbose, struct xtc_handle *handle);
-void print_rule6(const struct ip6t_entry *e, struct xtc_handle *h, const char *chain, int counters);
+extern void print_rule6(const struct ip6t_entry *e, struct xtc_handle *h,
+	const char *chain, int counters, unsigned int rule_num);
 
 extern struct xtables_globals ip6tables_globals;
 
diff --git a/include/iptables.h b/include/iptables.h
index c42613c..51106f0 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -16,7 +16,8 @@ extern int flush_entries4(const xt_chainlabel chain, int verbose,
 extern int for_each_chain4(int (*fn)(const xt_chainlabel, int, struct xtc_handle *),
 		int verbose, int builtinstoo, struct xtc_handle *handle);
 extern void print_rule4(const struct ipt_entry *e,
-		struct xtc_handle *handle, const char *chain, int counters);
+		struct xtc_handle *handle, const char *chain, int counters,
+		unsigned int rule_num);
 
 extern struct xtables_globals iptables_globals;
 
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..a5fd355 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -106,7 +106,7 @@ static int do_output(const char *tablename)
 		/* Dump out rules */
 		e = ip6tc_first_rule(chain, h);
 		while(e) {
-			print_rule6(e, h, chain, show_counters);
+			print_rule6(e, h, chain, show_counters, 0);
 			e = ip6tc_next_rule(e, h);
 		}
 	}
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b2c8776..0981129 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -163,7 +163,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'},
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x',' ','x'},
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
 };
 
@@ -1079,12 +1079,15 @@ static void print_ip(const char *prefix, const struct in6_addr *ip,
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-void print_rule6(const struct ip6t_entry *e,
-		       struct xtc_handle *h, const char *chain, int counters)
+void print_rule6(const struct ip6t_entry *e, struct xtc_handle *h,
+		 const char *chain, int counters, unsigned int rule_num)
 {
 	const struct xt_entry_target *t;
 	const char *target_name;
 
+	if (rule_num > 0)
+		printf("# Rule %u:\n", rule_num);
+
 	/* print counters for iptables-save */
 	if (counters > 0)
 		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
@@ -1169,15 +1172,12 @@ void print_rule6(const struct ip6t_entry *e,
 }
 
 static int
-list_rules(const xt_chainlabel chain, int rulenum, int counters,
+list_rules(const xt_chainlabel chain, int rulenum, unsigned int options,
 	     struct xtc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
 
-	if (counters)
-	    counters = -1;		/* iptables -c format */
-
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
 	if (!rulenum) for (this = ip6tc_first_chain(handle);
@@ -1189,7 +1189,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 		if (ip6tc_builtin(this, handle)) {
 			struct xt_counters count;
 			printf("-P %s %s", this, ip6tc_get_policy(this, &count, handle));
-			if (counters)
+			if (options & OPT_VERBOSE)
 			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
 			printf("\n");
 		} else {
@@ -1211,7 +1211,10 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 		while(e) {
 			num++;
 			if (!rulenum || num == rulenum)
-			    print_rule6(e, handle, this, counters);
+				print_rule6(e, handle, this,
+					    (options & OPT_VERBOSE) ? -1 : 0,
+					    (options & OPT_LINENUMBERS) ?
+						num : 0);
 			e = ip6tc_next_rule(e, handle);
 		}
 		found = 1;
@@ -1929,7 +1932,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
-				   cs.options&OPT_VERBOSE,
+				   cs.options,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..41b520f 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -104,7 +104,7 @@ static int do_output(const char *tablename)
 		/* Dump out rules */
 		e = iptc_first_rule(chain, h);
 		while(e) {
-			print_rule4(e, h, chain, show_counters);
+			print_rule4(e, h, chain, show_counters, 0);
 			e = iptc_next_rule(e, h);
 		}
 	}
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 8884c6a..2294753 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -162,7 +162,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x',' ','x','x'},
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
 };
 
@@ -1096,12 +1096,15 @@ static void print_ip(const char *prefix, uint32_t ip,
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-void print_rule4(const struct ipt_entry *e,
-		struct xtc_handle *h, const char *chain, int counters)
+void print_rule4(const struct ipt_entry *e, struct xtc_handle *h,
+		 const char *chain, int counters, unsigned int rule_num)
 {
 	const struct xt_entry_target *t;
 	const char *target_name;
 
+	if (rule_num > 0)
+		printf("# Rule %u:\n", rule_num);
+
 	/* print counters for iptables-save */
 	if (counters > 0)
 		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
@@ -1177,15 +1180,12 @@ void print_rule4(const struct ipt_entry *e,
 }
 
 static int
-list_rules(const xt_chainlabel chain, int rulenum, int counters,
+list_rules(const xt_chainlabel chain, int rulenum, unsigned int options,
 	     struct xtc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
 
-	if (counters)
-	    counters = -1;		/* iptables -c format */
-
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
 	if (!rulenum) for (this = iptc_first_chain(handle);
@@ -1197,7 +1197,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 		if (iptc_builtin(this, handle)) {
 			struct xt_counters count;
 			printf("-P %s %s", this, iptc_get_policy(this, &count, handle));
-			if (counters)
+			if (options & OPT_VERBOSE)
 			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
 			printf("\n");
 		} else {
@@ -1219,7 +1219,10 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 		while(e) {
 			num++;
 			if (!rulenum || num == rulenum)
-			    print_rule4(e, handle, this, counters);
+				print_rule4(e, handle, this,
+					    (options & OPT_VERBOSE) ? -1 : 0,
+					    (options & OPT_LINENUMBERS) ?
+						num : 0);
 			e = iptc_next_rule(e, handle);
 		}
 		found = 1;
@@ -1945,7 +1948,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
-				   cs.options&OPT_VERBOSE,
+				   cs.options,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-- 
1.7.10.4

