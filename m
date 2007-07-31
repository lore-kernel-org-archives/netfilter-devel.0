From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Tue, 31 Jul 2007 09:59:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707241111280.18990@fbirervta.pbzchgretzou.qr>
	<200707240949.l6O9n1Oi008901@toshiba.co.jp>
	<Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
	<200707310025.l6V0PDOP029552@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707310025.l6V0PDOP029552@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Jul 31 2007 09:25, Yasuyuki KOZAKAI wrote:
>> +		snprintf(path, sizeof(path), "%s/lib%s_%s.so", lib_dir,
>> +		         family_prefix[AF_UNSPEC], name);
>
>So, here "%s/libxt_%s.so" is enough, and
>
>> +		if (ptr == NULL && family < ARRAY_SIZE(family_prefix) &&
>> +		    family_prefix[family] != NULL) {
>> +			snprintf(path, sizeof(path), "%s/lib%s_%s.so",
>> +			         lib_dir, family_prefix[family], name);
>
>let's use afinfo.libprefix.
>


	Jan
===

Let the iptable tools search for libxt modules first,
then for l3-specific modules (libipt, libip6t)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/xtables.h |    6 +++-
 ip6tables-save.c  |    4 +--
 ip6tables.c       |   22 ++++++++---------
 iptables-save.c   |    4 +--
 iptables.c        |   22 ++++++++---------
 xtables.c         |   68 ++++++++++++++++++++++++++++++------------------------
 6 files changed, 68 insertions(+), 58 deletions(-)

Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -191,8 +191,10 @@ extern void xtables_register_match(struc
 extern void xtables_register_target(struct xtables_target *me);
 
 extern struct xtables_match *find_match(const char *name, enum xt_tryload,
-					struct xtables_rule_match **match);
-extern struct xtables_target *find_target(const char *name, enum xt_tryload);
+					struct xtables_rule_match **match,
+					unsigned int family);
+extern struct xtables_target *find_target(const char *name, enum xt_tryload,
+                                          unsigned int family);
 
 extern int string_to_number_ll(const char *s,
 			       unsigned long long min,
Index: iptables/ip6tables-save.c
===================================================================
--- iptables.orig/ip6tables-save.c
+++ iptables/ip6tables-save.c
@@ -100,7 +100,7 @@ static int print_match(const struct ip6t
 			const struct ip6t_ip6 *ip)
 {
 	struct ip6tables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
+		= find_match(e->u.user.name, TRY_LOAD, NULL, "ip6t");
 
 	if (match) {
 		printf("-m %s ", e->u.user.name);
@@ -196,7 +196,7 @@ static void print_rule(const struct ip6t
 	t = ip6t_get_target((struct ip6t_entry *)e);
 	if (t->u.user.name[0]) {
 		struct ip6tables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
+			= find_target(t->u.user.name, TRY_LOAD, AF_INET6);
 
 		if (!target) {
 			fprintf(stderr, "Can't find library for target `%s'\n",
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -700,9 +700,9 @@ find_proto(const char *pname, enum ip6t_
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
-			return find_match(protoname, tryload, matches);
+			return find_match(protoname, tryload, matches, AF_INET6);
 	} else
-		return find_match(pname, tryload, matches);
+		return find_match(pname, tryload, matches, AF_INET6);
 
 	return NULL;
 }
@@ -929,7 +929,7 @@ print_match(const struct ip6t_entry_matc
 	    const struct ip6t_ip6 *ip,
 	    int numeric)
 {
-	struct ip6tables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct ip6tables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL, AF_INET6);
 
 	if (match) {
 		if (match->print)
@@ -958,9 +958,9 @@ print_firewall(const struct ip6t_entry *
 	char buf[BUFSIZ];
 
 	if (!ip6tc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = find_target(targname, TRY_LOAD, AF_INET6);
 	else
-		target = find_target(IP6T_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = find_target(IP6T_STANDARD_TARGET, LOAD_MUST_SUCCEED, AF_INET6);
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
 	flags = fw->ipv6.flags;
@@ -1513,7 +1513,7 @@ int do_command6(int argc, char *argv[], 
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (find_target(optarg, TRY_LOAD, AF_INET6))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1564,7 +1564,7 @@ int do_command6(int argc, char *argv[], 
 
 			/* ip6tables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				find_match(protocol, TRY_LOAD, &matches, AF_INET6);
 
 			exit_printhelp(matches);
 
@@ -1615,7 +1615,7 @@ int do_command6(int argc, char *argv[], 
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = find_target(jumpto, TRY_LOAD, AF_INET6);
 
 			if (target) {
 				size_t size;
@@ -1665,7 +1665,7 @@ int do_command6(int argc, char *argv[], 
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches, AF_INET6);
 			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 					 + m->size;
 			m->m = fw_calloc(1, size);
@@ -1940,7 +1940,7 @@ int do_command6(int argc, char *argv[], 
 			size_t size;
 
 			target = find_target(IP6T_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+					     LOAD_MUST_SUCCEED, AF_INET6);
 
 			size = sizeof(struct ip6t_entry_target)
 				+ target->size;
@@ -1956,7 +1956,7 @@ int do_command6(int argc, char *argv[], 
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
-			find_target(jumpto, LOAD_MUST_SUCCEED);
+			find_target(jumpto, LOAD_MUST_SUCCEED, AF_INET6);
 		} else {
 			e = generate_entry(&fw, matches, target->t);
 			free(target->t);
Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -119,7 +119,7 @@ static int print_match(const struct ipt_
 			const struct ipt_ip *ip)
 {
 	struct iptables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
+		= find_match(e->u.user.name, TRY_LOAD, NULL, AF_INET);
 
 	if (match) {
 		printf("-m %s ", e->u.user.name);
@@ -207,7 +207,7 @@ static void print_rule(const struct ipt_
 	t = ipt_get_target((struct ipt_entry *)e);
 	if (t->u.user.name[0]) {
 		struct iptables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
+			= find_target(t->u.user.name, TRY_LOAD, AF_INET);
 
 		if (!target) {
 			fprintf(stderr, "Can't find library for target `%s'\n",
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -687,9 +687,9 @@ find_proto(const char *pname, enum ipt_t
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
-			return find_match(protoname, tryload, matches);
+			return find_match(protoname, tryload, matches, AF_INET);
 	} else
-		return find_match(pname, tryload, matches);
+		return find_match(pname, tryload, matches, AF_INET);
 
 	return NULL;
 }
@@ -967,7 +967,7 @@ print_match(const struct ipt_entry_match
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
-	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL, AF_INET);
 
 	if (match) {
 		if (match->print)
@@ -996,9 +996,9 @@ print_firewall(const struct ipt_entry *f
 	char buf[BUFSIZ];
 
 	if (!iptc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = find_target(targname, TRY_LOAD, AF_INET);
 	else
-		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED, AF_INET);
 
 	t = ipt_get_target((struct ipt_entry *)fw);
 	flags = fw->ip.flags;
@@ -1569,7 +1569,7 @@ int do_command(int argc, char *argv[], c
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (find_target(optarg, TRY_LOAD, AF_INET))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1620,7 +1620,7 @@ int do_command(int argc, char *argv[], c
 
 			/* iptables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				find_match(protocol, TRY_LOAD, &matches, AF_INET);
 
 			exit_printhelp(matches);
 
@@ -1673,7 +1673,7 @@ int do_command(int argc, char *argv[], c
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = find_target(jumpto, TRY_LOAD, AF_INET);
 
 			if (target) {
 				size_t size;
@@ -1731,7 +1731,7 @@ int do_command(int argc, char *argv[], c
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches, AF_INET);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;
 			m->m = fw_calloc(1, size);
@@ -2005,7 +2005,7 @@ int do_command(int argc, char *argv[], c
 			size_t size;
 
 			target = find_target(IPT_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+					     LOAD_MUST_SUCCEED, AF_INET);
 
 			size = sizeof(struct ipt_entry_target)
 				+ target->size;
@@ -2029,7 +2029,7 @@ int do_command(int argc, char *argv[], c
 				exit_error(PARAMETER_PROBLEM,
 					   "goto '%s' is not a chain\n", jumpto);
 #endif
-			find_target(jumpto, LOAD_MUST_SUCCEED);
+			find_target(jumpto, LOAD_MUST_SUCCEED, AF_INET);
 		} else {
 			e = generate_entry(&fw, matches, target->t);
 			free(target->t);
Index: iptables/xtables.c
===================================================================
--- iptables.orig/xtables.c
+++ iptables/xtables.c
@@ -31,6 +31,7 @@
 
 #include <xtables.h>
 
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #define NPROTO	255
 
 #ifndef PROC_SYS_MODPROBE
@@ -256,7 +257,8 @@ void parse_interface(const char *arg, ch
 }
 
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
-				 struct xtables_rule_match **matches)
+				 struct xtables_rule_match **matches,
+				 unsigned int family)
 {
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
@@ -292,21 +294,25 @@ struct xtables_match *find_match(const c
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/.so")
 			  + strlen(afinfo.libprefix) + strlen(name)];
-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
-			name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
-
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load match `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
+
+		snprintf(path, sizeof(path), "%s/libxt_%s.so", lib_dir, name);
+		if (dlopen(path, RTLD_NOW) != NULL)
+			/*
+			 * Library loaded (and its constructors run).
+			 * Try to grab the pointer to the struct.
+			 */
+			ptr = find_match(name, DONT_LOAD, NULL, family);
+
+		if (ptr == NULL) {
+			snprintf(path, sizeof(path), "%s/%s%s.so",
+			         lib_dir, afinfo.libprefix, name);
+			if (dlopen(path, RTLD_NOW) != NULL)
+				ptr = find_match(name, DONT_LOAD, NULL, family);
+		}
+
+		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load match `%s':%s\n",
-				   name, dlerror());
+				   "Couldn't load match `%s'\n", name);
 	}
 #else
 	if (ptr && !ptr->loaded) {
@@ -341,7 +347,8 @@ struct xtables_match *find_match(const c
 }
 
 
-struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
+struct xtables_target *find_target(const char *name, enum xt_tryload tryload,
+                                   unsigned int family)
 {
 	struct xtables_target *ptr;
 
@@ -362,19 +369,20 @@ struct xtables_target *find_target(const
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/.so")
 			  + strlen(afinfo.libprefix) + strlen(name)];
-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix, name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified match as a target. */
-			ptr = find_target(name, DONT_LOAD);
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load target `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
+
+		snprintf(path, sizeof(path), "%s/libxt_%s.so", lib_dir, name);
+		if (dlopen(path, RTLD_NOW) != NULL)
+			ptr = find_target(name, DONT_LOAD, family);
+
+		if (ptr == NULL) {
+			snprintf(path, sizeof(path), "%s/%s%s.so",
+			         lib_dir, afinfo.libprefix, name);
+			if (dlopen(path, RTLD_NOW) != NULL)
+				ptr = find_target(name, DONT_LOAD, family);
+		}
+		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load target `%s':%s\n",
-				   name, dlerror());
+				   "Couldn't load target `%s'\n", name);
 	}
 #else
 	if (ptr && !ptr->loaded) {
@@ -472,7 +480,7 @@ void xtables_register_match(struct xtabl
 	if (me->family != afinfo.family)
 		return;
 
-	old = find_match(me->name, DURING_LOAD, NULL);
+	old = find_match(me->name, DURING_LOAD, NULL, me->family);
 	if (old) {
 		if (old->revision == me->revision) {
 			fprintf(stderr,
@@ -538,7 +546,7 @@ void xtables_register_target(struct xtab
 	if (me->family != afinfo.family)
 		return;
 
-	old = find_target(me->name, DURING_LOAD);
+	old = find_target(me->name, DURING_LOAD, me->family);
 	if (old) {
 		struct xtables_target **i;
 
