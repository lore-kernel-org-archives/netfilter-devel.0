From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [03/10] [IPTABLES]: Fix -Wshadow warnings
Date: Fri, 1 Feb 2008 01:28:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010128220.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38763 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYBAA2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:28:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix -Wshadow warnings.
Update deshadowed xt_sctp.h from kernel.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 configure.ac                      |    3 -
 extensions/libipt_SAME.c          |   12 ++---
 extensions/libipt_addrtype.c      |    4 -
 extensions/libxt_RATEEST.c        |   12 ++---
 extensions/libxt_conntrack.c      |   28 ++++++-------
 extensions/libxt_hashlimit.c      |    4 -
 extensions/libxt_state.c          |   12 ++---
 extensions/libxt_statistic.c      |   23 +++++++---
 include/linux/netfilter/xt_sctp.h |   81 +++++++++++++++-----------------------
 include/xtables.h                 |    2 
 ip6tables-save.c                  |   10 ++--
 ip6tables.c                       |   12 ++---
 iptables-save.c                   |   10 ++--
 iptables-xml.c                    |    7 +--
 iptables.c                        |   12 ++---
 libiptc/libiptc.c                 |   49 ++++++++++------------
 xtables.c                         |    4 -
 17 files changed, 136 insertions(+), 149 deletions(-)

Index: iptables/configure.ac
===================================================================
--- iptables.orig/configure.ac
+++ iptables/configure.ac
@@ -46,8 +46,7 @@ kinclude_CFLAGS="-I\"$kbuilddir/include\
 # Remove workarounds soon
 regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
 	-Wno-missing-declarations -Wno-missing-prototypes \
