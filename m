From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  libip6t_dst.c
Date: Thu, 04 Sep 2003 14:34:37 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5785BD.9010202@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_94ewzm4U7hwu/CGYUoaepg)"
Cc: Netfilter Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_94ewzm4U7hwu/CGYUoaepg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

  in a patch I've sent you recently, I introduced a typo.

  The following patch fixes this and includes:

1- Fix preprocessor directive usage,
2- Redefine UNAME and LNAME macros such that their value is determined 
at compile-time, not at run-time,
3- Modify all printf() calls that use LNAME and UNAME to take advantage 
of the compile-time macro definitions,
4- More indentation fixes.

Please apply,

Stephane Ouellette.

--Boundary_(ID_94ewzm4U7hwu/CGYUoaepg)
Content-type: text/plain; name=libip6t_dst.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_dst.c.patch

--- netfilter.orig/userspace/extensions/libip6t_dst.c	Mon Aug 25 14:49:42 2003
+++ netfilter/userspace/extensions/libip6t_dst.c	Mon Aug 25 16:15:43 2003
@@ -6,44 +6,37 @@
 #include <getopt.h>
 #include <errno.h>
 #include <ip6tables.h>
-/*#include <linux/in6.h>*/
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
-                                        
-#define DEBUG		0
-#define HOPBYHOP	0
-#define UNAME		(HOPBYHOP ? "HBH" : "DST")
-#define LNAME		(HOPBYHOP ? "hbh" : "dst")
+
+#ifdef HOPBYHOP
+#define UNAME "HBH"
+#define LNAME "hbh"
+#else
+#define UNAME "DST"
+#define LNAME "dst"
+#endif
 
 /* Function which prints out usage message. */
 static void
 help(void)
 {
 	printf(
-"%s v%s options:\n"
-" --%s-len [!] length           total length of this header\n"
-" --%s-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
+UNAME " v%s options:\n"
+" --" LNAME "-len [!] length           total length of this header\n"
+" --" LNAME "-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
 "                               Options and its length (list, max: %d)\n", 
-UNAME , IPTABLES_VERSION, LNAME, LNAME, IP6T_OPTS_OPTSNR);
+IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
-#if HOPBYHOP
 static struct option opts[] = {
-	{ .name = "hbh-len",        .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = "hbh-opts",       .has_arg = 1, .flag = 0, .val = '2' },
-	{ .name = "hbh-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = LNAME "-len",        .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = LNAME "-opts",       .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = LNAME "-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
 	{ .name = 0 }
 };
-#else
-static struct option opts[] = {
-	{ .name = "dst-len",        .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = "dst-opts",       .has_arg = 1, .flag = 0, .val = '2' },
-	{ .name = "dst-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
-	{ .name = 0 }
-};
-#endif
 
 static u_int32_t
 parse_opts_num(const char *idstr, const char *typestr)
@@ -55,16 +48,16 @@
 
 	if ( idstr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
-			   "%s no valid digits in %s `%s'", UNAME, typestr, idstr);
+			   UNAME " no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
 		exit_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
-	}	
+	}
 	if ( *idstr != '\0'  && *ep != '\0' ) {
 		exit_error(PARAMETER_PROBLEM,
-			   "%s error parsing %s `%s'", UNAME, typestr, idstr);
+			   UNAME " error parsing %s `%s'", typestr, idstr);
 	}
 	return (u_int32_t) id;
 }
@@ -76,39 +69,47 @@
         unsigned int i;
 	
 	buffer = strdup(optsstr);
-        if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+        if (!buffer)
+		exit_error(OTHER_PROBLEM, "strdup failed");
 			
-        for (cp=buffer, i=0; cp && i<IP6T_OPTS_OPTSNR; cp=next,i++)
+        for (cp = buffer, i = 0; cp && i < IP6T_OPTS_OPTSNR; cp = next, i++)
         {
-                next=strchr(cp, ',');
-                if (next) *next++='\0';
+                next = strchr(cp, ',');
+
+                if (next)
+			*next++='\0';
+
                 range = strchr(cp, ':');
+
                 if (range) {
                         if (i == IP6T_OPTS_OPTSNR-1)
                                 exit_error(PARAMETER_PROBLEM,
                                            "too many ports specified");
                         *range++ = '\0';
                 }
+
                 opts[i] = (u_int16_t)((parse_opts_num(cp,"opt") & 0x000000FF)<<8); 
                 if (range) {
 			if (opts[i] == 0)
-        			exit_error(PARAMETER_PROBLEM, "PAD0 hasn't got length");
+        			exit_error(PARAMETER_PROBLEM,
+					"PAD0 hasn't got length");
                         opts[i] |= (u_int16_t)(parse_opts_num(range,"length") &
 					0x000000FF);
-                } else {
+                } else
                         opts[i] |= (0x00FF);
-		}
 
