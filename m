From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][COSMETIC]  libip6t_fuzzy.c
Date: Tue, 12 Aug 2003 13:45:36 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F3927C0.8040102@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_UfCiCjGqZfy9BubaAmEcag)"
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

--Boundary_(ID_UfCiCjGqZfy9BubaAmEcag)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   this patch includes:

1- Indentation fixes,
2- Reduce the number of calls to printf(),
3- C99 initializers.

Please apply.

Stephane.


--Boundary_(ID_UfCiCjGqZfy9BubaAmEcag)
Content-type: text/plain; name=libip6t_fuzzy.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_fuzzy.c.patch

--- netfilter.orig/userspace/extensions/libip6t_fuzzy.c	Sat Jun 14 10:08:53 2003
+++ netfilter/userspace/extensions/libip6t_fuzzy.c	Mon Aug 11 22:16:27 2003
@@ -34,9 +34,9 @@
 };
 
 static struct option opts[] = {
-	{ "lower-limit", 1 , 0 , '1' } ,
-	{ "upper-limit", 1 , 0 , '2' } ,
-	{ 0 }
+	{ .name = "lower-limit", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "upper-limit", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = 0 }
 };
 
 /* Initialize data structures */
@@ -64,8 +64,8 @@
       unsigned int *nfcache,
       struct ip6t_entry_match **match)
 {
-
-struct ip6t_fuzzy_info *fuzzyinfo = (struct ip6t_fuzzy_info *)(*match)->data;
+	struct ip6t_fuzzy_info *fuzzyinfo =
+		(struct ip6t_fuzzy_info *)(*match)->data;
 
 	u_int32_t num;
 
@@ -99,7 +99,7 @@
 	if (string_to_number(optarg,1,MAXFUZZYRATE,&num) == -1 || num < 1)
 		exit_error(PARAMETER_PROBLEM,"BAD --upper-limit");
 
-		fuzzyinfo->maximum_rate = num ;
+		fuzzyinfo->maximum_rate = num;
 
 		*flags |= IP6T_FUZZY_OPT_MAXIMUM;
 
@@ -123,8 +123,8 @@
 	const struct ip6t_fuzzy_info *fuzzyinfo
 		= (const struct ip6t_fuzzy_info *)match->data;
 
-	printf(" fuzzy: lower limit = %u pps - upper limit = %u pps ",fuzzyinfo->minimum_rate,fuzzyinfo->maximum_rate);
-
+	printf(" fuzzy: lower limit = %u pps - upper limit = %u pps ",
+		fuzzyinfo->minimum_rate, fuzzyinfo->maximum_rate);
 }
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
@@ -134,24 +134,22 @@
 	const struct ip6t_fuzzy_info *fuzzyinfo
 		= (const struct ip6t_fuzzy_info *)match->data;
 
-	printf("--lower-limit %u ",fuzzyinfo->minimum_rate);
-	printf("--upper-limit %u ",fuzzyinfo->maximum_rate);
-
+	printf("--lower-limit %u --upper-limit %u ",
+		fuzzyinfo->minimum_rate, fuzzyinfo->maximum_rate);
 }
 
-struct ip6tables_match fuzzy_match
-= { NULL,
-    "fuzzy",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
-    IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_match fuzzy_match = {
+	.name          = "fuzzy",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_fuzzy_info)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_UfCiCjGqZfy9BubaAmEcag)--
