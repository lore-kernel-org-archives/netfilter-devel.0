From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] src: resolve old macro names that are indirections
Date: Sun, 11 Sep 2011 17:35:56 +0200
Message-ID: <1315755359-7012-8-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51845 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab1IKPgJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:09 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Command used:

	git grep -f <(pcregrep -hior
	'(?<=#define\s)IP6?(T_\w+)(?=\s+X\1)' include/)

and then fix all occurrences.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_realm.c    |   10 ++++----
 include/libiptc/libip6tc.h   |    8 +++---
 include/libiptc/libiptc.h    |    8 +++---
 iptables/ip6tables-restore.c |   13 +++++------
 iptables/ip6tables-save.c    |    4 +-
 iptables/ip6tables.c         |   50 +++++++++++++++++++++---------------------
 iptables/iptables-restore.c  |   13 +++++------
 iptables/iptables-save.c     |    4 +-
 iptables/iptables-xml.c      |   36 +++++++++++++++---------------
 iptables/iptables.c          |   48 ++++++++++++++++++++--------------------
 iptables/xshared.c           |    2 +-
 libiptc/libip4tc.c           |   32 +++++++++++++-------------
 libiptc/libip6tc.c           |   30 ++++++++++++------------
 13 files changed, 128 insertions(+), 130 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index b60c57e..a8d9dda 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -41,7 +41,7 @@ static void realm_init(struct xt_entry_match *m)
 
 static void realm_parse(struct xt_option_call *cb)
 {
-	struct ipt_realm_info *realminfo = cb->data;
+	struct xt_realm_info *realminfo = cb->data;
 	int id;
 	char *end;
 
@@ -87,7 +87,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
 static void realm_print(const void *ip, const struct xt_entry_match *match,
                         int numeric)
 {
-	const struct ipt_realm_info *ri = (const void *)match->data;
+	const struct xt_realm_info *ri = (const void *)match->data;
 
 	if (ri->invert)
 		printf(" !");
@@ -98,7 +98,7 @@ static void realm_print(const void *ip, const struct xt_entry_match *match,
 
 static void realm_save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_realm_info *ri = (const void *)match->data;
+	const struct xt_realm_info *ri = (const void *)match->data;
 
 	if (ri->invert)
 		printf(" !");
@@ -111,8 +111,8 @@ static struct xtables_match realm_mt_reg = {
 	.name		= "realm",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ipt_realm_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ipt_realm_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_realm_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_realm_info)),
 	.help		= realm_help,
 	.init		= realm_init,
 	.print		= realm_print,
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index f85dda7..61c1e7f 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -50,7 +50,7 @@ int ip6tc_builtin(const char *chain, struct xtc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *ip6tc_get_policy(const char *chain,
-			     struct ip6t_counters *counters,
+			     struct xt_counters *counters,
 			     struct xtc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno. If errno ==
@@ -122,7 +122,7 @@ int ip6tc_rename_chain(const xt_chainlabel oldname,
 /* Sets the policy on a built-in chain. */
 int ip6tc_set_policy(const xt_chainlabel chain,
 		     const xt_chainlabel policy,
-		     struct ip6t_counters *counters,
+		     struct xt_counters *counters,
 		     struct xtc_handle *handle);
 
 /* Get the number of references to this chain */
@@ -130,7 +130,7 @@ int ip6tc_get_references(unsigned int *ref, const xt_chainlabel chain,
 			 struct xtc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
-struct ip6t_counters *ip6tc_read_counter(const xt_chainlabel chain,
+struct xt_counters *ip6tc_read_counter(const xt_chainlabel chain,
 					unsigned int rulenum,
 					struct xtc_handle *handle);
 
@@ -142,7 +142,7 @@ int ip6tc_zero_counter(const xt_chainlabel chain,
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const xt_chainlabel chain,
 		      unsigned int rulenum,
-		      struct ip6t_counters *counters,
+		      struct xt_counters *counters,
 		      struct xtc_handle *handle);
 
 /* Makes the actual changes. */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index cf91725..6f64f5a 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -54,7 +54,7 @@ int iptc_builtin(const char *chain, struct xtc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *iptc_get_policy(const char *chain,
-			    struct ipt_counters *counter,
+			    struct xt_counters *counter,
 			    struct xtc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno.  If errno ==
@@ -127,7 +127,7 @@ int iptc_rename_chain(const xt_chainlabel oldname,
 /* Sets the policy on a built-in chain. */
 int iptc_set_policy(const xt_chainlabel chain,
 		    const xt_chainlabel policy,
-		    struct ipt_counters *counters,
+		    struct xt_counters *counters,
 		    struct xtc_handle *handle);
 
 /* Get the number of references to this chain */
@@ -136,7 +136,7 @@ int iptc_get_references(unsigned int *ref,
 			struct xtc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
-struct ipt_counters *iptc_read_counter(const xt_chainlabel chain,
+struct xt_counters *iptc_read_counter(const xt_chainlabel chain,
 				       unsigned int rulenum,
 				       struct xtc_handle *handle);
 
@@ -148,7 +148,7 @@ int iptc_zero_counter(const xt_chainlabel chain,
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const xt_chainlabel chain,
 		     unsigned int rulenum,
-		     struct ipt_counters *counters,
+		     struct xt_counters *counters,
 		     struct xtc_handle *handle);
 
 /* Makes the actual changes. */
diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index c5afe31..073e42b 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -77,7 +77,7 @@ static struct xtc_handle *create_handle(const char *tablename)
 	return handle;
 }
 
-static int parse_counters(char *string, struct ip6t_counters *ctr)
+static int parse_counters(char *string, struct xt_counters *ctr)
 {
 	unsigned long long pcnt, bcnt;
 	int ret;
@@ -119,7 +119,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	struct xtc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
-	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
+	char curtable[XT_TABLE_MAXNAMELEN + 1];
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
@@ -218,8 +218,8 @@ int ip6tables_restore_main(int argc, char *argv[])
 					line);
 				exit(1);
 			}
-			strncpy(curtable, table, IP6T_TABLE_MAXNAMELEN);
-			curtable[IP6T_TABLE_MAXNAMELEN] = '\0';
+			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
+			curtable[XT_TABLE_MAXNAMELEN] = '\0';
 
 			if (tablename != NULL && strcmp(tablename, table) != 0)
 				continue;
@@ -291,7 +291,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			}
 
 			if (strcmp(policy, "-") != 0) {
-				struct ip6t_counters count;
+				struct xt_counters count;
 
 				if (counters) {
 					char *ctrs;
@@ -303,8 +303,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 							  "for chain '%s'\n", chain);
 
 				} else {
-					memset(&count, 0,
-					       sizeof(struct ip6t_counters));
+					memset(&count, 0, sizeof(count));
 				}
 
 				DEBUGP("Setting policy of chain %s to %s\n",
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index fbfce78..d819b30 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -38,7 +38,7 @@ static int for_each_table(int (*func)(const char *tablename))
 {
 	int ret = 1;
 	FILE *procfile = NULL;
-	char tablename[IP6T_TABLE_MAXNAMELEN+1];
+	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip6_tables_names", "re");
 	if (!procfile)
@@ -89,7 +89,7 @@ static int do_output(const char *tablename)
 
 		printf(":%s ", chain);
 		if (ip6tc_builtin(chain, h)) {
-			struct ip6t_counters count;
+			struct xt_counters count;
 			printf("%s ",
 			       ip6tc_get_policy(chain, &count, h));
 			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 7b12205..b191d5d 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -172,7 +172,7 @@ static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
 /* -n */ 0,
 /* -s */ IP6T_INV_SRCIP,
 /* -d */ IP6T_INV_DSTIP,
-/* -p */ IP6T_INV_PROTO,
+/* -p */ XT_INV_PROTO,
 /* -j */ 0,
 /* -v */ 0,
 /* -x */ 0,
@@ -471,7 +471,7 @@ print_num(uint64_t number, unsigned int format)
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
-	struct ip6t_counters counters;
+	struct xt_counters counters;
 	const char *pol = ip6tc_get_policy(chain, &counters, handle);
 	printf("Chain %s", chain);
 	if (pol) {
@@ -519,7 +519,7 @@ print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 
 
 static int
-print_match(const struct ip6t_entry_match *m,
+print_match(const struct xt_entry_match *m,
 	    const struct ip6t_ip6 *ip,
 	    int numeric)
 {
@@ -548,13 +548,13 @@ print_firewall(const struct ip6t_entry *fw,
 	       struct xtc_handle *const handle)
 {
 	const struct xtables_target *target = NULL;
-	const struct ip6t_entry_target *t;
+	const struct xt_entry_target *t;
 	char buf[BUFSIZ];
 
 	if (!ip6tc_is_chain(targname, handle))
 		target = xtables_find_target(targname, XTF_TRY_LOAD);
 	else
-		target = xtables_find_target(IP6T_STANDARD_TARGET,
+		target = xtables_find_target(XT_STANDARD_TARGET,
 		         XTF_LOAD_MUST_SUCCEED);
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
@@ -570,7 +570,7 @@ print_firewall(const struct ip6t_entry *fw,
 	if (!(format & FMT_NOTARGET))
 		printf(FMT("%-9s ", "%s "), targname);
 
-	fputc(fw->ipv6.invflags & IP6T_INV_PROTO ? '!' : ' ', stdout);
+	fputc(fw->ipv6.invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 	{
 		const char *pname = proto_to_name(fw->ipv6.proto, format&FMT_NUMERIC);
 		if (pname)
@@ -669,7 +669,7 @@ static void
 print_firewall_line(const struct ip6t_entry *fw,
 		    struct xtc_handle *const h)
 {
-	struct ip6t_entry_target *t;
+	struct xt_entry_target *t;
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
 	print_firewall(fw, t->u.user.name, 0, FMT_PRINT_RULE, h);
@@ -766,10 +766,10 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	size = sizeof(struct ip6t_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += XT_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
 
 	mask = xtables_calloc(1, size
-			 + XT_ALIGN(sizeof(struct ip6t_entry_target))
+			 + XT_ALIGN(sizeof(struct xt_entry_target))
 			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ip6t_entry));
@@ -777,13 +777,13 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	for (matchp = matches; matchp; matchp = matchp->next) {
 		memset(mptr, 0xFF,
-		       XT_ALIGN(sizeof(struct ip6t_entry_match))
+		       XT_ALIGN(sizeof(struct xt_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += XT_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF,
-	       XT_ALIGN(sizeof(struct ip6t_entry_target))
+	       XT_ALIGN(sizeof(struct xt_entry_target))
 	       + target->userspacesize);
 
 	return mask;
@@ -1033,7 +1033,7 @@ static void print_proto(uint16_t proto, int invert)
 	}
 }
 
-static int print_match_save(const struct ip6t_entry_match *e,
+static int print_match_save(const struct xt_entry_match *e,
 			const struct ip6t_ip6 *ip)
 {
 	const struct xtables_match *match =
@@ -1082,7 +1082,7 @@ static void print_ip(const char *prefix, const struct in6_addr *ip,
 void print_rule6(const struct ip6t_entry *e,
 		       struct xtc_handle *h, const char *chain, int counters)
 {
-	const struct ip6t_entry_target *t;
+	const struct xt_entry_target *t;
 	const char *target_name;
 
 	/* print counters for iptables-save */
@@ -1105,7 +1105,7 @@ void print_rule6(const struct ip6t_entry *e,
 	print_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
 		    e->ipv6.invflags & IP6T_INV_VIA_OUT);
 
-	print_proto(e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
+	print_proto(e->ipv6.proto, e->ipv6.invflags & XT_INV_PROTO);
 
 #if 0
 	/* not definied in ipv6
@@ -1153,11 +1153,11 @@ void print_rule6(const struct ip6t_entry *e,
 		if (target->save)
 			target->save(&e->ipv6, t);
 		else {
-			/* If the target size is greater than ip6t_entry_target
+			/* If the target size is greater than xt_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
 			if (t->u.target_size !=
-			    sizeof(struct ip6t_entry_target)) {
+			    sizeof(struct xt_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
 					t->u.user.name);
@@ -1187,7 +1187,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 			continue;
 
 		if (ip6tc_builtin(this, handle)) {
-			struct ip6t_counters count;
+			struct xt_counters count;
 			printf("-P %s %s", this, ip6tc_get_policy(this, &count, handle));
 			if (counters)
 			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
@@ -1224,7 +1224,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 static struct ip6t_entry *
 generate_entry(const struct ip6t_entry *fw,
 	       struct xtables_rule_match *matches,
-	       struct ip6t_entry_target *target)
+	       struct xt_entry_target *target)
 {
 	unsigned int size;
 	struct xtables_rule_match *matchp;
@@ -1282,7 +1282,7 @@ static void command_jump(struct iptables_command_state *cs)
 	if (cs->target == NULL)
 		return;
 
-	size = XT_ALIGN(sizeof(struct ip6t_entry_target)) + cs->target->size;
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + cs->target->size;
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
@@ -1311,7 +1311,7 @@ static void command_match(struct iptables_command_state *cs)
 			   "unexpected ! flag before --match");
 
 	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
-	size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
@@ -1548,12 +1548,12 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			cs.fw6.ipv6.flags |= IP6T_F_PROTO;
 
 			if (cs.fw6.ipv6.proto == 0
-			    && (cs.fw6.ipv6.invflags & IP6T_INV_PROTO))
+			    && (cs.fw6.ipv6.invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
 			if (is_exthdr(cs.fw6.ipv6.proto)
-			    && (cs.fw6.ipv6.invflags & IP6T_INV_PROTO) == 0)
+			    && (cs.fw6.ipv6.invflags & XT_INV_PROTO) == 0)
 				fprintf(stderr,
 					"Warning: never matched protocol: %s. "
 					"use extension match instead.\n",
@@ -1824,10 +1824,10 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			|| ip6tc_is_chain(cs.jumpto, *handle))) {
 			size_t size;
 
-			cs.target = xtables_find_target(IP6T_STANDARD_TARGET,
+			cs.target = xtables_find_target(XT_STANDARD_TARGET,
 					XTF_LOAD_MUST_SUCCEED);
 
-			size = sizeof(struct ip6t_entry_target)
+			size = sizeof(struct xt_entry_target)
 				+ cs.target->size;
 			cs.target->t = xtables_calloc(1, size);
 			cs.target->t->u.target_size = size;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 7152d75..001da73 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -76,7 +76,7 @@ static struct xtc_handle *create_handle(const char *tablename)
 	return handle;
 }
 
-static int parse_counters(char *string, struct ipt_counters *ctr)
+static int parse_counters(char *string, struct xt_counters *ctr)
 {
 	unsigned long long pcnt, bcnt;
 	int ret;
@@ -119,7 +119,7 @@ iptables_restore_main(int argc, char *argv[])
 	struct xtc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
-	char curtable[IPT_TABLE_MAXNAMELEN + 1];
+	char curtable[XT_TABLE_MAXNAMELEN + 1];
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
@@ -217,8 +217,8 @@ iptables_restore_main(int argc, char *argv[])
 					prog_name, line);
 				exit(1);
 			}
-			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
-			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
+			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
+			curtable[XT_TABLE_MAXNAMELEN] = '\0';
 
 			if (tablename && (strcmp(tablename, table) != 0))
 				continue;
@@ -288,7 +288,7 @@ iptables_restore_main(int argc, char *argv[])
 			}
 
 			if (strcmp(policy, "-") != 0) {
-				struct ipt_counters count;
+				struct xt_counters count;
 
 				if (counters) {
 					char *ctrs;
@@ -300,8 +300,7 @@ iptables_restore_main(int argc, char *argv[])
 							   "for chain '%s'\n", chain);
 
 				} else {
-					memset(&count, 0,
-					       sizeof(struct ipt_counters));
+					memset(&count, 0, sizeof(count));
 				}
 
 				DEBUGP("Setting policy of chain %s to %s\n",
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index ff42f88..e599fce 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -36,7 +36,7 @@ static int for_each_table(int (*func)(const char *tablename))
 {
 	int ret = 1;
 	FILE *procfile = NULL;
-	char tablename[IPT_TABLE_MAXNAMELEN+1];
+	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip_tables_names", "re");
 	if (!procfile)
@@ -87,7 +87,7 @@ static int do_output(const char *tablename)
 
 		printf(":%s ", chain);
 		if (iptc_builtin(chain, h)) {
-			struct ipt_counters count;
+			struct xt_counters count;
 			printf("%s ",
 			       iptc_get_policy(chain, &count, h));
 			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 4ecddcb..4b12bd4 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -56,7 +56,7 @@ print_usage(const char *name, const char *version)
 }
 
 static int
-parse_counters(char *string, struct ipt_counters *ctr)
+parse_counters(char *string, struct xt_counters *ctr)
 {
 	__u64 *pcnt, *bcnt;
 
@@ -81,16 +81,16 @@ static unsigned int oldargc = 0;
 /* arg meta data, were they quoted, frinstance */
 static int newargvattr[255];
 
-#define IPT_CHAIN_MAXNAMELEN IPT_TABLE_MAXNAMELEN
-static char closeActionTag[IPT_TABLE_MAXNAMELEN + 1];
-static char closeRuleTag[IPT_TABLE_MAXNAMELEN + 1];
-static char curTable[IPT_TABLE_MAXNAMELEN + 1];
-static char curChain[IPT_CHAIN_MAXNAMELEN + 1];
+#define XT_CHAIN_MAXNAMELEN XT_TABLE_MAXNAMELEN
+static char closeActionTag[XT_TABLE_MAXNAMELEN + 1];
+static char closeRuleTag[XT_TABLE_MAXNAMELEN + 1];
+static char curTable[XT_TABLE_MAXNAMELEN + 1];
+static char curChain[XT_CHAIN_MAXNAMELEN + 1];
 
 struct chain {
 	char *chain;
 	char *policy;
-	struct ipt_counters count;
+	struct xt_counters count;
 	int created;
 };
 
@@ -233,12 +233,12 @@ closeChain(void)
 }
 
 static void
-openChain(char *chain, char *policy, struct ipt_counters *ctr, char close)
+openChain(char *chain, char *policy, struct xt_counters *ctr, char close)
 {
 	closeChain();
 
-	strncpy(curChain, chain, IPT_CHAIN_MAXNAMELEN);
-	curChain[IPT_CHAIN_MAXNAMELEN] = '\0';
+	strncpy(curChain, chain, XT_CHAIN_MAXNAMELEN);
+	curChain[XT_CHAIN_MAXNAMELEN] = '\0';
 
 	printf("    <chain ");
 	xmlAttrS("name", curChain);
@@ -287,7 +287,7 @@ needChain(char *chain)
 }
 
 static void
-saveChain(char *chain, char *policy, struct ipt_counters *ctr)
+saveChain(char *chain, char *policy, struct xt_counters *ctr)
 {
 	if (nextChain >= maxChains) {
 		xtables_error(PARAMETER_PROBLEM,
@@ -332,8 +332,8 @@ openTable(char *table)
 {
 	closeTable();
 
-	strncpy(curTable, table, IPT_TABLE_MAXNAMELEN);
-	curTable[IPT_TABLE_MAXNAMELEN] = '\0';
+	strncpy(curTable, table, XT_TABLE_MAXNAMELEN);
+	curTable[XT_TABLE_MAXNAMELEN] = '\0';
 
 	printf("  <table ");
 	xmlAttrS("name", curTable);
@@ -592,8 +592,8 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 			xmlAttrS("byte-count", bcnt);
 		printf(">\n");
 
-		strncpy(closeRuleTag, "      </rule>\n", IPT_TABLE_MAXNAMELEN);
-		closeRuleTag[IPT_TABLE_MAXNAMELEN] = '\0';
+		strncpy(closeRuleTag, "      </rule>\n", XT_TABLE_MAXNAMELEN);
+		closeRuleTag[XT_TABLE_MAXNAMELEN] = '\0';
 
 		/* no point in writing out condition if there isn't one */
 		if (argc >= 3 && !isTarget(argv[2])) {
@@ -607,8 +607,8 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 	if (!closeActionTag[0]) {
 		printf("       <actions>\n");
 		strncpy(closeActionTag, "       </actions>\n",
-			IPT_TABLE_MAXNAMELEN);
-		closeActionTag[IPT_TABLE_MAXNAMELEN] = '\0';
+			XT_TABLE_MAXNAMELEN);
+		closeActionTag[XT_TABLE_MAXNAMELEN] = '\0';
 	}
 	do_rule_part(NULL, NULL, 1, argc, argv, argvattr);
 }
@@ -694,7 +694,7 @@ iptables_xml_main(int argc, char *argv[])
 		} else if ((buffer[0] == ':') && (curTable[0])) {
 			/* New chain. */
 			char *policy, *chain;
-			struct ipt_counters count;
+			struct xt_counters count;
 			char *ctrs;
 
 			chain = strtok(buffer + 1, " \t\n");
diff --git a/iptables/iptables.c b/iptables/iptables.c
index d4a7ca1..03ac63b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -171,7 +171,7 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 /* -n */ 0,
 /* -s */ IPT_INV_SRCIP,
 /* -d */ IPT_INV_DSTIP,
-/* -p */ IPT_INV_PROTO,
+/* -p */ XT_INV_PROTO,
 /* -j */ 0,
 /* -v */ 0,
 /* -x */ 0,
@@ -473,7 +473,7 @@ print_num(uint64_t number, unsigned int format)
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
-	struct ipt_counters counters;
+	struct xt_counters counters;
 	const char *pol = iptc_get_policy(chain, &counters, handle);
 	printf("Chain %s", chain);
 	if (pol) {
@@ -521,7 +521,7 @@ print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 
 
 static int
-print_match(const struct ipt_entry_match *m,
+print_match(const struct xt_entry_match *m,
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
@@ -550,14 +550,14 @@ print_firewall(const struct ipt_entry *fw,
 	       struct xtc_handle *const handle)
 {
 	const struct xtables_target *target = NULL;
-	const struct ipt_entry_target *t;
+	const struct xt_entry_target *t;
 	uint8_t flags;
 	char buf[BUFSIZ];
 
 	if (!iptc_is_chain(targname, handle))
 		target = xtables_find_target(targname, XTF_TRY_LOAD);
 	else
-		target = xtables_find_target(IPT_STANDARD_TARGET,
+		target = xtables_find_target(XT_STANDARD_TARGET,
 		         XTF_LOAD_MUST_SUCCEED);
 
 	t = ipt_get_target((struct ipt_entry *)fw);
@@ -574,7 +574,7 @@ print_firewall(const struct ipt_entry *fw,
 	if (!(format & FMT_NOTARGET))
 		printf(FMT("%-9s ", "%s "), targname);
 
-	fputc(fw->ip.invflags & IPT_INV_PROTO ? '!' : ' ', stdout);
+	fputc(fw->ip.invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 	{
 		const char *pname = proto_to_name(fw->ip.proto, format&FMT_NUMERIC);
 		if (pname)
@@ -671,7 +671,7 @@ static void
 print_firewall_line(const struct ipt_entry *fw,
 		    struct xtc_handle *const h)
 {
-	struct ipt_entry_target *t;
+	struct xt_entry_target *t;
 
 	t = ipt_get_target((struct ipt_entry *)fw);
 	print_firewall(fw, t->u.user.name, 0, FMT_PRINT_RULE, h);
@@ -768,10 +768,10 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	size = sizeof(struct ipt_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += XT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
 
 	mask = xtables_calloc(1, size
-			 + XT_ALIGN(sizeof(struct ipt_entry_target))
+			 + XT_ALIGN(sizeof(struct xt_entry_target))
 			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ipt_entry));
@@ -779,13 +779,13 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	for (matchp = matches; matchp; matchp = matchp->next) {
 		memset(mptr, 0xFF,
-		       XT_ALIGN(sizeof(struct ipt_entry_match))
+		       XT_ALIGN(sizeof(struct xt_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += XT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF,
-	       XT_ALIGN(sizeof(struct ipt_entry_target))
+	       XT_ALIGN(sizeof(struct xt_entry_target))
 	       + target->userspacesize);
 
 	return mask;
@@ -1041,7 +1041,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 	}
 }
 
-static int print_match_save(const struct ipt_entry_match *e,
+static int print_match_save(const struct xt_entry_match *e,
 			const struct ipt_ip *ip)
 {
 	const struct xtables_match *match =
@@ -1099,7 +1099,7 @@ static void print_ip(const char *prefix, uint32_t ip,
 void print_rule4(const struct ipt_entry *e,
 		struct xtc_handle *h, const char *chain, int counters)
 {
-	const struct ipt_entry_target *t;
+	const struct xt_entry_target *t;
 	const char *target_name;
 
 	/* print counters for iptables-save */
@@ -1122,7 +1122,7 @@ void print_rule4(const struct ipt_entry *e,
 	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
 		    e->ip.invflags & IPT_INV_VIA_OUT);
 
-	print_proto(e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
+	print_proto(e->ip.proto, e->ip.invflags & XT_INV_PROTO);
 
 	if (e->ip.flags & IPT_F_FRAG)
 		printf("%s -f",
@@ -1161,11 +1161,11 @@ void print_rule4(const struct ipt_entry *e,
 		if (target->save)
 			target->save(&e->ip, t);
 		else {
-			/* If the target size is greater than ipt_entry_target
+			/* If the target size is greater than xt_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
 			if (t->u.target_size !=
-			    sizeof(struct ipt_entry_target)) {
+			    sizeof(struct xt_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
 					t->u.user.name);
@@ -1195,7 +1195,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 			continue;
 
 		if (iptc_builtin(this, handle)) {
-			struct ipt_counters count;
+			struct xt_counters count;
 			printf("-P %s %s", this, iptc_get_policy(this, &count, handle));
 			if (counters)
 			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
@@ -1232,7 +1232,7 @@ list_rules(const xt_chainlabel chain, int rulenum, int counters,
 static struct ipt_entry *
 generate_entry(const struct ipt_entry *fw,
 	       struct xtables_rule_match *matches,
-	       struct ipt_entry_target *target)
+	       struct xt_entry_target *target)
 {
 	unsigned int size;
 	struct xtables_rule_match *matchp;
@@ -1290,7 +1290,7 @@ static void command_jump(struct iptables_command_state *cs)
 	if (cs->target == NULL)
 		return;
 
-	size = XT_ALIGN(sizeof(struct ipt_entry_target))
+	size = XT_ALIGN(sizeof(struct xt_entry_target))
 		+ cs->target->size;
 
 	cs->target->t = xtables_calloc(1, size);
@@ -1321,7 +1321,7 @@ static void command_match(struct iptables_command_state *cs)
 			   "unexpected ! flag before --match");
 
 	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
-	size = XT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
+	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
@@ -1559,7 +1559,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			cs.fw.ip.proto = xtables_parse_protocol(cs.protocol);
 
 			if (cs.fw.ip.proto == 0
-			    && (cs.fw.ip.invflags & IPT_INV_PROTO))
+			    && (cs.fw.ip.invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 			break;
@@ -1837,10 +1837,10 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			|| iptc_is_chain(cs.jumpto, *handle))) {
 			size_t size;
 
-			cs.target = xtables_find_target(IPT_STANDARD_TARGET,
+			cs.target = xtables_find_target(XT_STANDARD_TARGET,
 					 XTF_LOAD_MUST_SUCCEED);
 
-			size = sizeof(struct ipt_entry_target)
+			size = sizeof(struct xt_entry_target)
 				+ cs.target->size;
 			cs.target->t = xtables_calloc(1, size);
 			cs.target->t->u.target_size = size;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 79da507..e61c28c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -139,7 +139,7 @@ int command_default(struct iptables_command_state *cs,
 
 		cs->proto_used = 1;
 
-		size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+		size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 
 		m->m = xtables_calloc(1, size);
 		m->m->u.match_size = size;
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index cf29238..c55cbc7 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -37,23 +37,23 @@ typedef unsigned int socklen_t;
 #define HOOK_LOCAL_OUT		NF_IP_LOCAL_OUT
 #define HOOK_POST_ROUTING	NF_IP_POST_ROUTING
 
-#define STRUCT_ENTRY_TARGET	struct ipt_entry_target
+#define STRUCT_ENTRY_TARGET	struct xt_entry_target
 #define STRUCT_ENTRY		struct ipt_entry
-#define STRUCT_ENTRY_MATCH	struct ipt_entry_match
+#define STRUCT_ENTRY_MATCH	struct xt_entry_match
 #define STRUCT_GETINFO		struct ipt_getinfo
 #define STRUCT_GET_ENTRIES	struct ipt_get_entries
-#define STRUCT_COUNTERS		struct ipt_counters
-#define STRUCT_COUNTERS_INFO	struct ipt_counters_info
-#define STRUCT_STANDARD_TARGET	struct ipt_standard_target
+#define STRUCT_COUNTERS		struct xt_counters
+#define STRUCT_COUNTERS_INFO	struct xt_counters_info
+#define STRUCT_STANDARD_TARGET	struct xt_standard_target
 #define STRUCT_REPLACE		struct ipt_replace
 
 #define ENTRY_ITERATE		IPT_ENTRY_ITERATE
-#define TABLE_MAXNAMELEN	IPT_TABLE_MAXNAMELEN
-#define FUNCTION_MAXNAMELEN	IPT_FUNCTION_MAXNAMELEN
+#define TABLE_MAXNAMELEN	XT_TABLE_MAXNAMELEN
+#define FUNCTION_MAXNAMELEN	XT_FUNCTION_MAXNAMELEN
 
 #define GET_TARGET		ipt_get_target
 
-#define ERROR_TARGET		IPT_ERROR_TARGET
+#define ERROR_TARGET		XT_ERROR_TARGET
 #define NUMHOOKS		NF_IP_NUMHOOKS
 
 #define IPT_CHAINLABEL		xt_chainlabel
@@ -100,14 +100,14 @@ typedef unsigned int socklen_t;
 #define SO_GET_ENTRIES		IPT_SO_GET_ENTRIES
 #define SO_GET_VERSION		IPT_SO_GET_VERSION
 
-#define STANDARD_TARGET		IPT_STANDARD_TARGET
+#define STANDARD_TARGET		XT_STANDARD_TARGET
 #define LABEL_RETURN		IPTC_LABEL_RETURN
 #define LABEL_ACCEPT		IPTC_LABEL_ACCEPT
 #define LABEL_DROP		IPTC_LABEL_DROP
 #define LABEL_QUEUE		IPTC_LABEL_QUEUE
 
 #define ALIGN			XT_ALIGN
-#define RETURN			IPT_RETURN
+#define RETURN			XT_RETURN
 
 #include "libiptc.c"
 
@@ -160,7 +160,7 @@ dump_entry(struct ipt_entry *e, struct xtc_handle *const handle)
 			       : "UNKNOWN");
 		else
 			printf("verdict=%u\n", pos);
-	} else if (strcmp(t->u.user.name, IPT_ERROR_TARGET) == 0)
+	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0)
 		printf("error=`%s'\n", t->data);
 
 	printf("\n");
@@ -203,7 +203,7 @@ is_same(const STRUCT_ENTRY *a, const STRUCT_ENTRY *b, unsigned char *matchmask)
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IPT_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
-	mptr += XT_ALIGN(sizeof(struct ipt_entry_target));
+	mptr += XT_ALIGN(sizeof(struct xt_entry_target));
 
 	return mptr;
 }
@@ -271,14 +271,14 @@ check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 
 			idx = iptcb_entry2index(h, te);
 			assert(strcmp(GET_TARGET(te)->u.user.name,
-				      IPT_ERROR_TARGET)
+				      XT_ERROR_TARGET)
 			       != 0);
 			assert(te != e);
 
 			/* Prior node must be error node, or this node. */
 			assert(t->verdict == iptcb_entry2offset(h, e)+e->next_offset
 			       || strcmp(GET_TARGET(index2entry(h, idx-1))
-					 ->u.user.name, IPT_ERROR_TARGET)
+					 ->u.user.name, XT_ERROR_TARGET)
 			       == 0);
 		}
 
@@ -288,7 +288,7 @@ check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 			*was_return = 1;
 		else
 			*was_return = 0;
-	} else if (strcmp(t->target.u.user.name, IPT_ERROR_TARGET) == 0) {
+	} else if (strcmp(t->target.u.user.name, XT_ERROR_TARGET) == 0) {
 		assert(t->target.u.target_size
 		       == ALIGN(sizeof(struct ipt_error_target)));
 
@@ -301,7 +301,7 @@ check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 	else *was_return = 0;
 
 	if (*off == user_offset)
-		assert(strcmp(t->target.u.user.name, IPT_ERROR_TARGET) == 0);
+		assert(strcmp(t->target.u.user.name, XT_ERROR_TARGET) == 0);
 
 	(*off) += e->next_offset;
 	(*i)++;
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 636466f..9febee3 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -35,23 +35,23 @@ typedef unsigned int socklen_t;
 #define HOOK_LOCAL_OUT		NF_IP6_LOCAL_OUT
 #define HOOK_POST_ROUTING	NF_IP6_POST_ROUTING
 
-#define STRUCT_ENTRY_TARGET	struct ip6t_entry_target
+#define STRUCT_ENTRY_TARGET	struct xt_entry_target
 #define STRUCT_ENTRY		struct ip6t_entry
-#define STRUCT_ENTRY_MATCH	struct ip6t_entry_match
+#define STRUCT_ENTRY_MATCH	struct xt_entry_match
 #define STRUCT_GETINFO		struct ip6t_getinfo
 #define STRUCT_GET_ENTRIES	struct ip6t_get_entries
-#define STRUCT_COUNTERS		struct ip6t_counters
-#define STRUCT_COUNTERS_INFO	struct ip6t_counters_info
-#define STRUCT_STANDARD_TARGET	struct ip6t_standard_target
+#define STRUCT_COUNTERS		struct xt_counters
+#define STRUCT_COUNTERS_INFO	struct xt_counters_info
+#define STRUCT_STANDARD_TARGET	struct xt_standard_target
 #define STRUCT_REPLACE		struct ip6t_replace
 
 #define ENTRY_ITERATE		IP6T_ENTRY_ITERATE
-#define TABLE_MAXNAMELEN	IP6T_TABLE_MAXNAMELEN
-#define FUNCTION_MAXNAMELEN	IP6T_FUNCTION_MAXNAMELEN
+#define TABLE_MAXNAMELEN	XT_TABLE_MAXNAMELEN
+#define FUNCTION_MAXNAMELEN	XT_FUNCTION_MAXNAMELEN
 
 #define GET_TARGET		ip6t_get_target
 
-#define ERROR_TARGET		IP6T_ERROR_TARGET
+#define ERROR_TARGET		XT_ERROR_TARGET
 #define NUMHOOKS		NF_IP6_NUMHOOKS
 
 #define IPT_CHAINLABEL		xt_chainlabel
@@ -98,14 +98,14 @@ typedef unsigned int socklen_t;
 #define SO_GET_ENTRIES		IP6T_SO_GET_ENTRIES
 #define SO_GET_VERSION		IP6T_SO_GET_VERSION
 
-#define STANDARD_TARGET		IP6T_STANDARD_TARGET
+#define STANDARD_TARGET		XT_STANDARD_TARGET
 #define LABEL_RETURN		IP6TC_LABEL_RETURN
 #define LABEL_ACCEPT		IP6TC_LABEL_ACCEPT
 #define LABEL_DROP		IP6TC_LABEL_DROP
 #define LABEL_QUEUE		IP6TC_LABEL_QUEUE
 
 #define ALIGN			XT_ALIGN
-#define RETURN			IP6T_RETURN
+#define RETURN			XT_RETURN
 
 #include "libiptc.c"
 
@@ -133,7 +133,7 @@ dump_entry(struct ip6t_entry *e, struct xtc_handle *const handle)
 	size_t i;
 	char buf[40];
 	int len;
-	struct ip6t_entry_target *t;
+	struct xt_entry_target *t;
 	
 	printf("Entry %u (%lu):\n", iptcb_entry2index(handle, e),
 	       iptcb_entry2offset(handle, e));
@@ -182,18 +182,18 @@ dump_entry(struct ip6t_entry *e, struct xtc_handle *const handle)
 
 	t = ip6t_get_target(e);
 	printf("Target name: `%s' [%u]\n", t->u.user.name, t->u.target_size);
-	if (strcmp(t->u.user.name, IP6T_STANDARD_TARGET) == 0) {
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0) {
 		const unsigned char *data = t->data;
 		int pos = *(const int *)data;
 		if (pos < 0)
 			printf("verdict=%s\n",
 			       pos == -NF_ACCEPT-1 ? "NF_ACCEPT"
 			       : pos == -NF_DROP-1 ? "NF_DROP"
-			       : pos == IP6T_RETURN ? "RETURN"
+			       : pos == XT_RETURN ? "RETURN"
 			       : "UNKNOWN");
 		else
 			printf("verdict=%u\n", pos);
-	} else if (strcmp(t->u.user.name, IP6T_ERROR_TARGET) == 0)
+	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0)
 		printf("error=`%s'\n", t->data);
 
 	printf("\n");
@@ -238,7 +238,7 @@ is_same(const STRUCT_ENTRY *a, const STRUCT_ENTRY *b,
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IP6T_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
-	mptr += XT_ALIGN(sizeof(struct ip6t_entry_target));
+	mptr += XT_ALIGN(sizeof(struct xt_entry_target));
 
 	return mptr;
 }
-- 
1.7.3.4