-#if DEBUG
+#ifdef DEBUG
 		printf("opts str: %s %s\n", cp, range);
 		printf("opts opt: %04X\n", opts[i]);
 #endif
 	}
-        if (cp) exit_error(PARAMETER_PROBLEM, "too many addresses specified");
+
+        if (cp)
+		exit_error(PARAMETER_PROBLEM, "too many addresses specified");
 
 	free(buffer);
 
-#if DEBUG
+#ifdef DEBUG
 	printf("addr nr: %d\n", i);
 #endif
 
@@ -141,7 +142,7 @@
 	case '1':
 		if (*flags & IP6T_OPTS_LEN)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-len' allowed", LNAME);
+				   "Only one `--" LNAME "-len' allowed");
 		check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
@@ -152,11 +153,11 @@
 	case '2':
 		if (*flags & IP6T_OPTS_OPTS)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-opts' allowed", LNAME);
+				   "Only one `--" LNAME "-opts' allowed");
                 check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
                         exit_error(PARAMETER_PROBLEM,
-				" '!' not allowed with `--%s-opts'", LNAME);
+				" '!' not allowed with `--" LNAME "-opts'");
 		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
@@ -164,10 +165,11 @@
 	case '3':
 		if (*flags & IP6T_OPTS_NSTRICT)
 			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--%s-not-strict' allowed", LNAME);
+				   "Only one `--" LNAME "-not-strict' allowed");
 		if ( !(*flags & IP6T_OPTS_OPTS) )
 			exit_error(PARAMETER_PROBLEM,
-				   "`--%s-opts ...' required before `--%s-not-strict'", LNAME, LNAME);
+				   "`--" LNAME "-opts ...' required before `--"
+				   LNAME "-not-strict'");
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
 		break;
@@ -189,12 +191,13 @@
 {
 	unsigned int i;
 
-	for(i=0; i<optsnr; i++){
-		printf("%d", (optsp[i] & 0xFF00)>>8);
-		if ((optsp[i] & 0x00FF) != 0x00FF){
+	for(i = 0; i < optsnr; i++) {
+		printf("%d", (optsp[i] & 0xFF00) >> 8);
+
+		if ((optsp[i] & 0x00FF) != 0x00FF)
 			printf(":%d", (optsp[i] & 0x00FF));
-		} 
-		printf("%c", (i!=optsnr-1)?',':' ');
+
+		printf("%c", (i != optsnr - 1) ? ',' : ' ');
 	}
 }
 
@@ -205,7 +208,7 @@
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
-	printf("%s ", LNAME);
+	printf(LNAME " ");
 	if (optinfo->flags & IP6T_OPTS_LEN)
 		printf("length:%s%u ",
 			optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "",
@@ -230,34 +233,30 @@
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("--%s-len %s%u ", LNAME, 
+		printf("--" LNAME "-len %s%u ", 
 			(optinfo->invflags & IP6T_OPTS_INV_LEN) ? "! " : "", 
 			optinfo->hdrlen);
 	}
 
 	if (optinfo->flags & IP6T_OPTS_OPTS)
-		printf("--%s-opts ", LNAME);
+		printf("--" LNAME "-opts ");
 
 	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
 
 	if (optinfo->flags & IP6T_OPTS_NSTRICT)
-		printf("--%s-not-strict ", LNAME);
+		printf("--" LNAME "-not-strict ");
 }
 
 static
 struct ip6tables_match optstruct = {
-#if HOPBYHOP
-	.name          = "hbh",
-#else
-	.name          = "dst",
-#endif
+	.name          = LNAME,
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.help          = &help,
 	.init          = &init,
 	.parse         = &parse,
-	.final         = &final_check,
+	.final_check   = &final_check,
 	.print         = &print,
 	.save          = &save,
 	.extra_opts    = opts

--Boundary_(ID_94ewzm4U7hwu/CGYUoaepg)--
