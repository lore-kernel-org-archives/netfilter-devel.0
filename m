From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]    Less printf() calls for libip6t_esp.c
Date: Tue, 12 Aug 2003 14:08:12 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F392D0C.7080104@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_xz+fvCo7yXQURT0lFq5Hwg)"
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

--Boundary_(ID_xz+fvCo7yXQURT0lFq5Hwg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    this attached patch contains C99 initializers and printf() 
simplifications fo libip6t_esp.c.

    Please apply.

Stephane


--Boundary_(ID_xz+fvCo7yXQURT0lFq5Hwg)
Content-type: text/plain; name=libip6t_esp.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_esp.c.patch

--- netfilter.orig/userspace/extensions/libip6t_esp.c	Wed May 29 09:08:16 2002
+++ netfilter/userspace/extensions/libip6t_esp.c	Mon Aug 11 21:57:45 2003
@@ -19,8 +19,8 @@
 }
 
 static struct option opts[] = {
-	{ "espspi", 1, 0, '1' },
-	{0}
+	{ .name = "espspi", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = 0 }
 };
 
 static u_int32_t
@@ -29,7 +29,7 @@
 	unsigned long int spi;
 	char* ep;
 
-	spi =  strtoul(spistr,&ep,0) ;
+	spi = strtoul(spistr, &ep, 0);
 
 	if ( spistr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -117,17 +117,10 @@
 	const char *inv = invert ? "!" : "";
 
 	if (min != 0 || max != 0xFFFFFFFF || invert) {
-		printf("%s", name);
-		if (min == max) {
-			printf(":%s", inv);
-			printf("%u", min);
-		} else {
-			printf("s:%s", inv);
-			printf("%u",min);
-			printf(":");
-			printf("%u",max);
-		}
-		printf(" ");
+		if (min == max)
+			printf("%s:%s%u ", name, inv, min);
+		else
+			printf("%ss:%s%u:%u ", name, inv, min, max);
 	}
 }
 
@@ -168,19 +161,18 @@
 }
 
 static
-struct ip6tables_match esp
-= { NULL,
-    "esp",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_esp)),
-    IP6T_ALIGN(sizeof(struct ip6t_esp)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_match esp = {
+	.name          = "esp",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_esp)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_esp)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void

--Boundary_(ID_xz+fvCo7yXQURT0lFq5Hwg)--
