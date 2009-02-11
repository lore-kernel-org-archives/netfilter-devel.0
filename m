From: jamal <hadi@cyberus.ca>
Subject: [RFC] libxtables:  Introduce xtables_init_all()
Date: Wed, 11 Feb 2009 12:48:36 -0500
Message-ID: <1234374516.20903.130.camel@dogo.mojatatu.com>
References: <1234301869.20903.82.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111624380.20223@fbirervta.pbzchgretzou.qr>
	 <1234373064.20903.121.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:16925 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZBKRud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:50:33 -0500
Received: by ey-out-2122.google.com with SMTP id 25so36803eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:50:30 -0800 (PST)
In-Reply-To: <1234373064.20903.121.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 12:24 -0500, jamal wrote:

> 
> Ok, goody - I actually had almost finished it; have some cycles.
> I will post shortly.
> 

Ok, here it is inlined. I just got pulled off into some tangent, so will
sync with Patrick's tree only later today and fixup all the issues you
brought up.

With this patch (in addition to the other 3), I think tc/m_xt.c will
be a happy camper. Any additional changes (such as killing program_name)
are not exposed to user of xtables so should not affect it.
I have moved around xtables_set_params() in this patch for readability
purposes inside xtables.c 

cheers,
jamal

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 1956cf0..05a963e 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -14,6 +14,7 @@
 #define ip6t_tryload		xt_tryload
 
 extern int line;
+extern struct xtables_globals ip6tables_globals;
 
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
diff --git a/include/iptables.h b/include/iptables.h
index f7ae0cc..69564fe 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -15,6 +15,7 @@
 
 extern int line;
 
+extern struct xtables_globals iptables_globals;
 /* Your shared library should call one of these. */
 extern int do_command(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
diff --git a/include/xtables.h.in b/include/xtables.h.in
index d49fea9..477d534 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -209,6 +209,7 @@ extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
 extern void xtables_free_opts(int reset_offset);
 extern void xtables_set_revision(char *name, u_int8_t revision);
+extern int xtables_init_all(struct xtables_globals *xtp, uint8_t
nfproto);
 
 
 extern struct option *xtables_merge_options(struct option *oldopts,
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index acaf97b..c7557d4 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -131,8 +131,13 @@ int main(int argc, char *argv[])
 	line = 0;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
+
+	ip6tables_globals.program_name = "ip6tables-restore",
+	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",ip6tables_globals.program_name,ip6tables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 32b5992..dc066b8 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -140,8 +140,13 @@ int main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
+
+	ip6tables_globals.program_name = "ip6tables-save",
+	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",ip6tables_globals.program_name, ip6tables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index cea4818..27583be 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -53,8 +53,13 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV6);
+
+	ip6tables_globals.program_name = "ip6tables",
+	ret = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",ip6tables_globals.program_name, ip6tables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables.c b/ip6tables.c
index 3bc29bd..474405b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -148,7 +148,6 @@ void ip6tables_exit_error(enum xtables_exittype
status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.program_name = "ip6tables",
 	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
@@ -1333,7 +1332,6 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
            demand-load a protocol. */
 	opterr = 0;
 
-	xtables_set_params(&ip6tables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/iptables-restore.c b/iptables-restore.c
index 810806f..8a260df 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -133,8 +133,13 @@ main(int argc, char *argv[])
 	line = 0;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
+
+	iptables_globals.program_name = "iptables-restore";
+	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",iptables_globals.program_name, iptables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-save.c b/iptables-save.c
index c4306fd..b36ed34 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -140,8 +140,13 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
+
+	iptables_globals.program_name = "iptables-save";
+	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",iptables_globals.program_name, iptables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-standalone.c b/iptables-standalone.c
index ece7cf4..3aed1c1 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -54,8 +54,13 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 
 	xtables_program_name = program_name;
-	xtables_init();
-	xtables_set_nfproto(NFPROTO_IPV4);
+	iptables_globals.program_name = "iptables";
+
+	ret = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables
\n",iptables_globals.program_name, iptables_globals.program_version);
+		exit(1);
+	}
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables.c b/iptables.c
index c5b48c4..ce43075 100644
--- a/iptables.c
+++ b/iptables.c
@@ -149,7 +149,6 @@ void iptables_exit_error(enum xtables_exittype
status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.program_name = "iptables",
 	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
@@ -1355,7 +1354,6 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
            demand-load a protocol. */
 	opterr = 0;
 
-	xtables_set_params(&iptables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/xtables.c b/xtables.c
index 48b4104..c0077e0 100644
--- a/xtables.c
+++ b/xtables.c
@@ -64,31 +64,6 @@ void basic_exit_err(enum xtables_exittype status,
const char *msg, ...)
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
@@ -240,6 +215,38 @@ void xtables_set_revision(char *name, u_int8_t
revision)
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



