From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] add nf_log handler
Date: Mon, 29 Mar 2004 12:58:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329105831.GG1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RNGrj7vazCqBHNw7"
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


--RNGrj7vazCqBHNw7
Content-Type: multipart/mixed; boundary="kswDJesP0akhmDn8"
Content-Disposition: inline


--kswDJesP0akhmDn8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is a patch adding a generic packet logging interface called
'nf_log'.  The idea is that anybody wanting to log a packet calls a
common function, which in turn dispatches that call to a 'logging
handler'.  Currently ipt_LOG and ipt_ULOG can both register as such a
handler. =20

This is neccessarry especially for the upcoming 'TRACE' target that
would allow you to trace a packet while iterating through all
netfilter/iptables modules.

Author: Jozsef Kadlecsik

Please submit,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kswDJesP0akhmDn8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nf_log.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/include/linux/netfilter.h linux-2.6.5-rc2-nflog/include/linux=
/netfilter.h
--- linux-2.6.5-rc2-nfsubmit/include/linux/netfilter.h	2004-03-11 03:55:27.=
000000000 +0100
+++ linux-2.6.5-rc2-nflog/include/linux/netfilter.h	2004-03-29 12:57:07.000=
000000 +0200
@@ -99,6 +99,24 @@
=20
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
=20
+typedef void nf_logfn(unsigned int hooknum,
+		      const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const char *prefix);
+
+/* Function to register/unregister log function. */
+int nf_log_register(int pf, nf_logfn *logfn);
+void nf_log_unregister(int pf, nf_logfn *logfn);
+
+/* Calls the registered backend logging function */
+void nf_log_packet(int pf,
+		   unsigned int hooknum,
+		   const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const char *fmt, ...);
+                  =20
 /* Activate hook; either okfn or kfree_skb called, unless a hook
    returns NF_STOLEN (in which case, it's up to the hook to deal with
    the consequences).
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/include/linux/netfilter_ipv4/ip_logging.h linux-2.6.5-rc2-nfl=
og/include/linux/netfilter_ipv4/ip_logging.h
--- linux-2.6.5-rc2-nfsubmit/include/linux/netfilter_ipv4/ip_logging.h	1970=
-01-01 01:00:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4/ip_logging.h	2004-03=
-29 12:57:07.000000000 +0200
@@ -0,0 +1,20 @@
+/* IPv4 macros for the internal logging interface. */
+#ifndef __IP_LOGGING_H
+#define __IP_LOGGING_H
+
+#ifdef __KERNEL__
+#include <linux/socket.h>
+#include <linux/netfilter_logging.h>
+
+#define nf_log_ip_packet(pskb,hooknum,in,out,fmt,args...) \
+	nf_log_packet(AF_INET,pskb,hooknum,in,out,fmt,##args)
+
+#define nf_log_ip(pfh,len,fmt,args...) \
+	nf_log(AF_INET,pfh,len,fmt,##args)
+
+#define nf_ip_log_register(logging) nf_log_register(AF_INET,logging)
+#define nf_ip_log_unregister(logging) nf_log_unregister(AF_INET,logging)
+=09
+#endif /*__KERNEL__*/
+
+#endif /*__IP_LOGGING_H*/
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/include/linux/netfilter_ipv4/ipt_ULOG.h linux-2.6.5-rc2-nflog=
/include/linux/netfilter_ipv4/ipt_ULOG.h
--- linux-2.6.5-rc2-nfsubmit/include/linux/netfilter_ipv4/ipt_ULOG.h	2004-0=
3-11 03:55:26.000000000 +0100
+++ linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4/ipt_ULOG.h	2004-03-2=
9 12:57:07.000000000 +0200
@@ -11,6 +11,9 @@
 #define NETLINK_NFLOG 	5
 #endif
=20
+#define ULOG_DEFAULT_NLGROUP	1
+#define ULOG_DEFAULT_QTHRESHOLD	1
+
 #define ULOG_MAC_LEN	80
 #define ULOG_PREFIX_LEN	32
=20
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/include/linux/netfilter_ipv6/ip6_logging.h linux-2.6.5-rc2-nf=
log/include/linux/netfilter_ipv6/ip6_logging.h
--- linux-2.6.5-rc2-nfsubmit/include/linux/netfilter_ipv6/ip6_logging.h	197=
0-01-01 01:00:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv6/ip6_logging.h	2004-0=
3-29 12:57:07.000000000 +0200
@@ -0,0 +1,20 @@
+/* IPv6 macros for the nternal logging interface. */
+#ifndef __IP6_LOGGING_H
+#define __IP6_LOGGING_H
+
+#ifdef __KERNEL__
+#include <linux/socket.h>
+#include <linux/netfilter_logging.h>
+
+#define nf_log_ip6_packet(pskb,hooknum,in,out,fmt,args...) \
+	nf_log_packet(AF_INET6,pskb,hooknum,in,out,fmt,##args)
+
+#define nf_log_ip6(pfh,len,fmt,args...) \
+	nf_log(AF_INET6,pfh,len,fmt,##args)
+
+#define nf_ip6_log_register(logging) nf_log_register(AF_INET6,logging)
+#define nf_ip6_log_unregister(logging) nf_log_unregister(AF_INET6,logging)
+=09
+#endif /*__KERNEL__*/
+
+#endif /*__IP6_LOGGING_H*/
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/include/linux/netfilter_logging.h linux-2.6.5-rc2-nflog/inclu=
de/linux/netfilter_logging.h
--- linux-2.6.5-rc2-nfsubmit/include/linux/netfilter_logging.h	1970-01-01 0=
1:00:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog/include/linux/netfilter_logging.h	2004-03-29 12:5=
7:07.000000000 +0200
@@ -0,0 +1,33 @@
+/* Internal logging interface, which relies on the real=20
+   LOG target modules */
+#ifndef __LINUX_NETFILTER_LOGGING_H
+#define __LINUX_NETFILTER_LOGGING_H
+
+#ifdef __KERNEL__
+#include <asm/atomic.h>
+
+struct nf_logging_t {
+	void (*nf_log_packet)(struct sk_buff **pskb,
+			      unsigned int hooknum,
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const char *prefix);
+	void (*nf_log)(char *pfh, size_t len,
+		       const char *prefix);
+};
+
+extern void nf_log_register(int pf, const struct nf_logging_t *logging);
+extern void nf_log_unregister(int pf, const struct nf_logging_t *logging);
+
+extern void nf_log_packet(int pf,
+			  struct sk_buff **pskb,
+			  unsigned int hooknum,
+			  const struct net_device *in,
+			  const struct net_device *out,
+			  const char *fmt, ...);
+extern void nf_log(int pf,
+		   char *pfh, size_t len,
+		   const char *fmt, ...);
+#endif /*__KERNEL__*/
+
+#endif /*__LINUX_NETFILTER_LOGGING_H*/
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/net/core/netfilter.c linux-2.6.5-rc2-nflog/net/core/netfilter=
=2Ec
--- linux-2.6.5-rc2-nfsubmit/net/core/netfilter.c	2004-03-11 03:55:27.00000=
0000 +0100
+++ linux-2.6.5-rc2-nflog/net/core/netfilter.c	2004-03-29 12:57:07.00000000=
0 +0200
@@ -8,8 +8,10 @@
  *
  * February 2000: Modified by James Morris to have 1 queue per protocol.
  * 15-Mar-2000:   Added NF_REPEAT --RR.
+ * 08-May-2003:	  Internal logging interface added by Jozsef Kadlecsik.
  */
 #include <linux/config.h>
+#include <linux/kernel.h>
 #include <linux/netfilter.h>
 #include <net/protocol.h>
 #include <linux/init.h>
@@ -741,6 +743,72 @@
 EXPORT_SYMBOL(skb_ip_make_writable);
 #endif /*CONFIG_INET*/
=20
+/* Internal logging interface, which relies on the real=20
+   LOG target modules */
+
+#define NF_LOG_PREFIXLEN		128
+
+static nf_logfn *nf_logging[NPROTO]; /* =3D NULL */
+static int reported =3D 0;
+static spinlock_t nf_log_lock =3D SPIN_LOCK_UNLOCKED;
+
+int nf_log_register(int pf, nf_logfn *logfn)
+{
+	int ret =3D -EBUSY;
+
+	/* Any setup of logging members must be done before
+	 * substituting pointer. */
+	smp_wmb();
+	spin_lock(&nf_log_lock);
+	if (!nf_logging[pf]) {
+		nf_logging[pf] =3D logfn;
+		ret =3D 0;
+	}
+	spin_unlock(&nf_log_lock);
+	return ret;
+}	=09
+
+void nf_log_unregister(int pf, nf_logfn *logfn)
+{
+	spin_lock(&nf_log_lock);
+	if (nf_logging[pf] =3D=3D logfn)
+		nf_logging[pf] =3D NULL;
+	spin_unlock(&nf_log_lock);
+
+	/* Give time to concurrent readers. */
+	synchronize_net();
+}	=09
+
+void nf_log_packet(int pf,
+		   unsigned int hooknum,
+		   const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const char *fmt, ...)
+{
+	va_list args;
+	char prefix[NF_LOG_PREFIXLEN];
+	nf_logfn *logfn;
+=09
+	rcu_read_lock();
+	logfn =3D nf_logging[pf];
+	if (logfn) {
+		va_start(args, fmt);
+		vsnprintf(prefix, sizeof(prefix), fmt, args);
+		va_end(args);
+		/* We must read logging before nf_logfn[pf] */
+		smp_read_barrier_depends();
+		logfn(hooknum, skb, in, out, prefix);
+	} else if (!reported) {
+		printk(KERN_WARNING "nf_log_packet: can\'t log yet, "
+		       "no backend logging module loaded in!\n");
+		reported++;
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nf_log_register);
+EXPORT_SYMBOL(nf_log_unregister);
+EXPORT_SYMBOL(nf_log_packet);
=20
 /* This does not belong here, but ipt_REJECT needs it if connection
    tracking in use: without this, connection may not be in hash table,
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/net/ipv4/netfilter/ipt_LOG.c linux-2.6.5-rc2-nflog/net/ipv4/n=
etfilter/ipt_LOG.c
--- linux-2.6.5-rc2-nfsubmit/net/ipv4/netfilter/ipt_LOG.c	2004-03-11 03:55:=
44.000000000 +0100
+++ linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ipt_LOG.c	2004-03-29 12:57:07.=
000000000 +0200
@@ -19,6 +19,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
=20
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
=20
@@ -26,6 +27,10 @@
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("iptables syslog logging module");
=20
+static unsigned int nflog =3D 1;
+MODULE_PARM(nflog, "i");
+MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
+=20
 #if 0
 #define DEBUGP printk
 #else
@@ -324,28 +329,25 @@
 	/* maxlen =3D 230+   91  + 230 + 252 =3D 803 */
 }
=20
-static unsigned int
-ipt_log_target(struct sk_buff **pskb,
+static void
+ipt_log_packet(unsigned int hooknum,
+	       const struct sk_buff *skb,
 	       const struct net_device *in,
 	       const struct net_device *out,
-	       unsigned int hooknum,
-	       const void *targinfo,
-	       void *userinfo)
+	       const struct ipt_log_info *loginfo,
+	       const char *level_string,
+	       const char *prefix)
 {
-	const struct ipt_log_info *loginfo =3D targinfo;
-	char level_string[4] =3D "< >";
-
-	level_string[1] =3D '0' + (loginfo->level % 8);
 	spin_lock_bh(&log_lock);
 	printk(level_string);
 	printk("%sIN=3D%s OUT=3D%s ",
-	       loginfo->prefix,
+	       prefix =3D=3D NULL ? loginfo->prefix : prefix,
 	       in ? in->name : "",
 	       out ? out->name : "");
 #ifdef CONFIG_BRIDGE_NETFILTER
-	if ((*pskb)->nf_bridge) {
-		struct net_device *physindev =3D (*pskb)->nf_bridge->physindev;
-		struct net_device *physoutdev =3D (*pskb)->nf_bridge->physoutdev;
+	if (skb->nf_bridge) {
+		struct net_device *physindev =3D skb->nf_bridge->physindev;
+		struct net_device *physoutdev =3D skb->nf_bridge->physoutdev;
=20
 		if (physindev && in !=3D physindev)
 			printk("PHYSIN=3D%s ", physindev->name);
@@ -357,25 +359,56 @@
 	if (in && !out) {
 		/* MAC logging for input chain only. */
 		printk("MAC=3D");
-		if ((*pskb)->dev && (*pskb)->dev->hard_header_len
-		    && (*pskb)->mac.raw !=3D (void*)(*pskb)->nh.iph) {
+		if (skb->dev && skb->dev->hard_header_len
+		    && skb->mac.raw !=3D (void*)skb->nh.iph) {
 			int i;
-			unsigned char *p =3D (*pskb)->mac.raw;
-			for (i =3D 0; i < (*pskb)->dev->hard_header_len; i++,p++)
+			unsigned char *p =3D skb->mac.raw;
+			for (i =3D 0; i < skb->dev->hard_header_len; i++,p++)
 				printk("%02x%c", *p,
-				       i=3D=3D(*pskb)->dev->hard_header_len - 1
+				       i=3D=3Dskb->dev->hard_header_len - 1
 				       ? ' ':':');
 		} else
 			printk(" ");
 	}
=20
-	dump_packet(loginfo, *pskb, 0);
+	dump_packet(loginfo, skb, 0);
 	printk("\n");
 	spin_unlock_bh(&log_lock);
+}
+
+static unsigned int
+ipt_log_target(struct sk_buff **pskb,
+	       const struct net_device *in,
+	       const struct net_device *out,
+	       unsigned int hooknum,
+	       const void *targinfo,
+	       void *userinfo)
+{
+	const struct ipt_log_info *loginfo =3D targinfo;
+	char level_string[4] =3D "< >";
+
+	level_string[1] =3D '0' + (loginfo->level % 8);
+	ipt_log_packet(hooknum, *pskb, in, out, loginfo, level_string, NULL);
=20
 	return IPT_CONTINUE;
 }
=20
+static void
+ipt_logfn(unsigned int hooknum,
+	  const struct sk_buff *skb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  const char *prefix)
+{
+	struct ipt_log_info loginfo =3D {=20
+		.level =3D 0,=20
+		.logflags =3D IPT_LOG_MASK,=20
+		.prefix =3D ""=20
+	};
+
+	ipt_log_packet(hooknum, skb, in, out, &loginfo, KERN_WARNING, prefix);
+}
+
 static int ipt_log_checkentry(const char *tablename,
 			      const struct ipt_entry *e,
 			      void *targinfo,
@@ -413,11 +446,18 @@
=20
 static int __init init(void)
 {
-	return ipt_register_target(&ipt_log_reg);
+	if (ipt_register_target(&ipt_log_reg))
+		return -EINVAL;
+	if (nflog)
+		nf_log_register(PF_INET, &ipt_logfn);
+=09
+	return 0;
 }
=20
 static void __exit fini(void)
 {
+	if (nflog)
+		nf_log_unregister(PF_INET, &ipt_logfn);
 	ipt_unregister_target(&ipt_log_reg);
 }
=20
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/net/ipv4/netfilter/ipt_ULOG.c linux-2.6.5-rc2-nflog/net/ipv4/=
netfilter/ipt_ULOG.c
--- linux-2.6.5-rc2-nfsubmit/net/ipv4/netfilter/ipt_ULOG.c	2004-03-11 03:55=
:25.000000000 +0100
+++ linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ipt_ULOG.c	2004-03-29 12:57:07=
=2E000000000 +0200
@@ -50,6 +50,7 @@
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
 #include <linux/mm.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
@@ -80,6 +81,10 @@
 MODULE_PARM(flushtimeout, "i");
 MODULE_PARM_DESC(flushtimeout, "buffer flush timeout");
=20
+static unsigned int nflog =3D 1;
+MODULE_PARM(nflog, "i");
+MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
+
 /* global data structures */
=20
 typedef struct {
@@ -157,17 +162,17 @@
 	return skb;
 }
=20
-static unsigned int ipt_ulog_target(struct sk_buff **pskb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const void *targinfo, void *userinfo)
+static void ipt_ulog_packet(unsigned int hooknum,
+			    const struct sk_buff *skb,
+			    const struct net_device *in,
+			    const struct net_device *out,
+			    const struct ipt_ulog_info *loginfo,
+			    const char *prefix)
 {
 	ulog_buff_t *ub;
 	ulog_packet_msg_t *pm;
 	size_t size, copy_len;
 	struct nlmsghdr *nlh;
-	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) targinfo;
=20
 	/* ffs =3D=3D find first bit set, necessary because userspace
 	 * is already shifting groupnumber, but we need unshifted.
@@ -176,8 +181,8 @@
=20
 	/* calculate the size of the skb needed */
 	if ((loginfo->copy_range =3D=3D 0) ||
-	    (loginfo->copy_range > (*pskb)->len)) {
-		copy_len =3D (*pskb)->len;
+	    (loginfo->copy_range > skb->len)) {
+		copy_len =3D skb->len;
 	} else {
 		copy_len =3D loginfo->copy_range;
 	}
@@ -214,19 +219,21 @@
=20
 	/* copy hook, prefix, timestamp, payload, etc. */
 	pm->data_len =3D copy_len;
-	pm->timestamp_sec =3D (*pskb)->stamp.tv_sec;
-	pm->timestamp_usec =3D (*pskb)->stamp.tv_usec;
-	pm->mark =3D (*pskb)->nfmark;
+	pm->timestamp_sec =3D skb->stamp.tv_sec;
+	pm->timestamp_usec =3D skb->stamp.tv_usec;
+	pm->mark =3D skb->nfmark;
 	pm->hook =3D hooknum;
-	if (loginfo->prefix[0] !=3D '\0')
+	if (prefix !=3D NULL)
+		strncpy(pm->prefix, prefix, sizeof(pm->prefix));
+	else if (loginfo->prefix[0] !=3D '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
 	else
 		*(pm->prefix) =3D '\0';
=20
 	if (in && in->hard_header_len > 0
-	    && (*pskb)->mac.raw !=3D (void *) (*pskb)->nh.iph
+	    && skb->mac.raw !=3D (void *) skb->nh.iph
 	    && in->hard_header_len <=3D ULOG_MAC_LEN) {
-		memcpy(pm->mac, (*pskb)->mac.raw, in->hard_header_len);
+		memcpy(pm->mac, skb->mac.raw, in->hard_header_len);
 		pm->mac_len =3D in->hard_header_len;
 	} else
 		pm->mac_len =3D 0;
@@ -241,8 +248,8 @@
 	else
 		pm->outdev_name[0] =3D '\0';
=20
-	/* copy_len <=3D (*pskb)->len, so can't fail. */
-	if (skb_copy_bits(*pskb, 0, pm->payload, copy_len) < 0)
+	/* copy_len <=3D skb->len, so can't fail. */
+	if (skb_copy_bits(skb, 0, pm->payload, copy_len) < 0)
 		BUG();
 =09
 	/* check if we are building multi-part messages */
@@ -266,8 +273,7 @@
=20
 	UNLOCK_BH(&ulog_lock);
=20
-	return IPT_CONTINUE;
-
+	return;
=20
 nlmsg_failure:
 	PRINTR("ipt_ULOG: error during NLMSG_PUT\n");
@@ -276,8 +282,35 @@
 	PRINTR("ipt_ULOG: Error building netlink message\n");
=20
 	UNLOCK_BH(&ulog_lock);
+}
+
+static unsigned int ipt_ulog_target(struct sk_buff **pskb,
+				    const struct net_device *in,
+				    const struct net_device *out,
+				    unsigned int hooknum,
+				    const void *targinfo, void *userinfo)
+{
+	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) targinfo;
=20
-	return IPT_CONTINUE;
+	ipt_ulog_packet(hooknum, *pskb, in, out, loginfo, NULL);
+=20
+ 	return IPT_CONTINUE;
+}
+=20
+static void ipt_logfn(unsigned int hooknum,
+		      const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const char *prefix)
+{
+	struct ipt_ulog_info loginfo =3D {=20
+		.nl_group =3D ULOG_DEFAULT_NLGROUP,
+		.copy_range =3D 0,
+		.qthreshold =3D ULOG_DEFAULT_QTHRESHOLD,
+		.prefix =3D ""
+	};
+
+	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
=20
 static int ipt_ulog_checkentry(const char *tablename,
@@ -341,7 +374,9 @@
 		sock_release(nflognl->sk_socket);
 		return -EINVAL;
 	}
-
+	if (nflog)
+		nf_log_register(PF_INET, &ipt_logfn);
+=09
 	return 0;
 }
=20
@@ -352,6 +387,8 @@
=20
 	DEBUGP("ipt_ULOG: cleanup_module\n");
=20
+	if (nflog)
+		nf_log_unregister(PF_INET, &ipt_logfn);
 	ipt_unregister_target(&ipt_ulog_reg);
 	sock_release(nflognl->sk_socket);
=20
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nfsubmit/net/ipv6/netfilter/ip6t_LOG.c linux-2.6.5-rc2-nflog/net/ipv6/=
netfilter/ip6t_LOG.c
--- linux-2.6.5-rc2-nfsubmit/net/ipv6/netfilter/ip6t_LOG.c	2004-03-11 03:55=
:24.000000000 +0100
+++ linux-2.6.5-rc2-nflog/net/ipv6/netfilter/ip6t_LOG.c	2004-03-29 12:57:07=
=2E000000000 +0200
@@ -18,12 +18,17 @@
 #include <net/udp.h>
 #include <net/tcp.h>
 #include <net/ipv6.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
 MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_DESCRIPTION("IP6 tables LOG target module");
 MODULE_LICENSE("GPL");
=20
+static unsigned int nflog =3D 1;
+MODULE_PARM(nflog, "i");
+MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
+=20
 struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
@@ -265,40 +270,38 @@
 	}
 }
=20
-static unsigned int
-ip6t_log_target(struct sk_buff **pskb,
-		unsigned int hooknum,
+static void
+ip6t_log_packet(unsigned int hooknum,
+		const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
-		const void *targinfo,
-		void *userinfo)
+		const struct ip6t_log_info *loginfo,
+		const char *level_string,
+		const char *prefix)
 {
-	struct ipv6hdr *ipv6h =3D (*pskb)->nh.ipv6h;
-	const struct ip6t_log_info *loginfo =3D targinfo;
-	char level_string[4] =3D "< >";
+	struct ipv6hdr *ipv6h =3D skb->nh.ipv6h;
=20
-	level_string[1] =3D '0' + (loginfo->level % 8);
 	spin_lock_bh(&log_lock);
 	printk(level_string);
 	printk("%sIN=3D%s OUT=3D%s ",
-		loginfo->prefix,
+		prefix =3D=3D NULL ? loginfo->prefix : prefix,
 		in ? in->name : "",
 		out ? out->name : "");
 	if (in && !out) {
 		/* MAC logging for input chain only. */
 		printk("MAC=3D");
-		if ((*pskb)->dev && (*pskb)->dev->hard_header_len && (*pskb)->mac.raw !=
=3D (void*)ipv6h) {
-			if ((*pskb)->dev->type !=3D ARPHRD_SIT){
+		if (skb->dev && skb->dev->hard_header_len && skb->mac.raw !=3D (void*)ip=
v6h) {
+			if (skb->dev->type !=3D ARPHRD_SIT){
 			  int i;
-			  unsigned char *p =3D (*pskb)->mac.raw;
-			  for (i =3D 0; i < (*pskb)->dev->hard_header_len; i++,p++)
+			  unsigned char *p =3D skb->mac.raw;
+			  for (i =3D 0; i < skb->dev->hard_header_len; i++,p++)
 				printk("%02x%c", *p,
-			       		i=3D=3D(*pskb)->dev->hard_header_len - 1
+			       		i=3D=3Dskb->dev->hard_header_len - 1
 			       		? ' ':':');
 			} else {
 			  int i;
-			  unsigned char *p =3D (*pskb)->mac.raw;
-			  if ( p - (ETH_ALEN*2+2) > (*pskb)->head ){
+			  unsigned char *p =3D skb->mac.raw;
+			  if ( p - (ETH_ALEN*2+2) > skb->head ){
 			    p -=3D (ETH_ALEN+2);
 			    for (i =3D 0; i < (ETH_ALEN); i++,p++)
 				printk("%02x%s", *p,
@@ -309,10 +312,10 @@
 					i =3D=3D ETH_ALEN-1 ? ' ' : ':');
 			  }
 			 =20
-			  if (((*pskb)->dev->addr_len =3D=3D 4) &&
-			      (*pskb)->dev->hard_header_len > 20){
+			  if ((skb->dev->addr_len =3D=3D 4) &&
+			      skb->dev->hard_header_len > 20){
 			    printk("TUNNEL=3D");
-			    p =3D (*pskb)->mac.raw + 12;
+			    p =3D skb->mac.raw + 12;
 			    for (i =3D 0; i < 4; i++,p++)
 				printk("%3d%s", *p,
 					i =3D=3D 3 ? "->" : ".");
@@ -328,10 +331,41 @@
 	dump_packet(loginfo, ipv6h, 1);
 	printk("\n");
 	spin_unlock_bh(&log_lock);
+}
+
+static unsigned int
+ip6t_log_target(struct sk_buff **pskb,
+		unsigned int hooknum,
+		const struct net_device *in,
+		const struct net_device *out,
+		const void *targinfo,
+		void *userinfo)
+{
+	const struct ip6t_log_info *loginfo =3D targinfo;
+	char level_string[4] =3D "< >";
+
+	level_string[1] =3D '0' + (loginfo->level % 8);
+	ip6t_log_packet(hooknum, *pskb, in, out, loginfo, level_string, NULL);
=20
 	return IP6T_CONTINUE;
 }
=20
+static void
+ip6t_logfn(unsigned int hooknum,
+	   const struct sk_buff *skb,
+	   const struct net_device *in,
+	   const struct net_device *out,
+	   const char *prefix)
+{
+	struct ip6t_log_info loginfo =3D {
+		.level =3D 0,
+		.logflags =3D IP6T_LOG_MASK,
+		.prefix =3D ""
+	};
+
+	ip6t_log_packet(hooknum, skb, in, out, &loginfo, KERN_WARNING, prefix);
+}
+
 static int ip6t_log_checkentry(const char *tablename,
 			       const struct ip6t_entry *e,
 			       void *targinfo,
@@ -360,20 +394,27 @@
 	return 1;
 }
=20
-static struct ip6t_target ip6t_log_reg
-=3D { { NULL, NULL }, "LOG", ip6t_log_target, ip6t_log_checkentry, NULL,=
=20
-    THIS_MODULE };
+static struct ip6t_target ip6t_log_reg =3D {
+	.name 		=3D "LOG",
+	.target 	=3D ip6t_log_target,=20
+	.checkentry	=3D ip6t_log_checkentry,=20
+	.me 		=3D THIS_MODULE,
+};
=20
 static int __init init(void)
 {
 	if (ip6t_register_target(&ip6t_log_reg))
 		return -EINVAL;
+	if (nflog)
+		nf_log_register(PF_INET6, &ip6t_logfn);
=20
 	return 0;
 }
=20
 static void __exit fini(void)
 {
+	if (nflog)
+		nf_log_unregister(PF_INET6, &ip6t_logfn);
 	ip6t_unregister_target(&ip6t_log_reg);
 }
=20

--kswDJesP0akhmDn8--

--RNGrj7vazCqBHNw7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAaAFXXaXGVTD0i/8RAvixAJ48xziQP0zpxnV8mzJc7Zprq8rngwCeMqp3
QR42M5LJL8zOkxH2NyrSql0=
=SlTj
-----END PGP SIGNATURE-----

--RNGrj7vazCqBHNw7--
