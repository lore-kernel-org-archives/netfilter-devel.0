From: Paul P Komkoff Jr <i@stingr.net>
Subject: [CRAP] Some patches
Date: Mon, 17 Jun 2002 00:02:39 +0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020616200239.GI23720@stingr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is the result of make allyesconfig

Actually, make allyesconfig won't link vmlinux due to netfilter p-o-m
additions. While conntrack_egg part isn't very clean (I'll resend
cleaner version later), and conntrack_rpc bombing out the kernel to panic,
and needs a big rewrite just because _tcp and _udp files ARE just a
copy&paste results (Harald, so please move it to b0rken suite for now).

But ipv6 stuff seems awful :( it just duplicating one function already
present in ipv6 code :( and doing it without static keyword ...

diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ip_conntrack_egg.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_egg.c
--- a/net/ipv4/netfilter/ip_conntrack_egg.c	Sat Jun 15 12:51:09 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_egg.c	Fri Jun 14 12:37:50 2002
@@ -175,7 +175,14 @@
 static struct ip_conntrack_helper egg_helpers[MAX_PORTS];
 static char egg_names[MAX_PORTS][14]; /* eggdrop-65535 */
 
-static void __exit fini(void);
+static void deregister_helpers(void) {
+	int i;
+
+	for (i = 0; i < ports_c; i++) {
+		DEBUGP("unregistering helper for port %d\n", ports[i]);
+		ip_conntrack_helper_unregister(&egg_helpers[i]);
+	}
+}
 
 static int __init init(void)
 {
@@ -213,7 +220,7 @@
 		if (ret) {
 			printk("ip_conntrack_egg: ERROR registering helper "
 				"for port %d\n", ports[i]);
-			fini();
+			deregister_helpers();
 			return 1;
 		}
 		ports_c++;
@@ -223,11 +230,7 @@
 
 static void __exit fini(void)
 {
-	int i;
-	for (i = 0; i < ports_c; i++) {
-		DEBUGP("unregistering helper for port %d\n", ports[i]);
-		ip_conntrack_helper_unregister(&egg_helpers[i]);
-	}
+	deregister_helpers();
 }
 
 module_init(init);
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	Sat Jun 15 12:50:55 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	Fri Jun 14 16:43:33 2002
@@ -325,13 +325,13 @@
 					 { 0, { 0 }, 0xFFFF } },
 				       help };
 
-int init_module(void)
+static int __init init_m(void)
 {
 	printk("ip_conntrack_rpc_tcp.o\n");
 	return ip_conntrack_helper_register(&rpc_tcp);
 }
 
-void cleanup_module(void)
+static void __exit cleanup_m(void)
 {
 	clean_expect(&expect_rpc_list_tcp);
 	clean_request(&request_p_list_tcp);
@@ -342,3 +342,6 @@
 EXPORT_SYMBOL(expect_rpc_list_tcp);
 EXPORT_SYMBOL(ip_conntrack_rpc_tcp);
 EXPORT_SYMBOL(ipct_rpc_tcp_lock);
+
+module_init(init_m);
+module_exit(cleanup_m);
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ip_conntrack_rpc_udp.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_rpc_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	Sat Jun 15 12:49:52 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	Fri Jun 14 16:44:45 2002
@@ -318,13 +318,13 @@
 					 { 0, { 0 }, 0xFFFF } },
 				       help };
 
-int init_module(void)
+static int __init init_m(void)
 {
 	printk("ip_conntrack_rpc_udp.o\n");
 	return ip_conntrack_helper_register(&rpc_udp);
 }
 
