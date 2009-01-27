From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxtables: prefix names and order #3
Date: Tue, 27 Jan 2009 15:23:58 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901271523470.13940@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901271511190.13940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49242 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZA0OYA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:24:00 -0500
In-Reply-To: <alpine.LSU.2.00.0901271511190.13940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 8759aeb8e8531f26df72ee15fbcab921ca4f361f (v1.4.3-rc1-24-g8759aeb)
commit 1ec3f7612119d65d26d2774414ee92fdabec214a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 27 15:23:01 2009 +0100

libxtables: prefix names and order #3

This change affects:
	find_{match,target} -> xtables_find_{match,target}
	enum xt_tryload -> enum xtables_tryload
	loose flags like DONT_LOAD -> XTF_DONT_LOAD

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in       |   22 +++++++++++++++++
 include/xtables/internal.h |   23 ------------------
 ip6tables.c                |   45 ++++++++++++++++++++----------------
 iptables.c                 |   45 ++++++++++++++++++++----------------
 xtables.c                  |   41 +++++++++++++++++---------------
 5 files changed, 94 insertions(+), 82 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 2512d79..02a832d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -140,7 +140,24 @@ struct xtables_target
 #endif
 };
 
+struct xtables_rule_match {
+	struct xtables_rule_match *next;
+	struct xtables_match *match;
+	/* Multiple matches of the same type: the ones before
+	   the current one are completed from parsing point of view */
+	bool completed;
+};
+
+enum xtables_tryload {
+	XTF_DONT_LOAD,
+	XTF_DURING_LOAD,
+	XTF_TRY_LOAD,
+	XTF_LOAD_MUST_SUCCEED,
+};
+
 extern const char *xtables_modprobe_program;
+extern struct xtables_match *xtables_matches;
+extern struct xtables_target *xtables_targets;
 
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
@@ -148,6 +165,11 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 
+extern struct xtables_match *xtables_find_match(const char *name,
+	enum xtables_tryload, struct xtables_rule_match **match);
+extern struct xtables_target *xtables_find_target(const char *name,
+	enum xtables_tryload);
+
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_target(struct xtables_target *me);
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 62fe2ed..60375cd 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -26,34 +26,11 @@ struct afinfo {
 	int so_rev_target;
 };
 
-enum xt_tryload {
-	DONT_LOAD,
-	DURING_LOAD,
-	TRY_LOAD,
-	LOAD_MUST_SUCCEED
-};
-
-struct xtables_rule_match {
-	struct xtables_rule_match *next;
-	struct xtables_match *match;
-	/* Multiple matches of the same type: the ones before
-	   the current one are completed from parsing point of view */
-	unsigned int completed;
-};
-
 extern char *lib_dir;
 
 /* This is decleared in ip[6]tables.c */
 extern struct afinfo afinfo;
 
-/* Keeping track of external matches and targets: linked lists.  */
-extern struct xtables_match *xtables_matches;
-extern struct xtables_target *xtables_targets;
-
-extern struct xtables_match *find_match(const char *name, enum xt_tryload,
-					struct xtables_rule_match **match);
-extern struct xtables_target *find_target(const char *name, enum xt_tryload);
-
 extern void _init(void);
 
 #endif /* _XTABLES_INTERNAL_H */
diff --git a/ip6tables.c b/ip6tables.c
index 580a644..0a6f75b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -481,7 +481,8 @@ check_inverse(const char option[], int *invert, int *my_optind, int argc)
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct xtables_match *
-find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup, struct ip6tables_rule_match **matches)
+find_proto(const char *pname, enum xtables_tryload tryload,
+	   int nolookup, struct ip6tables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -489,9 +490,9 @@ find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup, struct ip
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
-			return find_match(protoname, tryload, matches);
+			return xtables_find_match(protoname, tryload, matches);
 	} else
-		return find_match(pname, tryload, matches);
+		return xtables_find_match(pname, tryload, matches);
 
 	return NULL;
 }
