From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] iptables: add -C to check for existing rules
Date: Tue,  8 Mar 2011 23:20:59 +0100
Message-ID: <1299622860-32634-3-git-send-email-jengelh@medozas.de>
References: <1299622860-32634-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55706 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1CHWVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:21:09 -0500
In-Reply-To: <1299622860-32634-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stefan Tomanek <stefan.tomanek@wertarbyte.de>

It is often useful to check whether a specific rule is already present
in a chain without actually modifying the iptables config.

Services like fail2ban usually employ techniques like grepping through
the output of "iptables -L" which is quite error prone.

This patch adds a new operation -C to the iptables command which
mostly works like -D; it can detect and indicate the existence of the
specified rule by modifying the exit code. The new operation
TC_CHECK_ENTRY uses the same code as the -D operation, whose functions
got a dry-run parameter appended.

Signed-off-by: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libiptc/libip6tc.h |    6 ++++
 include/libiptc/libiptc.h  |    6 ++++
 ip6tables.8.in             |   10 ++++++-
 ip6tables.c                |   60 +++++++++++++++++++++++++++++++++++++++----
 iptables.8.in              |    9 ++++++-
 iptables.c                 |   60 +++++++++++++++++++++++++++++++++++++++----
 libiptc/libip4tc.c         |    1 +
 libiptc/libip6tc.c         |    1 +
 libiptc/libiptc.c          |   30 +++++++++++++++++----
 9 files changed, 162 insertions(+), 21 deletions(-)

diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 33ec69d..9796574 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -80,6 +80,12 @@ int ip6tc_append_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       struct ip6tc_handle *handle);
 
+/* Check whether a matching rule exists */
+int ip6tc_check_entry(const ip6t_chainlabel chain,
+		       const struct ip6t_entry *origfw,
+		       unsigned char *matchmask,
+		       struct ip6tc_handle *handle);
+
 /* Delete the first rule in `chain' which matches `fw'. */
 int ip6tc_delete_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *origfw,
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 5d782da..4355ac9 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -88,6 +88,12 @@ int iptc_append_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      struct iptc_handle *handle);
 
+/* Check whether a mathching rule exists */
+int iptc_check_entry(const ipt_chainlabel chain,
+		      const struct ipt_entry *origfw,
+		      unsigned char *matchmask,
+		      struct iptc_handle *handle);
+
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
 int iptc_delete_entry(const ipt_chainlabel chain,
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 4306934..7690ba1 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -27,8 +27,8 @@
 .SH NAME
 ip6tables \(em IPv6 packet filter administration
 .SH SYNOPSIS
-\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
-rule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP}
+\fIchain rule-specification\fP [\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP]
 \fIrule-specification\fP [\fIoptions...\fP]
@@ -139,6 +139,12 @@ Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
+\fB\-C\fP, \fB\-\-check\fP \fIchain rule-specification\fP
+Check whether a rule matching the specification does exist in the
+selected chain. This command uses the same logic as \fB\-D\fP to
+find a matching entry, but does not alter the existing iptables
+configuration and uses its exit code to indicate success or failure.
+.TP
 \fB\-D\fP, \fB\-\-delete\fP \fIchain rule-specification\fP
 .ns
 .TP
diff --git a/ip6tables.c b/ip6tables.c
index 06f570b..96a0fdc 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -82,9 +82,10 @@
 #define CMD_RENAME_CHAIN	0x0800U
 #define CMD_LIST_RULES		0x1000U
 #define CMD_ZERO_NUM		0x2000U
-#define NUMBER_OF_CMD	15
+#define CMD_CHECK		0x4000U
+#define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'Z', 'N', 'X', 'P', 'E', 'S' };
+				 'Z', 'N', 'X', 'P', 'E', 'S', 'C' };
 
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
@@ -93,6 +94,7 @@ static const char optflags[]
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
+	{.name = "check" ,        .has_arg = 1, .val = 'C'},
 	{.name = "insert",        .has_arg = 1, .val = 'I'},
 	{.name = "replace",       .has_arg = 1, .val = 'R'},
 	{.name = "list",          .has_arg = 2, .val = 'L'},
