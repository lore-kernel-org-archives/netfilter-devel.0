From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][COSMETIC]   C99 initializers + indentation + simplification of
 libip6t_dst.c
Date: Tue, 12 Aug 2003 13:40:58 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F3926AA.4080305@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_sGdD06SoWTUKCzj59f6UEw)"
Cc: netfilter-devel@lists.netfilter.org
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

--Boundary_(ID_sGdD06SoWTUKCzj59f6UEw)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    here's another cosmetic patch that includes:

1- C99 initializers
2- Indentation cleanups
3- Reduce the number of calls to printf() without changing the output.

Please apply.

Stephane.



--Boundary_(ID_sGdD06SoWTUKCzj59f6UEw)
Content-type: text/plain; name=libip6t_dst.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_dst.c.patch

--- netfilter.orig/userspace/extensions/libip6t_dst.c	Fri Jun 14 03:38:16 2002
+++ netfilter/userspace/extensions/libip6t_dst.c	Mon Aug 11 21:49:15 2003
@@ -31,17 +31,17 @@
 
 #if HOPBYHOP
 static struct option opts[] = {
-	{ "hbh-len", 1, 0, '1' },
-	{ "hbh-opts", 1, 0, '2' },
-	{ "hbh-not-strict", 1, 0, '3' },
-	{0}
+	{ .name = "hbh-len",        .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "hbh-opts",       .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "hbh-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 #else
 static struct option opts[] = {
-	{ "dst-len", 1, 0, '1' },
-	{ "dst-opts", 1, 0, '2' },
-	{ "dst-not-strict", 1, 0, '3' },
-	{0}
+	{ .name = "dst-len",        .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "dst-opts",       .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "dst-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 #endif
 
@@ -51,7 +51,7 @@
 	unsigned long int id;
 	char* ep;
 
-	id =  strtoul(idstr,&ep,0) ;
+	id = strtoul(idstr, &ep, 0);
 
 	if ( idstr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -206,15 +206,19 @@
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	printf("%s ", LNAME);
-	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("length");
-		printf(":%s", optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "");
-		printf("%u", optinfo->hdrlen);
-		printf(" ");
-	}
-	if (optinfo->flags & IP6T_OPTS_OPTS) printf("opts ");
+	if (optinfo->flags & IP6T_OPTS_LEN)
+		printf("length:%s%u ",
+			optinfo->invflags & IP6T_OPTS_INV_LEN ? "!" : "",
+			optinfo->hdrlen);
+
+	if (optinfo->flags & IP6T_OPTS_OPTS)
+		printf("opts ");
+
 	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
-	if (optinfo->flags & IP6T_OPTS_NSTRICT) printf("not-strict ");
+
+	if (optinfo->flags & IP6T_OPTS_NSTRICT)
+		printf("not-strict ");
+
 	if (optinfo->invflags & ~IP6T_OPTS_INV_MASK)
 		printf("Unknown invflags: 0x%X ",
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
@@ -231,30 +235,32 @@
 			optinfo->hdrlen);
 	}
 
-	if (optinfo->flags & IP6T_OPTS_OPTS) printf("--%s-opts ", LNAME);
+	if (optinfo->flags & IP6T_OPTS_OPTS)
+		printf("--%s-opts ", LNAME);
+
 	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
-	if (optinfo->flags & IP6T_OPTS_NSTRICT) printf("--%s-not-strict ", LNAME);
 
+	if (optinfo->flags & IP6T_OPTS_NSTRICT)
+		printf("--%s-not-strict ", LNAME);
 }
 
 static
-struct ip6tables_match optstruct
-= { NULL,
+struct ip6tables_match optstruct = {
 #if HOPBYHOP
-    "hbh",
+	.name          = "hbh",
 #else
-    "dst",
+	.name          = "dst",
 #endif
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_opts)),
-    IP6T_ALIGN(sizeof(struct ip6t_opts)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_opts)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_opts)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final         = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void

--Boundary_(ID_sGdD06SoWTUKCzj59f6UEw)--
