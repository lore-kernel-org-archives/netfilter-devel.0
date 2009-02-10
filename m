From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables:  simple aliasing macro for exit_error
Date: Tue, 10 Feb 2009 09:43:33 -0500
Message-ID: <1234277013.20903.44.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7A4liooQ3RySVspGOYum"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48511 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZBJOp3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:45:29 -0500
Received: by ewy14 with SMTP id 14so3098163ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 06:45:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-7A4liooQ3RySVspGOYum
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I think this is it for exit_error(). I didnt want to convert all the
calls to exit_error(), so i introduced a simple macro to point to
the xtables_globals

Next, after you look at these changes i would like to create a
xtables_merge_options and convert apps defining their own
merge_options to use it.

cheers,
jamal

--=-7A4liooQ3RySVspGOYum
Content-Disposition: attachment; filename=iptv2-5
Content-Type: text/plain; name=iptv2-5; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 24a8e3b70bf70fd62da0ef493eb43fa5bb16d436
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Tue Feb 10 09:34:11 2009 -0500

    Rename xtables_globals exit_error cb to exit_err and introduce
    a very simple aliasing macro to point to it.
    convert iptables, ip6tables and iptables_xml to use it.
    Note iptables_xml does not have to define its own exit_error()
    since it can use the basic one provided.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 3a16651..da7ee6b 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -189,7 +189,7 @@ struct xtables_globals
 	char *program_version;
 	char *program_name;
 	struct option *opts;
-	void (*exit_error)(enum xtables_exittype status, const char *msg, ...);
+	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
 extern const char *xtables_program_name;
@@ -204,7 +204,7 @@ extern void *xtables_malloc(size_t);
 
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
-int xtables_set_params(struct xtables_globals *xtp);
+extern int xtables_set_params(struct xtables_globals *xtp);
 void xtables_free_opts(int reset_offset, struct option *original_opts);
 
 extern struct xtables_match *xtables_find_match(const char *name,
@@ -230,8 +230,8 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 int xtables_check_inverse(const char option[], int *invert,
 	int *my_optind, int argc);
-void exit_error(enum xtables_exittype, const char *, ...)
-	__attribute__((noreturn, format(printf,2,3)));
+extern struct xtables_globals *xt_params;
+#define exit_error xt_params->exit_err
 extern void xtables_param_act(unsigned int, const char *, ...);
 
 extern const char *xtables_ipaddr_to_numeric(const struct in_addr *);
diff --git a/ip6tables.c b/ip6tables.c
index 7561353..9262b14 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -145,12 +145,13 @@ int line = -1;
 
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
+void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.program_name = "ip6tables",
 	.opts = original_opts,
-	.exit_error = exit_error,
+	.exit_err = ip6tables_exit_error,
 };
 
 /* Table of legal combinations of commands and options.  If any of the
@@ -336,7 +337,7 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 }
 
 void
-exit_error(enum xtables_exittype status, const char *msg, ...)
+ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
diff --git a/iptables-xml.c b/iptables-xml.c
index 329c598..4bb0557 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -31,18 +31,6 @@ const char *program_version;
 
 #ifndef IPTABLES_MULTI
 int line = 0;
-void exit_error(enum xtables_exittype status, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	fprintf(stderr, "%s v%s: ", program_name, program_version);
-	vfprintf(stderr, msg, args);
-	va_end(args);
-	fprintf(stderr, "\n");
-	/* On error paths, make sure that we don't leak memory */
-	exit(status);
-}
 #endif
 
 static void print_usage(const char *name, const char *version)
@@ -634,7 +622,6 @@ struct xtables_globals iptables_xml_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.program_name = "iptables-xml",
-	.exit_error = exit_error,
 };
 
 #ifdef IPTABLES_MULTI
diff --git a/iptables.c b/iptables.c
index e8bed87..fe28e50 100644
--- a/iptables.c
+++ b/iptables.c
@@ -145,12 +145,14 @@ int line = -1;
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
+void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
 	.program_name = "iptables",
 	.opts = original_opts,
