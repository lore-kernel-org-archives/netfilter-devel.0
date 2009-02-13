From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce xtables_init_all()
Date: Fri, 13 Feb 2009 09:22:10 -0500
Message-ID: <1234534930.4078.17.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tlnytqj0IPvV0Ft8KfuF"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:42700 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZBMOYK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:24:10 -0500
Received: by nf-out-0910.google.com with SMTP id d21so113854nfb.21
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2009 06:24:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-tlnytqj0IPvV0Ft8KfuF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ok, last one - a little cosmetics but it helps to reduce code on the
app; 

anything after this will be just cleanups etc.

cheers,
jamal

--=-tlnytqj0IPvV0Ft8KfuF
Content-Disposition: attachment; filename=iptv3-4
Content-Type: text/plain; name=iptv3-4; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 2c2f361331ae498816be371c222ff363f7d83388
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Fri Feb 13 09:14:17 2009 -0500

    Introduce xtables_init_all() which hides three calls
    xtables_init(), xtables_set_nfproto(), and xtables_set_params().
    Make ip[6]tables-restore, ip[6]tables-save and ip[6]tables-standalone
    use it.
    I moved xtables_set_params around for readability reasons.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index ce41b37..ab3bb06 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -209,7 +209,7 @@ extern void xtables_set_revision(char *name, u_int8_t revision);
 extern void xtables_free_opts(int reset_offset);
 extern struct option *xtables_merge_options(struct option *oldopts,
 	const struct option *newopts, unsigned int *option_offset);
-
+extern int xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto);
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
 extern struct xtables_target *xtables_find_target(const char *name,
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 3d535de..0f06a1c 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -131,9 +131,14 @@ int main(int argc, char *argv[])
 	line = 0;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
 	ip6tables_globals.program_name = "ip6tables-restore";
+	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				ip6tables_globals.program_name,
+				ip6tables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 3af81ab..9de34b5 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -140,9 +140,14 @@ int main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
 	ip6tables_globals.program_name = "ip6tables-save";
+	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				ip6tables_globals.program_name,
+				ip6tables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index ab77065..b40c79b 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -53,9 +53,15 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
 	ip6tables_globals.program_name = "ip6tables";
+	ret = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				ip6tables_globals.program_name,
+				ip6tables_globals.program_version);
+		exit(1);
+	}
+
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables.c b/ip6tables.c
index 8553d08..3cc124a 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1330,7 +1330,6 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
            demand-load a protocol. */
 	opterr = 0;
 
-	xtables_set_params(&ip6tables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/iptables-restore.c b/iptables-restore.c
index 0103016..c52af0a 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -133,9 +133,14 @@ main(int argc, char *argv[])
 	line = 0;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
 	iptables_globals.program_name = "iptables-restore";
+	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				iptables_globals.program_name,
+				iptables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-save.c b/iptables-save.c
index 396406f..312673a 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -140,9 +140,14 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
 	iptables_globals.program_name = "iptables-save";
+	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				iptables_globals.program_name,
+				iptables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 007f2c2..6090ea1 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -54,9 +54,14 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
 	iptables_globals.program_name = "iptables";
+	ret = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				iptables_globals.program_name,
+				iptables_globals.program_version);
+				exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables.c b/iptables.c
index 8f0dd46..c83da15 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1352,7 +1352,6 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
            demand-load a protocol. */
 	opterr = 0;
 
-	xtables_set_params(&iptables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/xtables.c b/xtables.c
index 98ba619..7e87cd2 100644
--- a/xtables.c
+++ b/xtables.c
@@ -64,31 +64,6 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 }
 
 
-/**
- * xtables_set_params - set the global parameters used by xtables
- * @xtp:	input xtables_globals structure
- *
- * The app is expected to pass a valid xtables_globals data-filled
- * with proper values
- * @xtp cannot be NULL
- *
- * Returns -1 on failure to set and 0 on success
- */
-int xtables_set_params(struct xtables_globals *xtp)
-{
-	if (!xtp) {
-		fprintf(stderr, "%s: Illegal global params\n",__func__);
-		return -1;
-	}
-
-	xt_params = xtp;
-
-	if (!xt_params->exit_err)
-		xt_params->exit_err = basic_exit_err;
-
-	return 0;
-}
-
 void xtables_free_opts(int reset_offset)
 {
 	if (xt_params->opts != xt_params->orig_opts) {
@@ -220,6 +195,38 @@ void xtables_set_nfproto(uint8_t nfproto)
 }
 
 /**
+ * xtables_set_params - set the global parameters used by xtables
+ * @xtp:	input xtables_globals structure
+ *
+ * The app is expected to pass a valid xtables_globals data-filled
+ * with proper values
+ * @xtp cannot be NULL
+ *
+ * Returns -1 on failure to set and 0 on success
+ */
+int xtables_set_params(struct xtables_globals *xtp)
+{
+	if (!xtp) {
+		fprintf(stderr, "%s: Illegal global params\n",__func__);
+		return -1;
+	}
+
+	xt_params = xtp;
+
+	if (!xt_params->exit_err)
+		xt_params->exit_err = basic_exit_err;
+
+	return 0;
+}
+
+int xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto)
+{
+	xtables_init();
+	xtables_set_nfproto(nfproto);
+	return xtables_set_params(xtp);
+}
+
+/**
  * xtables_*alloc - wrappers that exit on failure
  */
 void *xtables_calloc(size_t count, size_t size)

--=-tlnytqj0IPvV0Ft8KfuF--