-        -Wno-unused-parameter \
-	-Wno-shadow -Wno-inline"
+        -Wno-unused-parameter"
 
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
Index: iptables/extensions/libipt_SAME.c
===================================================================
--- iptables.orig/extensions/libipt_SAME.c
+++ iptables/extensions/libipt_SAME.c
@@ -149,7 +149,7 @@ static void SAME_print(const void *ip, c
 	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
-	int random = 0;
+	int random_selection = 0;
 	
 	printf("same:");
 	
@@ -167,13 +167,13 @@ static void SAME_print(const void *ip, c
 		else
 			printf("-%s ", ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
-			random = 1;
+			random_selection = 1;
 	}
 	
 	if (mr->info & IPT_SAME_NODST)
 		printf("nodst ");
 
-	if (random)
+	if (random_selection)
 		printf("random ");
 }
 
@@ -183,7 +183,7 @@ static void SAME_save(const void *ip, co
 	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
-	int random = 0;
+	int random_selection = 0;
 
 	for (count = 0; count < mr->rangesize; count++) {
 		struct ip_nat_range *r = &mr->range[count];
@@ -198,13 +198,13 @@ static void SAME_save(const void *ip, co
 		else
 			printf("-%s ", ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
-			random = 1;
+			random_selection = 1;
 	}
 	
 	if (mr->info & IPT_SAME_NODST)
 		printf("--nodst ");
 
-	if (random)
+	if (random_selection)
 		printf("--random ");
 }
 
Index: iptables/extensions/libipt_addrtype.c
===================================================================
--- iptables.orig/extensions/libipt_addrtype.c
+++ iptables/extensions/libipt_addrtype.c
@@ -49,12 +49,12 @@ static void addrtype_help(void)
 }
 
 static int
-parse_type(const char *name, size_t strlen, u_int16_t *mask)
+parse_type(const char *name, size_t len, u_int16_t *mask)
 {
 	int i;
 
 	for (i = 0; rtn_names[i]; i++)
-		if (strncasecmp(name, rtn_names[i], strlen) == 0) {
+		if (strncasecmp(name, rtn_names[i], len) == 0) {
 			/* build up bitmask for kernel module */
 			*mask |= (1 << i);
 			return 1;
Index: iptables/extensions/libxt_RATEEST.c
===================================================================
--- iptables.orig/extensions/libxt_RATEEST.c
+++ iptables/extensions/libxt_RATEEST.c
@@ -177,17 +177,17 @@ static void
 __RATEEST_print(const struct xt_entry_target *target, const char *prefix)
 {
 	struct xt_rateest_target_info *info = (void *)target->data;
-	unsigned int interval;
-	unsigned int ewma_log;
+	unsigned int local_interval;
+	unsigned int local_ewma_log;
 
-	interval = (TIME_UNITS_PER_SEC << (info->interval + 2)) / 4;
-	ewma_log = interval * (1 << (info->ewma_log));
+	local_interval = (TIME_UNITS_PER_SEC << (info->interval + 2)) / 4;
+	local_ewma_log = local_interval * (1 << (info->ewma_log));
 
 	printf("%sname %s ", prefix, info->name);
 	printf("%sinterval ", prefix);
-	RATEEST_print_time(interval);
+	RATEEST_print_time(local_interval);
 	printf("%sewmalog ", prefix);
-	RATEEST_print_time(ewma_log);
+	RATEEST_print_time(local_ewma_log);
 }
 
 static void
Index: iptables/extensions/libxt_conntrack.c
===================================================================
--- iptables.orig/extensions/libxt_conntrack.c
+++ iptables/extensions/libxt_conntrack.c
@@ -78,21 +78,21 @@ static const struct option conntrack_mt_
 };
 
 static int
-parse_state(const char *state, size_t strlen, struct xt_conntrack_info *sinfo)
+parse_state(const char *state, size_t len, struct xt_conntrack_info *sinfo)
 {
-	if (strncasecmp(state, "INVALID", strlen) == 0)
+	if (strncasecmp(state, "INVALID", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_INVALID;
-	else if (strncasecmp(state, "NEW", strlen) == 0)
+	else if (strncasecmp(state, "NEW", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_NEW);
-	else if (strncasecmp(state, "ESTABLISHED", strlen) == 0)
+	else if (strncasecmp(state, "ESTABLISHED", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED);
-	else if (strncasecmp(state, "RELATED", strlen) == 0)
+	else if (strncasecmp(state, "RELATED", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_RELATED);
-	else if (strncasecmp(state, "UNTRACKED", strlen) == 0)
+	else if (strncasecmp(state, "UNTRACKED", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_UNTRACKED;
-	else if (strncasecmp(state, "SNAT", strlen) == 0)
+	else if (strncasecmp(state, "SNAT", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_SNAT;
-	else if (strncasecmp(state, "DNAT", strlen) == 0)
+	else if (strncasecmp(state, "DNAT", len) == 0)
 		sinfo->statemask |= XT_CONNTRACK_STATE_DNAT;
 	else
 		return 0;
@@ -154,18 +154,18 @@ conntrack_ps_states(struct xt_conntrack_
 }
 
 static int
-parse_status(const char *status, size_t strlen, struct xt_conntrack_info *sinfo)
+parse_status(const char *status, size_t len, struct xt_conntrack_info *sinfo)
 {
-	if (strncasecmp(status, "NONE", strlen) == 0)
+	if (strncasecmp(status, "NONE", len) == 0)
 		sinfo->statusmask |= 0;
-	else if (strncasecmp(status, "EXPECTED", strlen) == 0)
+	else if (strncasecmp(status, "EXPECTED", len) == 0)
 		sinfo->statusmask |= IPS_EXPECTED;
-	else if (strncasecmp(status, "SEEN_REPLY", strlen) == 0)
+	else if (strncasecmp(status, "SEEN_REPLY", len) == 0)
 		sinfo->statusmask |= IPS_SEEN_REPLY;
-	else if (strncasecmp(status, "ASSURED", strlen) == 0)
+	else if (strncasecmp(status, "ASSURED", len) == 0)
 		sinfo->statusmask |= IPS_ASSURED;
 #ifdef IPS_CONFIRMED
-	else if (strncasecmp(status, "CONFIRMED", strlen) == 0)
+	else if (strncasecmp(status, "CONFIRMED", len) == 0)
 		sinfo->statusmask |= IPS_CONFIRMED;
 #endif
 	else
Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -106,10 +106,10 @@ static void hashlimit_init(struct xt_ent
 
 
 /* Parse a 'mode' parameter into the required bitmask */
-static int parse_mode(struct xt_hashlimit_info *r, char *optarg)
+static int parse_mode(struct xt_hashlimit_info *r, char *option_arg)
 {
 	char *tok;
-	char *arg = strdup(optarg);
+	char *arg = strdup(option_arg);
 
 	if (!arg)
 		return -1;
Index: iptables/extensions/libxt_state.c
===================================================================
--- iptables.orig/extensions/libxt_state.c
+++ iptables/extensions/libxt_state.c
@@ -29,17 +29,17 @@ static const struct option state_opts[] 
 };
 
 static int
-state_parse_state(const char *state, size_t strlen, struct xt_state_info *sinfo)
+state_parse_state(const char *state, size_t len, struct xt_state_info *sinfo)
 {
-	if (strncasecmp(state, "INVALID", strlen) == 0)
+	if (strncasecmp(state, "INVALID", len) == 0)
 		sinfo->statemask |= XT_STATE_INVALID;
-	else if (strncasecmp(state, "NEW", strlen) == 0)
+	else if (strncasecmp(state, "NEW", len) == 0)
 		sinfo->statemask |= XT_STATE_BIT(IP_CT_NEW);
-	else if (strncasecmp(state, "ESTABLISHED", strlen) == 0)
+	else if (strncasecmp(state, "ESTABLISHED", len) == 0)
 		sinfo->statemask |= XT_STATE_BIT(IP_CT_ESTABLISHED);
-	else if (strncasecmp(state, "RELATED", strlen) == 0)
+	else if (strncasecmp(state, "RELATED", len) == 0)
 		sinfo->statemask |= XT_STATE_BIT(IP_CT_RELATED);
-	else if (strncasecmp(state, "UNTRACKED", strlen) == 0)
+	else if (strncasecmp(state, "UNTRACKED", len) == 0)
 		sinfo->statemask |= XT_STATE_UNTRACKED;
 	else
 		return 0;
Index: iptables/extensions/libxt_statistic.c
===================================================================
--- iptables.orig/extensions/libxt_statistic.c
+++ iptables/extensions/libxt_statistic.c
@@ -30,16 +30,20 @@ static const struct option statistic_opt
 	{},
 };
 
-static struct xt_statistic_info *info;
+static struct xt_statistic_info *global_info;
+
+static void statistic_mt_init(struct xt_entry_match *match)
+{
+	global_info = (void *)match->data;
+}
 
 static int
 statistic_parse(int c, char **argv, int invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
+	struct xt_statistic_info *info = (void *)(*match)->data;
 	double prob;
 
-	info = (void *)(*match)->data;
-
 	if (invert)
 		info->flags |= XT_STATISTIC_INVERT;
 
@@ -100,25 +104,26 @@ static void statistic_check(unsigned int
 	if ((flags & 0x2) && (flags & (0x4 | 0x8)))
 		exit_error(PARAMETER_PROBLEM,
 			   "both nth and random parameters given");
-	if (flags & 0x2 && info->mode != XT_STATISTIC_MODE_RANDOM)
+	if (flags & 0x2 && global_info->mode != XT_STATISTIC_MODE_RANDOM)
 		exit_error(PARAMETER_PROBLEM,
 			   "--probability can only be used in random mode");
-	if (flags & 0x4 && info->mode != XT_STATISTIC_MODE_NTH)
+	if (flags & 0x4 && global_info->mode != XT_STATISTIC_MODE_NTH)
 		exit_error(PARAMETER_PROBLEM,
 			   "--every can only be used in nth mode");
-	if (flags & 0x8 && info->mode != XT_STATISTIC_MODE_NTH)
+	if (flags & 0x8 && global_info->mode != XT_STATISTIC_MODE_NTH)
 		exit_error(PARAMETER_PROBLEM,
 			   "--packet can only be used in nth mode");
 	if ((flags & 0x8) && !(flags & 0x4))
 		exit_error(PARAMETER_PROBLEM,
 			   "--packet can only be used with --every");
 	/* at this point, info->u.nth.every have been decreased. */
-	if (info->u.nth.packet > info->u.nth.every)
+	if (global_info->u.nth.packet > global_info->u.nth.every)
 		exit_error(PARAMETER_PROBLEM,
 			  "the --packet p must be 0 <= p <= n-1");
 
 
-	info->u.nth.count = info->u.nth.every - info->u.nth.packet;
+	global_info->u.nth.count = global_info->u.nth.every -
+	                           global_info->u.nth.packet;
 }
 
 /* Prints out the matchinfo. */
@@ -164,6 +169,7 @@ static struct xtables_match statistic_ma
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
+	.init		= statistic_mt_init,
 	.help		= statistic_help,
 	.parse		= statistic_parse,
 	.final_check	= statistic_check,
@@ -178,6 +184,7 @@ static struct xtables_match statistic_ma
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
+	.init		= statistic_mt_init,
 	.help		= statistic_help,
 	.parse		= statistic_parse,
 	.final_check	= statistic_check,
Index: iptables/include/linux/netfilter/xt_sctp.h
===================================================================
--- iptables.orig/include/linux/netfilter/xt_sctp.h
+++ iptables/include/linux/netfilter/xt_sctp.h
@@ -7,7 +7,8 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
-#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
+/* temporary */
+#define SCTP_ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 
 
 struct xt_sctp_flag_info {
@@ -40,68 +41,54 @@ struct xt_sctp_info {
 
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
-		chunkmap[type / bytes(u_int32_t)] |= 	\
+		(chunkmap)[type / bytes(u_int32_t)] |= 	\
 			1 << (type % bytes(u_int32_t));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
-		chunkmap[type / bytes(u_int32_t)] &= 		\
+		(chunkmap)[type / bytes(u_int32_t)] &= 		\
 			~(1 << (type % bytes(u_int32_t)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
-	(chunkmap[type / bytes (u_int32_t)] & 			\
+	((chunkmap)[type / bytes (u_int32_t)] & 		\
 		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
 })
 
-#define SCTP_CHUNKMAP_RESET(chunkmap) 				\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
-			chunkmap[i] = 0;			\
-	} while (0)
+#define SCTP_CHUNKMAP_RESET(chunkmap) \
+	memset((chunkmap), 0, sizeof(chunkmap))
 
-#define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
-			chunkmap[i] = ~0;			\
-	} while (0)
+#define SCTP_CHUNKMAP_SET_ALL(chunkmap) \
+	memset((chunkmap), ~0U, sizeof(chunkmap))
 
-#define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
-	do {							\
-		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
-			destmap[i] = srcmap[i];			\
-	} while (0)
-
-#define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) 		\
-({							\
-	int i; 						\
-	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
-		if (chunkmap[i]) {			\
-			flag = 0;			\
-			break;				\
-		}					\
-	}						\
-        flag;						\
-})
+#define SCTP_CHUNKMAP_COPY(destmap, srcmap) \
+	memcpy((destmap), (srcmap), sizeof(srcmap))
 
-#define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) 		\
-({							\
-	int i; 						\
-	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
-		if (chunkmap[i] != ~0) {		\
-			flag = 0;			\
-				break;			\
-		}					\
-	}						\
-        flag;						\
-})
+#define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
+	__sctp_chunkmap_is_clear((chunkmap), SCTP_ARRAY_SIZE(chunkmap))
+static inline bool
+__sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
+{
+	unsigned int i;
+	for (i = 0; i < n; ++i)
+		if (chunkmap[i])
+			return false;
+	return true;
+}
+
+#define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
+	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
+static inline bool
+__sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
+{
+	unsigned int i;
+	for (i = 0; i < n; ++i)
+		if (chunkmap[i] != ~0U)
+			return false;
+	return true;
+}
 
 #endif /* _XT_SCTP_H_ */
 
Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -176,7 +176,7 @@ extern char *lib_dir;
 extern void *fw_calloc(size_t count, size_t size);
 extern void *fw_malloc(size_t size);
 
-extern const char *modprobe;
+extern const char *modprobe_program;
 extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
 extern int load_xtables_ko(const char *modprobe, int quiet);
 
Index: iptables/ip6tables-save.c
===================================================================
--- iptables.orig/ip6tables-save.c
+++ iptables/ip6tables-save.c
@@ -21,7 +21,7 @@
 #include <dlfcn.h>
 #endif
 
-static int binary = 0, counters = 0;
+static int show_binary = 0, show_counters = 0;
 
 static struct option options[] = {
 	{ "binary", 0, 0, 'b' },
@@ -264,7 +264,7 @@ static int do_output(const char *tablena
 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   ip6tc_strerror(errno));
 
-	if (!binary) {
+	if (!show_binary) {
 		time_t now = time(NULL);
 
 		printf("# Generated by ip6tables-save v%s on %s",
@@ -297,7 +297,7 @@ static int do_output(const char *tablena
 			/* Dump out rules */
 			e = ip6tc_first_rule(chain, &h);
 			while(e) {
-				print_rule(e, &h, chain, counters);
+				print_rule(e, &h, chain, show_counters);
 				e = ip6tc_next_rule(e, &h);
 			}
 		}
@@ -342,11 +342,11 @@ int main(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
-			binary = 1;
+			show_binary = 1;
 			break;
 
 		case 'c':
-			counters = 1;
+			show_counters = 1;
 			break;
 
 		case 't':
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -440,16 +440,16 @@ add_command(unsigned int *cmd, const int
 }
 
 int
-check_inverse(const char option[], int *invert, int *optind, int argc)
+check_inverse(const char option[], int *invert, int *my_optind, int argc)
 {
 	if (option && strcmp(option, "!") == 0) {
 		if (*invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "Multiple `!' flags not allowed");
 		*invert = TRUE;
-		if (optind) {
-			*optind = *optind+1;
-			if (argc && *optind > argc)
+		if (my_optind != NULL) {
+			++*my_optind;
+			if (argc && *my_optind > argc)
 				exit_error(PARAMETER_PROBLEM,
 					   "no argument following `!'");
 		}
@@ -1492,7 +1492,7 @@ int do_command6(int argc, char *argv[], 
 			break;
 
 		case 'M':
-			modprobe = optarg;
+			modprobe_program = optarg;
 			break;
 
 		case 'c':
@@ -1673,7 +1673,7 @@ int do_command6(int argc, char *argv[], 
 		*handle = ip6tc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_xtables_ko(modprobe, 0) != -1)
+	if (!*handle && load_xtables_ko(modprobe_program, 0) != -1)
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -20,7 +20,7 @@
 #include <dlfcn.h>
 #endif
 
-static int binary = 0, counters = 0;
+static int show_binary = 0, show_counters = 0;
 
 static struct option options[] = {
 	{ "binary", 0, 0, 'b' },
@@ -287,7 +287,7 @@ static int do_output(const char *tablena
 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   iptc_strerror(errno));
 
-	if (!binary) {
+	if (!show_binary) {
 		time_t now = time(NULL);
 
 		printf("# Generated by iptables-save v%s on %s",
@@ -320,7 +320,7 @@ static int do_output(const char *tablena
 			/* Dump out rules */
 			e = iptc_first_rule(chain, &h);
 			while(e) {
-				print_rule(e, &h, chain, counters);
+				print_rule(e, &h, chain, show_counters);
 				e = iptc_next_rule(e, &h);
 			}
 		}
@@ -367,11 +367,11 @@ main(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
-			binary = 1;
+			show_binary = 1;
 			break;
 
 		case 'c':
-			counters = 1;
+			show_counters = 1;
 			break;
 
 		case 't':
Index: iptables/iptables-xml.c
===================================================================
--- iptables.orig/iptables-xml.c
+++ iptables/iptables-xml.c
@@ -99,16 +99,15 @@ char closeRuleTag[IPT_TABLE_MAXNAMELEN +
 char curTable[IPT_TABLE_MAXNAMELEN + 1];
 char curChain[IPT_CHAIN_MAXNAMELEN + 1];
 
-typedef struct chain
-{
+struct chain {
 	char *chain;
 	char *policy;
 	struct ipt_counters count;
 	int created;
-} chain;
+};
 
 #define maxChains 10240		/* max chains per table */
-static chain chains[maxChains];
+static struct chain chains[maxChains];
 static int nextChain = 0;
 
 /* funCtion adding one argument to newargv, updating newargc 
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -447,16 +447,16 @@ add_command(unsigned int *cmd, const int
 }
 
 int
-check_inverse(const char option[], int *invert, int *optind, int argc)
+check_inverse(const char option[], int *invert, int *my_optind, int argc)
 {
 	if (option && strcmp(option, "!") == 0) {
 		if (*invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "Multiple `!' flags not allowed");
 		*invert = TRUE;
-		if (optind) {
-			*optind = *optind+1;
-			if (argc && *optind > argc)
+		if (my_optind != NULL) {
+			++*my_optind;
+			if (argc && *my_optind > argc)
 				exit_error(PARAMETER_PROBLEM,
 					   "no argument following `!'");
 		}
@@ -1529,7 +1529,7 @@ int do_command(int argc, char *argv[], c
 			break;
 
 		case 'M':
-			modprobe = optarg;
+			modprobe_program = optarg;
 			break;
 
 		case 'c':
@@ -1712,7 +1712,7 @@ int do_command(int argc, char *argv[], c
 		*handle = iptc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_xtables_ko(modprobe, 0) != -1)
+	if (!*handle && load_xtables_ko(modprobe_program, 0) != -1)
 		*handle = iptc_init(*table);
 
 	if (!*handle)
Index: iptables/libiptc/libiptc.c
===================================================================
--- iptables.orig/libiptc/libiptc.c
+++ iptables/libiptc/libiptc.c
@@ -317,7 +317,7 @@ static inline unsigned int iptcc_is_buil
  * is sorted by name.
  */
 static struct list_head *
-iptcc_bsearch_chain_index(const char *name, unsigned int *index, TC_HANDLE_T handle)
+iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handle)
 {
 	unsigned int pos, end;
 	int res;
@@ -346,7 +346,7 @@ iptcc_bsearch_chain_index(const char *na
 
 	res = strcmp(name, handle->chain_index[pos]->name);
 	list_pos = &handle->chain_index[pos]->list;
-	(*index)=pos;
+	*idx = pos;
 
 	debug("bsearch Index[%d] name:%s res:%d ",
 	      pos, handle->chain_index[pos]->name, res);
@@ -536,9 +536,9 @@ static int iptcc_chain_index_delete_chai
 {
 	struct list_head *index_ptr, *index_ptr2, *next;
 	struct chain_head *c2;
-	unsigned int index, index2;
+	unsigned int idx, idx2;
 
-	index_ptr = iptcc_bsearch_chain_index(c->name, &index, h);
+	index_ptr = iptcc_bsearch_chain_index(c->name, &idx, h);
 
 	debug("Del chain[%s] c->list:%p index_ptr:%p\n",
 	      c->name, &c->list, index_ptr);
@@ -554,15 +554,15 @@ static int iptcc_chain_index_delete_chai
 		 * is located in the same index bucket.
 		 */
 		c2         = list_entry(next, struct chain_head, list);
-		index_ptr2 = iptcc_bsearch_chain_index(c2->name, &index2, h);
-		if (index != index2) {
+		index_ptr2 = iptcc_bsearch_chain_index(c2->name, &idx2, h);
+		if (idx != idx2) {
 			/* Rebuild needed */
 			return iptcc_chain_index_rebuild(h);
 		} else {
 			/* Avoiding rebuild */
 			debug("Update cindex[%d] with next ptr name:[%s]\n",
-			      index, c2->name);
-			h->chain_index[index]=c2;
+			      idx, c2->name);
+			h->chain_index[idx]=c2;
 			return 0;
 		}
 	}
@@ -962,18 +962,18 @@ static int parse_table(TC_HANDLE_T h)
 	list_for_each_entry(c, &h->chains, list) {
 		struct rule_head *r;
 		list_for_each_entry(r, &c->rules, list) {
-			struct chain_head *c;
+			struct chain_head *lc;
 			STRUCT_STANDARD_TARGET *t;
 
 			if (r->type != IPTCC_R_JUMP)
 				continue;
 
 			t = (STRUCT_STANDARD_TARGET *)GET_TARGET(r->entry);
-			c = iptcc_find_chain_by_offset(h, t->verdict);
-			if (!c)
+			lc = iptcc_find_chain_by_offset(h, t->verdict);
+			if (!lc)
 				return -1;
-			r->jump = c;
-			c->references++;
+			r->jump = lc;
+			lc->references++;
 		}
 	}
 
@@ -2395,16 +2395,14 @@ subtract_counters(STRUCT_COUNTERS *answe
 }
 
 
-static void counters_nomap(STRUCT_COUNTERS_INFO *newcounters,
-			   unsigned int index)
+static void counters_nomap(STRUCT_COUNTERS_INFO *newcounters, unsigned int idx)
 {
-	newcounters->counters[index] = ((STRUCT_COUNTERS) { 0, 0});
+	newcounters->counters[idx] = ((STRUCT_COUNTERS) { 0, 0});
 	DEBUGP_C("NOMAP => zero\n");
 }
 
 static void counters_normal_map(STRUCT_COUNTERS_INFO *newcounters,
-				STRUCT_REPLACE *repl,
-				unsigned int index,
+				STRUCT_REPLACE *repl, unsigned int idx,
 				unsigned int mappos)
 {
 	/* Original read: X.
@@ -2414,15 +2412,13 @@ static void counters_normal_map(STRUCT_C
 	 * => Add in X + Y
 	 * => Add in replacement read.
 	 */
-	newcounters->counters[index] = repl->counters[mappos];
+	newcounters->counters[idx] = repl->counters[mappos];
 	DEBUGP_C("NORMAL_MAP => mappos %u \n", mappos);
 }
 
 static void counters_map_zeroed(STRUCT_COUNTERS_INFO *newcounters,
-				STRUCT_REPLACE *repl,
-				unsigned int index,
-				unsigned int mappos,
-				STRUCT_COUNTERS *counters)
+				STRUCT_REPLACE *repl, unsigned int idx,
+				unsigned int mappos, STRUCT_COUNTERS *counters)
 {
 	/* Original read: X.
 	 * Atomic read on replacement: X + Y.
@@ -2431,19 +2427,18 @@ static void counters_map_zeroed(STRUCT_C
 	 * => Add in Y.
 	 * => Add in (replacement read - original read).
 	 */
-	subtract_counters(&newcounters->counters[index],
+	subtract_counters(&newcounters->counters[idx],
 			  &repl->counters[mappos],
 			  counters);
 	DEBUGP_C("ZEROED => mappos %u\n", mappos);
 }
 
 static void counters_map_set(STRUCT_COUNTERS_INFO *newcounters,
-			     unsigned int index,
-			     STRUCT_COUNTERS *counters)
+                             unsigned int idx, STRUCT_COUNTERS *counters)
 {
 	/* Want to set counter (iptables-restore) */
 
-	memcpy(&newcounters->counters[index], counters,
+	memcpy(&newcounters->counters[idx], counters,
 		sizeof(STRUCT_COUNTERS));
 
 	DEBUGP_C("SET\n");
Index: iptables/xtables.c
===================================================================
--- iptables.orig/xtables.c
+++ iptables/xtables.c
@@ -46,7 +46,7 @@
 char *lib_dir;
 
 /* the path to command to load kernel module */
-const char *modprobe = NULL;
+const char *modprobe_program = NULL;
 
 /* Keeping track of external matches and targets: linked lists.  */
 struct xtables_match *xtables_matches;
@@ -488,7 +488,7 @@ static int compatible_revision(const cha
 		exit(1);
 	}
 
-	load_xtables_ko(modprobe, 1);
+	load_xtables_ko(modprobe_program, 1);
 
 	strcpy(rev.name, name);
 	rev.revision = revision;