@@ -165,7 +167,8 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'}
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'},
+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
 };
 
 static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
@@ -208,7 +211,7 @@ static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
 	printf("%s v%s\n\n"
-"Usage: %s -[AD] chain rule-specification [options]\n"
+"Usage: %s -[ACD] chain rule-specification [options]\n"
 "       %s -I chain [rulenum] rule-specification [options]\n"
 "       %s -R chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
@@ -226,6 +229,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "Commands:\n"
 "Either long or short options are allowed.\n"
 "  --append  -A chain		Append to chain\n"
+"  --check   -C chain		Check for the existence of a rule\n"
 "  --delete  -D chain		Delete matching rule from chain\n"
 "  --delete  -D chain rulenum\n"
 "				Delete rule rulenum (1 = first) from chain\n"
@@ -824,6 +828,36 @@ delete_entry(const ip6t_chainlabel chain,
 	return ret;
 }
 
+static int
+check_entry(const ip6t_chainlabel chain, struct ip6t_entry *fw,
+	    unsigned int nsaddrs, const struct in6_addr *saddrs,
+	    const struct in6_addr *smasks, unsigned int ndaddrs,
+	    const struct in6_addr *daddrs, const struct in6_addr *dmasks,
+	    bool verbose, struct ip6tc_handle *handle,
+	    struct xtables_rule_match *matches,
+	    const struct xtables_target *target)
+{
+	unsigned int i, j;
+	int ret = 1;
+	unsigned char *mask;
+
+	mask = make_delete_mask(matches, target);
+	for (i = 0; i < nsaddrs; i++) {
+		fw->ipv6.src = saddrs[i];
+		fw->ipv6.smsk = smasks[i];
+		for (j = 0; j < ndaddrs; j++) {
+			fw->ipv6.dst = daddrs[j];
+			fw->ipv6.dmsk = dmasks[j];
+			if (verbose)
+				print_firewall_line(fw, handle);
+			ret &= ip6tc_check_entry(chain, fw, mask, handle);
+		}
+	}
+
+	free(mask);
+	return ret;
+}
+
 int
 for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
 	       int verbose, int builtinstoo, struct ip6tc_handle *handle)
@@ -1393,7 +1427,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1405,6 +1439,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			chain = optarg;
 			break;
 
+		case 'C':
+			add_command(&command, CMD_CHECK, CMD_NONE,
+			            cs.invert);
+			chain = optarg;
+			break;
+
 		case 'D':
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    cs.invert);
@@ -1742,7 +1782,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "::0/0";
 		if (!(cs.options & OPT_SOURCE))
