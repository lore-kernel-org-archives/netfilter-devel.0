From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (4/X): use new module_param() api
Date: Sat, 24 Jul 2004 10:27:12 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724142712.GL2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KCXyoJ//PRyfzsc9"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KCXyoJ//PRyfzsc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch makes all of ipv4/ipv6 netfilter use the 'new' module_param
API.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Harald Welte <laforge@netfilter.org>


diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_am=
anda.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_aman=
da.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-0=
7-22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_amanda.=
c	2004-07-24 10:10:55.139074248 -0400
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
+#include <linux/moduleparam.h>
 #include <net/checksum.h>
 #include <net/udp.h>
=20
@@ -34,7 +35,7 @@
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
-MODULE_PARM(master_timeout, "i");
+module_param(master_timeout, int, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
=20
 static char *conns[] =3D { "DATA ", "MESG ", "INDEX " };
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_co=
re.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-=
22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_core.c	=
2004-07-24 10:10:55.142073792 -0400
@@ -34,8 +34,8 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
-/* For ERR_PTR().  Yeah, I know... --RR */
-#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/moduleparam.h>
=20
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -1373,7 +1373,7 @@
 }
=20
 static int hashsize;
-MODULE_PARM(hashsize, "i");
+module_param(hashsize, int, 0400);
=20
 int __init ip_conntrack_init(void)
 {
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_ft=
p.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-07-2=
2 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_ftp.c	2=
004-07-24 10:10:55.144073488 -0400
@@ -19,6 +19,7 @@
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
+#include <linux/moduleparam.h>
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
@@ -33,10 +34,10 @@
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
=20
 static int loose;
-MODULE_PARM(loose, "i");
+module_param(loose, int, 0600);
=20
 #if 0
 #define DEBUGP printk
@@ -420,10 +421,10 @@
 	int i, ret;
 	char *tmpname;
=20
-	if (ports[0] =3D=3D 0)
-		ports[0] =3D FTP_PORT;
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D FTP_PORT;
=20
-	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		ftp[i].tuple.src.u.tcp.port =3D htons(ports[i]);
 		ftp[i].tuple.dst.protonum =3D IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port =3D 0xFFFF;
@@ -449,7 +450,6 @@
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
 	return 0;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_ir=
c.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_irc.c	2004-07-2=
2 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_irc.c	2=
004-07-24 10:10:55.145073336 -0400
@@ -32,6 +32,7 @@
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+#include <linux/moduleparam.h>
=20
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
@@ -44,11 +45,11 @@
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-MODULE_PARM(max_dcc_channels, "i");
+module_param(max_dcc_channels, int, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels pe=
r IRC session");
-MODULE_PARM(dcc_timeout, "i");
+module_param(dcc_timeout, int, 0400);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
=20
 static char *dccprotos[] =3D { "SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT=
 " };
@@ -252,10 +253,10 @@
 	}
 =09
 	/* If no port given, default to standard irc port */
-	if (ports[0] =3D=3D 0)
-		ports[0] =3D IRC_PORT;
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D IRC_PORT;
=20
-	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		hlpr =3D &irc_helpers[i];
 		hlpr->tuple.src.u.tcp.port =3D htons(ports[i]);
 		hlpr->tuple.dst.protonum =3D IPPROTO_TCP;
@@ -284,7 +285,6 @@
 			fini();
 			return -EBUSY;
 		}
-		ports_c++;
 	}
 	return 0;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_tf=
tp.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_tftp.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-07-=
22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_conntrack_tftp.c	=
2004-07-24 10:10:55.147073032 -0400
@@ -19,6 +19,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
+#include <linux/moduleparam.h>
=20
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("tftp connection tracking helper");
@@ -27,7 +28,7 @@
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
=20
 #if 0
@@ -104,10 +105,10 @@
 	int i, ret;
 	char *tmpname;
=20
-	if (!ports[0])
-		ports[0]=3DTFTP_PORT;
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D TFTP_PORT;
=20
-	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		/* Create helper structure */
 		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
=20
@@ -137,7 +138,6 @@
 			fini();
 			return(ret);
 		}
-		ports_c++;
 	}
 	return(0);
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_ftp.c li=
nux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_ftp.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_ftp.c	2004-07-22 11:4=
9:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_ftp.c	2004-07=
-24 10:10:55.148072880 -0400
@@ -12,6 +12,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <linux/moduleparam.h>
 #include <net/tcp.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
@@ -33,7 +34,7 @@
 static int ports[MAX_PORTS];
 static int ports_c;
