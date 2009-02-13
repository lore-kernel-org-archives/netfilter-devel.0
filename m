From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce xtables_merge_options()
Date: Fri, 13 Feb 2009 08:51:32 -0500
Message-ID: <1234533092.4078.13.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-250r90qzZSG3094Aqgnn"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:44390 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZBMNxc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:53:32 -0500
Received: by nf-out-0910.google.com with SMTP id d21so112758nfb.21
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2009 05:53:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-250r90qzZSG3094Aqgnn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

One more to go...

cheers,
jamal

--=-250r90qzZSG3094Aqgnn
Content-Disposition: attachment; filename=iptv3-3
Content-Type: text/plain; name=iptv3-3; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 5575e90e41f5b61539a524dc39056d3eaa96bdd0
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Fri Feb 13 08:36:44 2009 -0500

    Introduce xtables_merge_options() for re-use reasons. Apps
    can use it instead of each defining their own merge_options().
    Made iptables and ip6tables use the new shared interface.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index a4c4cb7..ce41b37 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -207,6 +207,8 @@ extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
 extern void xtables_set_revision(char *name, u_int8_t revision);
 extern void xtables_free_opts(int reset_offset);
+extern struct option *xtables_merge_options(struct option *oldopts,
+	const struct option *newopts, unsigned int *option_offset);
 
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
@@ -233,6 +235,8 @@ int xtables_check_inverse(const char option[], int *invert,
 	int *my_optind, int argc);
 extern struct xtables_globals *xt_params;
 #define exit_error xt_params->exit_err
+#define OPTION_OFFSET 256
+
 extern void xtables_param_act(unsigned int, const char *, ...);
 
 extern const char *xtables_ipaddr_to_numeric(const struct in_addr *);
diff --git a/ip6tables.c b/ip6tables.c
index 2765308..8553d08 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -84,8 +84,6 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S' };
 
-#define OPTION_OFFSET 256
-
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
 #define OPT_SOURCE	0x00002U
@@ -144,7 +142,6 @@ static struct option original_opts[] = {
 int line = -1;
 
 static struct option *opts = original_opts;
-static unsigned int global_option_offset = 0;
 void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
@@ -503,34 +500,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	}
 }
 
-static struct option *
-merge_options(struct option *oldopts, const struct option *newopts,
-	      unsigned int *option_offset)
-{
-	unsigned int num_old, num_new, i;
-	struct option *merge;
-
-	if (newopts == NULL)
-		return oldopts;
-
-	for (num_old = 0; oldopts[num_old].name; num_old++);
-	for (num_new = 0; newopts[num_new].name; num_new++);
-
-	global_option_offset += OPTION_OFFSET;
-	*option_offset = global_option_offset;
-
-	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
-	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	xtables_free_opts(0); /* Release previous options merged if any */
-	for (i = 0; i < num_new; i++) {
-		merge[num_old + i] = newopts[i];
-		merge[num_old + i].val += *option_offset;
-	}
-	memset(merge + num_old + num_new, 0, sizeof(struct option));
-
-	return merge;
-}
-
 static void
 print_num(u_int64_t number, unsigned int format)
 {
@@ -1584,7 +1553,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1638,7 +1607,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				m->init(m->m);
 			if (m != m->next)
 				/* Merge options for non-cloned matches */
-				opts = merge_options(opts, m->extra_opts, &m->option_offset);
+				opts = xtables_merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;
 
@@ -1785,7 +1754,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = merge_options(opts,
+					opts = xtables_merge_options(opts,
 					    m->extra_opts, &m->option_offset);
 
 					optind--;
diff --git a/iptables.c b/iptables.c
index 0487442..8f0dd46 100644
--- a/iptables.c
+++ b/iptables.c
@@ -81,8 +81,6 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S' };
 
-#define OPTION_OFFSET 256
-
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
 #define OPT_SOURCE	0x00002U
@@ -143,7 +141,6 @@ static struct option original_opts[] = {
 int line = -1;
 
 static struct option *opts = original_opts;
-static unsigned int global_option_offset = 0;
 
 void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
@@ -507,36 +504,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	}
 }
 
-static struct option *
-merge_options(struct option *oldopts, const struct option *newopts,
-	      unsigned int *option_offset)
-{
-	unsigned int num_old, num_new, i;
-	struct option *merge;
-
-	if (newopts == NULL)
-		return oldopts;
-
-	for (num_old = 0; oldopts[num_old].name; num_old++);
-	for (num_new = 0; newopts[num_new].name; num_new++);
-
-	global_option_offset += OPTION_OFFSET;
-	*option_offset = global_option_offset;
-
-	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
-	if (merge == NULL)
-		return NULL;
-	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	xtables_free_opts(0); /* Release previous options merged if any */
-	for (i = 0; i < num_new; i++) {
-		merge[num_old + i] = newopts[i];
-		merge[num_old + i].val += *option_offset;
-	}
-	memset(merge + num_old + num_new, 0, sizeof(struct option));
-
-	return merge;
-}
-
 static void
 print_num(u_int64_t number, unsigned int format)
 {
@@ -1600,7 +1567,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1660,7 +1627,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				m->init(m->m);
 			if (m != m->next) {
 				/* Merge options for non-cloned matches */
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     m->extra_opts,
 						     &m->option_offset);
 				if (opts == NULL)
@@ -1814,7 +1781,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = merge_options(opts,
+					opts = xtables_merge_options(opts,
 							     m->extra_opts,
 							     &m->option_offset);
 					if (opts == NULL)
diff --git a/xtables.c b/xtables.c
index 9b4b27d..98ba619 100644
--- a/xtables.c
+++ b/xtables.c
@@ -39,6 +39,7 @@
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
 #endif
+#include <getopt.h>
 
 #define NPROTO	255
 
@@ -98,6 +99,36 @@ void xtables_free_opts(int reset_offset)
 	}
 }
 
+struct option *xtables_merge_options(struct option *oldopts,
+				     const struct option *newopts,
+				     unsigned int *option_offset)
+{
+	unsigned int num_old, num_new, i;
+	struct option *merge;
+
+	if (newopts == NULL)
+		return oldopts;
+
+	for (num_old = 0; oldopts[num_old].name; num_old++) ;
+	for (num_new = 0; newopts[num_new].name; num_new++) ;
+
+	xt_params->option_offset += OPTION_OFFSET;
+	*option_offset = xt_params->option_offset;
+
+	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
+	if (merge == NULL)
+		return NULL;
+	memcpy(merge, oldopts, num_old * sizeof(struct option));
+	xtables_free_opts(0);	/* Release any old options merged  */
+	for (i = 0; i < num_new; i++) {
+		merge[num_old + i] = newopts[i];
+		merge[num_old + i].val += *option_offset;
+	}
+	memset(merge + num_old + num_new, 0, sizeof(struct option));
+
+	return merge;
+}
+
 void xtables_set_revision(char *name, u_int8_t revision)
 {
 	/* Old kernel sources don't have ".revision" field,

--=-250r90qzZSG3094Aqgnn--

