From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/4] userspace: core changes for the new interface
Date: Sun, 21 Jun 2009 00:05:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210002590.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:56011 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZFTWFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:05:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4FC2E88287
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:05:07 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UI0jv9i7fX0Q for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:05:07 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id 352508825F
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:05:07 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patches by which the iptables/ip6tables binaries use the new 
*GET_REPLACE operation and fall back to the old *PUT_REPLACE if the former 
is not supported by the kernel. If the new operation is supported and an 
error block is received, the match/target specific error reporting 
function is called.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 configure.ac                              |    2 +
 include/linux/netfilter/x_tables.h        |    6 ++++
 include/linux/netfilter_ipv4/ip_tables.h  |   10 +++++++
 include/linux/netfilter_ipv6/ip6_tables.h |   10 +++++++
 include/xtables.h.in                      |   13 +++++++++
 ip6tables.c                               |   35 +++++++++++++++++++++++++
 iptables.c                                |   35 +++++++++++++++++++++++++
 libiptc/libip4tc.c                        |    1 +
 libiptc/libip6tc.c                        |    1 +
 libiptc/libiptc.c                         |   40 ++++++++++++++++++++++++++++-
 xtables.c                                 |   27 ++++++++++++++++++++
 11 files changed, 174 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 74c3835..62a3aaf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@
 AC_INIT([iptables], [1.4.4])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=2
+libxtables_vcurrent=3
 libxtables_vage=0
 
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 89eae5c..52365fb 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -68,6 +68,12 @@ struct xt_standard_target
 	int verdict;
 };
 
+struct xt_error_entry {
+	__u8 errcode;
+	__u8 match;
+	unsigned char data[0];
+};
+
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index a9f21c9..941a0f8 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -109,7 +109,8 @@ struct ipt_entry
 #define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
-#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
+#define IPT_SO_GET_REPLACE		(IPT_BASE_CTL + 4)
+#define IPT_SO_GET_MAX			IPT_SO_GET_REPLACE
 
 #define IPT_CONTINUE XT_CONTINUE
 #define IPT_RETURN XT_RETURN
@@ -128,6 +129,13 @@ struct ipt_entry
 #define IPT_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
 #define IPT_UDP_INV_MASK	XT_UDP_INV_MASK
 
