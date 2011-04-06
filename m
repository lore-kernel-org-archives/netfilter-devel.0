From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/10] libxtables: guided option parser
Date: Wed,  6 Apr 2011 13:31:09 +0200
Message-ID: <1302089478-15022-3-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46482 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1DFLbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:23 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset seeks to drastically reduce the code in the individual
extensions by centralizing their argument parsing (breakdown of
strings), validation, and in part, assignment.

As a secondary goal, this reduces the number of static storage duration
variables in flight.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am          |    2 +-
 include/xtables.h.in |   91 +++++++++++++++
 ip6tables.c          |   58 +++++++---
 iptables.c           |   60 +++++++---
 xshared.h            |   20 ++++
 xtables.c            |   25 +---
 xtoptions.c          |  299 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
 7 files changed, 501 insertions(+), 54 deletions(-)
 create mode 100644 xtoptions.c

diff --git a/Makefile.am b/Makefile.am
index 7f0eb2f..fbed41f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -27,7 +27,7 @@ libiptc_libip6tc_la_SOURCES =3D libiptc/libip6tc.c
 libiptc_libip6tc_la_LDFLAGS =3D -version-info 0:0:0 ${libiptc_LDFLAGS2=
}
=20
 lib_LTLIBRARIES      +=3D libxtables.la
-libxtables_la_SOURCES =3D xtables.c
+libxtables_la_SOURCES =3D xtables.c xtoptions.c
 libxtables_la_LDFLAGS =3D -version-info ${libxtables_vcurrent}:0:${lib=
xtables_vage}
 if ENABLE_SHARED
 libxtables_la_CFLAGS  =3D ${AM_CFLAGS}
diff --git a/include/xtables.h.in b/include/xtables.h.in
index c3d34af..928f465 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -10,6 +10,8 @@
 #include <sys/types.h>
 #include <limits.h>
 #include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
 #include <linux/types.h>
@@ -34,6 +36,73 @@
=20
 struct in_addr;
=20
+/*
+ * .size is here so that there is a somewhat reasonable check
+ * against the chosen .type.
+ */
+#define XTOPT_POINTER(stype, member) \
+	.ptroff =3D offsetof(stype, member), \
+	.size =3D sizeof(((stype *)NULL)->member)
+#define XTOPT_TABLEEND {.name =3D NULL}
+
+/**
+ * %XTTYPE_NONE:	option takes no argument
+ */
+enum xt_option_type {
+	XTTYPE_NONE,
+};
+
+/**
+ * %XTOPT_INVERT:	option is invertible (usable with !)
+ * %XTOPT_MAND:		option is mandatory
+ * %XTOPT_MULTI:	option may be specified multiple times
+ * %XTOPT_PUT:		store value into memory at @ptroff
+ */
+enum xt_option_flags {
+	XTOPT_INVERT =3D 1 << 0,
+	XTOPT_MAND   =3D 1 << 1,
+	XTOPT_MULTI  =3D 1 << 2,
+	XTOPT_PUT    =3D 1 << 3,
+};
+
+/**
+ * @name:	name of option
+ * @type:	type of input and validation method, see %XTTYPE_*
+ * @id:		unique number (within extension) for option, 0-31
+ * @excl:	bitmask of flags that cannot be used with this option
+ * @also:	bitmask of flags that must be used with this option
+ * @flags:	bitmask of option flags, see %XTOPT_*
+ * @ptroff:	offset into private structure for member
+ * @size:	size of the item pointed to by @ptroff; this is a safeguard
+ */
+struct xt_option_entry {
+	const char *name;
+	enum xt_option_type type;
+	unsigned int id, excl, also, flags;
+	unsigned int ptroff;
+	size_t size;
+};
+
+/**
+ * @arg:	input from command line
+ * @ext_name:	name of extension currently being processed
+ * @entry:	current option being processed
+ * @data:	per-extension data block
+ * @xflags:	options of the extension that have been used
+ * @invert:	whether option was used with !
+ * @val:	parsed result
+ */
+struct xt_option_call {
+	const char *arg, *ext_name;
+	const struct xt_option_entry *entry;
+	void *data;
+	unsigned int xflags;
+	bool invert;
+	union {
+		/* to be filled */
+	} val;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -86,6 +155,10 @@ struct xtables_match
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
=20
+	/* New parser */
+	void (*x6_parse)(struct xt_option_call *);
+	const struct xt_option_entry *x6_options;
+
 	/* Ignore these men behind the curtain: */
 	unsigned int option_offset;
 	struct xt_entry_match *m;
@@ -145,6 +218,10 @@ struct xtables_target
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
=20
+	/* New parser */
+	void (*x6_parse)(struct xt_option_call *);
+	const struct xt_option_entry *x6_options;
+
 	/* Ignore these men behind the curtain: */
 	unsigned int option_offset;
 	struct xt_entry_target *t;
@@ -292,6 +369,20 @@ extern void xtables_save_string(const char *value)=
;
 extern const struct xtables_pprot xtables_chain_protos[];
 extern u_int16_t xtables_parse_protocol(const char *s);
=20
+/* xtoptions.c */
+extern void xtables_option_metavalidate(const char *,
+					const struct xt_option_entry *);
+extern struct option *xtables_options_xfrm(struct option *, struct opt=
ion *,
+					   const struct xt_option_entry *,
+					   unsigned int *);
+extern void xtables_option_parse(struct xt_option_call *);
+extern void xtables_option_tpcall(unsigned int, char **, bool,
+				  struct xtables_target *, void *);
+extern void xtables_option_mpcall(unsigned int, char **, bool,
+				  struct xtables_match *, void *);
+extern void xtables_options_fcheck(const char *, unsigned int,
+				   const struct xt_option_entry *);
+
 #ifdef XTABLES_INTERNAL
=20
 /* Shipped modules rely on this... */
diff --git a/ip6tables.c b/ip6tables.c
index 96a0fdc..83d2fae 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1279,25 +1279,25 @@ static void command_default(struct iptables_com=
mand_state *cs)
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
=20
-	if (cs->target !=3D NULL && cs->target->parse !=3D NULL &&
+	if (cs->target !=3D NULL &&
+	    (cs->target->parse !=3D NULL || cs->target->x6_parse !=3D NULL) &=
&
 	    cs->c >=3D cs->target->option_offset &&
 	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
-		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
-				  cs->invert, &cs->target->tflags, &cs->fw6,
-				  &cs->target->t);
+		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
+				      cs->target, &cs->fw);
 		return;
 	}
