From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  libip6t_MARK.c
Date: Fri, 05 Sep 2003 02:42:04 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F58303C.3030508@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_YiZohTLBPa+yAtHODzrWMQ)"
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

--Boundary_(ID_YiZohTLBPa+yAtHODzrWMQ)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    here's another userspace patch:

1- remove unused struct markinfo,
2- print_mark() was only used once, so I removed it and changed print() 
accordingly,
3- C99 initializers.

Please apply,

Stephane


--Boundary_(ID_YiZohTLBPa+yAtHODzrWMQ)
Content-type: text/plain; name=libip6t_MARK.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_MARK.c.patch

--- netfilter.orig/userspace/extensions/libip6t_MARK.c	Wed May 29 09:08:15 2002
+++ netfilter/userspace/extensions/libip6t_MARK.c	Mon Aug 11 21:09:59 2003
@@ -8,11 +8,6 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_MARK.h>
 
-struct markinfo {
-	struct ip6t_entry_target t;
-	struct ip6t_mark_target_info mark;
-};
-
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -25,8 +20,8 @@
 }
 
 static struct option opts[] = {
-	{ "set-mark", 1, 0, '1' },
-	{ 0 }
+	{ .name = "set-mark", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = 0 }
 };
 
 /* Initialize the target. */
@@ -72,12 +67,6 @@
 		           "MARK target: Parameter --set-mark is required");
 }
 
-static void
-print_mark(unsigned long mark, int numeric)
-{
-	printf("0x%lx ", mark);
-}
-
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
@@ -86,8 +75,8 @@
 {
 	const struct ip6t_mark_target_info *markinfo =
 		(const struct ip6t_mark_target_info *)target->data;
-	printf("MARK set ");
-	print_mark(markinfo->mark, numeric);
+
+	printf("MARK set 0x%lx ", markinfo->mark);
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
@@ -101,19 +90,18 @@
 }
 
 static
-struct ip6tables_target mark
-= { NULL,
-    "MARK",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
-    IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_target mark = {
+	.name          = "MARK",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_mark_target_info)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_YiZohTLBPa+yAtHODzrWMQ)--
