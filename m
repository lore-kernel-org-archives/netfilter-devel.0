From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables:  Introduce xtables_merge_options()
Date: Tue, 10 Feb 2009 16:27:30 -0500
Message-ID: <1234301250.20903.73.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Dm9uM75NLb5Qa+DBKFgP"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:63639 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbZBJV3Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:29:25 -0500
Received: by ewy14 with SMTP id 14so71156ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 13:29:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Dm9uM75NLb5Qa+DBKFgP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Sorry, I said i wasnt gonna send more until i hear the ACKs/NACKs on all
patches  but found myself with extra cycles; so i am sending 2-3 more.
This one is for code reuse so i dont have to keep up in tc/ipt
with the latest variant inside iptables.

cheers,
jamal

--=-Dm9uM75NLb5Qa+DBKFgP
Content-Disposition: attachment; filename=iptv2-6
Content-Type: text/plain; name=iptv2-6; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 7803e039c046cd46123eb949a76e355bb808046c
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Tue Feb 10 15:34:02 2009 -0500

    Introduce xtables_merge_options() for re-use reasons. Apps
    can use it instead of each defining their own merge_options().
    Made iptables and ip6tables use the new shared interface.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index da7ee6b..609e6a6 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -31,6 +31,7 @@
 #define XTABLES_VERSION "libxtables.so.@libxtables_vmajor@"
 #define XTABLES_VERSION_CODE @libxtables_vmajor@
 
+#define OPTION_OFFSET 256
 struct in_addr;
 
 /* Include file for additions: new matches and targets. */
@@ -188,6 +189,7 @@ struct xtables_globals
 	unsigned int option_offset;
 	char *program_version;
 	char *program_name;
+	struct option *orig_opts;
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
@@ -205,8 +207,10 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
-void xtables_free_opts(int reset_offset, struct option *original_opts);
+void xtables_free_opts(int reset_offset);
 
+extern struct option *xtables_merge_options(struct option *oldopts,
+		const struct option *newopts, unsigned int *option_offset);
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
 extern struct xtables_target *xtables_find_target(const char *name,
diff --git a/ip6tables.c b/ip6tables.c
index 9262b14..2ac3a1d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -84,7 +84,6 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S' };
 
-#define OPTION_OFFSET 256
 
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
@@ -151,6 +150,7 @@ struct xtables_globals ip6tables_globals = {
 	.program_version = IPTABLES_VERSION,
 	.program_name = "ip6tables",
 	.opts = original_opts,
+	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
 
@@ -513,34 +513,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
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
-	free_opts(0); /* Release previous options merged if any */
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
@@ -1602,7 +1574,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1656,7 +1628,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				m->init(m->m);
 			if (m != m->next)
 				/* Merge options for non-cloned matches */
-				opts = merge_options(opts, m->extra_opts, &m->option_offset);
+				opts = xtables_merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;
 
@@ -1803,7 +1775,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = merge_options(opts,
+					opts = xtables_merge_options(opts,
 					    m->extra_opts, &m->option_offset);
 
 					optind--;
diff --git a/iptables.c b/iptables.c
index fe28e50..d079125 100644
--- a/iptables.c
+++ b/iptables.c
@@ -81,7 +81,6 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S' };
 
-#define OPTION_OFFSET 256
 
 #define OPT_NONE	0x00000U
 #define OPT_NUMERIC	0x00001U
@@ -152,6 +151,7 @@ struct xtables_globals iptables_globals = {
 	.program_version = IPTABLES_VERSION,
 	.program_name = "iptables",
 	.opts = original_opts,
+	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 };
 
@@ -517,36 +517,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
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
-	free_opts(0); /* Release previous options merged if any */
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
@@ -1618,7 +1588,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1678,7 +1648,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				m->init(m->m);
 			if (m != m->next) {
 				/* Merge options for non-cloned matches */
-				opts = merge_options(opts,
+				opts = xtables_merge_options(opts,
 						     m->extra_opts,
 						     &m->option_offset);
 				if (opts == NULL)
@@ -1832,7 +1802,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = merge_options(opts,
+					opts = xtables_merge_options(opts,
 							     m->extra_opts,
 							     &m->option_offset);
 					if (opts == NULL)
diff --git a/xtables.c b/xtables.c
index 8e28d5e..805b940 100644
--- a/xtables.c
+++ b/xtables.c
@@ -39,6 +39,7 @@
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
 #endif
+#include <getopt.h>
 
 #define NPROTO	255
 
@@ -88,17 +89,47 @@ int xtables_set_params(struct xtables_globals *xtp)
 	return 0;
 }
 
-void xtables_free_opts(int reset_offset, struct option *original_opts)
+void xtables_free_opts(int reset_offset)
 {
-	if (xt_params->opts != original_opts) {
-		if (original_opts) 
-			free(xt_params->opts);
-		xt_params->opts = original_opts;
+	if (xt_params->opts != xt_params->orig_opts) {
+		free(xt_params->opts);
+		xt_params->opts = xt_params->orig_opts;
 		if (reset_offset)
 			xt_params->option_offset = 0;
 	}
 }
 
+
+struct option *
+xtables_merge_options(struct option *oldopts, const struct option *newopts,
+	      unsigned int *option_offset)
+{
+	unsigned int num_old, num_new, i;
+	struct option *merge;
+
+	if (newopts == NULL)
+		return oldopts;
+
+	for (num_old = 0; oldopts[num_old].name; num_old++);
+	for (num_new = 0; newopts[num_new].name; num_new++);
+
+	xt_params->option_offset += OPTION_OFFSET;
+	*option_offset = xt_params->option_offset;
+
+	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
+	if (merge == NULL)
+		return NULL;
+	memcpy(merge, oldopts, num_old * sizeof(struct option));
+	xtables_free_opts(0); /* Release any old options merged  */
+	for (i = 0; i < num_new; i++) {
+		merge[num_old + i] = newopts[i];
+		merge[num_old + i].val += *option_offset;
+	}
+	memset(merge + num_old + num_new, 0, sizeof(struct option));
+
+	return merge;
+}
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")

--=-Dm9uM75NLb5Qa+DBKFgP--

