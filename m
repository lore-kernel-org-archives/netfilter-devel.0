From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 4/5] use c99 initializers
Date: Wed, 19 Jan 2005 01:47:04 +0100
Message-ID: <20050119004704.GE12967@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AbQceqfdZEv+FvjW"
Cc: Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050119004332.GA12629@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

use c99 initializers



--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="04-use_c99_initializers.patch"

Wed Jan 19 01:34:09 CET 2005  max@duempel.org
  * use c99 initializers
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:50.524216856 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:50.551212752 +0100
@@ -129,19 +129,16 @@
 }
 
 /* H.245 helper is not registered! */
-static struct ip_conntrack_helper h245 = 
-	{ { NULL, NULL },
-          "H.245",				/* name */
-          IP_CT_HELPER_F_REUSE_EXPECT,		/* flags */
-          NULL,					/* module */
-          8,					/* max_ expected */
-          240,					/* timeout */
-          { { 0, { 0 } },			/* tuple */
-            { 0, { 0 }, IPPROTO_TCP } },
-          { { 0, { 0xFFFF } },			/* mask */
-            { 0, { 0 }, 0xFFFF } },
-          h245_help				/* helper */
-	};
+static struct ip_conntrack_helper h245 = {
+	.name = "H.245",
+	.flags = IP_CT_HELPER_F_REUSE_EXPECT,
+	.max_expected = 8,
+	.timeout = 240,
+	.tuple = { .dst = { .protonum = IPPROTO_TCP } },
+	.mask = { .src = { .u = { 0xFFFF } },
+		  .dst = { .protonum = 0xFFFF } },
+	.help = h245_help
+};
 
 static int h225_expect(struct ip_conntrack *ct)
 {
@@ -278,19 +275,18 @@
 
 }
 
-static struct ip_conntrack_helper h225 = 
-	{ { NULL, NULL },
-	  "H.225",					/* name */
-	  IP_CT_HELPER_F_REUSE_EXPECT,			/* flags */
-	  THIS_MODULE,					/* module */
-	  2,						/* max_expected */
-	  240,						/* timeout */
-	  { { 0, { __constant_htons(H225_PORT) } },	/* tuple */
-	    { 0, { 0 }, IPPROTO_TCP } },
-	  { { 0, { 0xFFFF } },				/* mask */
-	    { 0, { 0 }, 0xFFFF } },
-	  h225_help					/* helper */
-	};
+static struct ip_conntrack_helper h225 = {
+	.name = "H.225",
+	.flags = IP_CT_HELPER_F_REUSE_EXPECT,
+	.me = THIS_MODULE,
+	.max_expected = 2,
+	.timeout = 240,
+	.tuple = { .src = { .u = { __constant_htons(H225_PORT) } },
+		   .dst = { .protonum = IPPROTO_TCP } },
+	.mask = { .src = { .u = { 0xFFFF } },
+		  .dst = { .protonum = 0xFFFF } },
+	.help = h225_help
+};
 
 static int __init init(void)
 {
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:50.522217160 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:50.549213056 +0100
@@ -52,18 +52,18 @@
 				  unsigned int hooknum,
 				  struct sk_buff **pskb);
 
-static struct ip_nat_helper h245 =
-	{ { NULL, NULL },
-          "H.245",				/* name */
-	  0,					/* flags */
-	  NULL,					/* module */
-	  { { 0, { 0 } },			/* tuple */
-	    { 0, { 0 }, IPPROTO_TCP } },
-	  { { 0, { 0xFFFF } },			/* mask */
-	    { 0, { 0 }, 0xFFFF } },
-	  h225_nat_help,			/* helper */
-	  h225_nat_expected			/* expectfn */
-	};
+static struct ip_nat_helper h245 = {
+	.list = { NULL, NULL },
+	.name = "H.245",
+	.flags = 0,
+	.me = THIS_MODULE,
+	.tuple = { { 0, { 0 } },
+		   { 0, { 0 }, IPPROTO_TCP } },
+	.mask = { { 0, { 0xFFFF } },
+		  { 0, { 0 }, 0xFFFF } },
+	.help = h225_nat_help,
+	.expect = h225_nat_expected
+};
 
 static unsigned int
 h225_nat_expected(struct sk_buff **pskb,
@@ -386,18 +386,18 @@
 	return NF_ACCEPT;
 }
 
-static struct ip_nat_helper h225 = 
-	{ { NULL, NULL },
-	  "H.225",					/* name */
-	  IP_NAT_HELPER_F_ALWAYS, 			/* flags */
-	  THIS_MODULE,					/* module */
-	  { { 0, { .tcp = { __constant_htons(H225_PORT) } } },	/* tuple */
-	    { 0, { 0 }, IPPROTO_TCP } },
-	  { { 0, { .tcp = { 0xFFFF } } },		/* mask */
-	    { 0, { 0 }, 0xFFFF } },
-	  h225_nat_help,				/* helper */
-	  h225_nat_expected				/* expectfn */
-	};
+static struct ip_nat_helper h225 = {
+	.list = { NULL, NULL },
+	.name = "H.225",
+	.flags = IP_NAT_HELPER_F_ALWAYS,
+	.me = THIS_MODULE,
+	.tuple = { { 0, { .tcp = { __constant_htons(H225_PORT) } } },
+		   { 0, { 0 }, IPPROTO_TCP } },
+	.mask = { { 0, { .tcp = { 0xFFFF } } },
+		  { 0, { 0 }, 0xFFFF } },
+	.help = h225_nat_help,
+	.expect = h225_nat_expected
+};
 
 static int __init init(void)
 {


--AbQceqfdZEv+FvjW--
