From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/13] Remove redundant dst/hbh lines
Date: Thu, 4 Oct 2007 12:13:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041210160.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37101 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbXJDKN6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:13:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id E8F581C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:13:56 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Remove hbh stuff from libip6t_dst,
remove dst stuff from libip6t_hbh.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_dst.c |   48 ++++++++++++++++++--------------------------
 extensions/libip6t_hbh.c |   51 ++++++++++++++++-------------------------------
 2 files changed, 38 insertions(+), 61 deletions(-)

Index: iptables/extensions/libip6t_dst.c
===================================================================
--- iptables.orig/extensions/libip6t_dst.c
+++ iptables/extensions/libip6t_dst.c
@@ -11,29 +11,21 @@
 #include <sys/socket.h>
 #include <arpa/inet.h>
 
-#ifdef HOPBYHOP
-#define UNAME "HBH"
-#define LNAME "hbh"
-#else
-#define UNAME "DST"
-#define LNAME "dst"
-#endif
-
 /* Function which prints out usage message. */
 static void dst_help(void)
 {
 	printf(
-UNAME " v%s options:\n"
-" --" LNAME "-len [!] length           total length of this header\n"
-" --" LNAME "-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
-"                               Options and its length (list, max: %d)\n", 
+"dst v%s options:\n"
+"  --dst-len [!] length          total length of this header\n"
+"  --dst-opts TYPE[:LEN][,TYPE[:LEN]...]\n"
+"                                Options and its length (list, max: %d)\n",
 IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
 static const struct option dst_opts[] = {
-	{ .name = LNAME "-len",        .has_arg = 1, .val = '1' },
-	{ .name = LNAME "-opts",       .has_arg = 1, .val = '2' },
-	{ .name = LNAME "-not-strict", .has_arg = 1, .val = '3' },
+	{ .name = "dst-len",        .has_arg = 1, .val = '1' },
+	{ .name = "dst-opts",       .has_arg = 1, .val = '2' },
+	{ .name = "dst-not-strict", .has_arg = 1, .val = '3' },
 	{ }
 };
 
@@ -47,7 +39,7 @@ parse_opts_num(const char *idstr, const 
 
 	if ( idstr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
-			   UNAME " no valid digits in %s `%s'", typestr, idstr);
+		           "dst: no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -56,7 +48,7 @@ parse_opts_num(const char *idstr, const 
 	}
 	if ( *idstr != '\0'  && *ep != '\0' ) {
 		exit_error(PARAMETER_PROBLEM,
-			   UNAME " error parsing %s `%s'", typestr, idstr);
+		           "dst: error parsing %s `%s'", typestr, idstr);
 	}
 	return (u_int32_t) id;
 }
@@ -137,7 +129,7 @@ static int dst_parse(int c, char **argv,
 	case '1':
 		if (*flags & IP6T_OPTS_LEN)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--" LNAME "-len' allowed");
+				   "Only one `--dst-len' allowed");
 		check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
@@ -148,11 +140,11 @@ static int dst_parse(int c, char **argv,
 	case '2':
 		if (*flags & IP6T_OPTS_OPTS)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--" LNAME "-opts' allowed");
+				   "Only one `--dst-opts' allowed");
                 check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
                         exit_error(PARAMETER_PROBLEM,
-				" '!' not allowed with `--" LNAME "-opts'");
+				" '!' not allowed with `--dst-opts'");
 		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