=20
 	for (matchp =3D cs->matches; matchp; matchp =3D matchp->next) {
 		m =3D matchp->match;
=20
-		if (matchp->completed || m->parse =3D=3D NULL)
+		if (matchp->completed ||
+		    (m->x6_parse =3D=3D NULL && m->parse =3D=3D NULL))
 			continue;
 		if (cs->c < matchp->match->option_offset ||
 		    cs->c >=3D matchp->match->option_offset + XT_OPTION_OFFSET_SCALE=
)
 			continue;
-		m->parse(cs->c - m->option_offset, cs->argv, cs->invert,
-			 &m->mflags, &cs->fw6, &m->m);
+		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
 		return;
 	}
=20
@@ -1317,9 +1317,17 @@ static void command_default(struct iptables_comm=
and_state *cs)
 		if (m->init !=3D NULL)
 			m->init(m->m);
=20
-		opts =3D xtables_merge_options(ip6tables_globals.orig_opts, opts,
-					     m->extra_opts, &m->option_offset);
-
+		if (m->x6_options !=3D NULL)
+			opts =3D xtables_options_xfrm(ip6tables_globals.orig_opts,
+						    opts, m->x6_options,
+						    &m->option_offset);
+		else
+			opts =3D xtables_merge_options(ip6tables_globals.orig_opts,
+						     opts,
+						     m->extra_opts,
+						     &m->option_offset);
+		if (opts =3D=3D NULL)
+			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 		optind--;
 		return;
 	}
@@ -1353,9 +1361,14 @@ static void command_jump(struct iptables_command=
_state *cs)
 	cs->target->t->u.user.revision =3D cs->target->revision;
 	if (cs->target->init !=3D NULL)
 		cs->target->init(cs->target->t);
-	opts =3D xtables_merge_options(ip6tables_globals.orig_opts, opts,
-				     cs->target->extra_opts,
-				     &cs->target->option_offset);
+	if (cs->target->x6_options !=3D NULL)
+		opts =3D xtables_options_xfrm(ip6tables_globals.orig_opts, opts,
+					    cs->target->x6_options,
+					    &cs->target->option_offset);
+	else
+		opts =3D xtables_merge_options(ip6tables_globals.orig_opts, opts,
+					     cs->target->extra_opts,
+					     &cs->target->option_offset);
 	if (opts =3D=3D NULL)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
