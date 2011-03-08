From: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Subject: [PATCH] iptables: add -C to check for existing rules
Date: Tue, 8 Mar 2011 12:56:39 +0100
Message-ID: <20110308115639.GA30013@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zirkel.wertarbyte.de ([188.40.44.137]:53515 "EHLO
	zirkel.wertarbyte.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1CHL4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:56:41 -0500
Received: from stefan by zirkel.wertarbyte.de with local (Exim 4.72)
	(envelope-from <stefan.tomanek@wertarbyte.de>)
	id 1PwvWp-0007oV-Nv
	for netfilter-devel@vger.kernel.org; Tue, 08 Mar 2011 12:56:39 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is often useful to check whether a specific rule is already present
in a chain without actually modifying the iptables config.

Services like fail2ban usually employ techniques like grepping through
the output of "iptables -L" which is quite error prone.

This patch adds a new operation -C to the iptables command which mostly
works like -D; it can detect and indicate the existence of the specified
rule by modifying the exit code. The new operation TC_CHECK_ENTRY uses
the same code as the -D operation, whose functions got a dry-run
parameter appended.

Signed-off-by: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
---
 include/libiptc/libiptc.h |    6 ++++
 iptables.c                |   66 ++++++++++++++++++++++++++++++++++++++++----
 libiptc/libip4tc.c        |    1 +
 libiptc/libiptc.c         |   34 ++++++++++++++++++++---
 4 files changed, 97 insertions(+), 10 deletions(-)

diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 5d782da..21b20df 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -88,6 +88,12 @@ int iptc_append_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      struct iptc_handle *handle);
 
+/* Check whether a rule mathching `e' exists */
+int iptc_check_entry(const ipt_chainlabel chain,
+		      const struct ipt_entry *origfw,
+		      unsigned char *matchmask,
+		      struct iptc_handle *handle);
+
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
 int iptc_delete_entry(const ipt_chainlabel chain,
diff --git a/iptables.c b/iptables.c
index a73df3e..f5d2cd5 100644
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
+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '}
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
@@ -827,6 +831,42 @@ delete_entry(const ipt_chainlabel chain,
 	return ret;
 }
 
+static int
+check_entry(const ipt_chainlabel chain,
+	     struct ipt_entry *fw,
+	     unsigned int nsaddrs,
+	     const struct in_addr saddrs[],
+	     const struct in_addr smasks[],
+	     unsigned int ndaddrs,
+	     const struct in_addr daddrs[],
+	     const struct in_addr dmasks[],
+	     int verbose,
+	     struct iptc_handle *handle,
+	     struct xtables_rule_match *matches,
+	     const struct xtables_target *target)
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
+	free(mask);
+
+	return ret;
+}
+
+
 int
 for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
 	       int verbose, int builtinstoo, struct iptc_handle *handle)
@@ -1423,7 +1463,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-:A:D:C:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1446,6 +1486,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			}
 			break;
 
+		case 'C':
+			add_command(&command, CMD_CHECK, CMD_NONE,
+				    cs.invert);
+			chain = optarg;
+			break;
+
 		case 'R':
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    cs.invert);
@@ -1778,7 +1824,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "0.0.0.0/0";
 		if (!(cs.options & OPT_SOURCE))
@@ -1824,6 +1870,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
+	    || command == CMD_CHECK
 	    || command == CMD_INSERT
 	    || command == CMD_REPLACE) {
 		if (strcmp(chain, "PREROUTING") == 0
@@ -1914,6 +1961,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
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
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 7a9c742..2803fa0 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1956,12 +1956,14 @@ is_same(const STRUCT_ENTRY *a,
 	const STRUCT_ENTRY *b,
 	unsigned char *matchmask);
 
-/* Delete the first rule in `chain' which matches `fw'. */
-int
-TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
+
+/* find the first rule in `chain' which matches `fw' and remove it unless dry_run is set */
+static int
+delete_entry(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *origfw,
 		unsigned char *matchmask,
-		struct xtc_handle *handle)
+		struct xtc_handle *handle,
+		int dry_run)
 {
 	struct chain_head *c;
 	struct rule_head *r, *i;
@@ -2004,6 +2006,10 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 
 		if (!target_same(r, i, mask))
 			continue;
+		
+		/* if we are just doing a dry run, we simply skip the rest */
+		if (dry_run)
+			return 1;
 
 		/* If we are about to delete the rule that is the
 		 * current iterator, move rule iterator back.  next
@@ -2027,6 +2033,26 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 	return 0;
 }
 
+/* check whether a specified rule is present */
+int
+TC_CHECK_ENTRY(const IPT_CHAINLABEL chain,
+		const STRUCT_ENTRY *origfw,
+		unsigned char *matchmask,
+		struct xtc_handle *handle)
+{
+	/* do a dry-run delete to find out whether a matching rule exists */
+	return delete_entry(chain, origfw, matchmask, handle, 1);
+}
+
+/* Delete the first rule in `chain' which matches `fw'. */
+int
+TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
+		const STRUCT_ENTRY *origfw,
+		unsigned char *matchmask,
+		struct xtc_handle *handle)
+{
+	return delete_entry(chain, origfw, matchmask, handle, 0);
+}
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int
-- 
1.7.2.3