=20
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
=20
 DECLARE_LOCK_EXTERN(ip_ftp_lock);
=20
@@ -313,10 +314,10 @@
 	int i, ret =3D 0;
 	char *tmpname;
=20
-	if (ports[0] =3D=3D 0)
-		ports[0] =3D FTP_PORT;
+	if (ports_c =3D=3D 0)
+		ports[ports_c] =3D FTP_PORT;
=20
-	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		ftp[i].tuple.dst.protonum =3D IPPROTO_TCP;
 		ftp[i].tuple.src.u.tcp.port =3D htons(ports[i]);
 		ftp[i].mask.dst.protonum =3D 0xFFFF;
@@ -343,7 +344,6 @@
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
=20
 	return ret;
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_irc.c li=
nux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_irc.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_irc.c	2004-07-22 11:4=
9:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_irc.c	2004-07=
-24 10:10:55.149072728 -0400
@@ -27,6 +27,7 @@
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/moduleparam.h>
=20
 #if 0
 #define DEBUGP printk
@@ -41,7 +42,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
=20
 /* protects irc part of conntracks */
@@ -235,11 +236,10 @@
 	struct ip_nat_helper *hlpr;
 	char *tmpname;
=20
-	if (ports[0] =3D=3D 0) {
-		ports[0] =3D IRC_PORT;
-	}
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D IRC_PORT;
=20
-	for (i =3D 0; (i < MAX_PORTS) && ports[i] !=3D 0; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		hlpr =3D &ip_nat_irc_helpers[i];
 		hlpr->tuple.dst.protonum =3D IPPROTO_TCP;
 		hlpr->tuple.src.u.tcp.port =3D htons(ports[i]);
@@ -269,7 +269,6 @@
 			fini();
 			return 1;
 		}
-		ports_c++;
 	}
 	return ret;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_snmp_bas=
ic.c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-07-=
24 09:59:36.207287568 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_snmp_basic.c	=
2004-07-24 10:10:55.152072272 -0400
@@ -47,6 +47,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
@@ -1360,4 +1361,4 @@
 module_init(init);
 module_exit(fini);
=20
-MODULE_PARM(debug, "i");
+module_param(debug, bool, 0600);
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_tftp.c l=
inux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_tftp.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ip_nat_tftp.c	2004-07-22 11:=
49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ip_nat_tftp.c	2004-0=
7-24 10:10:55.153072120 -0400
@@ -32,6 +32,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/moduleparam.h>
=20
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("tftp NAT helper");
@@ -41,7 +42,7 @@
=20
 static int ports[MAX_PORTS];
 static int ports_c =3D 0;
-MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
=20
 #if 0
@@ -162,10 +163,10 @@
 	int i, ret =3D 0;
 	char *tmpname;
