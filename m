From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] Versioning (aka release) stuff for iptables
Date: Sat, 25 Dec 2004 22:31:43 +0100
Message-ID: <41CDDC3F.2060708@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040709040708090909010101"
Cc: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------040709040708090909010101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty,

I've been working on the versioning stuff last days. I've tested with 
the mark target.

As I told you, I propose to add an option called --release to the 
current syntax of iptables which works as follows:

a) New version of matches/targets: iptables -I INPUT -t mangle -j MARK 
--release 1 --and-mark 0x1

b) Primitive version. To keep backward compatibility, the syntax is the 
same, no modification: iptables -I INPUT -t mangle -j MARK --set-mark 0x1

Optionally, someone could apply this: iptables -I INPUT -t mangle -j 
MARK --release 0 --set-mark 0x1

To finish, some comments about what I have in mind for next days:

1) Test this stuff in nfsim with a test case based on yours.
2) Clean up the kernel patch that I sent you some weeks ago and rename 
field `version' to `release'
3) port mport match to multiport to test that versioning stuff is 
working fine with matches.
4) More testing...

Please, comments welcome.

--
Pablo

--------------040709040708090909010101
Content-Type: text/x-patch;
 name="xmas-version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xmas-version.patch"

Index: iptables.c
===================================================================
--- iptables.c	(revision 3357)
+++ iptables.c	(working copy)
@@ -138,6 +138,7 @@
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "release", 1, 0, 'r' },
 	{ 0 }
 };
 
@@ -664,12 +665,12 @@
 }
 
 struct iptables_match *
-find_match(const char *name, enum ipt_tryload tryload, struct iptables_rule_match **matches)
+find_match(const char *name, u_int8_t rel, enum ipt_tryload tryload, struct iptables_rule_match **matches)
 {
 	struct iptables_match *ptr;
 
 	for (ptr = iptables_matches; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0)
+		if (strcmp(name, ptr->name) == 0 && ptr->release == rel) 
 			break;
 	}
 
@@ -681,16 +682,16 @@
 		if (dlopen(path, RTLD_NOW)) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
+			ptr = find_match(name, rel, DONT_LOAD, NULL);
 
 			if (!ptr)
 				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load match `%s'\n",
-					   name);
+					   "Couldn't load match `%s' (r.%d)\n",
+					   name, rel);
 		} else if (tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load match `%s':%s\n",
-				   name, dlerror());
+				   "Couldn't load match `%s' (r.%d):%s\n",
+				   name, rel, dlerror());
 	}
 #else
 	if (ptr && !ptr->loaded) {
@@ -701,7 +702,7 @@
 	}
 	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
 		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find match `%s'\n", name);
+			   "Couldn't find match `%s' (r.%d)\n", name, rel);
 	}
 #endif
 
@@ -730,9 +731,10 @@
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
-			return find_match(protoname, tryload, matches);
+			/* standalone matches doesn't support versioning */
+			return find_match(protoname, 0, tryload, matches);
 	} else
-		return find_match(pname, tryload, matches);
+		return find_match(pname, 0, tryload, matches);
 
 	return NULL;
 }
@@ -966,7 +968,7 @@
 }
 
 struct iptables_target *
-find_target(const char *name, enum ipt_tryload tryload)
+find_target(const char *name, u_int8_t rel, enum ipt_tryload tryload)
 {
 	struct iptables_target *ptr;
 
@@ -979,7 +981,7 @@
 		name = "standard";
 
 	for (ptr = iptables_targets; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0)
+		if (strcmp(name, ptr->name) == 0 && ptr->release == rel)
 			break;
 	}
 
@@ -991,15 +993,15 @@
 		if (dlopen(path, RTLD_NOW)) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified match as a target. */
-			ptr = find_target(name, DONT_LOAD);
+			ptr = find_target(name, rel, DONT_LOAD);
 			if (!ptr)
 				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load target `%s'\n",
-					   name);
+					   "Couldn't load target `%s' (r.%d)\n",
+					   name, rel);
 		} else if (tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load target `%s':%s\n",
-				   name, dlerror());
+				   "Couldn't load target `%s' (r.%d):%s\n",
+				   name, rel, dlerror());
 	}
 #else
 	if (ptr && !ptr->loaded) {
@@ -1010,7 +1012,7 @@
 	}
 	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
 		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find target `%s'\n", name);
+			   "Couldn't find target `%s' (r.%d)\n", name, rel);
 	}
 #endif
 
@@ -1055,7 +1057,7 @@
 		exit(1);
 	}
 