+enum {
+	IPT_ICMP_ERR_NONE,
+	IPT_ICMP_ERR_PROTO,
+	IPT_ICMP_ERR_FLAGS,
+	IPT_ICMP_ERR_MAX,
+};
+
 /* ICMP matching stuff */
 struct ipt_icmp
 {
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 70ed8a1..eb5cbb4 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -162,7 +162,8 @@ struct ip6t_error
 #define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
 #define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 4)
 #define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
-#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
+#define IP6T_SO_GET_REPLACE		(IP6T_BASE_CTL + 6)
+#define IP6T_SO_GET_MAX			IP6T_SO_GET_REPLACE
 
 /* CONTINUE verdict for targets */
 #define IP6T_CONTINUE XT_CONTINUE
@@ -188,6 +189,13 @@ struct ip6t_error
 #define IP6T_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
 #define IP6T_UDP_INV_MASK	XT_UDP_INV_MASK
 
+enum {
+	IP6T_ICMPV6_ERR_NONE,
+	IP6T_ICMPV6_ERR_PROTO,
+	IP6T_ICMPV6_ERR_FLAGS,
+	IP6T_ICMPV6_ERR_MAX,
+};
+
 /* ICMP matching stuff */
 struct ip6t_icmp
 {
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 4d4ca0a..fd9d69d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -73,6 +73,10 @@ struct xtables_match
 
 	/* Final check; exit if not ok. */
 	void (*final_check)(unsigned int flags);
+	
+	/* Kernel error handling */
+	void (*kernel_error)(u_int8_t errcode, u_int8_t family,
+			     const struct xt_entry_match *match);
 
 	/* Prints out the match iff non-NULL: put space at end */
 	/* ip is struct ipt_ip * for example */
@@ -113,7 +117,6 @@ struct xtables_target
 
 	u_int16_t family;
 
-
 	/* Size of target data. */
 	size_t size;
 
@@ -136,6 +139,10 @@ struct xtables_target
 	/* Final check; exit if not ok. */
 	void (*final_check)(unsigned int flags);
 
+	/* Kernel error handling */
+	void (*kernel_error)(u_int8_t errcode, u_int8_t family,
+			     const struct xt_entry_target *target);
+
 	/* Prints out the target iff non-NULL: put space at end */
 	void (*print)(const void *ip,
 		      const struct xt_entry_target *target, int numeric);
@@ -201,6 +208,8 @@ struct xtables_globals
 	struct option *orig_opts;
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+	void (*err_head)(const char *msg, ...) __attribute__((format(printf,1,2)));
+	void (*exit_tail)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
 #ifdef __cplusplus
@@ -250,6 +259,8 @@ int xtables_check_inverse(const char option[], int *invert,
 	int *my_optind, int argc);
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
+#define xtables_error_head (xt_params->err_head)
+#define xtables_error_tail (xt_params->exit_tail)
 
 extern void xtables_param_act(unsigned int, const char *, ...);
 
diff --git a/ip6tables.c b/ip6tables.c
index 35067f8..2d3ed61 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -142,12 +142,16 @@ static struct option original_opts[] = {
 int line = -1;
 
 void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+void ip6tables_err_head(const char *msg, ...) __attribute__((format(printf,1,2)));
+void ip6tables_exit_tail(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
+	.err_head = ip6tables_err_head,
+	.exit_tail = ip6tables_exit_tail,
 };
 
 /* Table of legal combinations of commands and options.  If any of the
@@ -343,6 +347,37 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
+void
+ip6tables_err_head(const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+}
+
+void
+ip6tables_exit_tail(enum xtables_exittype status, const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+	if (status == PARAMETER_PROBLEM)
+		exit_tryhelp(status);
+	if (status == VERSION_PROBLEM)
+		fprintf(stderr,
+			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
+	/* On error paths, make sure that we don't leak memory */
+	xtables_free_opts(1);
+	exit(status);
+}
+
 static void
 generic_opt_check(int command, int options)
 {
diff --git a/iptables.c b/iptables.c
index 649baf4..84a5c12 100644
--- a/iptables.c
+++ b/iptables.c
@@ -141,6 +141,8 @@ static struct option original_opts[] = {
 int line = -1;
 
 void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+void iptables_err_head(const char *msg, ...) __attribute__((format(printf,1,2)));
+void iptables_exit_tail(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
@@ -148,6 +150,8 @@ struct xtables_globals iptables_globals = {
 	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
+	.err_head = iptables_err_head,
+	.exit_tail = iptables_exit_tail,
 };
 
 /* Table of legal combinations of commands and options.  If any of the
@@ -356,6 +360,37 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
+void
+iptables_err_head(const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+}
+
+void
+iptables_exit_tail(enum xtables_exittype status, const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+	if (status == PARAMETER_PROBLEM)
+		exit_tryhelp(status);
+	if (status == VERSION_PROBLEM)
+		fprintf(stderr,
+			"Perhaps iptables or your kernel needs to be upgraded.\n");
+	/* On error paths, make sure that we don't leak memory */
+	xtables_free_opts(1);
+	exit(status);
+}
+
 static void
 generic_opt_check(int command, int options)
 {
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 1f33f1c..cd32450 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -104,6 +104,7 @@ typedef unsigned int socklen_t;
 #define SO_GET_INFO		IPT_SO_GET_INFO
 #define SO_GET_ENTRIES		IPT_SO_GET_ENTRIES
 #define SO_GET_VERSION		IPT_SO_GET_VERSION
+#define SO_GET_REPLACE		IPT_SO_GET_REPLACE
 
 #define STANDARD_TARGET		IPT_STANDARD_TARGET
 #define LABEL_RETURN		IPTC_LABEL_RETURN
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 5966841..5cc40d2 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -99,6 +99,7 @@ typedef unsigned int socklen_t;
 #define SO_GET_INFO		IP6T_SO_GET_INFO
 #define SO_GET_ENTRIES		IP6T_SO_GET_ENTRIES
 #define SO_GET_VERSION		IP6T_SO_GET_VERSION
+#define SO_GET_REPLACE		IP6T_SO_GET_REPLACE
 
 #define STANDARD_TARGET		IP6T_STANDARD_TARGET
 #define LABEL_RETURN		IP6TC_LABEL_RETURN
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 4c3437e..9fe0d75 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2545,6 +2545,7 @@ TC_COMMIT(struct xtc_handle *handle)
 	size_t counterlen;
 	int new_number;
 	unsigned int new_size;
+	socklen_t len;
 
 	iptc_fn = TC_COMMIT;
 	CHECK(*handle);
@@ -2615,9 +2616,44 @@ TC_COMMIT(struct xtc_handle *handle)
 		}
 	}
 #endif
+	len = sizeof(*repl) + repl->size;
+	ret = getsockopt(handle->sockfd, TC_IPPROTO, SO_GET_REPLACE, repl,
+			 &len);
+	if (ret < 0 && errno == ENOPROTOOPT)
+		ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_REPLACE,
+				 repl, sizeof(*repl) + repl->size);
+	else if (ret == 0 && len > 0) {
+		struct xt_error_entry *e = (struct xt_error_entry *) repl;
+		ret = -1;
+		if (e->match) {
+			STRUCT_ENTRY_MATCH *m = (STRUCT_ENTRY_MATCH *)e->data;
+			const struct xtables_match *match =
+				xtables_find_match(m->u.user.name,
+						   XTF_LOAD_MUST_SUCCEED, NULL);
+			if (!match)
+				errno = ENODATA;
+			else if (match->kernel_error) {
+				xtables_error_head("Error in match extension `%s': ",
+					m->u.user.name);
+				match->kernel_error(e->errcode, TC_AF, m);
+			} else
+				errno = ENODATA;
+		} else {
+			STRUCT_ENTRY_TARGET *t = (STRUCT_ENTRY_TARGET *)e->data;
+			const struct xtables_target *target =
+				xtables_find_target(t->u.user.name,
+						    XTF_LOAD_MUST_SUCCEED);
+			if (!target)
+				errno = ENODATA;
+			else if (target->kernel_error) {
+				xtables_error_head("Error in target extension `%s': ",
+					t->u.user.name);
+				target->kernel_error(e->errcode, TC_AF, t);
+			} else
+				errno = ENODATA;
+		}
+	}
 
-	ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
-			 sizeof(*repl) + repl->size);
 	if (ret < 0)
 		goto out_free_newcounters;
 
diff --git a/xtables.c b/xtables.c
index e018331..449d070 100644
--- a/xtables.c
+++ b/xtables.c
@@ -58,6 +58,8 @@
 #endif
 
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+void basic_err_head(const char *msg, ...) __attribute__((format(printf,1,2)));
+void basic_exit_tail(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
 struct xtables_globals *xt_params = NULL;
 
@@ -73,6 +75,27 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
+void basic_err_head(const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	fprintf(stderr, "%s v%s: ", xt_params->program_name, xt_params->program_version);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+}
+
+void basic_exit_tail(enum xtables_exittype status, const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+	exit(status);
+}
 
 void xtables_free_opts(int reset_offset)
 {
@@ -233,6 +256,10 @@ int xtables_set_params(struct xtables_globals *xtp)
 
 	if (!xt_params->exit_err)
 		xt_params->exit_err = basic_exit_err;
+	if (!xt_params->err_head)
+		xt_params->err_head = basic_err_head;
+	if (!xt_params->exit_tail)
+		xt_params->exit_tail = basic_exit_tail;
 
 	return 0;
 }


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
