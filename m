From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  dead code elimination in libipt_ecn.c
Date: Fri, 04 Apr 2003 11:21:07 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8DB0F3.1070007@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_SSbo2a1s5CSHtJTC6Qbi5Q)"
Cc: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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

--Boundary_(ID_SSbo2a1s5CSHtJTC6Qbi5Q)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

    the following patch removes print_dscp() which is not used.  It also 
converts all structures to C99.

Regards,

Stephane Ouellette


--Boundary_(ID_SSbo2a1s5CSHtJTC6Qbi5Q)
Content-type: text/plain; name=libipt_ecn.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_ecn.c.patch

--- netfilter/userspace/extensions/libipt_ecn.c	Mon Aug  5 15:35:52 2002
+++ netfilter.fixed/userspace/extensions/libipt_ecn.c	Fri Apr  4 11:14:59 2003
@@ -32,10 +32,10 @@
 }
 
 static struct option opts[] = {
-	{ "ecn-tcp-cwr", 0, 0, 'F' },
-	{ "ecn-tcp-ece", 0, 0, 'G' },
-	{ "ecn-ip-ect", 1, 0, 'H' },
-	{ 0 }
+	{ .name = "ecn-tcp-cwr", .has_arg = 0, .flag = 0, .val = 'F' },
+	{ .name = "ecn-tcp-ece", .has_arg = 0, .flag = 0, .val = 'G' },
+	{ .name = "ecn-ip-ect",  .has_arg = 1, .flag = 0, .val = 'H' },
+	{ .name = 0 }
 };
 
 static int
@@ -100,15 +100,6 @@
 		           "ECN match: some option required");
 }
 
-static void
-print_dscp(u_int8_t dscp, int invert, int numeric)
-{
-	if (invert)
-		fputc('!', stdout);
-
- 	printf("0x%02x ", dscp);
-}
-
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
@@ -167,18 +158,17 @@
 
 static
 struct iptables_match ecn
-= { NULL,
-    "ecn",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_ecn_info)),
-    IPT_ALIGN(sizeof(struct ipt_ecn_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= { .name          = "ecn",
+    .version       = IPTABLES_VERSION,
+    .size          = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
+    .userspacesize = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
+    .help          = &help,
+    .init          = &init,
+    .parse         = &parse,
+    .final_check   = &final_check,
+    .print         = &print,
+    .save          = &save,
+    .extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_SSbo2a1s5CSHtJTC6Qbi5Q)--
