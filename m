From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][RESEND]  Error in first patch --- libipt_string.c
Date: Mon, 21 Apr 2003 23:41:24 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA4B9E4.10709@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_VYqNzxfvuHgeU96KBa4ZzA)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@gnumonks.org>
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

--Boundary_(ID_VYqNzxfvuHgeU96KBa4ZzA)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

  the attached patch contains the following modifications:

1- Remove unneeded fputc() in help().
2- C99 initializers.
3- In parse(), print an error message when multiple strings are 
specified on the command line.
4- Remove print_string(). This fixes save() when used with 
iptables-save/iptables-restore.


Stephane

--Boundary_(ID_VYqNzxfvuHgeU96KBa4ZzA)
Content-type: text/plain; name=libipt_string.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_string.c.patch

--- netfilter-orig/userspace/extensions/libipt_string.c	Mon Apr 21 13:40:47 2003
+++ netfilter-fixed/userspace/extensions/libipt_string.c	Mon Apr 21 23:37:45 2003
@@ -18,6 +18,7 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
 
+
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -27,16 +28,16 @@
 "--string [!] string          Match a string in a packet\n"
 "--hex-string [!] string      Match a hex string in a packet\n",
 IPTABLES_VERSION);
-
-	fputc('\n', stdout);
 }
 
+
 static struct option opts[] = {
-	{ "string", 1, 0, '1' },
-	{ "hex-string", 1, 0, '2' },
-	{0}
+	{ .name = "string",     .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "hex-string", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = 0 }
 };
 
+
 /* Initialize the match. */
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
@@ -44,6 +45,7 @@
 	*nfcache |= NFC_UNKNOWN;
 }
 
+
 static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
@@ -51,6 +53,7 @@
 	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
 
+
 static void
 parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
 {
@@ -125,6 +128,7 @@
 	info->len = sindex;
 }
 
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -137,6 +141,10 @@
 
 	switch (c) {
 	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple strings");
+
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_string(argv[optind-1], stringinfo);
 		if (invert)
@@ -146,6 +154,10 @@
 		break;
 
 	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify multiple strings");
+
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
 		if (invert)
@@ -159,14 +171,6 @@
 	return 1;
 }
 
-static void
-print_string(char string[], int invert, int numeric)
-{
-
-	if (invert)
-		fputc('!', stdout);
-	printf("%s ",string);
-}
 
 /* Final check; must have specified --string. */
 static void
@@ -177,42 +181,46 @@
 			   "STRING match: You must specify `--string'");
 }
 
+
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
       const struct ipt_entry_match *match,
       int numeric)
 {
-	printf("STRING match ");
-	print_string(((struct ipt_string_info *)match->data)->string,
-		  ((struct ipt_string_info *)match->data)->invert, numeric);
+	const struct ipt_string_info *info =
+	    (const struct ipt_string_info*) match->data;
+
+	printf("STRING match %s%s ", (info->invert) ? "!" : "", info->string);
 }
 
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
+
+/* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
-	printf("--string ");
-	print_string(((struct ipt_string_info *)match->data)->string,
-		  ((struct ipt_string_info *)match->data)->invert, 0);
-}
-
-static
-struct iptables_match string
-= { NULL,
-    "string",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_string_info)),
-    IPT_ALIGN(sizeof(struct ipt_string_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+	const struct ipt_string_info *info =
+	    (const struct ipt_string_info*) match->data;
+
+	printf("--string %s%s ", (info->invert) ? "! " : "", info->string);
+}
+
+
+static struct iptables_match string = {
+    .name          = "string",
+    .version       = IPTABLES_VERSION,
+    .size          = IPT_ALIGN(sizeof(struct ipt_string_info)),
+    .userspacesize = IPT_ALIGN(sizeof(struct ipt_string_info)),
+    .help          = &help,
+    .init          = &init,
+    .parse         = &parse,
+    .final_check   = &final_check,
+    .print         = &print,
+    .save          = &save,
+    .extra_opts    = opts
 };
 
+
 void _init(void)
 {
 	register_match(&string);

--Boundary_(ID_VYqNzxfvuHgeU96KBa4ZzA)--
