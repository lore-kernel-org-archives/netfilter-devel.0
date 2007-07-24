From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/**] libxt_*.so lookup (Re: [PATCH IPTABLES 0/13]: Unifies
 rest of ip[6]tables matches/targets)
Date: Tue, 24 Jul 2007 12:14:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707241052250.18990@fbirervta.pbzchgretzou.qr>
	<200707240908.l6O98uBA008051@toshiba.co.jp>
	<Pine.LNX.4.64.0707241111280.18990@fbirervta.pbzchgretzou.qr>
	<200707240949.l6O9n1Oi008901@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707240949.l6O9n1Oi008901@toshiba.co.jp>
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


On Jul 24 2007 18:49, Yasuyuki KOZAKAI wrote:
>> 
>> From /ws/iptables (svn code dir):
>> 
>> make KERNEL_DIR=/ws/linux/linux-2.6.22 PREFIX=/usr
>> LIBIPT_DIR=/ws/iptables/extensions
>> 
>> I did not install it, but ran it from /ws/iptables.
>
>Wow, I didn't expect such usage. But I'm not sure we should support
>this usage. The reason why I employed symbolic link instead of iptables
>searching libxt_*.so is to keep codes simple. Actually I'm not familiar
>of 'tryload' argument of find_{match,target} so I just kept the behavior of
>them :) If I come up with good idea, I will support it.

Something like this

===

Let the iptable tools search for libxt modules first,
then for l3-specific modules (libipt, libip6t)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/xtables.h |    6 ++--
 ip6tables-save.c  |    4 +-
 ip6tables.c       |   22 +++++++--------
 iptables-save.c   |    4 +-
 iptables.c        |   22 +++++++--------
 xtables.c         |   78 +++++++++++++++++++++++++++++++++---------------------
 6 files changed, 78 insertions(+), 58 deletions(-)

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
@@ -926,7 +926,7 @@ print_match(const struct ip6t_entry_matc
 	    const struct ip6t_ip6 *ip,
 	    int numeric)
 {
-	struct ip6tables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct ip6tables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL, AF_INET6);
 
 	if (match) {
 		if (match->print)
@@ -955,9 +955,9 @@ print_firewall(const struct ip6t_entry *
 	char buf[BUFSIZ];
 
 	if (!ip6tc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = find_target(targname, TRY_LOAD, AF_INET6);
 	else
-		target = find_target(IP6T_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = find_target(IP6T_STANDARD_TARGET, LOAD_MUST_SUCCEED, AF_INET6);
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
 	flags = fw->ipv6.flags;
@@ -1510,7 +1510,7 @@ int do_command6(int argc, char *argv[], 
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (find_target(optarg, TRY_LOAD, AF_INET6))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1561,7 +1561,7 @@ int do_command6(int argc, char *argv[], 
 
 			/* ip6tables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				find_match(protocol, TRY_LOAD, &matches, AF_INET6);
 
 			exit_printhelp(matches);
 
@@ -1612,7 +1612,7 @@ int do_command6(int argc, char *argv[], 
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = find_target(jumpto, TRY_LOAD, AF_INET6);
 
 			if (target) {
 				size_t size;
@@ -1662,7 +1662,7 @@ int do_command6(int argc, char *argv[], 
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches, AF_INET6);
 			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 					 + m->size;
 			m->m = fw_calloc(1, size);
@@ -1937,7 +1937,7 @@ int do_command6(int argc, char *argv[], 
 			size_t size;
 
 			target = find_target(IP6T_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+					     LOAD_MUST_SUCCEED, AF_INET6);
 
 			size = sizeof(struct ip6t_entry_target)
 				+ target->size;
@@ -1953,7 +1953,7 @@ int do_command6(int argc, char *argv[], 
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
@@ -964,7 +964,7 @@ print_match(const struct ipt_entry_match
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
-	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL, AF_INET);
 
 	if (match) {
 		if (match->print)
@@ -993,9 +993,9 @@ print_firewall(const struct ipt_entry *f
 	char buf[BUFSIZ];
 
 	if (!iptc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = find_target(targname, TRY_LOAD, AF_INET);
 	else
-		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED, AF_INET);
 
 	t = ipt_get_target((struct ipt_entry *)fw);
 	flags = fw->ip.flags;
@@ -1566,7 +1566,7 @@ int do_command(int argc, char *argv[], c
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (find_target(optarg, TRY_LOAD, AF_INET))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1617,7 +1617,7 @@ int do_command(int argc, char *argv[], c
 
 			/* iptables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				find_match(protocol, TRY_LOAD, &matches, AF_INET);
 
 			exit_printhelp(matches);
 
@@ -1670,7 +1670,7 @@ int do_command(int argc, char *argv[], c
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = find_target(jumpto, TRY_LOAD, AF_INET);
 
 			if (target) {
 				size_t size;
@@ -1728,7 +1728,7 @@ int do_command(int argc, char *argv[], c
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches, AF_INET);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;
 			m->m = fw_calloc(1, size);
@@ -2002,7 +2002,7 @@ int do_command(int argc, char *argv[], c
 			size_t size;
 
 			target = find_target(IPT_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+					     LOAD_MUST_SUCCEED, AF_INET);
 
 			size = sizeof(struct ipt_entry_target)
 				+ target->size;
@@ -2026,7 +2026,7 @@ int do_command(int argc, char *argv[], c
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
@@ -255,8 +256,15 @@ void parse_interface(const char *arg, ch
 	}
 }
 
+static const char *const family_prefix[] = {
+	[AF_UNSPEC] = "xt",
+	[AF_INET]   = "ipt",
+	[AF_INET6]  = "ip6t",
+};
+
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
-				 struct xtables_rule_match **matches)
+				 struct xtables_rule_match **matches,
+				 unsigned int family)
 {
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
@@ -292,21 +300,27 @@ struct xtables_match *find_match(const c
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
+		snprintf(path, sizeof(path), "%s/lib%s_%s.so", lib_dir,
+		         family_prefix[AF_UNSPEC], name);
+		if (dlopen(path, RTLD_NOW) != NULL)
+			/*
+			 * Library loaded (and its constructors run).
+			 * Try to grab the pointer to the struct.
+			 */
+			ptr = find_match(name, DONT_LOAD, NULL, family);
+
+		if (ptr == NULL && family < ARRAY_SIZE(family_prefix) &&
+		    family_prefix[family] != NULL) {
+			snprintf(path, sizeof(path), "%s/lib%s_%s.so",
+			         lib_dir, family_prefix[family], name);
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
@@ -341,7 +355,8 @@ struct xtables_match *find_match(const c
 }
 
 
-struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
+struct xtables_target *find_target(const char *name, enum xt_tryload tryload,
+                                   unsigned int family)
 {
 	struct xtables_target *ptr;
 
@@ -362,19 +377,22 @@ struct xtables_target *find_target(const
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
+		snprintf(path, sizeof(path), "%s/lib%s_%s.so", lib_dir,
+		         family_prefix[AF_UNSPEC], name);
+		if (dlopen(path, RTLD_NOW) != NULL)
+			ptr = find_target(name, DONT_LOAD, family);
+
+		if (ptr == NULL && family < ARRAY_SIZE(family_prefix) &&
+		    family_prefix[family] != NULL) {
+			snprintf(path, sizeof(path), "%s/lib%s_%s.so",
+			         lib_dir, family_prefix[family], name);
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
@@ -472,7 +490,7 @@ void xtables_register_match(struct xtabl
 	if (me->family != afinfo.family)
 		return;
 
-	old = find_match(me->name, DURING_LOAD, NULL);
+	old = find_match(me->name, DURING_LOAD, NULL, me->family);
 	if (old) {
 		if (old->revision == me->revision) {
 			fprintf(stderr,
@@ -538,7 +556,7 @@ void xtables_register_target(struct xtab
 	if (me->family != afinfo.family)
 		return;
 
-	old = find_target(me->name, DURING_LOAD);
+	old = find_target(me->name, DURING_LOAD, me->family);
 	if (old) {
 		struct xtables_target **i;
 
