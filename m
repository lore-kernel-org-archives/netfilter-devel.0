From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RESEND][PATCH] IPv6 port of the quota match.
Date: Thu, 7 Aug 2003 16:17:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0308071617220.16724@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Date: Mon, 30 Jun 2003 18:54:55 +0200 (CEST)
From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
To: netfilter-devel@lists.netfilter.org
Subject: [PATCH] IPv6 port of the quota match.

Hello,

this patch is an IPv6 port of the quota match.

 patch-o-matic/base/quota.patch.ipv6                |  263 +++++++++++++++++++++
 patch-o-matic/base/quota.patch.ipv6.config.in      |    2
 patch-o-matic/base/quota.patch.ipv6.configure.help |    8
 patch-o-matic/base/quota.patch.ipv6.help           |   12
 patch-o-matic/base/quota.patch.ipv6.makefile       |    2
 userspace/extensions/.quota-test6                  |    3
 userspace/extensions/libip6t_quota.c               |  116 +++++++++
 7 files changed, 406 insertions(+)

Regards,
Maciej

Here goes:

diff -Nru netfilter.orig/patch-o-matic/base/quota.patch.ipv6 netfilter/patch-o-matic/base/quota.patch.ipv6
--- netfilter.orig/patch-o-matic/base/quota.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/quota.patch.ipv6	2003-06-28 13:34:37.000000000 +0200
@@ -0,0 +1,263 @@
+diff -Nru linux-2.4.21.orig/include/linux/netfilter_ipv6/ip6t_quota.h linux-2.4.21/include/linux/netfilter_ipv6/ip6t_quota.h
+--- linux-2.4.21.orig/include/linux/netfilter_ipv6/ip6t_quota.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/include/linux/netfilter_ipv6/ip6t_quota.h	2003-06-28 13:25:10.000000000 +0200
+@@ -0,0 +1,11 @@
++#ifndef _IP6T_QUOTA_H
++#define _IP6T_QUOTA_H
++
++/* print debug info in both kernel/netfilter module & iptable library */
++/* #define DEBUG_IP6T_QUOTA */
++
++struct ip6t_quota_info {
++        u_int64_t quota;
++};
++
++#endif /*_IP6T_QUOTA_H */
+diff -Nru linux-2.4.21.orig/net/ipv6/netfilter/Config.in linux-2.4.21/net/ipv6/netfilter/Config.in
+--- linux-2.4.21.orig/net/ipv6/netfilter/Config.in	2003-06-28 13:24:11.000000000 +0200
++++ linux-2.4.21/net/ipv6/netfilter/Config.in	2003-06-28 13:28:03.000000000 +0200
+@@ -17,6 +17,7 @@
+ if [ "$CONFIG_IP6_NF_IPTABLES" != "n" ]; then
+ # The simple matches.
+   dep_tristate '  limit match support' CONFIG_IP6_NF_MATCH_LIMIT $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  quota match support' CONFIG_IP6_NF_MATCH_QUOTA $CONFIG_IP6_NF_IPTABLES
+   dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+   dep_tristate '  Random match support' CONFIG_IP6_NF_MATCH_RANDOM $CONFIG_IP6_NF_IPTABLES
+   dep_tristate '  Nth match support' CONFIG_IP6_NF_MATCH_NTH $CONFIG_IP6_NF_IPTABLES
+diff -Nru linux-2.4.21.orig/net/ipv6/netfilter/Config.in~ linux-2.4.21/net/ipv6/netfilter/Config.in~
+--- linux-2.4.21.orig/net/ipv6/netfilter/Config.in~	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/net/ipv6/netfilter/Config.in~	2003-06-28 13:20:06.000000000 +0200
+@@ -0,0 +1,89 @@
++#
++# IP netfilter configuration
++#
++mainmenu_option next_comment
++comment '  IPv6: Netfilter Configuration'
++
++#tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP6_NF_CONNTRACK
++#if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
++#  dep_tristate '  FTP protocol support' CONFIG_IP6_NF_FTP $CONFIG_IP6_NF_CONNTRACK
++#fi
++
++if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++  tristate 'Userspace queueing via NETLINK (EXPERIMENTAL)' CONFIG_IP6_NF_QUEUE
++fi
++
++tristate 'IP6 tables support (required for filtering/masq/NAT)' CONFIG_IP6_NF_IPTABLES
++if [ "$CONFIG_IP6_NF_IPTABLES" != "n" ]; then
++# The simple matches.
++  dep_tristate '  limit match support' CONFIG_IP6_NF_MATCH_LIMIT $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  Random match support' CONFIG_IP6_NF_MATCH_RANDOM $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  Nth match support' CONFIG_IP6_NF_MATCH_NTH $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '    Fuzzy match support' CONFIG_IP6_NF_MATCH_FUZZY $CONFIG_IP6_NF_FILTER
++  fi
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  Routing header match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_RT $CONFIG_IP6_NF_IPTABLES
++  fi
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  Hop-by-Hop and Dst opts header match (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_OPTS $CONFIG_IP6_NF_IPTABLES
++  fi
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  Fragmentation header match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_FRAG $CONFIG_IP6_NF_IPTABLES
++  fi
++  dep_tristate '  HL match support' CONFIG_IP6_NF_MATCH_HL $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIPORT $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  Owner match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_OWNER $CONFIG_IP6_NF_IPTABLES
++  fi
++#  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
++  dep_tristate '  netfilter MARK match support' CONFIG_IP6_NF_MATCH_MARK $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  IPv6 Extension Headers Match (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_IPV6HEADER $CONFIG_IP6_NF_IPTABLES
++  fi
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  AH/ESP match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_AHESP $CONFIG_IP6_NF_IPTABLES
++  fi
++  dep_tristate '  Packet Length match support' CONFIG_IP6_NF_MATCH_LENGTH $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++    dep_tristate '  EUI64 address check (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_EUI64 $CONFIG_IP6_NF_IPTABLES
++  fi
++#  dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIPORT $CONFIG_IP6_NF_IPTABLES
++#  dep_tristate '  TOS match support' CONFIG_IP6_NF_MATCH_TOS $CONFIG_IP6_NF_IPTABLES
++#  if [ "$CONFIG_IP6_NF_CONNTRACK" != "n" ]; then
++#    dep_tristate '  Connection state match support' CONFIG_IP6_NF_MATCH_STATE $CONFIG_IP6_NF_CONNTRACK $CONFIG_IP6_NF_IPTABLES
++#  fi
++#  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++#    dep_tristate '  Unclean match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_UNCLEAN $CONFIG_IP6_NF_IPTABLES
++#    dep_tristate '  Owner match support (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_OWNER $CONFIG_IP6_NF_IPTABLES
++#  fi
++
++# The targets
++  dep_tristate '  Packet filtering' CONFIG_IP6_NF_FILTER $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
++    dep_tristate '    REJECT target support' CONFIG_IP6_NF_TARGET_REJECT $CONFIG_IP6_NF_FILTER
++  fi
++  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
++    dep_tristate '    HL target support' CONFIG_IP6_NF_TARGET_HL $CONFIG_IP6_NF_FILTER
++  fi
++  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
++    dep_tristate '    LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_FILTER
++  fi
++
++#  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
++#    dep_tristate '    REJECT target support' CONFIG_IP6_NF_TARGET_REJECT $CONFIG_IP6_NF_FILTER
++#    if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
++#      dep_tristate '    MIRROR target support (EXPERIMENTAL)' CONFIG_IP6_NF_TARGET_MIRROR $CONFIG_IP6_NF_FILTER
++#    fi
++#  fi
++
++  dep_tristate '  Packet mangling' CONFIG_IP6_NF_MANGLE $CONFIG_IP6_NF_IPTABLES
++  if [ "$CONFIG_IP6_NF_MANGLE" != "n" ]; then
++#    dep_tristate '    TOS target support' CONFIG_IP6_NF_TARGET_TOS $CONFIG_IP_NF_MANGLE
++    dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK $CONFIG_IP6_NF_MANGLE
++  fi
++  #dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_IPTABLES
++fi
++
++endmenu
+diff -Nru linux-2.4.21.orig/net/ipv6/netfilter/Makefile linux-2.4.21/net/ipv6/netfilter/Makefile
+--- linux-2.4.21.orig/net/ipv6/netfilter/Makefile	2003-06-28 13:24:11.000000000 +0200
++++ linux-2.4.21/net/ipv6/netfilter/Makefile	2003-06-28 13:27:21.000000000 +0200
+@@ -31,6 +31,7 @@
+ obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
+ obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
+ obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
++obj-$(CONFIG_IP6_NF_QUEUE) += ip6_quota.o
+ obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+
+ obj-$(CONFIG_IP6_NF_MATCH_RANDOM) += ip6t_random.o
+diff -Nru linux-2.4.21.orig/net/ipv6/netfilter/Makefile~ linux-2.4.21/net/ipv6/netfilter/Makefile~
+--- linux-2.4.21.orig/net/ipv6/netfilter/Makefile~	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/net/ipv6/netfilter/Makefile~	2003-06-28 13:20:06.000000000 +0200
+@@ -0,0 +1,42 @@
++#
++# Makefile for the netfilter modules on top of IPv6.
++#
++# Note! Dependencies are done automagically by 'make dep', which also
++# removes any old dependencies. DON'T put your own dependencies here
++# unless it's something special (ie not a .c file).
++#
++# Note 2! The CFLAGS definition is now in the main makefile...
++
++O_TARGET := netfilter.o
++
++export-objs := ip6_tables.o
++
++# Link order matters here.
++obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
++obj-$(CONFIG_IP6_NF_MATCH_LIMIT) += ip6t_limit.o
++obj-$(CONFIG_IP6_NF_MATCH_MARK) += ip6t_mark.o
++obj-$(CONFIG_IP6_NF_MATCH_LENGTH) += ip6t_length.o
++obj-$(CONFIG_IP6_NF_MATCH_MAC) += ip6t_mac.o
++obj-$(CONFIG_IP6_NF_MATCH_FUZZY) += ip6t_fuzzy.o
++obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
++obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o ip6t_dst.o
++obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
++obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
++obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o
++obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
++obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
++obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
++obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
++obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
++obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
++obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
++obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
++obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
++
++obj-$(CONFIG_IP6_NF_MATCH_RANDOM) += ip6t_random.o
++
++obj-$(CONFIG_IP6_NF_MATCH_NTH) += ip6t_nth.o
++obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
++obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
++
++include $(TOPDIR)/Rules.make
+diff -Nru linux-2.4.21.orig/net/ipv6/netfilter/ip6t_quota.c linux-2.4.21/net/ipv6/netfilter/ip6t_quota.c
+--- linux-2.4.21.orig/net/ipv6/netfilter/ip6t_quota.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/net/ipv6/netfilter/ip6t_quota.c	2003-06-28 13:27:06.000000000 +0200
+@@ -0,0 +1,83 @@
++/*
++ * netfilter module to enforce network quotas
++ *
++ * Sam Johnston <samj@samj.net>
++ *
++ * IPv6 port by Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ */
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/spinlock.h>
++#include <linux/interrupt.h>
++
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_quota.h>
++
++MODULE_LICENSE("GPL");
++
++static spinlock_t quota_lock = SPIN_LOCK_UNLOCKED;
++
++static int
++match(const struct sk_buff *skb,
++      const struct net_device *in,
++      const struct net_device *out,
++      const void *matchinfo,
++      int offset, const void *hdr, u_int16_t datalen, int *hotdrop)
++{
++
++        struct ip6t_quota_info *q = (struct ip6t_quota_info *) matchinfo;
++
++        spin_lock_bh(&quota_lock);
++
++        if (q->quota >= datalen) {
++                /* we can afford this one */
++                q->quota -= datalen;
++                spin_unlock_bh(&quota_lock);
++
++#ifdef DEBUG_IP6T_QUOTA
++                printk("IP6T Quota OK: %llu datlen %d \n", q->quota, datalen);
++#endif
++                return 1;
++        }
++
++        /* so we do not allow even small packets from now on */
++        q->quota = 0;
++
++#ifdef DEBUG_IP6T_QUOTA
++        printk("IP6T Quota Failed: %llu datlen %d \n", q->quota, datalen);
++#endif
++
++        spin_unlock_bh(&quota_lock);
++        return 0;
++}
++
++static int
++checkentry(const char *tablename,
++           const struct ip6t_ip6 *ip6,
++           void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
++{
++        /* TODO: spinlocks? sanity checks? */
++        if (matchsize != IP6T_ALIGN(sizeof (struct ip6t_quota_info)))
++                return 0;
++
++        return 1;
++}
++
++static struct ip6t_match quota_match
++    = { {NULL, NULL}, "quota", &match, &checkentry, NULL, THIS_MODULE };
++
++static int __init
++init(void)
++{
++        return ip6t_register_match(&quota_match);
++}
++
++static void __exit
++fini(void)
++{
++        ip6t_unregister_match(&quota_match);
++}
++
++module_init(init);
++module_exit(fini);
++
diff -Nru netfilter.orig/patch-o-matic/base/quota.patch.ipv6.config.in netfilter/patch-o-matic/base/quota.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/quota.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/quota.patch.ipv6.config.in	2003-06-28 13:32:01.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  limit match support' CONFIG_IP6_NF_MATCH_LIMIT $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  quota match support' CONFIG_IP6_NF_MATCH_QUOTA $CONFIG_IP6_NF_IPTABLES
diff -Nru netfilter.orig/patch-o-matic/base/quota.patch.ipv6.configure.help netfilter/patch-o-matic/base/quota.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/quota.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/quota.patch.ipv6.configure.help	2003-06-28 13:32:34.000000000 +0200
@@ -0,0 +1,8 @@
+CONFIG_IP6_NF_MATCH_LIMIT
+quota match support
+CONFIG_IP6_NF_MATCH_QUOTA
+  This match implements network quotas.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff -Nru netfilter.orig/patch-o-matic/base/quota.patch.ipv6.help netfilter/patch-o-matic/base/quota.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/quota.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/quota.patch.ipv6.help	2003-06-28 13:33:41.000000000 +0200
@@ -0,0 +1,12 @@
+Author: Sam Johnston <samj@samj.net>
+Ported: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: worksforme
+
+This option adds CONFIG_IP6_NF_MATCH_QUOTA, which implements network
+quotas by decrementing a byte counter with each packet.
+
+Supported options are:
+--quota <bytes>
+  The quota in bytes.
+
+   This is an IPv6 port from IPv4 module.
diff -Nru netfilter.orig/patch-o-matic/base/quota.patch.ipv6.makefile netfilter/patch-o-matic/base/quota.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/quota.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/quota.patch.ipv6.makefile	2003-06-28 13:38:38.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_MATCH_QUOTA) += ip6t_quota.o
diff -Nru netfilter.orig/userspace/extensions/.quota-test6 netfilter/userspace/extensions/.quota-test6
--- netfilter.orig/userspace/extensions/.quota-test6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.quota-test6	2003-06-30 18:49:57.000000000 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_quota.h ] && echo quota
+
diff -Nru netfilter.orig/userspace/extensions/libip6t_quota.c netfilter/userspace/extensions/libip6t_quota.c
--- netfilter.orig/userspace/extensions/libip6t_quota.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_quota.c	2003-06-30 18:49:45.000000000 +0200
@@ -0,0 +1,116 @@
+/*
+ * Shared library add-on to ip6tables to add quota support
+ *
+ * Sam Johnston <samj@samj.net>
+ *
+ * IPv6 Port: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+
+#include <linux/netfilter_ipv6/ip6t_quota.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+static struct option opts[] = {
+        {"quota", 1, 0, '1'},
+        {0}
+};
+
+/* print usage */
+static void
+help(void)
+{
+        printf("quota options:\n"
+               " --quota quota			quota (bytes)\n" "\n");
+}
+
+/* initialise match */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+        /* no can cache */
+        *nfcache |= NFC_UNKNOWN;
+}
+
+/* print matchinfo */
+static void
+print(const struct ip6t_ip *ip, const struct ip6t_entry_match *match, int numeric)
+{
+        struct ip6t_quota_info *q = (struct ip6t_quota_info *) match->data;
+        printf("quota: %llu bytes", (unsigned long long) q->quota);
+}
+
+/* save matchinfo */
+static void
+save(const struct ip6t_ip *ip, const struct ip6t_entry_match *match)
+{
+        struct ip6t_quota_info *q = (struct ip6t_quota_info *) match->data;
+        printf("--quota %llu ", (unsigned long long) q->quota);
+}
+
+/* parse quota option */
+static int
+parse_quota(const char *s, u_int64_t * quota)
+{
+        *quota = strtoull(s, (char **) NULL, 10);
+
+#ifdef DEBUG_IP6T_QUOTA
+        printf("Quota: %llu\n", *quota);
+#endif
+
+        if (*quota == -1)
+                exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
+        else
+                return 1;
+}
+
+/* parse all options, returning true if we found any for us */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache, struct ip6t_entry_match **match)
+{
+        struct ip6t_quota_info *info = (struct ip6t_quota_info *) (*match)->data;
+
+        switch (c) {
+        case '1':
+                if (check_inverse(optarg, &invert, NULL, 0))
+                        exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
+                if (!parse_quota(optarg, &info->quota))
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad quota: '%s'", optarg);
+                break;
+
+        default:
+                return 0;
+        }
+        return 1;
+}
+
+/* no final check */
+static void
+final_check(unsigned int flags)
+{
+}
+
+struct ip6tables_match quota = { NULL,
+        "quota",
+        IPTABLES_VERSION,
+        IP6T_ALIGN(sizeof (struct ip6t_quota_info)),
+        IP6T_ALIGN(sizeof (struct ip6t_quota_info)),
+        &help,
+        &init,
+        &parse,
+        &final_check,
+        &print,
+        &save,
+        opts
+};
+
+void
+_init(void)
+{
+        register_match6(&quota);
+}