=20
-	if (!ports[0])
-		ports[0] =3D TFTP_PORT;
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D TFTP_PORT;
=20
-	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+	for (i =3D 0; i < ports_c; i++) {
 		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
=20
 		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
@@ -194,7 +195,6 @@
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
 	return ret;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_LOG.c linux=
-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_LOG.c	2004-07-22 11:49:1=
3.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_LOG.c	2004-07-24=
 10:13:21.534818712 -0400
@@ -28,7 +28,7 @@
 MODULE_DESCRIPTION("iptables syslog logging module");
=20
 static unsigned int nflog =3D 1;
-MODULE_PARM(nflog, "i");
+module_param(nflog, int, 0400);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
 =20
 #if 0
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_ULOG.c linu=
x-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_ULOG.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_ULOG.c	2004-07-24 09:59:=
57.291082344 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_ULOG.c	2004-07-2=
4 10:14:34.621707816 -0400
@@ -34,8 +34,8 @@
  * by that factor.
  *
  * flushtimeout:
- *   Specify, after how many clock ticks (intel: 100 per second) the queue
- * should be flushed even if it is not full yet.
+ *   Specify, after how many hundredths of a second the queue should be
+ *   flushed even if it is not full yet.
  *
  * ipt_ULOG.c,v 1.22 2002/10/30 09:07:31 laforge Exp
  */
@@ -50,6 +50,7 @@
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
@@ -74,15 +75,15 @@
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , =
## args); } while (0)
=20
 static unsigned int nlbufsiz =3D 4096;
-MODULE_PARM(nlbufsiz, "i");
+module_param(nlbufsiz, uint, 0600); /* FIXME: Check size < 128k --RR */
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
=20
-static unsigned int flushtimeout =3D 10 * HZ;
-MODULE_PARM(flushtimeout, "i");
-MODULE_PARM_DESC(flushtimeout, "buffer flush timeout");
+static unsigned int flushtimeout =3D 10;
+module_param(flushtimeout, int, 0600);
+MODULE_PARM_DESC(flushtimeout, "buffer flush timeout (hundredths of a seco=
nd)");
=20
 static unsigned int nflog =3D 1;
-MODULE_PARM(nflog, "i");
+module_param(nflog, int, 0400);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
=20
 /* global data structures */
@@ -264,7 +265,7 @@
=20
 	/* if timer isn't already running, start it */
 	if (!timer_pending(&ub->timer)) {
-		ub->timer.expires =3D jiffies + flushtimeout;
+		ub->timer.expires =3D jiffies + flushtimeout * HZ / 100;
 		add_timer(&ub->timer);
 	}
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_recent.c li=
nux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_recent.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/ipt_recent.c	2004-06-16 01:1=
8:58.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/ipt_recent.c	2004-07=
-24 10:10:55.157071512 -0400
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/ip.h>
 #include <linux/vmalloc.h>
+#include <linux/moduleparam.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_recent.h>
@@ -37,12 +38,12 @@
 MODULE_AUTHOR("Stephen Frost <sfrost@snowman.net>");
 MODULE_DESCRIPTION("IP tables recently seen matching module " RECENT_VER);
 MODULE_LICENSE("GPL");
-MODULE_PARM(ip_list_tot,"i");
-MODULE_PARM(ip_pkt_list_tot,"i");
-MODULE_PARM(ip_list_hash_size,"i");
-MODULE_PARM(ip_list_perms,"i");
+module_param(ip_list_tot, int, 0400);
+module_param(ip_pkt_list_tot, int, 0400);
+module_param(ip_list_hash_size, int, 0400);
+module_param(ip_list_perms, int, 0400);
 #ifdef DEBUG
-MODULE_PARM(debug,"i");
+module_param(debug, int, 0600);
 MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
 #endif
 MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv4/netfilter/iptable_filter.=
c linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/iptable_filter.c
--- linux-2.6.8-rc2-updates/net/ipv4/netfilter/iptable_filter.c	2004-06-16 =
01:19:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv4/netfilter/iptable_filter.c	200=
4-07-24 10:10:55.158071360 -0400
@@ -11,6 +11,7 @@
  */
=20
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
 MODULE_LICENSE("GPL");
@@ -155,7 +156,7 @@
=20
 /* Default to forward because I got too much mail already. */
 static int forward =3D NF_ACCEPT;
-MODULE_PARM(forward, "i");
+module_param(forward, bool, 0000);
=20
 static int __init init(void)
 {
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv6/netfilter/ip6t_LOG.c linu=
x-2.6.8-rc2-updates-modparm/net/ipv6/netfilter/ip6t_LOG.c
--- linux-2.6.8-rc2-updates/net/ipv6/netfilter/ip6t_LOG.c	2004-07-22 11:49:=
13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv6/netfilter/ip6t_LOG.c	2004-07-2=
4 10:17:56.355039688 -0400
@@ -11,6 +11,7 @@
  */
=20
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/spinlock.h>
@@ -26,7 +27,7 @@
 MODULE_LICENSE("GPL");
=20
 static unsigned int nflog =3D 1;
-MODULE_PARM(nflog, "i");
+module_param(nflog, int, 0400);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
 =20
 struct in_device;
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates/net/ipv6/netfilter/ip6table_filter=
=2Ec linux-2.6.8-rc2-updates-modparm/net/ipv6/netfilter/ip6table_filter.c
--- linux-2.6.8-rc2-updates/net/ipv6/netfilter/ip6table_filter.c	2004-06-16=
 01:18:57.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm/net/ipv6/netfilter/ip6table_filter.c	20=
04-07-24 10:17:35.725175904 -0400
@@ -10,6 +10,7 @@
  */
=20
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
 MODULE_LICENSE("GPL");
@@ -156,7 +157,7 @@
=20
 /* Default to forward because I got too much mail already. */
 static int forward =3D NF_ACCEPT;
-MODULE_PARM(forward, "i");
+module_param(forward, bool, 0000);
=20
 static int __init init(void)
 {
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KCXyoJ//PRyfzsc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnG/XaXGVTD0i/8RAj8SAJ9XXyjfuXtwJeNbrNfiK/trXIxCZgCgjFTW
1fkvIkiztik3yFNmPc1cZdc=
=y43y
-----END PGP SIGNATURE-----

--KCXyoJ//PRyfzsc9--