@@ -1788,6 +1828,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
+	    || command == CMD_CHECK
 	    || command == CMD_INSERT
 	    || command == CMD_REPLACE) {
 		if (strcmp(chain, "PREROUTING") == 0
@@ -1876,6 +1917,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	case CMD_DELETE_NUM:
 		ret = ip6tc_delete_num_entry(chain, rulenum - 1, *handle);
 		break;
+	case CMD_CHECK:
+		ret = check_entry(chain, e,
+				   nsaddrs, saddrs, smasks,
+				   ndaddrs, daddrs, dmasks,
+				   cs.options&OPT_VERBOSE,
+				   *handle, cs.matches, cs.target);
+		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, smasks, daddrs, dmasks,
diff --git a/iptables.8.in b/iptables.8.in
index f36d220..4b97bc3 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -25,7 +25,8 @@
 .SH NAME
 iptables \(em administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain\fP \fIrule-specification\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP}
+\fIchain\fP \fIrule-specification\fP
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
 .PP
@@ -144,6 +145,12 @@ Append one or more rules to the end of the selected chain.
 When the source and/or destination names resolve to more than one
 address, a rule will be added for each possible address combination.
 .TP
+\fB\-C\fP, \fB\-\-check\fP \fIchain rule-specification\fP
+Check whether a rule matching the specification does exist in the
+selected chain. This command uses the same logic as \fB\-D\fP to
+find a matching entry, but does not alter the existing iptables
+configuration and uses its exit code to indicate success or failure.
+.TP
 \fB\-D\fP, \fB\-\-delete\fP \fIchain rule-specification\fP
 .ns
 .TP
diff --git a/iptables.c b/iptables.c
index a73df3e..cff4a7b 100644
--- a/iptables.c
+++ b/iptables.c
@@ -79,9 +79,10 @@
 #define CMD_RENAME_CHAIN	0x0800U
 #define CMD_LIST_RULES		0x1000U
 #define CMD_ZERO_NUM		0x2000U
-#define NUMBER_OF_CMD	15
+#define CMD_CHECK		0x4000U
+#define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'Z', 'N', 'X', 'P', 'E', 'S' };
+				 'Z', 'N', 'X', 'P', 'E', 'S', 'C' };
 
 #define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
@@ -91,6 +92,7 @@ static const char optflags[]
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
+	{.name = "check",         .has_arg = 1, .val = 'C'},
 	{.name = "insert",        .has_arg = 1, .val = 'I'},
 	{.name = "replace",       .has_arg = 1, .val = 'R'},
 	{.name = "list",          .has_arg = 2, .val = 'L'},
@@ -165,7 +167,8 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
 };
 
 static const int inverse_for_options[NUMBER_OF_OPT] =
@@ -221,7 +224,7 @@ static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
 	printf("%s v%s\n\n"
-"Usage: %s -[AD] chain rule-specification [options]\n"
+"Usage: %s -[ACD] chain rule-specification [options]\n"
 "       %s -I chain [rulenum] rule-specification [options]\n"
 "       %s -R chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
@@ -239,6 +242,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "Commands:\n"
 "Either long or short options are allowed.\n"
 "  --append  -A chain		Append to chain\n"
+"  --check   -C chain		Check for the existence of a rule\n"
 "  --delete  -D chain		Delete matching rule from chain\n"
 "  --delete  -D chain rulenum\n"
 "				Delete rule rulenum (1 = first) from chain\n"
@@ -827,6 +831,36 @@ delete_entry(const ipt_chainlabel chain,
 	return ret;
 }
 
+static int
+check_entry(const ipt_chainlabel chain, struct ipt_entry *fw,
+	    unsigned int nsaddrs, const struct in_addr *saddrs,
+	    const struct in_addr *smasks, unsigned int ndaddrs,
+	    const struct in_addr *daddrs, const struct in_addr *dmasks,
+	    bool verbose, struct iptc_handle *handle,
+	    struct xtables_rule_match *matches,
+	    const struct xtables_target *target)
+{
+	unsigned int i, j;
+	int ret = 1;
+	unsigned char *mask;
+
+	mask = make_delete_mask(matches, target);
+	for (i = 0; i < nsaddrs; i++) {
+		fw->ip.src.s_addr = saddrs[i].s_addr;
+		fw->ip.smsk.s_addr = smasks[i].s_addr;
+		for (j = 0; j < ndaddrs; j++) {
+			fw->ip.dst.s_addr = daddrs[j].s_addr;
+			fw->ip.dmsk.s_addr = dmasks[j].s_addr;
+			if (verbose)
+				print_firewall_line(fw, handle);
+			ret &= iptc_check_entry(chain, fw, mask, handle);
+		}
+	}
+
+	free(mask);
+	return ret;
+}
+
 int
 for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
 	       int verbose, int builtinstoo, struct iptc_handle *handle)
@@ -1423,7 +1457,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1435,6 +1469,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			chain = optarg;
 			break;
 
+		case 'C':
+			add_command(&command, CMD_CHECK, CMD_NONE,
+				    cs.invert);
+			chain = optarg;
+			break;
+
 		case 'D':
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    cs.invert);
@@ -1778,7 +1818,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "0.0.0.0/0";
 		if (!(cs.options & OPT_SOURCE))
