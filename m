From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH 2.4/2.5]
Date: 29 Jun 2003 21:11:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056913883.1068.70.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-RKxEIeJXCvhnwBviHF24"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@interlinx.bc.ca
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-RKxEIeJXCvhnwBviHF24
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Brian,

Are you ok with the following two patches? They allow for the
amanda conntrack/nat modules to track up to 8 ports - it has
more or less become a common practice for most conntrack/nat
helpers in the kernel. There's a patch for 2.4 and one for 2.5.

Regards,
Filip







--=-RKxEIeJXCvhnwBviHF24
Content-Disposition: attachment; filename=diff.netfilter.amanda-2.4-20030629
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.amanda-2.4-20030629;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.22-pre2-orig/include/linux/netfilter_ipv4/i=
p_conntrack_amanda.h linux-2.4.22-pre2/include/linux/netfilter_ipv4/ip_conn=
track_amanda.h
--- linux-2.4.22-pre2-orig/include/linux/netfilter_ipv4/ip_conntrack_amanda=
.h	2003-06-28 23:20:35.000000000 +0200
+++ linux-2.4.22-pre2/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	20=
03-06-29 04:13:52.000000000 +0200
@@ -17,7 +17,7 @@
 };
=20
 #define NUM_MSGS 	3
-
+#define AMANDA_PORT	10080
=20
 struct ip_ct_amanda_expect
 {
diff -urN -X dontdiff linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_conntrac=
k_amanda.c linux-2.4.22-pre2/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-06=
-13 16:51:39.000000000 +0200
+++ linux-2.4.22-pre2/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-06-29 0=
5:29:27.000000000 +0200
@@ -1,4 +1,4 @@
-/* Amanda extension for IP connection tracking, Version 0.2
+/* Amanda extension for IP connection tracking, Version 0.3
  * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
  * based on HW's ip_conntrack_irc.c as well as other modules
  *
@@ -8,7 +8,8 @@
  *      2 of the License, or (at your option) any later version.
  *
  *	Module load syntax:
- * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]
+ * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]=20
+ * 				     [ports=3Dp1,p2,...,p<MAX_PORTS>]
  *=09
  *	Where master_timeout is the timeout (in seconds) of the master
  *	connection (port 10080).  This defaults to 5 minutes but if
@@ -16,6 +17,11 @@
  *	before getting back to the Amanda server, you can increase
  *	this value.
  *
+ *	Where ports sets the UDP ports used to track the Amanda protocol.
+ *
+ *	Changes:
+ *	v0.3 - 2003/06/29 - Add tracking support for up to 8 ports
+ *			    Filip Sneppe <filip.sneppe@cronos.be>
  */
=20
 #include <linux/module.h>
@@ -30,11 +36,19 @@
=20
 static unsigned int master_timeout =3D 300;
=20
+#define MAX_PORTS	8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
+#ifdef MODULE_PARM
 MODULE_PARM(master_timeout, "i");
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Amanda servers");
+#endif
=20
 DECLARE_LOCK(ip_amanda_lock);
 struct module *ip_conntrack_amanda =3D THIS_MODULE;
@@ -193,39 +207,60 @@
 	return NF_ACCEPT;
 }
=20
-static struct ip_conntrack_helper amanda_helper;
+static struct ip_conntrack_helper amanda_helper[MAX_PORTS];
+static char amanda_helper_names[MAX_PORTS][13];
=20
 static void fini(void)
 {
-	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
-	ip_conntrack_helper_unregister(&amanda_helper);
+	int i;
+
+	for (i =3D 0; (i < ports_c) && ports[i]; i++) {
+		DEBUGP("ip_ct_amanda: unregistering helper for port %d\n",
+		       ports[i]);
+		ip_conntrack_helper_unregister(&amanda_helper[i]);
+	}
 }
