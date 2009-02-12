From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Make iptables and ip6tables use
	xtables_free_opts()
Date: Thu, 12 Feb 2009 11:50:06 -0500
Message-ID: <1234457406.3271.23.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-lNKEAL15lXtZtqM8VjKz"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35183 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbZBLQwC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:52:02 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so667938ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2009 08:52:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-lNKEAL15lXtZtqM8VjKz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I have two more patches to send after this which i consider needed
to complete for tc/m_xt.c future versions - will do later today.

The first one is a rejuvenated version of what i sent yesterday 
under "[PATCH] libxtables:  Introduce xtables_merge_options()"
and the second one what i sent under subject "RFC: introduce xtables
global param struct" sent yesterday.

cheers,
jamal

--=-lNKEAL15lXtZtqM8VjKz
Content-Disposition: attachment; filename=iptv3-2
Content-Type: text/plain; name=iptv3-2; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 9ec18ffd759533bb0b2749d82cc832f86e6dd66f
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Thu Feb 12 11:43:01 2009 -0500

    Make iptables and ip6tables use xtables_free_opts()
    
    The patch modifies xtables_globals to introduce orig_opts
    and xtables_free_opts() to emulate what free_opts used to do.
    We also get rid of the copies of free_opts() that iptables
    and ip6tables keep.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index ee1c79b..a4c4cb7 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -187,6 +187,7 @@ struct xtables_globals
 {
 	unsigned int option_offset;
 	const char *program_name, *program_version;
+	struct option *orig_opts;
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
@@ -205,7 +206,7 @@ extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
 extern void xtables_set_revision(char *name, u_int8_t revision);
-void xtables_free_opts(int reset_offset, struct option *original_opts);
+extern void xtables_free_opts(int reset_offset);
 
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
diff --git a/ip6tables.c b/ip6tables.c
index b06cf84..2765308 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -150,6 +150,7 @@ struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.opts = original_opts,
+	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
 
@@ -224,16 +225,6 @@ proto_to_name(u_int8_t proto, int nolookup)
 	return NULL;
 }
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -241,7 +232,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -351,7 +342,7 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -530,7 +521,7 @@ merge_options(struct option *oldopts, const struct option *newopts,
 
 	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	free_opts(0); /* Release previous options merged if any */
+	xtables_free_opts(0); /* Release previous options merged if any */
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
 		merge[num_old + i].val += *option_offset;
@@ -2048,7 +2039,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	for (i = 0; i < ndaddrs; i++)
 		free(&daddrs[i]);
 
-	free_opts(1);
+	xtables_free_opts(1);
 
 	return ret;
 }
diff --git a/iptables.c b/iptables.c
index e30ebea..0487442 100644
--- a/iptables.c
+++ b/iptables.c
@@ -151,6 +151,7 @@ struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.opts = original_opts,
+	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 };
 
@@ -237,16 +238,6 @@ enum {
 	IPT_DOTTED_MASK
 };
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -254,7 +245,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -364,7 +355,7 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -536,7 +527,7 @@ merge_options(struct option *oldopts, const struct option *newopts,
 	if (merge == NULL)
 		return NULL;
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	free_opts(0); /* Release previous options merged if any */
+	xtables_free_opts(0); /* Release previous options merged if any */
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
 		merge[num_old + i].val += *option_offset;
@@ -1342,7 +1333,7 @@ get_kernel_version(void) {
 
 	if (uname(&uts) == -1) {
 		fprintf(stderr, "Unable to retrieve kernel version.\n");
-		free_opts(1);
+		xtables_free_opts(1);
 		exit(1);
 	}
 
@@ -2087,7 +2078,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	free(saddrs);
 	free(daddrs);
-	free_opts(1);
+	xtables_free_opts(1);
 
 	return ret;
 }
diff --git a/xtables.c b/xtables.c
index fe3d3f9..9b4b27d 100644
--- a/xtables.c
+++ b/xtables.c
@@ -88,12 +88,11 @@ int xtables_set_params(struct xtables_globals *xtp)
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

--=-lNKEAL15lXtZtqM8VjKz--