@@ -1824,6 +1864,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
+	    || command == CMD_CHECK
 	    || command == CMD_INSERT
 	    || command == CMD_REPLACE) {
 		if (strcmp(chain, "PREROUTING") == 0
@@ -1914,6 +1955,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	case CMD_DELETE_NUM:
 		ret = iptc_delete_num_entry(chain, rulenum - 1, *handle);
 		break;
+	case CMD_CHECK:
+		ret = check_entry(chain, e,
+				   nsaddrs, saddrs, smasks,
+				   ndaddrs, daddrs, dmasks,
+				   cs.options&OPT_VERBOSE,
+				   *handle, cs.matches, cs.target);
+		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, smasks, daddrs, dmasks,
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index c1d78e2..e2d2a5e 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -76,6 +76,7 @@ typedef unsigned int socklen_t;
 #define TC_INSERT_ENTRY		iptc_insert_entry
 #define TC_REPLACE_ENTRY	iptc_replace_entry
 #define TC_APPEND_ENTRY		iptc_append_entry
+#define TC_CHECK_ENTRY		iptc_check_entry
 #define TC_DELETE_ENTRY		iptc_delete_entry
 #define TC_DELETE_NUM_ENTRY	iptc_delete_num_entry
 #define TC_FLUSH_ENTRIES	iptc_flush_entries
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 27fe4c4..c1508cd 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -71,6 +71,7 @@ typedef unsigned int socklen_t;
 #define TC_INSERT_ENTRY		ip6tc_insert_entry
 #define TC_REPLACE_ENTRY	ip6tc_replace_entry
 #define TC_APPEND_ENTRY		ip6tc_append_entry
+#define TC_CHECK_ENTRY		ip6tc_check_entry
 #define TC_DELETE_ENTRY		ip6tc_delete_entry
 #define TC_DELETE_NUM_ENTRY	ip6tc_delete_num_entry
 #define TC_FLUSH_ENTRIES	ip6tc_flush_entries
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 7a9c742..d3b1c51 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -31,6 +31,7 @@
  */
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <stdbool.h>
 #include <xtables.h>
 
 #include "linux_list.h"
@@ -1956,12 +1957,11 @@ is_same(const STRUCT_ENTRY *a,
 	const STRUCT_ENTRY *b,
 	unsigned char *matchmask);
 
-/* Delete the first rule in `chain' which matches `fw'. */
-int
-TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
-		const STRUCT_ENTRY *origfw,
-		unsigned char *matchmask,
-		struct xtc_handle *handle)
+
+/* find the first rule in `chain' which matches `fw' and remove it unless dry_run is set */
+static int delete_entry(const IPT_CHAINLABEL chain, const STRUCT_ENTRY *origfw,
+			unsigned char *matchmask, struct xtc_handle *handle,
+			bool dry_run)
 {
 	struct chain_head *c;
 	struct rule_head *r, *i;
@@ -2005,6 +2005,10 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		if (!target_same(r, i, mask))
 			continue;
 
+		/* if we are just doing a dry run, we simply skip the rest */
+		if (dry_run)
+			return 1;
+
 		/* If we are about to delete the rule that is the
 		 * current iterator, move rule iterator back.  next
 		 * pointer will then point to real next node */
@@ -2027,6 +2031,20 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 	return 0;
 }
 
+/* check whether a specified rule is present */
+int TC_CHECK_ENTRY(const IPT_CHAINLABEL chain, const STRUCT_ENTRY *origfw,
+		   unsigned char *matchmask, struct xtc_handle *handle)
+{
+	/* do a dry-run delete to find out whether a matching rule exists */
+	return delete_entry(chain, origfw, matchmask, handle, true);
+}
+
+/* Delete the first rule in `chain' which matches `fw'. */
+int TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,	const STRUCT_ENTRY *origfw,
+		    unsigned char *matchmask, struct xtc_handle *handle)
+{
+	return delete_entry(chain, origfw, matchmask, handle, false);
+}
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int
-- 
1.7.1

