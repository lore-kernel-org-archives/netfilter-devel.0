From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] cosmetic netfilter patch
Date: Sun, 24 Aug 2003 10:46:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824084633.GO6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zywvytGCXzdVpkje"
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


--zywvytGCXzdVpkje
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch (against 2.6.0-test4) is purely cosmetic. It
- moves all MODULE_{AUTHOR,DESCRIPTION,LICENSE} statements to the same
  location
- adds some missing MODULE_LICENSE("GPL") tags
- adds MODULE_DESCRIPTION and AUTHOR to all modules

[yes, as any cosmetic patches, this could make other people's patches
 break... that's why the patch is 2.6. only]

Please apply, thanks.

diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/arp_tables.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/arp_tables.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/arp_tables.c	2003-08-23 01=
:58:39.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/arp_tables.c	2003-08-24 0=
0:32:34.000000000 +0200
@@ -25,6 +25,10 @@
=20
 #include <linux/netfilter_arp/arp_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David S. Miller <davem@redhat.com>");
+MODULE_DESCRIPTION("arptables core");
+
 /*#define DEBUG_ARP_TABLES*/
 /*#define DEBUG_ARP_TABLES_USER*/
=20
@@ -1324,4 +1328,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/arpt_mangle.c linux-=
2.6.0-test4-cosmetic/net/ipv4/netfilter/arpt_mangle.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/arpt_mangle.c	2003-08-23 0=
1:58:03.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/arpt_mangle.c	2003-08-24 =
00:33:12.000000000 +0200
@@ -3,6 +3,10 @@
 #include <linux/netfilter_arp/arpt_mangle.h>
 #include <net/sock.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David S. Miller <davem@redhat.com>");
+MODULE_DESCRIPTION("arptables mangle table");
+
 static unsigned int
 target(struct sk_buff **pskb, unsigned int hooknum, const struct net_devic=
e *in,
    const struct net_device *out, const void *targinfo, void *userinfo)
@@ -98,4 +102,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/arptable_filter.c li=
nux-2.6.0-test4-cosmetic/net/ipv4/netfilter/arptable_filter.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/arptable_filter.c	2003-08-=
23 01:50:23.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/arptable_filter.c	2003-08=
-24 00:34:05.000000000 +0200
@@ -8,6 +8,10 @@
 #include <linux/module.h>
 #include <linux/netfilter_arp/arp_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David S. Miller <davem@redhat.com>");
+MODULE_DESCRIPTION("arptables filter table");
+
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
=20
@@ -209,4 +213,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_ftp.c l=
inux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-08=
-23 01:58:39.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-0=
8-24 00:35:06.000000000 +0200
@@ -11,6 +11,10 @@
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("ftp connection tracking helper");
+
 /* This is slow, but it's simple. --RR */
 static char ftp_buffer[65536];
=20
@@ -439,6 +443,5 @@
 PROVIDES_CONNTRACK(ftp);
 EXPORT_SYMBOL(ip_ftp_lock);
=20
-MODULE_LICENSE("GPL");
 module_init(init);
 module_exit(fini);
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_irc.c l=
inux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_irc.c	2003-08=
-23 01:58:38.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_irc.c	2003-0=
8-24 00:35:31.000000000 +0200
@@ -41,8 +41,8 @@
 /* This is slow, but it's simple. --RR */
 static char irc_buffer[65536];
=20
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IRC (DCC) connection tracking module");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
 #ifdef MODULE_PARM
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_tftp.c =
linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_tftp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-0=
8-23 01:53:53.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-=
08-24 00:35:52.000000000 +0200
@@ -17,7 +17,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
=20
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
-MODULE_DESCRIPTION("Netfilter connection tracking module for tftp");
+MODULE_DESCRIPTION("tftp connection tracking helper");
 MODULE_LICENSE("GPL");
=20
 #define MAX_PORTS 8
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_amanda.c linu=
x-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_amanda.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_amanda.c	2003-08-23=
 01:53:06.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_amanda.c	2003-08-2=
4 00:36:16.000000000 +0200
@@ -35,7 +35,7 @@
 #endif
=20
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
-MODULE_DESCRIPTION("Amanda network address translation module");
+MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
=20
 /* protects amanda part of conntracks */
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_ftp.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_ftp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_ftp.c	2003-08-23 01=
:57:47.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_ftp.c	2003-08-24 0=
0:36:58.000000000 +0200
@@ -10,6 +10,10 @@
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("ftp NAT helper");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -342,4 +346,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_irc.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_irc.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_irc.c	2003-08-23 02=
:02:51.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_irc.c	2003-08-24 0=
0:37:22.000000000 +0200
@@ -39,7 +39,7 @@
 static int ports_c;
=20
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IRC (DCC) network address translation module");
+MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
 #ifdef MODULE_PARM
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_snmp_basic.c =
linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-0=
8-23 01:58:48.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-=
08-24 00:37:59.000000000 +0200
@@ -56,7 +56,9 @@
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
=20
-
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
+MODULE_DESCRIPTION("Basic SNMP Application Layer Gateway");
=20
 #define SNMP_PORT 161
 #define SNMP_TRAP_PORT 162
@@ -1357,5 +1359,3 @@
 module_exit(fini);
=20
 MODULE_PARM(debug, "i");
-MODULE_DESCRIPTION("Basic SNMP Application Layer Gateway");
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_tftp.c linux-=
2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_tftp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_nat_tftp.c	2003-08-23 0=
1:53:50.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_nat_tftp.c	2003-08-24 =
00:38:26.000000000 +0200
@@ -30,7 +30,7 @@
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
=20
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
-MODULE_DESCRIPTION("Netfilter NAT helper for tftp");
+MODULE_DESCRIPTION("tfpt NAT helper");
 MODULE_LICENSE("GPL");
=20
 #define MAX_PORTS 8
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_tables.c linux-2.=
6.0-test4-cosmetic/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ip_tables.c	2003-08-23 01:=
53:13.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ip_tables.c	2003-08-24 00=
:39:19.000000000 +0200
@@ -25,6 +25,10 @@
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("IPv4 packet filter");
+
 /*#define DEBUG_IP_FIREWALL*/
 /*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
 /*#define DEBUG_IP_FIREWALL_USER*/
@@ -1845,4 +1849,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipchains_core.c linu=
x-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipchains_core.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipchains_core.c	2003-08-23=
 01:58:57.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipchains_core.c	2003-08-2=
4 00:41:25.000000000 +0200
@@ -100,6 +100,9 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
=20
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("ipchains backwards compatibility layer");
+
 /* Understanding locking in this code: (thanks to Alan Cox for using
  * little words to explain this to me). -- PR
  *
@@ -1842,4 +1845,3 @@
 #endif
 	return ret;
 }
-MODULE_LICENSE("Dual BSD/GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipfwadm_core.c linux=
-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipfwadm_core.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipfwadm_core.c	2003-08-23 =
01:54:33.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipfwadm_core.c	2003-08-24=
 00:41:15.000000000 +0200
@@ -134,6 +134,7 @@
 #include <linux/version.h>
=20
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("ipfwadm backwards compatibility layer");
=20
 /*
  *	Implement IP packet firewall
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_DSCP.c linux-2.6=
=2E0-test4-cosmetic/net/ipv4/netfilter/ipt_DSCP.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_DSCP.c	2003-08-23 02:0=
0:59.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_DSCP.c	2003-08-24 00:=
41:46.000000000 +0200
@@ -17,8 +17,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_DSCP.h>
=20
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IP tables DSCP modification module");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("iptables DSCP modification module");
 MODULE_LICENSE("GPL");
=20
 static unsigned int
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ECN.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_ECN.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ECN.c	2003-08-23 02:01=
:55.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_ECN.c	2003-08-24 00:4=
2:21.000000000 +0200
@@ -17,6 +17,8 @@
 #include <linux/netfilter_ipv4/ipt_ECN.h>
=20
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("iptables ECN modification module");
=20
 /* set ECT codepoint from IP header.
  * 	return 0 if there was an error. */
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_LOG.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_LOG.c	2003-08-23 01:59=
:04.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_LOG.c	2003-08-24 00:4=
2:59.000000000 +0200
@@ -13,6 +13,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables syslog logging module");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -413,4 +417,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_MARK.c linux-2.6=
=2E0-test4-cosmetic/net/ipv4/netfilter/ipt_MARK.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_MARK.c	2003-08-23 01:5=
6:23.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_MARK.c	2003-08-24 00:=
44:18.000000000 +0200
@@ -7,6 +7,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_MARK.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables MARK modification module");
+
 static unsigned int
 target(struct sk_buff **pskb,
        const struct net_device *in,
@@ -68,4 +72,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_MASQUERADE.c lin=
ux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-08-2=
3 01:57:11.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-08-=
24 00:44:58.000000000 +0200
@@ -12,6 +12,10 @@
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables MASQUERADE target module");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -213,4 +217,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_REDIRECT.c linux=
-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_REDIRECT.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_REDIRECT.c	2003-08-23 =
01:54:17.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_REDIRECT.c	2003-08-24=
 00:45:45.000000000 +0200
@@ -12,6 +12,10 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables REDIRECT target module");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -115,4 +119,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_REJECT.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_REJECT.c	2003-08-23 01=
:58:52.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_REJECT.c	2003-08-24 0=
0:46:21.000000000 +0200
@@ -16,6 +16,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables REJECT target module");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -462,4 +466,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_TCPMSS.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ipt_TCPMSS.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_TCPMSS.c	2003-08-23 01=
:56:18.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_TCPMSS.c	2003-08-24 0=
0:47:01.000000000 +0200
@@ -12,6 +12,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_TCPMSS.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables TCP MSS modification module");
+
 #if 0
 #define DEBUGP printk
 #else
@@ -250,4 +254,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_TOS.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_TOS.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_TOS.c	2003-08-23 01:51=
:35.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_TOS.c	2003-08-24 00:4=
7:34.000000000 +0200
@@ -7,6 +7,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_TOS.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables TOS mangling module");
+
 static unsigned int
 target(struct sk_buff **pskb,
        const struct net_device *in,
@@ -93,4 +97,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ULOG.c linux-2.6=
=2E0-test4-cosmetic/net/ipv4/netfilter/ipt_ULOG.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ULOG.c	2003-08-23 01:5=
4:19.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_ULOG.c	2003-08-24 00:=
47:46.000000000 +0200
@@ -55,7 +55,7 @@
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IP tables userspace logging module");
+MODULE_DESCRIPTION("iptables userspace logging module");
=20
 #define ULOG_NL_EVENT		111		/* Harald's favorite number */
 #define ULOG_MAXNLGROUPS	32		/* numer of nlgroups */
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ah.c linux-2.6.0=
-test4-cosmetic/net/ipv4/netfilter/ipt_ah.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ah.c	2003-08-23 01:57:=
17.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_ah.c	2003-08-24 00:49=
:28.000000000 +0200
@@ -7,6 +7,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
+MODULE_DESCRIPTION("iptables AH SPI match module");
=20
 #ifdef DEBUG_CONNTRACK
 #define duprintf(format, args...) printk(format , ## args)
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_conntrack.c linu=
x-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_conntrack.c	2003-08-23=
 01:59:46.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_conntrack.c	2003-08-2=
4 00:50:13.000000000 +0200
@@ -8,6 +8,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_conntrack.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables connection tracking match module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -122,4 +126,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_dscp.c linux-2.6=
=2E0-test4-cosmetic/net/ipv4/netfilter/ipt_dscp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_dscp.c	2003-08-23 01:5=
7:53.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_dscp.c	2003-08-24 00:=
50:39.000000000 +0200
@@ -13,8 +13,8 @@
 #include <linux/netfilter_ipv4/ipt_dscp.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IP tables DSCP matching module");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("iptables DSCP matching module");
 MODULE_LICENSE("GPL");
=20
 static int match(const struct sk_buff *skb, const struct net_device *in,
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ecn.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_ecn.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ecn.c	2003-08-23 01:55=
:41.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_ecn.c	2003-08-24 00:5=
1:00.000000000 +0200
@@ -14,8 +14,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
=20
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("IP tables ECN matching module");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("iptables ECN matching module");
 MODULE_LICENSE("GPL");
=20
 static inline int match_ip(const struct sk_buff *skb,
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_esp.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_esp.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_esp.c	2003-08-23 01:56=
:18.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_esp.c	2003-08-24 00:5=
1:31.000000000 +0200
@@ -7,6 +7,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
+MODULE_DESCRIPTION("iptables ESP SPI match module");
=20
 #ifdef DEBUG_CONNTRACK
 #define duprintf(format, args...) printk(format , ## args)
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_helper.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ipt_helper.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_helper.c	2003-08-23 01=
:58:09.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_helper.c	2003-08-24 0=
0:52:08.000000000 +0200
@@ -17,6 +17,8 @@
 #include <linux/netfilter_ipv4/ipt_helper.h>
=20
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Josefsson <gandalf@netfilter.org>");
+MODULE_DESCRIPTION("iptables helper match module");
=20
 #if 0
 #define DEBUGP printk
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_limit.c linux-2.=
6.0-test4-cosmetic/net/ipv4/netfilter/ipt_limit.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_limit.c	2003-08-23 01:=
51:35.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_limit.c	2003-08-24 00=
:53:18.000000000 +0200
@@ -15,6 +15,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_limit.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
+MODULE_DESCRIPTION("iptables rate limit match");
+
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
  * see net/sched/sch_tbf.c in the linux source tree
  */
@@ -134,4 +138,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_mac.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_mac.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_mac.c	2003-08-23 01:52=
:11.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_mac.c	2003-08-24 00:5=
3:48.000000000 +0200
@@ -6,6 +6,10 @@
 #include <linux/netfilter_ipv4/ipt_mac.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables mac matching module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -64,4 +68,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_mark.c linux-2.6=
=2E0-test4-cosmetic/net/ipv4/netfilter/ipt_mark.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_mark.c	2003-08-23 02:0=
3:26.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_mark.c	2003-08-24 00:=
54:20.000000000 +0200
@@ -5,6 +5,10 @@
 #include <linux/netfilter_ipv4/ipt_mark.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables mark matching module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -50,4 +54,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_multiport.c linu=
x-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_multiport.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_multiport.c	2003-08-23=
 01:52:56.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_multiport.c	2003-08-2=
4 00:55:10.000000000 +0200
@@ -8,6 +8,10 @@
 #include <linux/netfilter_ipv4/ipt_multiport.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables multiple port match module");
+
 #if 0
 #define duprintf(format, args...) printk(format , ## args)
 #else
@@ -106,4 +110,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_owner.c linux-2.=
6.0-test4-cosmetic/net/ipv4/netfilter/ipt_owner.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_owner.c	2003-08-23 02:=
00:37.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_owner.c	2003-08-24 00=
:55:45.000000000 +0200
@@ -11,6 +11,10 @@
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables owner match");
+
 static int
 match_comm(const struct sk_buff *skb, const char *comm)
 {
@@ -198,4 +202,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_physdev.c linux-=
2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_physdev.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_physdev.c	2003-08-23 0=
1:53:45.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_physdev.c	2003-08-24 =
00:56:45.000000000 +0200
@@ -8,6 +8,10 @@
 #define MATCH   1
 #define NOMATCH 0
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Bart De Schuymer <bdschuy@pandora.be>");
+MODULE_DESCRIPTION("iptables bridge physical device match module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -120,4 +124,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_state.c linux-2.=
6.0-test4-cosmetic/net/ipv4/netfilter/ipt_state.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_state.c	2003-08-23 02:=
03:03.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_state.c	2003-08-24 00=
:57:42.000000000 +0200
@@ -7,6 +7,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_state.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("iptables connection tracking state match module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -59,4 +63,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_tcpmss.c linux-2=
=2E6.0-test4-cosmetic/net/ipv4/netfilter/ipt_tcpmss.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_tcpmss.c	2003-08-23 01=
:52:16.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_tcpmss.c	2003-08-24 0=
0:58:18.000000000 +0200
@@ -8,6 +8,10 @@
=20
 #define TH_SYN 0x02
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables TCP MSS match module");
+
 /* Returns 1 if the mss option is set and matched by the range, 0 otherwis=
e */
 static inline int
 mssoption_match(u_int16_t min, u_int16_t max,
@@ -117,4 +121,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_tos.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_tos.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_tos.c	2003-08-23 02:00=
:59.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_tos.c	2003-08-24 00:5=
8:45.000000000 +0200
@@ -5,6 +5,9 @@
 #include <linux/netfilter_ipv4/ipt_tos.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("iptables TOS match module");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -50,4 +53,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ttl.c linux-2.6.=
0-test4-cosmetic/net/ipv4/netfilter/ipt_ttl.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_ttl.c	2003-08-23 02:02=
:52.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/ipt_ttl.c	2003-08-24 00:5=
9:03.000000000 +0200

diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/iptable_filter.c lin=
ux-2.6.0-test4-cosmetic/net/ipv4/netfilter/iptable_filter.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/iptable_filter.c	2003-08-2=
3 01:54:23.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/iptable_filter.c	2003-08-=
24 00:59:43.000000000 +0200
@@ -6,6 +6,10 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables filter table");
+
 #define FILTER_VALID_HOOKS ((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |=
 (1 << NF_IP_LOCAL_OUT))
=20
 /* Standard entry. */
@@ -200,4 +204,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv4/netfilter/iptable_mangle.c lin=
ux-2.6.0-test4-cosmetic/net/ipv4/netfilter/iptable_mangle.c
--- linux-2.6.0-test4-unclean/net/ipv4/netfilter/iptable_mangle.c	2003-08-2=
3 01:59:04.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv4/netfilter/iptable_mangle.c	2003-08-=
24 01:00:36.000000000 +0200
@@ -14,6 +14,10 @@
 #include <net/route.h>
 #include <linux/ip.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables mangle table");
+
 #define MANGLE_VALID_HOOKS ((1 << NF_IP_PRE_ROUTING) | \
 			    (1 << NF_IP_LOCAL_IN) | \
 			    (1 << NF_IP_FORWARD) | \
@@ -267,4 +271,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6_tables.c linux-2=
=2E6.0-test4-cosmetic/net/ipv6/netfilter/ip6_tables.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6_tables.c	2003-08-23 01=
:59:32.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6_tables.c	2003-08-24 0=
0:26:42.000000000 +0200
@@ -26,6 +26,10 @@
=20
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("IPv6 packet filter");
+
 #define IPV6_HDR_LEN	(sizeof(struct ipv6hdr))
 #define IPV6_OPTHDR_LEN	(sizeof(struct ipv6_opt_hdr))
=20
@@ -1923,4 +1927,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_MARK.c linux-2.=
6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_MARK.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_MARK.c	2003-08-23 01:=
59:47.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_MARK.c	2003-08-24 00=
:26:02.000000000 +0200
@@ -7,6 +7,9 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_MARK.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+
 static unsigned int
 target(struct sk_buff **pskb,
        unsigned int hooknum,
@@ -65,4 +68,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_eui64.c linux-2=
=2E6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_eui64.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_eui64.c	2003-08-23 01=
:50:57.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_eui64.c	2003-08-24 0=
0:27:17.000000000 +0200
@@ -6,6 +6,10 @@
=20
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_DESCRIPTION("IPv6 EUI64 address checking match");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -88,6 +92,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_DESCRIPTION("IPv6 EUI64 address checking match");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_length.c linux-=
2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_length.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_length.c	2003-08-23 0=
2:01:45.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_length.c	2003-08-24 =
00:52:40.000000000 +0200
@@ -5,6 +5,10 @@
 #include <linux/netfilter_ipv6/ip6t_length.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
+MODULE_DESCRIPTION("IPv6 packet length match");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_limit.c linux-2=
=2E6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_limit.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_limit.c	2003-08-23 01=
:53:14.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_limit.c	2003-08-24 0=
0:28:24.000000000 +0200
@@ -15,6 +15,10 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_limit.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
+MODULE_DESCRIPTION("rate limiting within ip6tables");
+
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
  * see net/sched/sch_tbf.c in the linux source tree
  */
@@ -136,4 +140,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_mac.c linux-2.6=
=2E0-test4-cosmetic/net/ipv6/netfilter/ip6t_mac.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_mac.c	2003-08-23 01:5=
9:41.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_mac.c	2003-08-24 00:=
28:53.000000000 +0200
@@ -6,6 +6,10 @@
 #include <linux/netfilter_ipv6/ip6t_mac.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MAC address matching module for IPv6");
+MODULE_AUTHOR("Netfilter Core Teaam <coreteam@netfilter.org>");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -66,5 +70,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("MAC address matching module for IPv6");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_mark.c linux-2.=
6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_mark.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_mark.c	2003-08-23 02:=
03:24.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_mark.c	2003-08-24 00=
:29:33.000000000 +0200
@@ -5,6 +5,10 @@
 #include <linux/netfilter_ipv6/ip6t_mark.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("ip6tables mark match");
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -52,4 +56,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_multiport.c lin=
ux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_multiport.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6t_multiport.c	2003-08-2=
3 02:02:33.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6t_multiport.c	2003-08-=
24 00:30:20.000000000 +0200
@@ -9,6 +9,10 @@
 #include <linux/netfilter_ipv6/ip6t_multiport.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("ip6tables match for multiple ports");
+
 #if 0
 #define duprintf(format, args...) printk(format , ## args)
 #else
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6table_filter.c li=
nux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6table_filter.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6table_filter.c	2003-08-=
23 01:51:43.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6table_filter.c	2003-08=
-24 00:31:18.000000000 +0200
@@ -6,6 +6,10 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("ip6tables filter table");
+
 #define FILTER_VALID_HOOKS ((1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD)=
 | (1 << NF_IP6_LOCAL_OUT))
=20
 /* Standard entry. */
@@ -202,4 +206,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
diff -Nru linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6table_mangle.c li=
nux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6table_mangle.c
--- linux-2.6.0-test4-unclean/net/ipv6/netfilter/ip6table_mangle.c	2003-08-=
23 01:54:28.000000000 +0200
+++ linux-2.6.0-test4-cosmetic/net/ipv6/netfilter/ip6table_mangle.c	2003-08=
-24 00:31:49.000000000 +0200
@@ -6,6 +6,10 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("ip6tables mangle table");
+
 #define MANGLE_VALID_HOOKS ((1 << NF_IP6_PRE_ROUTING) | \
 			    (1 << NF_IP6_LOCAL_IN) | \
 			    (1 << NF_IP6_FORWARD) | \
@@ -279,4 +283,3 @@
=20
 module_init(init);
 module_exit(fini);
-MODULE_LICENSE("GPL");
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zywvytGCXzdVpkje
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SHtpXaXGVTD0i/8RAiKiAKCxFUt+3reeaQADgnThckSAUcSiSgCfTxt5
tV+dlvtXQLxk8vJvOiQFiys=
=bFWw
-----END PGP SIGNATURE-----

--zywvytGCXzdVpkje--