@@ -706,7 +707,8 @@ print_match(const struct ip6t_entry_match *m,
 	    const struct ip6t_ip6 *ip,
 	    int numeric)
 {
-	struct xtables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct xtables_match *match =
+		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
 		if (match->print)
@@ -735,9 +737,10 @@ print_firewall(const struct ip6t_entry *fw,
 	char buf[BUFSIZ];
 
 	if (!ip6tc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = xtables_find_target(targname, XTF_TRY_LOAD);
 	else
-		target = find_target(IP6T_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = xtables_find_target(IP6T_STANDARD_TARGET,
+		         XTF_LOAD_MUST_SUCCEED);
 
 	t = ip6t_get_target((struct ip6t_entry *)fw);
 	flags = fw->ipv6.flags;
@@ -1175,8 +1178,8 @@ static void print_proto(u_int16_t proto, int invert)
 static int print_match_save(const struct ip6t_entry_match *e,
 			const struct ip6t_ip6 *ip)
 {
-	struct xtables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
+	struct xtables_match *match =
+		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
 		printf("-m %s ", e->u.user.name);
@@ -1279,8 +1282,8 @@ void print_rule(const struct ip6t_entry *e,
 	/* Print targinfo part */
 	t = ip6t_get_target((struct ip6t_entry *)e);
 	if (t->u.user.name[0]) {
-		struct xtables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
+		struct xtables_target *target =
+			xtables_find_target(t->u.user.name, XTF_TRY_LOAD);
 
 		if (!target) {
 			fprintf(stderr, "Can't find library for target `%s'\n",
@@ -1555,7 +1558,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (xtables_find_target(optarg, XTF_TRY_LOAD))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1606,7 +1609,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 			/* ip6tables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				xtables_find_match(protocol, XTF_TRY_LOAD,
+					&matches);
 
 			exit_printhelp(matches);
 
@@ -1667,7 +1671,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = xtables_find_target(jumpto, XTF_TRY_LOAD);
 
 			if (target) {
 				size_t size;
@@ -1724,7 +1728,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
+			    &matches);
 			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 					 + m->size;
 			m->m = xtables_calloc(1, size);
@@ -1858,13 +1863,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				 */
 				if (m == NULL
 				    && protocol
-				    && (!find_proto(protocol, DONT_LOAD,
+				    && (!find_proto(protocol, XTF_DONT_LOAD,
 						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, DONT_LOAD,
+					|| (find_proto(protocol, XTF_DONT_LOAD,
 							options&OPT_NUMERIC, NULL)
 					    && (proto_used == 0))
 				       )
-				    && (m = find_proto(protocol, TRY_LOAD,
+				    && (m = find_proto(protocol, XTF_TRY_LOAD,
 						       options&OPT_NUMERIC, &matches))) {
 					/* Try loading protocol */
 					size_t size;
@@ -2018,8 +2023,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			|| ip6tc_is_chain(jumpto, *handle))) {
 			size_t size;
 
-			target = find_target(IP6T_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+			target = xtables_find_target(IP6T_STANDARD_TARGET,
+					XTF_LOAD_MUST_SUCCEED);
 
 			size = sizeof(struct ip6t_entry_target)
 				+ target->size;
@@ -2040,7 +2045,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				exit_error(PARAMETER_PROBLEM,
 						"goto '%s' is not a chain\n", jumpto);
 #endif
-			find_target(jumpto, LOAD_MUST_SUCCEED);
+			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&fw, matches, target->t);
 			free(target->t);
diff --git a/iptables.c b/iptables.c
index 61e7aab..7b8d239 100644
--- a/iptables.c
+++ b/iptables.c
@@ -483,7 +483,8 @@ check_inverse(const char option[], int *invert, int *my_optind, int argc)
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct xtables_match *
-find_proto(const char *pname, enum ipt_tryload tryload, int nolookup, struct iptables_rule_match **matches)
+find_proto(const char *pname, enum xtables_tryload tryload,
+	   int nolookup, struct iptables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -491,9 +492,9 @@ find_proto(const char *pname, enum ipt_tryload tryload, int nolookup, struct ipt
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
-			return find_match(protoname, tryload, matches);
+			return xtables_find_match(protoname, tryload, matches);
 	} else
-		return find_match(pname, tryload, matches);
+		return xtables_find_match(pname, tryload, matches);
 
 	return NULL;
 }
@@ -701,7 +702,8 @@ print_match(const struct ipt_entry_match *m,
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
-	struct xtables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct xtables_match *match =
+		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
 		if (match->print)
@@ -730,9 +732,10 @@ print_firewall(const struct ipt_entry *fw,
 	char buf[BUFSIZ];
 
 	if (!iptc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = xtables_find_target(targname, XTF_TRY_LOAD);
 	else
-		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = xtables_find_target(IPT_STANDARD_TARGET,
+		         XTF_LOAD_MUST_SUCCEED);
 
 	t = ipt_get_target((struct ipt_entry *)fw);
 	flags = fw->ip.flags;
@@ -1174,8 +1177,8 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 static int print_match_save(const struct ipt_entry_match *e,
 			const struct ipt_ip *ip)
 {
-	struct xtables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
+	struct xtables_match *match =
+		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
 		printf("-m %s ", e->u.user.name);
@@ -1278,8 +1281,8 @@ void print_rule(const struct ipt_entry *e,
 	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);
 	if (t->u.user.name[0]) {
-		struct xtables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
+		struct xtables_target *target =
+			xtables_find_target(t->u.user.name, XTF_TRY_LOAD);
 
 		if (!target) {
 			fprintf(stderr, "Can't find library for target `%s'\n",
@@ -1568,7 +1571,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
-			if (find_target(optarg, TRY_LOAD))
+			if (xtables_find_target(optarg, XTF_TRY_LOAD))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1619,7 +1622,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 			/* iptables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				xtables_find_match(protocol,
+					XTF_TRY_LOAD, &matches);
 
 			exit_printhelp(matches);
 
@@ -1672,7 +1676,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = xtables_find_target(jumpto, XTF_TRY_LOAD);
 
 			if (target) {
 				size_t size;
@@ -1735,7 +1739,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
+			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
+			    &matches);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;
 			m->m = xtables_calloc(1, size);
@@ -1876,13 +1881,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				 */
 				if (m == NULL
 				    && protocol
-				    && (!find_proto(protocol, DONT_LOAD,
+				    && (!find_proto(protocol, XTF_DONT_LOAD,
 						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, DONT_LOAD,
+					|| (find_proto(protocol, XTF_DONT_LOAD,
 							options&OPT_NUMERIC, NULL)
 					    && (proto_used == 0))
 				       )
-				    && (m = find_proto(protocol, TRY_LOAD,
+				    && (m = find_proto(protocol, XTF_TRY_LOAD,
 						       options&OPT_NUMERIC, &matches))) {
 					/* Try loading protocol */
 					size_t size;
@@ -2047,8 +2052,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			|| iptc_is_chain(jumpto, *handle))) {
 			size_t size;
 
-			target = find_target(IPT_STANDARD_TARGET,
-					     LOAD_MUST_SUCCEED);
+			target = xtables_find_target(IPT_STANDARD_TARGET,
+					 XTF_LOAD_MUST_SUCCEED);
 
 			size = sizeof(struct ipt_entry_target)
 				+ target->size;
@@ -2072,7 +2077,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				exit_error(PARAMETER_PROBLEM,
 					   "goto '%s' is not a chain\n", jumpto);
 #endif
-			find_target(jumpto, LOAD_MUST_SUCCEED);
+			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&fw, matches, target->t);
 			free(target->t);
diff --git a/xtables.c b/xtables.c
index 94ea764..849dc7d 100644
--- a/xtables.c
+++ b/xtables.c
@@ -329,9 +329,10 @@ static void *load_extension(const char *search_path, const char *prefix,
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
 			if (is_target)
-				ptr = find_target(name, DONT_LOAD);
+				ptr = xtables_find_target(name, XTF_DONT_LOAD);
 			else
-				ptr = find_match(name, DONT_LOAD, NULL);
+				ptr = xtables_find_match(name,
+				      XTF_DONT_LOAD, NULL);
 		} else if (stat(path, &sb) == 0) {
 			fprintf(stderr, "%s: %s\n", path, dlerror());
 		}
@@ -343,9 +344,10 @@ static void *load_extension(const char *search_path, const char *prefix,
 		         (unsigned int)(next - dir), dir, prefix, name);
 		if (dlopen(path, RTLD_NOW) != NULL) {
 			if (is_target)
-				ptr = find_target(name, DONT_LOAD);
+				ptr = xtables_find_target(name, XTF_DONT_LOAD);
 			else
-				ptr = find_match(name, DONT_LOAD, NULL);
+				ptr = xtables_find_match(name,
+				      XTF_DONT_LOAD, NULL);
 		} else if (stat(path, &sb) == 0) {
 			fprintf(stderr, "%s: %s\n", path, dlerror());
 		}
@@ -360,8 +362,9 @@ static void *load_extension(const char *search_path, const char *prefix,
 }
 #endif
 
-struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
-				 struct xtables_rule_match **matches)
+struct xtables_match *
+xtables_find_match(const char *name, enum xtables_tryload tryload,
+		   struct xtables_rule_match **matches)
 {
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
@@ -394,22 +397,22 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
+	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
 		ptr = load_extension(lib_dir, afinfo.libprefix, name, false);
 
-		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
+		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load match `%s':%s\n",
 				   name, dlerror());
 	}
 #else
 	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
+		if (tryload != XTF_DONT_LOAD)
 			ptr->loaded = 1;
 		else
 			ptr = NULL;
 	}
-	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
+	if(!ptr && (tryload == XTF_LOAD_MUST_SUCCEED)) {
 		exit_error(PARAMETER_PROBLEM,
 			   "Couldn't find match `%s'\n", name);
 	}
@@ -423,10 +426,10 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 
 		for (i = matches; *i; i = &(*i)->next) {
 			if (strcmp(name, (*i)->match->name) == 0)
-				(*i)->completed = 1;
+				(*i)->completed = true;
 		}
 		newentry->match = ptr;
-		newentry->completed = 0;
+		newentry->completed = false;
 		newentry->next = NULL;
 		*i = newentry;
 	}
@@ -434,8 +437,8 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 	return ptr;
 }
 
-
-struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
+struct xtables_target *
+xtables_find_target(const char *name, enum xtables_tryload tryload)
 {
 	struct xtables_target *ptr;
 
@@ -453,17 +456,17 @@ struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
+	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
 		ptr = load_extension(lib_dir, afinfo.libprefix, name, true);
 
-		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
+		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
 				   name, dlerror());
 	}
 #else
 	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
+		if (tryload != XTF_DONT_LOAD)
 			ptr->loaded = 1;
 		else
 			ptr = NULL;
@@ -566,7 +569,7 @@ void xtables_register_match(struct xtables_match *me)
 	if (me->family != afinfo.family && me->family != AF_UNSPEC)
 		return;
 
-	old = find_match(me->name, DURING_LOAD, NULL);
+	old = xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
 	if (old) {
 		if (old->revision == me->revision &&
 		    old->family == me->family) {
@@ -637,7 +640,7 @@ void xtables_register_target(struct xtables_target *me)
 	if (me->family != afinfo.family && me->family != AF_UNSPEC)
 		return;
 
-	old = find_target(me->name, DURING_LOAD);
+	old = xtables_find_target(me->name, XTF_DURING_LOAD);
 	if (old) {
 		struct xtables_target **i;
 
-- 
# Created with git-export-patch