@@ -1377,8 +1390,13 @@ static void command_match(struct iptables_comman=
d_state *cs)
 	m->m->u.user.revision =3D m->revision;
 	if (m->init !=3D NULL)
 		m->init(m->m);
-	if (m !=3D m->next)
-		/* Merge options for non-cloned matches */
+	if (m =3D=3D m->next)
+		return;
+	/* Merge options for non-cloned matches */
+	if (m->x6_options !=3D NULL)
+		opts =3D xtables_options_xfrm(ip6tables_globals.orig_opts, opts,
+					    m->x6_options, &m->option_offset);
+	else if (m->extra_opts !=3D NULL)
 		opts =3D xtables_merge_options(ip6tables_globals.orig_opts, opts,
 					     m->extra_opts, &m->option_offset);
 }
@@ -1764,10 +1782,18 @@ int do_command6(int argc, char *argv[], char **=
table, struct ip6tc_handle **hand
 		cs.invert =3D FALSE;
 	}
=20
-	for (matchp =3D cs.matches; matchp; matchp =3D matchp->next)
+	for (matchp =3D cs.matches; matchp; matchp =3D matchp->next) {
+		if (matchp->match->x6_options !=3D NULL)
+			xtables_options_fcheck(matchp->match->name,
+					       matchp->match->mflags,
+					       matchp->match->x6_options);
 		if (matchp->match->final_check !=3D NULL)
 			matchp->match->final_check(matchp->match->mflags);
+	}
=20
+	if (cs.target !=3D NULL && cs.target->x6_options !=3D NULL)
+		xtables_options_fcheck(cs.target->name, cs.target->tflags,
+				       cs.target->x6_options);
 	if (cs.target !=3D NULL && cs.target->final_check !=3D NULL)
 		cs.target->final_check(cs.target->tflags);
=20
diff --git a/iptables.c b/iptables.c
index cff4a7b..269a66f 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1303,25 +1303,25 @@ static void command_default(struct iptables_com=
mand_state *cs)
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
=20
-	if (cs->target !=3D NULL && cs->target->parse !=3D NULL &&
+	if (cs->target !=3D NULL &&
+	    (cs->target->parse !=3D NULL || cs->target->x6_parse !=3D NULL) &=
&
 	    cs->c >=3D cs->target->option_offset &&
 	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
-		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
-				  cs->invert, &cs->target->tflags, &cs->fw,
-				  &cs->target->t);
+		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
+				      cs->target, &cs->fw);
 		return;
 	}
=20
 	for (matchp =3D cs->matches; matchp; matchp =3D matchp->next) {
 		m =3D matchp->match;
=20
-		if (matchp->completed || m->parse =3D=3D NULL)
+		if (matchp->completed ||
+		    (m->x6_parse =3D=3D NULL && m->parse =3D=3D NULL))
 			continue;
 		if (cs->c < m->option_offset ||
 		    cs->c >=3D m->option_offset + XT_OPTION_OFFSET_SCALE)
 			continue;
-		m->parse(cs->c - m->option_offset, cs->argv, cs->invert,
-			 &m->mflags, &cs->fw, &m->m);
+		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
 		return;
 	}
=20
@@ -1341,8 +1341,15 @@ static void command_default(struct iptables_comm=
and_state *cs)
 		if (m->init !=3D NULL)
 			m->init(m->m);
=20
-		opts =3D xtables_merge_options(iptables_globals.orig_opts, opts,
-					     m->extra_opts, &m->option_offset);
+		if (m->x6_options !=3D NULL)
+			opts =3D xtables_options_xfrm(iptables_globals.orig_opts,
+						    opts, m->x6_options,
+						    &m->option_offset);
+		else
+			opts =3D xtables_merge_options(iptables_globals.orig_opts,
+						     opts,
+						     m->extra_opts,
+						     &m->option_offset);
 		if (opts =3D=3D NULL)
 			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