-void cleanup_module(void)
+static void __init cleanup_m(void)
 {
 	clean_expect(&expect_rpc_list_udp);
 	clean_request(&request_p_list_udp);
@@ -335,3 +335,6 @@
 EXPORT_SYMBOL(expect_rpc_list_udp);
 EXPORT_SYMBOL(ip_conntrack_rpc_udp);
 EXPORT_SYMBOL(ipct_rpc_udp_lock);
+
+module_init(init_m);
+module_exit(cleanup_m);
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ipt_ah.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_ah.c
--- a/net/ipv4/netfilter/ipt_ah.c	Sat Jun 15 12:51:20 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_ah.c	Fri Jun 14 12:31:05 2002
@@ -91,12 +91,12 @@
 static struct ipt_match ah_match
 = { { NULL, NULL }, "ah", &match, &checkentry, NULL, THIS_MODULE };
 
-int __init init(void)
+static int __init init(void)
 {
 	return ipt_register_match(&ah_match);
 }
 
-void __exit cleanup(void)
+static void __exit cleanup(void)
 {
 	ipt_unregister_match(&ah_match);
 }
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ipt_record_rpc.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_record_rpc.c
--- a/net/ipv4/netfilter/ipt_record_rpc.c	Sat Jun 15 12:51:13 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_record_rpc.c	Fri Jun 14 12:31:23 2002
@@ -149,7 +149,7 @@
 static struct ipt_match record_rpc_match
 = { { NULL, NULL }, "record_rpc", &match, NULL, NULL, THIS_MODULE };
 
-int __init init(void)
+static int __init init(void)
 {
 	__MOD_INC_USE_COUNT(ip_conntrack_module);
 	__MOD_INC_USE_COUNT(ip_conntrack_rpc_udp);
@@ -157,7 +157,7 @@
 	return ipt_register_match(&record_rpc_match);
 }
 
-void __exit cleanup(void)
+static void __exit cleanup(void)
 {
 	ipt_unregister_match(&record_rpc_match);
 	__MOD_DEC_USE_COUNT(ip_conntrack_module);
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/Makefile.in linux-2.4.19-pre10-ac2-s3/net/ipv6/Makefile.in
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/exthdrs.c linux-2.4.19-pre10-ac2-s3/net/ipv6/exthdrs.c
--- a/net/ipv6/exthdrs.c	Sat Jun 15 12:49:53 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/exthdrs.c	Fri Jun 14 20:03:51 2002
@@ -20,6 +20,8 @@
  *				  tlv options.
  */
 
+#include <linux/config.h>
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/socket.h>
@@ -729,6 +731,8 @@
 		 (nexthdr == NEXTHDR_NONE)	||
 		 (nexthdr == NEXTHDR_DEST) );
 }
+
+EXPORT_SYMBOL(ipv6_ext_hdr);
 
 /*
  * Skip any extension headers. This is used by the ICMP module.
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_ah.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c	Sat Jun 15 12:50:14 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_ah.c	Fri Jun 14 17:38:44 2002
@@ -27,16 +27,7 @@
        __u32   spi;
 };
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline int
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_dst.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_dst.c
--- a/net/ipv6/netfilter/ip6t_dst.c	Sat Jun 15 12:50:36 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_dst.c	Fri Jun 14 17:36:37 2002
@@ -30,16 +30,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /*
  * (Type & 0xC0) >> 6
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_esp.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c	Sat Jun 15 12:49:53 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_esp.c	Fri Jun 14 17:38:26 2002
@@ -24,16 +24,7 @@
 	__u32   spi;
 };
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline int
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_frag.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_frag.c
--- a/net/ipv6/netfilter/ip6t_frag.c	Sat Jun 15 12:51:12 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_frag.c	Fri Jun 14 17:37:45 2002
@@ -45,16 +45,7 @@
        __u32   id;
 };
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline int
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_hbh.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_hbh.c
--- a/net/ipv6/netfilter/ip6t_hbh.c	Sat Jun 15 12:49:54 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_hbh.c	Fri Jun 14 17:36:11 2002
@@ -30,16 +30,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /*
  * (Type & 0xC0) >> 6
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_ipv6header.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_ipv6header.c
--- a/net/ipv6/netfilter/ip6t_ipv6header.c	Sat Jun 15 12:51:26 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_ipv6header.c	Fri Jun 14 17:37:15 2002
@@ -25,16 +25,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 static int
 ipv6header_match(const struct sk_buff *skb,
diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/netfilter/ip6t_rt.c linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c	Sat Jun 15 12:51:03 2002
+++ linux-2.4.19-pre10-ac2-s3/net/ipv6/netfilter/ip6t_rt.c	Fri Jun 14 17:35:36 2002
@@ -22,16 +22,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-int ipv6_ext_hdr(u8 nexthdr)
-{
-        return ( (nexthdr == NEXTHDR_HOP)       ||
-                 (nexthdr == NEXTHDR_ROUTING)   ||
-                 (nexthdr == NEXTHDR_FRAGMENT)  ||
-                 (nexthdr == NEXTHDR_AUTH)      ||
-                 (nexthdr == NEXTHDR_ESP)       ||
-                 (nexthdr == NEXTHDR_NONE)      ||
-                 (nexthdr == NEXTHDR_DEST) );
-}
+extern int ipv6_ext_hdr(u8 nexthdr);
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline int


-- 
Paul P 'Stingray' Komkoff 'Greatest' Jr /// (icq)23200764 /// (http)stingr.net
  When you're invisible, the only one really watching you is you (my keychain)