@@ -160,11 +152,11 @@ static int dst_parse(int c, char **argv,
 	case '3':
 		if (*flags & IP6T_OPTS_NSTRICT)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--" LNAME "-not-strict' allowed");
+				   "Only one `--dst-not-strict' allowed");
 		if ( !(*flags & IP6T_OPTS_OPTS) )
 			exit_error(PARAMETER_PROBLEM,
-				   "`--" LNAME "-opts ...' required before `--"
-				   LNAME "-not-strict'");
+				   "`--dst-opts ...' required before "
+				   "`--dst-not-strict'");
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
@@ -196,7 +188,7 @@ static void dst_print(const void *ip, co
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
-	printf(LNAME " ");
+	printf("dst ");
 	if (optinfo->flags & IP6T_OPTS_LEN)
 		printf("length:%s%u ",
 			optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "",
@@ -221,22 +213,22 @@ static void dst_save(const void *ip, con
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("--" LNAME "-len %s%u ", 
+		printf("--dst-len %s%u ",
 			(optinfo->invflags & IP6T_OPTS_INV_LEN) ? "! " : "", 
 			optinfo->hdrlen);
 	}
 
 	if (optinfo->flags & IP6T_OPTS_OPTS)
-		printf("--" LNAME "-opts ");
+		printf("--dst-opts ");
 
 	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
 
 	if (optinfo->flags & IP6T_OPTS_NSTRICT)
-		printf("--" LNAME "-not-strict ");
+		printf("--dst-not-strict ");
 }
 
 static struct ip6tables_match dst_match6 = {
-	.name          = LNAME,
+	.name          = "dst",
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_opts)),
Index: iptables/extensions/libip6t_hbh.c
===================================================================
--- iptables.orig/extensions/libip6t_hbh.c
+++ iptables/extensions/libip6t_hbh.c
@@ -13,36 +13,24 @@
 #include <arpa/inet.h>
                                         
 #define DEBUG		0
-#define HOPBYHOP	1
-#define UNAME		(HOPBYHOP ? "HBH" : "DST")
-#define LNAME		(HOPBYHOP ? "hbh" : "dst")
 
 /* Function which prints out usage message. */
 static void hbh_help(void)
 {
 	printf(
-"%s v%s options:\n"
-" --%s-len [!] length           total length of this header\n"
-" --%s-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
-"                               Options and its length (list, max: %d)\n", 
-UNAME , IPTABLES_VERSION, LNAME, LNAME, IP6T_OPTS_OPTSNR);
+"hbh v%s options:\n"
+"  --hbh-len [!] length          total length of this header\n"
+"  --hbh-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
+"                                Options and its length (list, max: %d)\n",
+IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
-#if HOPBYHOP
 static const struct option hbh_opts[] = {
 	{ "hbh-len", 1, NULL, '1' },
 	{ "hbh-opts", 1, NULL, '2' },
 	{ "hbh-not-strict", 1, NULL, '3' },
 	{ }
 };
-#else
-static const struct option hbh_opts[] = {
-	{ "dst-len", 1, NULL, '1' },
-	{ "dst-opts", 1, NULL, '2' },
-	{ "dst-not-strict", 1, NULL, '3' },
-	{ }
-};
-#endif
 
 static u_int32_t
 parse_opts_num(const char *idstr, const char *typestr)
@@ -54,7 +42,7 @@ parse_opts_num(const char *idstr, const 
 
 	if ( idstr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
-			   "%s no valid digits in %s `%s'", UNAME, typestr, idstr);
+			   "hbh: no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -63,7 +51,7 @@ parse_opts_num(const char *idstr, const 
 	}	
 	if ( *idstr != '\0'  && *ep != '\0' ) {
 		exit_error(PARAMETER_PROBLEM,
-			   "%s error parsing %s `%s'", UNAME, typestr, idstr);
+			   "hbh: error parsing %s `%s'", typestr, idstr);
 	}
 	return (u_int32_t) id;
 }
@@ -136,7 +124,7 @@ static int hbh_parse(int c, char **argv,
 	case '1':
 		if (*flags & IP6T_OPTS_LEN)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-len' allowed", LNAME);
+				   "Only one `--hbh-len' allowed");
 		check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
@@ -147,11 +135,11 @@ static int hbh_parse(int c, char **argv,
 	case '2':
 		if (*flags & IP6T_OPTS_OPTS)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-opts' allowed", LNAME);
+				   "Only one `--hbh-opts' allowed");
                 check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
                         exit_error(PARAMETER_PROBLEM,
-				" '!' not allowed with `--%s-opts'", LNAME);
+				" '!' not allowed with `--hbh-opts'");
 		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
@@ -159,10 +147,10 @@ static int hbh_parse(int c, char **argv,
 	case '3':
 		if (*flags & IP6T_OPTS_NSTRICT)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-not-strict' allowed", LNAME);
+				   "Only one `--hbh-not-strict' allowed");
 		if ( !(*flags & IP6T_OPTS_OPTS) )
 			exit_error(PARAMETER_PROBLEM,
-				   "`--%s-opts ...' required before `--%s-not-strict'", LNAME, LNAME);
+				   "`--hbh-opts ...' required before `--hbh-not-strict'");
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
@@ -193,7 +181,7 @@ static void hbh_print(const void *ip, co
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
-	printf("%s ", LNAME);
+	printf("hbh ");
 	if (optinfo->flags & IP6T_OPTS_LEN) {
 		printf("length");
 		printf(":%s", optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "");
@@ -214,23 +202,20 @@ static void hbh_save(const void *ip, con
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("--%s-len %s%u ", LNAME, 
+		printf("--hbh-len %s%u ",
 			(optinfo->invflags & IP6T_OPTS_INV_LEN) ? "! " : "", 
 			optinfo->hdrlen);
 	}
 
-	if (optinfo->flags & IP6T_OPTS_OPTS) printf("--%s-opts ", LNAME);
+	if (optinfo->flags & IP6T_OPTS_OPTS)
+		printf("--hbh-opts ");
 	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
-	if (optinfo->flags & IP6T_OPTS_NSTRICT) printf("--%s-not-strict ", LNAME);
-
+	if (optinfo->flags & IP6T_OPTS_NSTRICT)
+		printf("--hbh-not-strict ");
 }
 
 static struct ip6tables_match hbh_match6 = {
-#if HOPBYHOP
 	.name 		= "hbh",
-#else
-	.name		= "dst",
-#endif
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_opts)),
