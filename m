From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][COSMETIC]  C99 initializers for libip6t_ah.c
Date: Tue, 12 Aug 2003 13:35:52 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F392578.5090908@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_A0EybQ5jYnHbdLd3Pqz8mA)"
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

--Boundary_(ID_A0EybQ5jYnHbdLd3Pqz8mA)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    this patch includes C99 initializers and indentation cleanups for 
libip6t_ah.c.

    Please apply.

Stephane Ouellette


--Boundary_(ID_A0EybQ5jYnHbdLd3Pqz8mA)
Content-type: text/plain; name=libip6t_ah.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_ah.c.patch

--- netfilter.orig/userspace/extensions/libip6t_ah.c	Wed May 29 09:08:15 2002
+++ netfilter/userspace/extensions/libip6t_ah.c	Mon Aug 11 21:35:39 2003
@@ -21,10 +21,10 @@
 }
 
 static struct option opts[] = {
-	{ "ahspi", 1, 0, '1' },
-	{ "ahlen", 1, 0, '2' },
-	{ "ahres", 0, 0, '3' },
-	{0}
+	{ .name = "ahspi", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "ahlen", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "ahres", .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 
 static u_int32_t
@@ -33,7 +33,7 @@
 	unsigned long int spi;
 	char* ep;
 
-	spi =  strtoul(spistr,&ep,0) ;
+	spi = strtoul(spistr, &ep, 0);
 
 	if ( spistr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -212,23 +212,21 @@
 	if (ahinfo->hdrres != 0 ) {
 		printf("--ahres ");
 	}
-
 }
 
 static
-struct ip6tables_match ah
-= { NULL,
-    "ah",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_ah)),
-    IP6T_ALIGN(sizeof(struct ip6t_ah)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_match ah = {
+	.name          = "ah",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_ah)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_ah)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void

--Boundary_(ID_A0EybQ5jYnHbdLd3Pqz8mA)--