-	if (find_match(me->name, DONT_LOAD, NULL)) {
+	if (find_match(me->name, me->release, DONT_LOAD, NULL)) {
 		fprintf(stderr, "%s: match `%s' already registered.\n",
 			program_name, me->name);
 		exit(1);
@@ -1085,7 +1087,7 @@
 		exit(1);
 	}
 
-	if (find_target(me->name, DONT_LOAD)) {
+	if (find_target(me->name, me->release, DONT_LOAD)) {
 		fprintf(stderr, "%s: target `%s' already registered.\n",
 			program_name, me->name);
 		exit(1);
@@ -1185,7 +1187,7 @@
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
-	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
+	struct iptables_match *match = find_match(m->u.user.name, m->u.user.version, TRY_LOAD, NULL);
 
 	if (match) {
 		if (match->print)
@@ -1213,12 +1215,12 @@
 	u_int8_t flags;
 	char buf[BUFSIZ];
 
+	t = ipt_get_target((struct ipt_entry *)fw);
 	if (!iptc_is_chain(targname, handle))
-		target = find_target(targname, TRY_LOAD);
+		target = find_target(targname, t->u.user.version, TRY_LOAD);
 	else
-		target = find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+		target = find_target(IPT_STANDARD_TARGET, t->u.user.version, LOAD_MUST_SUCCEED);
 
-	t = ipt_get_target((struct ipt_entry *)fw);
 	flags = fw->ip.flags;
 
 	if (format & FMT_LINENUMBERS)
@@ -1715,6 +1717,9 @@
 	char *protocol = NULL;
 	const char *modprobe = NULL;
 	int proto_used = 0;
+	int release = 0, match_option = 0, target_option = 0;
+	char *match_name = NULL, *target_name = NULL;
+	static struct option *old_opts;
 
 	memset(&fw, 0, sizeof(fw));
 
@@ -1737,7 +1742,7 @@
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:r:xc:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1815,7 +1820,7 @@
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `-'\n");
-			if (find_target(optarg, TRY_LOAD))
+			if (find_target(optarg, 0, TRY_LOAD))
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
@@ -1866,7 +1871,7 @@
 
 			/* iptables -p icmp -h */
 			if (!matches && protocol)
-				find_match(protocol, TRY_LOAD, &matches);
+				find_match(protocol, 0, TRY_LOAD, &matches);
 
 			exit_printhelp(matches);
 
@@ -1913,19 +1918,14 @@
 				   invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = find_target(jumpto, TRY_LOAD);
+			target = find_target(jumpto, 0, TRY_LOAD);
 
 			if (target) {
-				size_t size;
-
-				size = IPT_ALIGN(sizeof(struct ipt_entry_target))
-					+ target->size;
-
-				target->t = fw_calloc(1, size);
-				target->t->u.target_size = size;
-				strcpy(target->t->u.user.name, jumpto);
-				target->init(target->t, &fw.nfcache);
+				old_opts = opts;
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+				target_name = jumpto;
+				target_option = 1;
+				release = 0;
 			}
 			break;
 
@@ -1964,24 +1964,76 @@
 			verbose++;
 			break;
 
-		case 'm': {
-			size_t size;
-
+		case 'm':
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
-			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
-			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-					 + m->size;
-			m->m = fw_calloc(1, size);
-			m->m->u.match_size = size;
-			strcpy(m->m->u.user.name, m->name);
-			m->init(m->m, &fw.nfcache);
-			opts = merge_options(opts, m->extra_opts, &m->option_offset);
-		}
+			/* Backward compatibility: load release 0 */
+			m = find_match(optarg, release, LOAD_MUST_SUCCEED, NULL);
+
+			/* Merge option of release 0, but keep a 
+			 * pointer to the old structure */
+			old_opts = opts;
+			opts = merge_options(opts, m->extra_opts, 
+					     &m->option_offset);
+			match_name = optarg;
+			match_option = 1;
+			release = 0;
 		break;
 
+		case 'r':
+			release = atoi(optarg);
+
+			if (release < 0 || release > 256)
+				exit_error(PARAMETER_PROBLEM,
+					   "release must be >= 0 and =< 255");
+
+			if (match_option) {
+				size_t s;
+
+				/* restore old options */
+				free(opts);
+				opts = old_opts;
+
+				/* load a specific release of a match */
+				m = find_match(match_name, release, 
+					       LOAD_MUST_SUCCEED, &matches);
+				s = IPT_ALIGN(sizeof(struct ipt_entry_match))
+					      + m->size;
+				m->m = fw_calloc(1, s);
+				m->m->u.match_size = s;
+				strcpy(m->m->u.user.name, m->name);
+				m->m->u.user.version = m->release;
+				m->init(m->m, &fw.nfcache);
+				opts = merge_options(opts, m->extra_opts, 
+						     &m->option_offset);
+				/* reset flag */
+				match_option = 0;
+			} else if (target_option) {
+				size_t s;
+
+				/* restore old options */
+				free(opts);
+				opts = old_opts;
+
+				/* load a specific release of a target */
+				target = find_target(target_name, release, TRY_LOAD);
+
+				s = IPT_ALIGN(sizeof(struct ipt_entry_target))
+					      + target->size;
+
+				target->t = fw_calloc(1, s);
+				target->t->u.target_size = s;
+				strcpy(target->t->u.user.name, target_name);
+				target->t->u.user.version = target->release;
+				target->init(target->t, &fw.nfcache);
+				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+				/* reset flag */
+				target_option = 0;
+			}
+			break;
+			
 		case 'n':
 			set_option(&options, OPT_NUMERIC, &fw.ip.invflags,
 				   invert);
@@ -2056,6 +2108,41 @@
 			exit_tryhelp(2);
 
 		default:
+			if (match_option) {
+				/* No release specified, so use release 0 */
+				size_t s;
+
+				m = find_match(match_name, release, 
+					       LOAD_MUST_SUCCEED, &matches);
+				s = IPT_ALIGN(sizeof(struct ipt_entry_match))
+					      + m->size;
+				m->m = fw_calloc(1, s);
+				m->m->u.match_size = s;
+				strcpy(m->m->u.user.name, m->name);
+				m->m->u.user.version = 0;
+				m->init(m->m, &fw.nfcache);
+				
+				/* reset flag */
+				match_option = 0;
+			} else if (target_option) {
+				/* targets with parameters like SNAT need
+				 * this stuff */
+				size_t s;
+	
+				s = IPT_ALIGN(sizeof(struct ipt_entry_target))
+					      + target->size;
+
+				target->t = fw_calloc(1, s);
+				target->t->u.target_size = s;
+				strcpy(target->t->u.user.name, target_name);
+				target->t->u.user.version = 0;
+				target->init(target->t, &fw.nfcache);
+
+				/* reset flag */
+				target_option = 0;
+			}
+ 
+
 			/* FIXME: This scheme doesn't allow two of the same
 			   matches --RR */
 			if (!target
@@ -2135,6 +2222,23 @@
 		invert = FALSE;
 	}
 
+	if (target_option) {
+		/* This target has no parameters */
+		size_t s;
+				
+		s = IPT_ALIGN(sizeof(struct ipt_entry_target))
+ 			      + target->size;
+
+		target->t = fw_calloc(1, s);
+		target->t->u.target_size = s;
+		strcpy(target->t->u.user.name, target_name);
+		target->t->u.user.version = 0;
+		target->init(target->t, &fw.nfcache);
+
+		/* reset flag */
+		target_option = 0;
+	}
+
 	for (matchp = matches; matchp; matchp = matchp->next)
 		matchp->match->final_check(matchp->match->mflags);
 
@@ -2239,7 +2343,9 @@
 			|| iptc_is_chain(jumpto, *handle))) {
 			size_t size;
 
+			/* standard doesn't support versioning */
 			target = find_target(IPT_STANDARD_TARGET,
+					     0,
 					     LOAD_MUST_SUCCEED);
 
 			size = sizeof(struct ipt_entry_target)
@@ -2255,7 +2361,7 @@
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
-			find_target(jumpto, LOAD_MUST_SUCCEED);
+			find_target(jumpto, 0, LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&fw, matches, target->t);
 			free(target->t);
Index: include/iptables.h
===================================================================
--- include/iptables.h	(revision 3309)
+++ include/iptables.h	(working copy)
@@ -22,8 +22,12 @@
 
 	ipt_chainlabel name;
 
+	/* compatible with a certain iptables version */
 	const char *version;
 
+	/* release number of this match */
+	u_int8_t release;
+
 	/* Size of match data. */
 	size_t size;
 
@@ -74,6 +78,8 @@
 
 	const char *version;
 
+	u_int8_t release;
+
 	/* Size of target data. */
 	size_t size;
 
@@ -143,8 +149,8 @@
 	LOAD_MUST_SUCCEED
 };
 
-extern struct iptables_target *find_target(const char *name, enum ipt_tryload);
-extern struct iptables_match *find_match(const char *name, enum ipt_tryload, struct iptables_rule_match **match);
+extern struct iptables_target *find_target(const char *name, const u_int8_t version, enum ipt_tryload);
+extern struct iptables_match *find_match(const char *name, const u_int8_t version, enum ipt_tryload, struct iptables_rule_match **match);
 
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
 			iptc_handle_t *handle);
Index: libiptc/libiptc.c
===================================================================
--- libiptc/libiptc.c	(revision 3309)
+++ libiptc/libiptc.c	(working copy)
@@ -1246,7 +1246,11 @@
 	/* memset to all 0 for your memcmp convenience. */
 	memset(t->u.user.name + strlen(t->u.user.name),
 	       0,
-	       FUNCTION_MAXNAMELEN - strlen(t->u.user.name));
+	       FUNCTION_MAXNAMELEN - strlen(t->u.user.name) - 1);
+	/* fcuk (tm), this is what happens when you apply 
+	 * dirty hacks... that memset has been knocking me for
+	 * hours... arrrg! --pablo
+	 */
 
 	set_changed(handle);
 	return 1;

--------------040709040708090909010101--