=20
@@ -1380,9 +1387,14 @@ static void command_jump(struct iptables_command=
_state *cs)
 	cs->target->t->u.user.revision =3D cs->target->revision;
 	if (cs->target->init !=3D NULL)
 		cs->target->init(cs->target->t);
-	opts =3D xtables_merge_options(iptables_globals.orig_opts, opts,
-				     cs->target->extra_opts,
-				     &cs->target->option_offset);
+	if (cs->target->x6_options !=3D NULL)
+		opts =3D xtables_options_xfrm(iptables_globals.orig_opts, opts,
+					    cs->target->x6_options,
+					    &cs->target->option_offset);
+	else
+		opts =3D xtables_merge_options(iptables_globals.orig_opts, opts,
+					     cs->target->extra_opts,
+					     &cs->target->option_offset);
 	if (opts =3D=3D NULL)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
@@ -1404,13 +1416,17 @@ static void command_match(struct iptables_comma=
nd_state *cs)
 	m->m->u.user.revision =3D m->revision;
 	if (m->init !=3D NULL)
 		m->init(m->m);
-	if (m !=3D m->next) {
-		/* Merge options for non-cloned matches */
+	if (m =3D=3D m->next)
+		return;
+	/* Merge options for non-cloned matches */
+	if (m->x6_options !=3D NULL)
+		opts =3D xtables_options_xfrm(iptables_globals.orig_opts, opts,
+					    m->x6_options, &m->option_offset);
+	else if (m->extra_opts !=3D NULL)
 		opts =3D xtables_merge_options(iptables_globals.orig_opts, opts,
 					     m->extra_opts, &m->option_offset);
-		if (opts =3D=3D NULL)
-			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
-	}
+	if (opts =3D=3D NULL)
+		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
=20
 int do_command(int argc, char *argv[], char **table, struct iptc_handl=
e **handle)
@@ -1800,10 +1816,18 @@ int do_command(int argc, char *argv[], char **t=
able, struct iptc_handle **handle
 			"\nThe \"nat\" table is not intended for filtering, "
 		        "the use of DROP is therefore inhibited.\n\n");
=20
-	for (matchp =3D cs.matches; matchp; matchp =3D matchp->next)
+	for (matchp =3D cs.matches; matchp; matchp =3D matchp->next) {
+		if (matchp->match->x6_options !=3D NULL)
+			xtables_options_fcheck(matchp->match->name,
+					       matchp->match->mflags,
+					       matchp->match->x6_options);
 		if (matchp->match->final_check !=3D NULL)
 			matchp->match->final_check(matchp->match->mflags);
+	}
=20
+	if (cs.target !=3D NULL && cs.target->x6_options !=3D NULL)
+		xtables_options_fcheck(cs.target->name, cs.target->tflags,
+				       cs.target->x6_options);
 	if (cs.target !=3D NULL && cs.target->final_check !=3D NULL)
 		cs.target->final_check(cs.target->tflags);