-	.exit_error = exit_error,
+	.exit_err = iptables_exit_error,
 };
 
 /* Table of legal combinations of commands and options.  If any of the
@@ -348,7 +350,7 @@ exit_printhelp(struct iptables_rule_match *matches)
 }
 
 void
-exit_error(enum xtables_exittype status, const char *msg, ...)
+iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
diff --git a/xtables.c b/xtables.c
index a7425ec..8e28d5e 100644
--- a/xtables.c
+++ b/xtables.c
@@ -46,9 +46,11 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
+void basic_exit_err(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+
 struct xtables_globals *xt_params = NULL;
 
-void basic_exit_error(enum xtables_exittype status, const char *msg, ...)
+void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
@@ -60,6 +62,7 @@ void basic_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
+
 /**
  * xtables_set_params - set the global parameters used by xtables
  * @xtp:	input xtables_globals structure
@@ -79,8 +82,8 @@ int xtables_set_params(struct xtables_globals *xtp)
 
 	xt_params = xtp;
 
-	if (!xt_params->exit_error)
-		xt_params->exit_error = basic_exit_error;
+	if (!xt_params->exit_err)
+		xt_params->exit_err = basic_exit_err;
 
 	return 0;
 }
@@ -359,7 +362,7 @@ u_int16_t xtables_parse_port(const char *port, const char *proto)
 	    (portnum = xtables_service_to_port(port, proto)) != (unsigned)-1)
 		return portnum;
 
-	xt_params->exit_error(PARAMETER_PROBLEM,
+	xt_params->exit_err(PARAMETER_PROBLEM,
 		   "invalid port/service `%s' specified", port);
 }
 
@@ -373,7 +376,7 @@ void xtables_parse_interface(const char *arg, char *vianame,
 	memset(vianame, 0, IFNAMSIZ);
 
 	if (vialen + 1 > IFNAMSIZ)
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 			   "interface name `%s' must be shorter than IFNAMSIZ"
 			   " (%i)", arg, IFNAMSIZ-1);
 
@@ -495,7 +498,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		      name, false);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
-			xt_params->exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_err(PARAMETER_PROBLEM,
 				   "Couldn't load match `%s':%s\n",
 				   name, dlerror());
 	}
@@ -507,7 +510,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 			ptr = NULL;
 	}
 	if(!ptr && (tryload == XTF_LOAD_MUST_SUCCEED)) {
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 			   "Couldn't find match `%s'\n", name);
 	}
 #endif
@@ -555,7 +558,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		      name, true);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
-			xt_params->exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_err(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
 				   name, dlerror());
 	}
@@ -567,7 +570,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 			ptr = NULL;
 	}
 	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 			   "Couldn't find target `%s'\n", name);
 	}
 #endif
@@ -820,7 +823,7 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b  = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option may only be specified once",
 		           p1, p2);
 		break;
@@ -829,13 +832,13 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b  = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option cannot be inverted", p1, p2);
 		break;
 	case XTF_BAD_VALUE:
 		p2 = va_arg(args, const char *);
 		p3 = va_arg(args, const char *);
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: Bad value for \"%s\" option: \"%s\"",
 		           p1, p2, p3);
 		break;
@@ -843,11 +846,11 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: At most one action is possible", p1);
 		break;
 	default:
-		xt_params->exit_error(status, p1, args);
+		xt_params->exit_err(status, p1, args);
 		break;
 	}
 
@@ -1030,7 +1033,7 @@ ipparse_hostnetwork(const char *name, unsigned int *naddrs)
 	if ((addrptmp = host_to_ipaddr(name, naddrs)) != NULL)
 		return addrptmp;
 
-	xt_params->exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	xt_params->exit_err(PARAMETER_PROBLEM, "host/network `%s' not found", name);
 }
 
 static struct in_addr *parse_ipmask(const char *mask)
@@ -1048,7 +1051,7 @@ static struct in_addr *parse_ipmask(const char *mask)
 		/* dotted_to_addr already returns a network byte order addr */
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 32))
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
 		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
@@ -1259,7 +1262,7 @@ ip6parse_hostnetwork(const char *name, unsigned int *naddrs)
 	if ((addrp = host_to_ip6addr(name, naddrs)) != NULL)
 		return addrp;
 
-	xt_params->exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	xt_params->exit_err(PARAMETER_PROBLEM, "host/network `%s' not found", name);
 }
 
 static struct in6_addr *parse_ip6mask(char *mask)
@@ -1276,7 +1279,7 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	if ((addrp = xtables_numeric_to_ip6addr(mask)) != NULL)
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 128))
-		xt_params->exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_err(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
 		char *p = (void *)&maskaddr;
@@ -1376,13 +1379,13 @@ int xtables_check_inverse(const char option[], int *invert,
 		        "extrapositioned (`! --option this`).\n");
 
 		if (*invert)
-			xt_params->exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_err(PARAMETER_PROBLEM,
 				   "Multiple `!' flags not allowed");
 		*invert = true;
 		if (my_optind != NULL) {
 			++*my_optind;
 			if (argc && *my_optind > argc)
-				xt_params->exit_error(PARAMETER_PROBLEM,
+				xt_params->exit_err(PARAMETER_PROBLEM,
 					   "no argument following `!'");
 		}
 
@@ -1433,7 +1436,7 @@ xtables_parse_protocol(const char *s)
 				}
 			}
 			if (i == ARRAY_SIZE(xtables_chain_protos))
-				xt_params->exit_error(PARAMETER_PROBLEM,
+				xt_params->exit_err(PARAMETER_PROBLEM,
 					   "unknown protocol `%s' specified",
 					   s);
 		}

--=-7A4liooQ3RySVspGOYum--