=20
 static int __init init(void)
 {
-	int ret;
+	int i, ret;
+	char *tmpname;
+
+	if(ports[0] =3D=3D 0)
+		ports[0] =3D AMANDA_PORT;
=20
-	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
-	amanda_helper.tuple.src.u.udp.port =3D htons(10080);
-	amanda_helper.tuple.dst.protonum =3D IPPROTO_UDP;
-	amanda_helper.mask.src.u.udp.port =3D 0xFFFF;
-	amanda_helper.mask.dst.protonum =3D 0xFFFF;
-	amanda_helper.max_expected =3D NUM_MSGS;
-	amanda_helper.timeout =3D 180;
-	amanda_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
-	amanda_helper.me =3D ip_conntrack_amanda;
-	amanda_helper.help =3D help;
-	amanda_helper.name =3D "amanda";
-
-	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
-
-	ret =3D ip_conntrack_helper_register(&amanda_helper);
-
-	if (ret) {
-		printk("ip_ct_amanda: ERROR registering helper\n");
-		fini();
-		return -EBUSY;
+	for(i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&amanda_helper[i], 0, sizeof(struct ip_conntrack_helper));
+		amanda_helper[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		amanda_helper[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		amanda_helper[i].mask.src.u.udp.port =3D 0xFFFF;
+		amanda_helper[i].mask.dst.protonum =3D 0xFFFF;
+		amanda_helper[i].max_expected =3D NUM_MSGS;
+		amanda_helper[i].timeout =3D 180;
+		amanda_helper[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		amanda_helper[i].me =3D ip_conntrack_amanda;
+		amanda_helper[i].help =3D help;
+
+		tmpname =3D &amanda_helper_names[i][0];
+		if(ports[i] =3D=3D AMANDA_PORT)
+			sprintf(tmpname, "amanda");
+		else
+			sprintf(tmpname, "amanda-%d", ports[i]);
+		amanda_helper[i].name =3D tmpname;
+
+		DEBUGP("ip_ct_amanda: registering helper for port %d\n",
+		       ports[i]);
+	=09
+		ret =3D ip_conntrack_helper_register(&amanda_helper[i]);
+
+		if (ret) {
+			printk("ip_ct_amanda: ERROR registering helper\n");
+			fini();
+			return ret;
+		}
+		ports_c++;
 	}
+
 	return 0;
 }
=20
diff -urN -X dontdiff linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_nat_aman=
da.c linux-2.4.22-pre2/net/ipv4/netfilter/ip_nat_amanda.c
--- linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-28 21=
:49:01.000000000 +0200
+++ linux-2.4.22-pre2/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-29 05:29:4=
4.000000000 +0200
@@ -8,7 +8,13 @@
  *      2 of the License, or (at your option) any later version.
  *
  *	Module load syntax:
- * 	insmod ip_nat_amanda.o
+ * 	insmod ip_nat_amanda.o [ports=3Dp1,p2,...,p<MAX_PORTS>]
+ *
+ * 	Where ports sets the UDP ports used to track the Amanda protocol.
+ *
+ * 	Changes:
+ * 	2003/06/29 - Add tracking support for up to 8 ports
+ * 		     Filip Sneppe <filip.sneppe@cronos.be>
  */
=20
 #include <linux/module.h>
@@ -38,6 +44,14 @@
 MODULE_DESCRIPTION("Amanda network address translation module");
 MODULE_LICENSE("GPL");
=20
+#define MAX_PORTS	8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Amanda servers");
+#endif
+
 /* protects amanda part of conntracks */
 DECLARE_LOCK_EXTERN(ip_amanda_lock);
=20
@@ -179,45 +193,62 @@
 	return NF_ACCEPT;
 }
=20
-static struct ip_nat_helper ip_nat_amanda_helper;
+static struct ip_nat_helper ip_nat_amanda_helper[MAX_PORTS];
+static char amanda_helper_names[MAX_PORTS][13];
=20
 /* This function is intentionally _NOT_ defined as  __exit, because
  * it is needed by init() */
 static void fini(void)
 {
-	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
-	ip_nat_helper_unregister(&ip_nat_amanda_helper);
+	int i;
+
+	for(i =3D 0; i < ports_c; i++) {
+		DEBUGP("ip_nat_amanda: unregistering nat helper for port %d\n",
+		       ports[i]);
+		ip_nat_helper_unregister(&ip_nat_amanda_helper[i]);
+	}
 }
=20
 static int __init init(void)
 {
-	int ret =3D 0;
-	struct ip_nat_helper *hlpr;
+	int i, ret =3D 0;
+	char *tmpname;
=20
-	hlpr =3D &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
+	if(!ports[0])
+		ports[0] =3D AMANDA_PORT;
=20
-	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
-	hlpr->tuple.src.u.udp.port =3D htons(10080);
-	hlpr->mask.src.u.udp.port =3D 0xFFFF;
-	hlpr->mask.dst.protonum =3D 0xFFFF;
-	hlpr->help =3D help;
-	hlpr->flags =3D 0;
-	hlpr->me =3D THIS_MODULE;
-	hlpr->expect =3D amanda_nat_expected;
-
-	hlpr->name =3D "amanda";
-
-	DEBUGP
-	    ("ip_nat_amanda: Trying to register nat helper\n");
-	ret =3D ip_nat_helper_register(hlpr);
-
-	if (ret) {
-		printk
-		    ("ip_nat_amanda: error registering nat helper\n");
-		fini();
-		return 1;
+	for(i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&ip_nat_amanda_helper[i], 0, sizeof(struct ip_nat_helper));
+		ip_nat_amanda_helper[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		ip_nat_amanda_helper[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		ip_nat_amanda_helper[i].mask.src.u.udp.port =3D 0xFFFF;
+		ip_nat_amanda_helper[i].mask.dst.protonum =3D 0xFFFF;
+		ip_nat_amanda_helper[i].help =3D help;
+		ip_nat_amanda_helper[i].flags =3D 0;
+		ip_nat_amanda_helper[i].me =3D THIS_MODULE;
+		ip_nat_amanda_helper[i].expect =3D amanda_nat_expected;
+
+		tmpname =3D &amanda_helper_names[i][0];
+		if(ports[i] =3D=3D AMANDA_PORT)
+			sprintf(tmpname, "amanda");
+		else
+			sprintf(tmpname, "amanda-%d", ports[i]);
+		ip_nat_amanda_helper[i].name =3D tmpname;
+
+		DEBUGP("ip_nat_amanda: Trying to register nat helperfor port %d\n",
+		       ports[i]);
+		ret =3D ip_nat_helper_register(&ip_nat_amanda_helper[i]);
+
+		if (ret) {
+			printk
+				("ip_nat_amanda: error registering for port %d\n",
+				 ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
 	}
+
 	return ret;
 }
=20

--=-RKxEIeJXCvhnwBviHF24
Content-Disposition: attachment; filename=diff.netfilter.amanda-2.5-20030629
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.amanda-2.5-20030629;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.5.73-orig/include/linux/netfilter_ipv4/ip_con=
ntrack_amanda.h linux-2.5.73/include/linux/netfilter_ipv4/ip_conntrack_aman=
da.h
--- linux-2.5.73-orig/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	20=
03-06-22 20:32:33.000000000 +0200
+++ linux-2.5.73/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2003-06=
-29 21:12:07.000000000 +0200
@@ -11,6 +11,8 @@
=20
 #endif
=20
+#define AMANDA_PORT	10080
+
 struct ip_ct_amanda_expect
 {
 	u_int16_t port;		/* port number of this expectation */
diff -urN -X dontdiff linux-2.5.73-orig/net/ipv4/netfilter/ip_conntrack_ama=
nda.c linux-2.5.73/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.5.73-orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-06-22 2=
0:32:58.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-06-29 22:06:=
38.000000000 +0200
@@ -1,4 +1,4 @@
-/* Amanda extension for IP connection tracking, Version 0.2
+/* Amanda extension for IP connection tracking, Version 0.3
  * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
  * based on HW's ip_conntrack_irc.c as well as other modules
  *
@@ -8,7 +8,8 @@
  *      2 of the License, or (at your option) any later version.
  *
  *	Module load syntax:
- * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]
+ * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]=20
+ * 				     [ports=3Dp1,p2,...,p<MAX_PORTS>]
  *=09
  *	Where master_timeout is the timeout (in seconds) of the master
  *	connection (port 10080).  This defaults to 5 minutes but if
@@ -16,6 +17,11 @@
  *	before getting back to the Amanda server, you can increase
  *	this value.
  *
+ *	Where ports sets the UDP ports used to track the Amanda protocol.
+ *
+ *	Changes:
+ *	v0.3 - 2003/06/29 - Add tracking support for up to 8 ports
+ *			    Filip Sneppe <filip.sneppe@cronos.be>
  */
=20
 #include <linux/module.h>
@@ -30,11 +36,19 @@
=20
 static unsigned int master_timeout =3D 300;
=20
+#define MAX_PORTS	8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
+#ifdef MODULE_PARM
 MODULE_PARM(master_timeout, "i");
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Amanda servers");
+#endif
=20
 DECLARE_LOCK(ip_amanda_lock);
=20
@@ -170,41 +184,61 @@
 	return NF_ACCEPT;
 }
=20
-static struct ip_conntrack_helper amanda_helper =3D {
-	.max_expected =3D ARRAY_SIZE(conns),
-	.timeout =3D 180,
-	.flags =3D IP_CT_HELPER_F_REUSE_EXPECT,
-	.me =3D THIS_MODULE,
-	.help =3D help,
-	.name =3D "amanda",
-
-	.tuple =3D { .src =3D { .u =3D { __constant_htons(10080) } },
-		   .dst =3D { .protonum =3D IPPROTO_UDP },
-	},
-	.mask =3D { .src =3D { .u =3D { 0xFFFF } },
-		 .dst =3D { .protonum =3D 0xFFFF },
-	},
-};
+static struct ip_conntrack_helper amanda_helper[MAX_PORTS];
+static char amanda_helper_names[MAX_PORTS][13];
=20
 static void fini(void)
 {
-	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
-	ip_conntrack_helper_unregister(&amanda_helper);
+	int i;
+
+	for (i =3D 0; (i < ports_c) && ports[i]; i++) {
+		DEBUGP("ip_ct_amanda: unregistering helper for port %d\n",
+		       ports[i]);
+		ip_conntrack_helper_unregister(&amanda_helper[i]);
+	}
 }
=20
 static int __init init(void)
 {
-	int ret;
+	int i, ret =3D 0;
+	char *tmpname;
=20
-	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
-	ret =3D ip_conntrack_helper_register(&amanda_helper);
+	if(ports[0] =3D=3D 0)
+		ports[0] =3D AMANDA_PORT;
=20
-	if (ret) {
-		printk("ip_ct_amanda: ERROR registering helper\n");
-		fini();
-		return -EBUSY;
+	for(i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&amanda_helper[i], 0, sizeof(struct ip_conntrack_helper));
+		amanda_helper[i].tuple.src.u.udp.port =3D __constant_htons(ports[i]);
+		amanda_helper[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		amanda_helper[i].mask.src.u.udp.port =3D 0xFFFF;
+		amanda_helper[i].mask.dst.protonum =3D 0xFFFF;
+		amanda_helper[i].max_expected =3D ARRAY_SIZE(conns);
+		amanda_helper[i].timeout =3D 180;
+		amanda_helper[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		amanda_helper[i].me =3D THIS_MODULE;
+		amanda_helper[i].help =3D help;
+
+		tmpname =3D &amanda_helper_names[i][0];
+		if(ports[i] =3D=3D AMANDA_PORT)
+			sprintf(tmpname, "amanda");
+		else
+			sprintf(tmpname, "amanda-%d", ports[i]);
+		amanda_helper[i].name =3D tmpname;
+
+		DEBUGP("ip_ct_amanda: registering helper for port %d\n",
+		       ports[i]);
+
+		ret =3D ip_conntrack_helper_register(&amanda_helper[i]);
+
+		if (ret) {
+			printk("ip_ct_amanda: ERROR registering helper\n");
+			fini();
+			return ret;
+		}
+		ports_c++;
 	}
-	return 0;
+
+	return ret;
 }
=20
 PROVIDES_CONNTRACK(amanda);
diff -urN -X dontdiff linux-2.5.73-orig/net/ipv4/netfilter/ip_nat_amanda.c =
linux-2.5.73/net/ipv4/netfilter/ip_nat_amanda.c
--- linux-2.5.73-orig/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-22 20:32:3=
6.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-29 21:25:02.000=
000000 +0200
@@ -8,7 +8,13 @@
  *      2 of the License, or (at your option) any later version.
  *
  *	Module load syntax:
- * 	insmod ip_nat_amanda.o
+ * 	insmod ip_nat_amanda.o [ports=3Dp1,p2,...,p<MAX_PORTS>]
+ *
+ * 	Where ports sets the UDP ports used to track the Amanda protocol.
+ *
+ * 	Changes:
+ * 	2003/06/29 - Add tracking support for up to 8 ports
+ * 		     Filip Sneppe <filip.sneppe@cronos.be>
  */
=20
 #include <linux/module.h>
@@ -38,6 +44,14 @@
 MODULE_DESCRIPTION("Amanda network address translation module");
 MODULE_LICENSE("GPL");
=20
+#define MAX_PORTS	8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Amanda servers");
+#endif
+
 /* protects amanda part of conntracks */
 DECLARE_LOCK_EXTERN(ip_amanda_lock);
=20
@@ -179,45 +193,62 @@
 	return NF_ACCEPT;
 }
=20
-static struct ip_nat_helper ip_nat_amanda_helper;
+static struct ip_nat_helper ip_nat_amanda_helper[MAX_PORTS];
+static char amanda_helper_names[MAX_PORTS][13];
=20
 /* This function is intentionally _NOT_ defined as  __exit, because
  * it is needed by init() */
 static void fini(void)
 {
-	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
-	ip_nat_helper_unregister(&ip_nat_amanda_helper);
+	int i;
+
+	for(i =3D 0; i < ports_c; i++) {
+		DEBUGP("ip_nat_amanda: unregistering nat helper for port %d\n",
+		       ports[i]);
+		ip_nat_helper_unregister(&ip_nat_amanda_helper[i]);
+	}
 }
=20
 static int __init init(void)
 {
-	int ret =3D 0;
-	struct ip_nat_helper *hlpr;
+	int i, ret =3D 0;
+	char *tmpname;
=20
-	hlpr =3D &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
+	if(!ports[0])
+		ports[0] =3D AMANDA_PORT;
=20
-	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
-	hlpr->tuple.src.u.udp.port =3D htons(10080);
-	hlpr->mask.src.u.udp.port =3D 0xFFFF;
-	hlpr->mask.dst.protonum =3D 0xFFFF;
-	hlpr->help =3D help;
-	hlpr->flags =3D 0;
-	hlpr->me =3D THIS_MODULE;
-	hlpr->expect =3D amanda_nat_expected;
-
-	hlpr->name =3D "amanda";
-
-	DEBUGP
-	    ("ip_nat_amanda: Trying to register nat helper\n");
-	ret =3D ip_nat_helper_register(hlpr);
-
-	if (ret) {
-		printk
-		    ("ip_nat_amanda: error registering nat helper\n");
-		fini();
-		return 1;
+	for(i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&ip_nat_amanda_helper[i], 0, sizeof(struct ip_nat_helper));
+		ip_nat_amanda_helper[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		ip_nat_amanda_helper[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		ip_nat_amanda_helper[i].mask.src.u.udp.port =3D 0xFFFF;
+		ip_nat_amanda_helper[i].mask.dst.protonum =3D 0xFFFF;
+		ip_nat_amanda_helper[i].help =3D help;
+		ip_nat_amanda_helper[i].flags =3D 0;
+		ip_nat_amanda_helper[i].me =3D THIS_MODULE;
+		ip_nat_amanda_helper[i].expect =3D amanda_nat_expected;
+
+		tmpname =3D &amanda_helper_names[i][0];
+		if(ports[i] =3D=3D AMANDA_PORT)
+			sprintf(tmpname, "amanda");
+		else
+			sprintf(tmpname, "amanda-%d", ports[i]);
+		ip_nat_amanda_helper[i].name =3D tmpname;
+
+		DEBUGP("ip_nat_amanda: Trying to register nat helperfor port %d\n",
+		       ports[i]);
+		ret =3D ip_nat_helper_register(&ip_nat_amanda_helper[i]);
+
+		if (ret) {
+			printk
+				("ip_nat_amanda: error registering for port %d\n",
+				 ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
 	}
+
 	return ret;
 }
=20

--=-RKxEIeJXCvhnwBviHF24--