=20
diff --git a/xshared.h b/xshared.h
index 94abb39..be53535 100644
--- a/xshared.h
+++ b/xshared.h
@@ -26,6 +26,24 @@ enum {
 struct xtables_rule_match;
 struct xtables_target;
=20
+/**
+ * xtables_afinfo - protocol family dependent information
+ * @kmod:		kernel module basename (e.g. "ip_tables")
+ * @libprefix:		prefix of .so library name (e.g. "libipt_")
+ * @family:		nfproto family
+ * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
+ * @so_rev_match:	optname to check revision support of match
+ * @so_rev_target:	optname to check revision support of target
+ */
+struct xtables_afinfo {
+	const char *kmod;
+	const char *libprefix;
+	uint8_t family;
+	uint8_t ipproto;
+	int so_rev_match;
+	int so_rev_target;
+};
+
 struct iptables_command_state {
 	union {
 		struct ipt_entry fw;
@@ -59,4 +77,6 @@ extern const char *proto_to_name(uint8_t, int);
 extern struct xtables_match *load_proto(struct iptables_command_state =
*);
 extern int subcmd_main(int, char **, const struct subcommand *);
=20
+extern const struct xtables_afinfo *afinfo;
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/xtables.c b/xtables.c
index 352963f..235e2b2 100644
--- a/xtables.c
+++ b/xtables.c
@@ -49,6 +49,7 @@
 #	define IP6T_SO_GET_REVISION_TARGET	69
 #endif
 #include <getopt.h>
+#include "iptables/internal.h"
 #include "xshared.h"
=20
 #define NPROTO	255
@@ -130,24 +131,6 @@ struct option *xtables_merge_options(struct option=
 *orig_opts,
 	return merge;
 }
=20
-/**
- * xtables_afinfo - protocol family dependent information
- * @kmod:		kernel module basename (e.g. "ip_tables")
- * @libprefix:		prefix of .so library name (e.g. "libipt_")
- * @family:		nfproto family
- * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
- * @so_rev_match:	optname to check revision support of match
- * @so_rev_target:	optname to check revision support of target
- */
-struct xtables_afinfo {
-	const char *kmod;
-	const char *libprefix;
-	uint8_t family;
-	uint8_t ipproto;
-	int so_rev_match;
-	int so_rev_target;
-};
-
 static const struct xtables_afinfo afinfo_ipv4 =3D {
 	.kmod          =3D "ip_tables",
 	.libprefix     =3D "libipt_",
@@ -166,7 +149,7 @@ static const struct xtables_afinfo afinfo_ipv6 =3D =
{
 	.so_rev_target =3D IP6T_SO_GET_REVISION_TARGET,
 };
=20
-static const struct xtables_afinfo *afinfo;
+const struct xtables_afinfo *afinfo;
=20
 /* Search path for Xtables .so files */
 static const char *xtables_libdir;
@@ -785,6 +768,8 @@ void xtables_register_match(struct xtables_match *m=
e)
 		exit(1);
 	}
=20
+	if (me->x6_options !=3D NULL)
+		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts !=3D NULL)
 		xtables_check_options(me->name, me->extra_opts);
=20
@@ -873,6 +858,8 @@ void xtables_register_target(struct xtables_target =
*me)
 		exit(1);
 	}
=20
+	if (me->x6_options !=3D NULL)
+		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts !=3D NULL)
 		xtables_check_options(me->name, me->extra_opts);
=20
diff --git a/xtoptions.c b/xtoptions.c
new file mode 100644
index 0000000..3286aa1
--- /dev/null
+++ b/xtoptions.c
@@ -0,0 +1,299 @@
+/*
+ *	Argument parser
+ *	Copyright =C2=A9 Jan Engelhardt, 2011
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of
+ *	the License, or (at your option) any later version.
+ */
+#include <errno.h>
+#include <getopt.h>
+#include <limits.h>
+#include <netdb.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include "xtables.h"
+#include "xshared.h"
+
+#define XTOPT_MKPTR(cb) \
+	((void *)((char *)(cb)->data + (cb)->entry->ptroff))
+
+/**
+ * Creates getopt options from the x6-style option map, and assigns ea=
ch a
+ * getopt id.
+ */
+struct option *
+xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
+		     const struct xt_option_entry *entry, unsigned int *offset)
+{
+	unsigned int num_orig, num_old =3D 0, num_new, i;
+	struct option *merge, *mp;
+
+	if (entry =3D=3D NULL)
+		return oldopts;
+	for (num_orig =3D 0; orig_opts[num_orig].name !=3D NULL; ++num_orig)
+		;
+	if (oldopts !=3D NULL)
+		for (num_old =3D 0; oldopts[num_old].name !=3D NULL; ++num_old)
+			;
+	for (num_new =3D 0; entry[num_new].name !=3D NULL; ++num_new)
+		;
+
+	/*
+	 * Since @oldopts also has @orig_opts already (and does so at the
+	 * start), skip these entries.
+	 */
+	oldopts +=3D num_orig;
+	num_old -=3D num_orig;
+
+	merge =3D malloc(sizeof(*mp) * (num_orig + num_old + num_new + 1));
+	if (merge =3D=3D NULL)
+		return NULL;
+
+	/* Let the base options -[ADI...] have precedence over everything */
+	memcpy(merge, orig_opts, sizeof(*mp) * num_orig);
+	mp =3D merge + num_orig;
+
+	/* Second, the new options */
+	xt_params->option_offset +=3D XT_OPTION_OFFSET_SCALE;
+	*offset =3D xt_params->option_offset;
+
+	for (i =3D 0; i < num_new; ++i, ++mp, ++entry) {
+		mp->name         =3D entry->name;
+		mp->has_arg      =3D entry->type !=3D XTTYPE_NONE;
+		mp->flag         =3D NULL;
+		mp->val          =3D entry->id + *offset;
+	}
+
+	/* Third, the old options */
+	memcpy(mp, oldopts, sizeof(*mp) * num_old);
+	mp +=3D num_old;
+	xtables_free_opts(0);
+
+	/* Clear trailing entry */
+	memset(mp, 0, sizeof(*mp));
+	return merge;
+}
+
+static void (*const xtopt_subparse[])(struct xt_option_call *) =3D {
+	[XTTYPE_NONE]        =3D NULL,
+};
+
+static const size_t xtopt_psize[] =3D {
+	[XTTYPE_NONE]        =3D 0,
+};
+
+/**
+ * The master option parsing routine. May be used for the ".x6_parse"
+ * function pointer in extensions if fully automatic parsing is desire=
d.
+ * It may be also called manually from a custom x6_parse function.
+ */
+void xtables_option_parse(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry =3D cb->entry;
+	unsigned int eflag =3D 1 << cb->entry->id;
+
+	/*
+	 * With {.id =3D P_FOO, .excl =3D P_FOO} we can have simple double-us=
e
+	 * prevention. Though it turned out that this is too much typing (mos=
t
+	 * of the options are one-time use only), so now we also have
+	 * %XTOPT_MULTI.
+	 */
+	if ((!(entry->flags & XTOPT_MULTI) || (entry->excl & eflag)) &&
+	    cb->xflags & eflag)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: option \"--%s\" can only be used once.\n",
+			cb->ext_name, cb->entry->name);
+	if (cb->invert && !(entry->flags & XTOPT_INVERT))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: option \"--%s\" cannot be inverted.\n",
+			cb->ext_name, entry->name);
+	if (entry->type !=3D XTTYPE_NONE && optarg =3D=3D NULL)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: option \"--%s\" requires an argument.\n",
+			cb->ext_name, entry->name);
+	if (entry->type <=3D ARRAY_SIZE(xtopt_subparse) &&
+	    xtopt_subparse[entry->type] !=3D NULL)
+		xtopt_subparse[entry->type](cb);
+	/* Exclusion with other flags tested later in finalize. */
+	cb->xflags |=3D 1 << entry->id;
+}
+
+/**
+ * Verifies that an extension's option map descriptor is valid, and ou=
ght to
+ * be called right after the extension has been loaded, and before opt=
ion
+ * merging/xfrm.
+ */
+void xtables_option_metavalidate(const char *name,
+				 const struct xt_option_entry *entry)
+{
+	for (; entry->name !=3D NULL; ++entry) {
+		if (entry->id >=3D CHAR_BIT * sizeof(unsigned int) ||
+		    entry->id >=3D XT_OPTION_OFFSET_SCALE)
+			xt_params->exit_err(OTHER_PROBLEM,
+				"Extension %s uses invalid ID %u\n",
+				name, entry->id);
+		if (!(entry->flags & XTOPT_PUT))
+			continue;
+		if (entry->type >=3D ARRAY_SIZE(xtopt_psize))
+			xt_params->exit_err(OTHER_PROBLEM,
+				"%s: entry type of option \"--%s\" cannot be "
+				"combined with XTOPT_PUT\n",
+				name, entry->name);
+		if (xtopt_psize[entry->type] !=3D entry->size)
+			xt_params->exit_err(OTHER_PROBLEM,
+				"%s: option \"--%s\" points to a memory block "
+				"of wrong size (expected %zu, got %zu)\n",
+				name, entry->name,
+				xtopt_psize[entry->type], entry->size);
+	}
+}
+
+/**
+ * Find an option entry by its id.
+ */
+static const struct xt_option_entry *
+xtables_option_lookup(const struct xt_option_entry *entry, unsigned in=
t id)
+{
+	for (; entry->name !=3D NULL; ++entry)
+		if (entry->id =3D=3D id)
+			return entry;
+	return NULL;
+}
+
+/**
+ * @c:		getopt id (i.e. with offset)
+ * @fw:		struct ipt_entry or ip6t_entry
+ *
+ * Dispatch arguments to the appropriate parse function, based upon th=
e
+ * extension's choice of API.
+ */
+void xtables_option_tpcall(unsigned int c, char **argv, bool invert,
+			   struct xtables_target *t, void *fw)
+{
+	struct xt_option_call cb;
+
+	if (t->x6_parse =3D=3D NULL) {
+		if (t->parse !=3D NULL)
+			t->parse(c - t->option_offset, argv, invert,
+				 &t->tflags, fw, &t->t);
+		return;
+	}
+
+	c -=3D t->option_offset;
+	cb.entry =3D xtables_option_lookup(t->x6_options, c);
+	if (cb.entry =3D=3D NULL)
+		xtables_error(OTHER_PROBLEM,
+			"Extension does not know id %u\n", c);
+	cb.arg      =3D optarg;
+	cb.invert   =3D invert;
+	cb.ext_name =3D t->name;
+	cb.data     =3D t->t->data;
+	cb.xflags   =3D t->tflags;
+	t->x6_parse(&cb);
+	t->tflags =3D cb.xflags;
+}
+
+/**
+ * @c:		getopt id (i.e. with offset)
+ * @fw:		struct ipt_entry or ip6t_entry
+ *
+ * Dispatch arguments to the appropriate parse function, based upon th=
e
+ * extension's choice of API.
+ */
+void xtables_option_mpcall(unsigned int c, char **argv, bool invert,
+			   struct xtables_match *m, void *fw)
+{
+	struct xt_option_call cb;
+
+	if (m->x6_parse =3D=3D NULL) {
+		if (m->parse !=3D NULL)
+			m->parse(c - m->option_offset, argv, invert,
+				 &m->mflags, fw, &m->m);
+		return;
+	}
+
+	c -=3D m->option_offset;
+	cb.entry =3D xtables_option_lookup(m->x6_options, c);
+	if (cb.entry =3D=3D NULL)
+		xtables_error(OTHER_PROBLEM,
+			"Extension does not know id %u\n", c);
+	cb.arg      =3D optarg;
+	cb.invert   =3D invert;
+	cb.ext_name =3D m->name;
+	cb.data     =3D m->m->data;
+	cb.xflags   =3D m->mflags;
+	m->x6_parse(&cb);
+	m->mflags =3D cb.xflags;
+}
+
+/**
+ * @name:	name of extension
+ * @entry:	current option (from all ext's entries) being validated
+ * @xflags:	flags the extension has collected
+ * @i:		conflicting option (id) to test for
+ */
+static void
+xtables_option_fcheck2(const char *name, const struct xt_option_entry =
*entry,
+		       const struct xt_option_entry *other,
+		       unsigned int xflags)
+{
+	unsigned int ef =3D 1 << entry->id, of =3D 1 << other->id;
+
+	if (entry->also & of && !(xflags & of))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: option \"--%s\" also requires \"--%s\".\n",
+			name, entry->name, other->name);
+
+	if (!(entry->excl & of))
+		/* Use of entry does not collide with other option, good. */
+		return;
+	if ((xflags & (ef | of)) !=3D (ef | of))
+		/* Conflicting options were not used. */
+		return;
+
+	xt_params->exit_err(PARAMETER_PROBLEM,
+		"%s: option \"--%s\" cannot be used together with \"--%s\".\n",
+		name, entry->name, other->name);
+}
+
+/**
+ * @name:	name of extension
+ * @xflags:	accumulated flags
+ * @entry:	extension's option table
+ *
+ * Check that all option constraints have been met. This effectively r=
eplaces
+ * ->final_check of the older API.
+ */
+void xtables_options_fcheck(const char *name, unsigned int xflags,
+			    const struct xt_option_entry *table)
+{
+	const struct xt_option_entry *entry, *other;
+	unsigned int i;
+
+	for (entry =3D table; entry->name !=3D NULL; ++entry) {
+		if (entry->flags & XTOPT_MAND &&
+		    !(xflags & (1 << entry->id)))
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"%s: option \"--%s\" must be specified\n",
+				name, entry->name);
+
+		for (i =3D 0; i < CHAR_BIT * sizeof(entry->id); ++i) {
+			if (entry->id =3D=3D i)
+				/*
+				 * Avoid conflict with self. Multi-use check
+				 * was done earlier in xtables_option_parse.
+				 */
+				continue;
+			other =3D xtables_option_lookup(table, i);
+			if (other =3D=3D NULL)
+				continue;
+			xtables_option_fcheck2(name, entry, other, xflags);
+		}
+	}
+}
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
