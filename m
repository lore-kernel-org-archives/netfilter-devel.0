From: "Jesse Peng" <Jesse@deansoft.com.tw>
Subject: [PATCH 2.4] Introducing Bidirectional conntrack mark
Date: Wed, 7 Sep 2005 17:39:53 +0800
Message-ID: <002601c5b390$1d641d10$fefefe0a@jesseh7ht76e8n>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>, "Wang Jian" <lark@linux.net.cn>
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

Greetings all,
This patch fully derive from Henrik Nordstrom's long known connmark =
patch but is extended to bidirectional solution.
The solution once discussed as the following link:
https://lists.netfilter.org/pipermail/netfilter-devel/2005-March/018784.h=
tml


Dear Henrik:
Feel free to give any advice for the work extending your existing famous =
connmark patch.

Dear Jian:
I got approved for quite a period,but sorry for this late posting this =
patch after a busy season.Hope this help!

Cheers
Jesse=20
-------------- next part --------------
diff -Nru a/include/linux/netfilter_ipv4/ipt_ctdirmark.h =
b/include/linux/netfilter_ipv4/ipt_ctdirmark.h
--- a/include/linux/netfilter_ipv4/ipt_ctdirmark.h      Wed Sep  7 =
16:12:33 2005
+++ b/include/linux/netfilter_ipv4/ipt_ctdirmark.h   Wed Sep  7 15:23:40 =
2005
@@ -0,0 +1,16 @@
+#ifndef _IPT_CTDIRMARK_H
+#define _IPT_CTDIRMARK_H
+
+#define IPT_CTDIRMARK_ORIGINAL         0x01
+#define IPT_CTDIRMARK_REPLY            0x02
+
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+
+struct ipt_ctdirmark_info {
+        u_int8_t bitmask;
+       unsigned long mark[IP_CT_DIR_MAX], mask[IP_CT_DIR_MAX];
+       u_int8_t invert;
+};
+
+#endif /*_IPT_CTDIRMARK_H*/
+
diff -Nru a/net/ipv4/netfilter/Config.in b/net/ipv4/n
etfilter/Config.in
--- a/net/ipv4/netfilter/Config.in   Wed Jan 19 22:10:13 2005
+++ b/net/ipv4/netfilter/Config.in      Wed Sep  7 16:00:31 2005
@@ -7,6 +7,7 @@
 tristate 'Connection tracking (required for masq/NAT)' =
CONFIG_IP_NF_CONNTRACK
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP =
$CONFIG_IP_NF_CONNTRACK
+  bool '  Bidirectional connection mark tracking support' =
CONFIG_IP_NF_CTDIRMARK
   dep_tristate '  Amanda protocol support' CONFIG_IP_NF_AMANDA =
$CONFIG_IP_NF_CONNTRACK
   dep_tristate '  TFTP protocol support' CONFIG_IP_NF_TFTP =
$CONFIG_IP_NF_CONNTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC =
$CONFIG_IP_NF_CONNTRACK
@@ -38,6 +39,9 @@
   fi
   if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
     dep_tristate '  Connection state match support' =
CONFIG_IP_NF_MATCH_STATE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES
+    if [ "$CONFIG_IP_NF_CTDIRMARK" !=3D "n" ]; then
+      dep_tristate '  Bidirectional Connection mark match support' =
CONFIG_IP_NF_MATCH_CTDIRMARK $CONFIG_IP_NF_IPTABLES
+    fi
     dep_tristate '  Connection tracking match support' =
CONFIG_IP_NF_MATCH_CONNTRACK $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IP
TABLES
   fi
   if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
@@ -105,6 +109,9 @@
     dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK =
$CONFIG_IP_NF_MANGLE
   fi
   dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG =
$CONFIG_IP_NF_IPTABLES
+  if [ "$CONFIG_IP_NF_CTDIRMARK" !=3D "n" ]; then
+    dep_tristate '  Bidirectional Connection mark target support' =
CONFIG_IP_NF_TARGET_CTDIRMARK $CONFIG_IP_NF_IPTABLES
+  fi
   dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG =
$CONFIG_IP_NF_IPTABLES
   dep_tristate '  TCPMSS target support' CONFIG_IP_NF_TARGET_TCPMSS =
$CONFIG_IP_NF_IPTABLES
 fi
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/ne
tfilter/Makefile
--- a/net/ipv4/netfilter/Makefile    Mon Aug 25 19:44:44 2003
+++ b/net/ipv4/netfilter/Makefile       Wed Sep  7 16:24:52 2005
@@ -83,6 +83,7 @@

 obj-$(CONFIG_IP_NF_MATCH_TTL) +=3D ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
+obj-$(CONFIG_IP_NF_MATCH_CTDIRMARK) +=3D ipt_ctdirmark.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) +=3D ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) +=3D ipt_unclean.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) +=3D ipt_tcpmss.o
@@ -98,6 +99,7 @@
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_NAT_SNMP_BASIC) +=3D ip_nat_snmp_basic.o
 obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_CTDIRMARK) +=3D ipt_CTDIRMARK.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) +=3D ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) +=3D ipt_TCPMSS.o
diff -Nru a/net/ipv4/netfilter/ipt_ctdirmark.c =
b/net/ipv4/netfilter/ipt_ctdirmark.c
--- a/net/ipv4/netfilter/ipt_ctdirmark.c        Wed Sep  7 16:27:49 2005
+++ b/net/ipv4/netfilter/ipt_ctdirmark.c     Wed Sep  7 15:24:48 2005
@@ -0,0 +1,64 @@
+/* Kernel module to match bidirectional connection mark values. */
+#define __KERNEL__
+#define MODULE
+#define MATCH   1
+#define NOMATCH 0
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include "ipt_ctdirmark.h"
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+       const struct ipt_ctdirmark_info *info =3D matchinfo;
+       enum ip_conntrack_info ctinfo;
+       struct ip_conntrack *ct =3D ip_conntrack_get((struct sk_buff =
*)skb, &ctinfo);
+       if (!ct)
+           return 0;
+        if ((info->bitmask & IPT_CTDIRMARK_ORIGINAL &&
+           (!((ct->mark_dir[IP_CT_DIR_ORIGINAL] & =
info->mask[IP_CT_DIR_ORIGINAL]) =3D=3D info->mark[IP_CT_DIR_ORIGINAL]) ^ =
!!(in
fo->invert & IPT_CTDIRMARK_ORIGINAL))) ||
+           (info->bitmask & IPT_CTDIRMARK_REPLY &&
+           (!((ct->mark_dir[IP_CT_DIR_REPLY] & =
info->mask[IP_CT_DIR_REPLY]) =3D=3D info->mark[IP_CT_DIR_REPLY]) ^ =
!!(info->inver
t & IPT_CTDIRMARK_REPLY))))
+           return NOMATCH;
+        return MATCH;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+       if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_ctdirmark_info)))
+               return 0;
+
+       return 1;
+}
+
+static struct ipt_match ctdirmark_match
+=3D { { NULL, NULL }, "ctdirmark", &match, &checkentry, NULL, =
THIS_MODULE };
+
+static int __init init(void)
+{
+       return ipt_register_match(&ctdirmark_match);
+}
+
+static void __exit fini(void)
+{
+       ipt_unregister_match(&ctdirmark_match);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru a/net/ipv4/netfilter/ipt_CTDIRMARK.c =
b/net/ipv4/netfilter/ipt_CTDIRMARK.c
--- a/net/ipv4/netfilter/ipt_CTDIRMARK.c        Wed Sep  7 16:31:08 2005
+++ b/net/ipv4/netfilter/ipt_CTDIRMARK.c     Wed Sep  7 15:25:19 2005
@@ -0,0 +1,103 @@
+/* This is a module which is used for setting/remembering the mark =
field of
+ * an connection, or optionally restore it to the skb
+ */
+#define __KERNEL__
+#define MODULE
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include "ipt_CTDIRMARK.h"
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+static unsigned int
+target(struct sk_buff **pskb,
+       unsigned int hooknum,
+       const struct net_device *in,
+       const struct net_device *out,
+       const void *targinfo,
+       void *userinfo)
+{
+       const struct ipt_ctdirmark_target_info *info =3D targinfo;
+
+       enum ip_conntrack_info ctinfo;
+       struct ip_conntrack *ct =3D ip_conntrack_get((*pskb), &ctinfo);
+       if (ct) {
+           switch(info->mode) {
+           case IPT_CTDIRMARK_SET:
+                if (info->bitmask & IPT_CTDIRMARK_ORIGINAL)
+                   ct->mark_dir[IP_CT_DIR_ORIGINAL] =3D =
info->mark[IP_CT_DIR_ORIGINAL];
+                if (info->bitmask & IPT_CTDIRMARK_REPLY)
+                   ct->mark_dir[IP_CT_DIR_REPLY] =3D =
info->mark[IP_CT_DIR_REPLY];
+               break;
+           case IPT_CTDIRMARK_SAVE:
+                if (info->bitmask & IPT_CTDIRMARK_ORIGINAL)
+                   ct->mark_dir[IP_CT_DIR_ORIGINAL] =3D =
(*pskb)->nfmark;
+                if (info->bitmask & IPT_CTDIRMARK_REPLY)
+                   ct->mark_dir[IP_CT_DIR_REPLY] =3D (*pskb)->nfmark;
+               break;
+           case IPT_CTDIRMARK_RESTORE:
+                if (info->bitmask & IPT_CTDIRMARK_ORIGINAL){
+                   if (ct->mark_dir[IP_CT_DIR_ORIGINAL] !=3D =
(*pskb)->nfmark) {
+                       (*pskb)->nfmark =3D =
ct->mark_dir[IP_CT_DIR_ORIGINAL];
+                       (*pskb)->nfcache |=3D NFC_ALTERED;
+                    }
+                }else if (info->bitmask & IPT_CTDIRMARK_REPLY){
+                   if (ct->mark_dir[IP_CT_DIR_REPLY] !=3D =
(*pskb)->nfmark) {
+                       (*pskb)->nfmark =3D =
ct->mark_dir[IP_CT_DIR_REPLY];
+                       (*pskb)->nfcache |=3D NFC_ALTERED;
+                    }
+               }
+               break;
+           }
+       }
+
+       return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+          const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+       struct ipt_ctdirmark_target_info *info =3D targinfo;
+       if (targinfosize !=3D IPT_ALIGN(sizeof(struct =
ipt_ctdirmark_target_info))) {
+               printk(KERN_WARNING "CTDIRMARK: targinfosize %u !=3D =
%Zu\n",
+                      targinfosize,
+                      IPT_ALIGN(sizeof(struct =
ipt_ctdirmark_target_info)));
+               return 0;
+       }
+
+       if (info->mode =3D=3D IPT_CTDIRMARK_RESTORE) {
+           if (strcmp(tablename, "mangle") !=3D 0) {
+                   printk(KERN_WARNING "CTDIRMARK: restore can only be =
called from \"mangle\" table, not \"%s\"\n", tablenam
e);
+                   return 0;
+           }
+       }
+
+       return 1;
+}
+
+static struct ipt_target ipt_ctdirmark_reg
+=3D { { NULL, NULL }, "CTDIRMARK", target, checkentry, NULL, =
THIS_MODULE };
+
+static int __init init(void)
+{
+       if (ipt_register_target(&ipt_ctdirmark_reg))
+               return -EINVAL;
+
+       return 0;
+}
+
+static void __exit fini(void)
+{
+       ipt_unregister_target(&ipt_ctdirmark_reg);
+}
+
+module_init(init);
+module_exit(fini);

-------------- next part --------------
diff -Nru a/extensions/Makefile b/extensions/Makefile
--- a/extensions/Makefile       Wed Sep  7 16:42:31 2005
+++ b/extensions/Makefile Wed Sep  7 16:40:11 2005
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this =
iptables
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah conntrack dscp ecn esp helper icmp iplimit length =
limit mac mark multiport owner physdev pkttype rpc standar
d state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE =
MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS T
TL ULOG
+PF_EXT_SLIB:=3Dah conntrack dscp ecn esp helper icmp iplimit length =
limit mac mark multiport owner physdev pkttype rpc standar
d state ctdirmark tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK =
MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TC
PMSS TOS TTL ULOG CTDIRMARK
 PF6_EXT_SLIB:=3Deui64 hl icmpv6 length limit mac mark multiport owner =
standard tcp udp HL LOG MARK

 # Optionals
diff -Nru a/extensions/libipt_ctdirmark.c =
b/extensions/libipt_ctdirmark.c
--- a/extensions/libipt_ctdirmark.c     Wed Sep  7 16:46:18 2005
+++ b/extensions/libipt_ctdirmark.c       Wed Sep  7 15:28:33 2005
@@ -0,0 +1,171 @@
+/* Shared library add-on to iptables to add CTDIRMARK matching support. =
*/
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_CTDIRMARK.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+       printf(
+"ctdirmark match v%s options:\n"
+"[!] --mark_original value[/mask]         Match nfmark in dir original =
value with optional mask\n"
+"[!] --mark_reply value[/mask]         Match nfmark in dir reply value =
with optional mask\n"
+"\n",
+NETFILTER_VERSION);
+}
+
+static struct option opts[] =3D {
+       { "mark_original", 1, 0, '1' },
+        { "mark_reply", 1, 0, '2' },
+       {0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+       /* Can't cache this. */
+       *nfcache |=3D NFC_UNKNOWN;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+       struct ipt_ctdirmark_info *info =3D (struct ipt_ctdirmark_info =
*)(*match)->data;
+
+       switch (c) {
+               char *end;
+       case '1':
+               if (*flags & IPT_CTDIRMARK_ORIGINAL)
+                        goto multiple_use;
+                check_inverse(optarg, &invert, &optind, 0);
+               info->mark[IP_CT_DIR_ORIGINAL] =3D strtoul(optarg, &end, =
0);
+               if (*end =3D=3D '/') {
+                       info->mask[IP_CT_DIR_ORIGINAL] =3D =
strtoul(end+1, &end, 0);
+               } else
+                       info->mask[IP_CT_DIR_ORIGINAL] =3D 0xffffffff;
+               if (*end !=3D '\0' || end =3D=3D optarg)
+                       exit_error(PARAMETER_PROBLEM, "Bad MARK value =
`%s'", optarg);
+               if (invert)
+                       info->invert |=3D IPT_CTDIRMARK_ORIGINAL;
+               info->bitmask |=3D IPT_CTDIRMARK_ORIGINAL;
+               *flags |=3D IPT_CTDIRMARK_ORIGINAL;
+               break;
+
+        case '2':
+               if (*flags & IPT_CTDIRMARK_REPLY)
+                        goto multiple_use;
+                check_inverse(optarg, &invert, &optind, 0);
+               info->mark[IP_CT_DIR_REPLY] =3D strtoul(optarg, &end, =
0);
+               if (*end =3D=3D '/') {
+                       info->mask[IP_CT_DIR_REPLY] =3D strtoul(end+1, =
&end, 0);
+               } else
+                       info->mask[IP_CT_DIR_REPLY] =3D 0xffffffff;
+               if (*end !=3D '\0' || end =3D=3D optarg)
+                       exit_error(PARAMETER_PROBLEM, "Bad MARK value =
`%s'", optarg);
+               if (invert)
+                       info->invert |=3D IPT_CTDIRMARK_REPLY;
+               info->bitmask |=3D IPT_CTDIRMARK_REPLY;
+               *flags |=3D IPT_CTDIRMARK_REPLY;
+               break;
+       default:
+               return 0;
+       }
+       return 1;
+        multiple_use:
+       exit_error(PARAMETER_PROBLEM,
+          "multiple use of the same ctdirmark  option is not allowed");
+}
+
+static void
+print_mark(unsigned long mark, unsigned long mask, int numeric)
+{
+       if(mask !=3D 0xffffffff)
+               printf("0x%lx/0x%lx ", mark, mask);
+       else
+               printf("0x%lx ", mark);
+}
+
+/* Final check; must have specified --mark. */
+static void
+final_check(unsigned int flags)
+{
+       if (!flags)
+               exit_error(PARAMETER_PROBLEM,
+                          "MARK match: You must specify =
`--mark_original' or `--mark_reply'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+       struct ipt_ctdirmark_info *info =3D (struct ipt_ctdirmark_info =
*)match->data;
+
+       printf("ctdirmark match ");
+        if (info->bitmask & IPT_CTDIRMARK_ORIGINAL) {
+           if (info->invert & IPT_CTDIRMARK_ORIGINAL)
+               printf("!");
+            printf("--mark_original ");
+           print_mark(info->mark[IP_CT_DIR_ORIGINAL], =
info->mask[IP_CT_DIR_ORIGINAL], numeric);
+        }
+        if (info->bitmask & IPT_CTDIRMARK_REPLY) {
+           if (info->invert & IPT_CTDIRMARK_REPLY)
+               printf("!");
+            printf("--mark_reply ");
+           print_mark(info->mark[IP_CT_DIR_REPLY], =
info->mask[IP_CT_DIR_REPLY], numeric);
+        }
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+       struct ipt_ctdirmark_info *info =3D (struct ipt_ctdirmark_info =
*)match->data;
+
+       if (info->bitmask & IPT_CTDIRMARK_ORIGINAL) {
+           if (info->invert & IPT_CTDIRMARK_ORIGINAL)
+               printf("!");
+            printf("--mark_original ");
+           print_mark(info->mark[IP_CT_DIR_ORIGINAL], =
info->mask[IP_CT_DIR_ORIGINAL], 0);
+        }
+        if (info->bitmask & IPT_CTDIRMARK_REPLY) {
+           if (info->invert & IPT_CTDIRMARK_REPLY)
+               printf("!");
+            printf("--mark_reply ");
+           print_mark(info->mark[IP_CT_DIR_REPLY], =
info->mask[IP_CT_DIR_REPLY], 0);
+        }
+}
+
+static
+struct iptables_match mark
+=3D { NULL,
+    "ctdirmark",
+    NETFILTER_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_ctdirmark_info)),
+    IPT_ALIGN(sizeof(struct ipt_ctdirmark_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+       register_match(&mark);
+}
diff -Nru a/extensions/libipt_CTDIRMARK.c =
b/extensions/libipt_CTDIRMARK.c
--- a/extensions/libipt_CTDIRMARK.c     Wed Sep  7 16:48:53 2005
+++ b/extensions/libipt_CTDIRMARK.c       Wed Sep  7 15:28:52 2005
@@ -0,0 +1,221 @@
+/* Shared library add-on to iptables to add CTDIRMARK target support. =
*/
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_CTDIRMARK.h>
+
+/*
+#if 0
+struct markinfo {
+       struct ipt_entry_target t;
+       struct ipt_ctdirmark_target_info mark;
+};
+#endif
+*/
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+       printf(
+"CTDIRMARK target v%s options:\n"
+"  --set-mark_original value              Set ctdirmark mark value in =
original dir\n"
+"  --set-mark_reply value              Set ctdirmark mark value in =
reply dir\n"
+"  --save-mark                   Save the packet nfmark on the =
connection in the specified dir\n"
+"  --restore-mark                Restore saved nfmark value\n"
+"  --mark_original               specify original dir\n"
+"  --mark_reply                  specify reply dir\n"
+"\n",
+NETFILTER_VERSION);
+}
+
+static struct option opts[] =3D {
+       { "set-mark_original", 1, 0, '1' },
+        { "set-mark_reply", 1, 0, '2' },
+       { "save-mark", 0, 0, '3' },
+       { "restore-mark", 0, 0, '4' },
+        { "mark_original", 0, 0, '5' },
+        { "mark_reply", 0, 0, '6' },
+       { 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+       struct ipt_ctdirmark_target_info *info
+               =3D (struct ipt_ctdirmark_target_info *)(*target)->data;
+
+       switch (c) {
+               char *end;
+       case '1':
+               if (*flags & ~IPT_CTDIRMARK_TARGET_SET_REPLY)
+                        goto multiple_use;
+                info->mode =3D IPT_CTDIRMARK_SET;
+                info->bitmask |=3D IPT_CTDIRMARK_ORIGINAL;
+               info->mark[IP_CT_DIR_ORIGINAL] =3D strtoul(optarg, &end, =
0);
+               if (*end !=3D '\0' || end =3D=3D optarg)
+                       exit_error(PARAMETER_PROBLEM, "Bad MARK value =
`%s'", optarg);
+               *flags |=3D IPT_CTDIRMARK_TARGET_SET_ORIGINAL;
+               break;
+        case '2':
+               if (*flags & ~IPT_CTDIRMARK_TARGET_SET_ORIGINAL)
+                        goto multiple_use;
+                info->mode =3D IPT_CTDIRMARK_SET;
+                info->bitmask |=3D IPT_CTDIRMARK_REPLY;
+               info->mark[IP_CT_DIR_REPLY] =3D strtoul(optarg, &end, =
0);
+               if (*end !=3D '\0' || end =3D=3D optarg)
+                       exit_error(PARAMETER_PROBLEM, "Bad MARK value =
`%s'", optarg);
+               *flags |=3D IPT_CTDIRMARK_TARGET_SET_REPLY;
+                break;
+       case '3':
+                if (*flags)
+                        goto multiple_use;
+               info->mode =3D IPT_CTDIRMARK_SAVE;
+               *flags |=3D IPT_CTDIRMARK_TARGET_SAVE;
+               break;
+       case '4':
+                if (*flags)
+                        goto multiple_use;
+               info->mode =3D IPT_CTDIRMARK_RESTORE;
+               *flags |=3D IPT_CTDIRMARK_TARGET_RESTORE;
+               break;
+        case '5':
+                if ((*flags & IPT_CTDIRMARK_TARGET_SET_ORIGINAL) ||
+                     (*flags & IPT_CTDIRMARK_TARGET_SET_REPLY) ||
+                      (*flags & IPT_CTDIRMARK_TARGET_ORIGINAL))
+                        goto multiple_use;
+                if (!(*flags & IPT_CTDIRMARK_TARGET_SAVE) &&
+                      !(*flags & IPT_CTDIRMARK_TARGET_RESTORE))
+                        goto wrong_use;
+                info->bitmask |=3D IPT_CTDIRMARK_ORIGINAL;
+                *flags |=3D IPT_CTDIRMARK_TARGET_ORIGINAL;
+               break;
+        case '6':
+                if ((*flags & IPT_CTDIRMARK_TARGET_SET_ORIGINAL) ||
+                     (*flags & IPT_CTDIRMARK_TARGET_SET_REPLY) ||
+                      (*flags & IPT_CTDIRMARK_TARGET_REPLY))
+                        goto multiple_use;
+                if (!(*flags & IPT_CTDIRMARK_TARGET_SAVE) &&
+                      !(*flags & IPT_CTDIRMARK_TARGET_RESTORE))
+                        goto wrong_use;
+                info->bitmask |=3D IPT_CTDIRMARK_REPLY;
+               *flags |=3D IPT_CTDIRMARK_TARGET_REPLY;
+               break;
+       default:
+               return 0;
+       }
+
+       return 1;
+multiple_use:
+       exit_error(PARAMETER_PROBLEM,
+          "multiple use of the same ctdirmark option is not allowed");
+wrong_use:
+       exit_error(PARAMETER_PROBLEM,
+          "without save or restore option in advance is not allowed");
+}
+
+static void
+final_check(unsigned int flags)
+{
+       if (!flags)
+               exit_error(PARAMETER_PROBLEM,
+                          "CTDIRMARK target: Parameter =
--set-mark_original or --set-mark_reply is required");
+}
+
+static void
+print_mark(unsigned long mark, int numeric)
+{
+       printf("0x%lx ", mark);
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+       const struct ipt_ctdirmark_target_info *info =3D
+               (const struct ipt_ctdirmark_target_info *)target->data;
+       switch (info->mode) {
+       case IPT_CTDIRMARK_SET:
+            if (info->bitmask & IPT_CTDIRMARK_ORIGINAL){
+           printf("CTDIRMARK set original");
+           print_mark(info->mark[IP_CT_DIR_ORIGINAL], numeric);
+            }
+            if (info->bitmask & IPT_CTDIRMARK_REPLY){
+            printf("CTDIRMARK set reply");
+           print_mark(info->mark[IP_CT_DIR_REPLY], numeric);
+            }
+           break;
+       case IPT_CTDIRMARK_SAVE:
+           printf("CTDIRMARK save ");
+           break;
+       case IPT_CTDIRMARK_RESTORE:
+           printf("CTDIRMARK restore ");
+           break;
+       default:
+           printf("ERROR: UNKNOWN CTDIRMARK MODE ");
+           break;
+       }
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+       const struct ipt_ctdirmark_target_info *info =3D
+               (const struct ipt_ctdirmark_target_info *)target->data;
+
+       switch (info->mode) {
+       case IPT_CTDIRMARK_SET:
+            if (info->bitmask & IPT_CTDIRMARK_ORIGINAL)
+              printf("--set-mark_original 0x%lx ", =
info->mark[IP_CT_DIR_ORIGINAL]);
+            if (info->bitmask & IPT_CTDIRMARK_REPLY)
+               printf("--set-mark_reply 0x%lx ", =
info->mark[IP_CT_DIR_REPLY]);
+           break;
+       case IPT_CTDIRMARK_SAVE:
+           printf("--save-mark ");
+           break;
+       case IPT_CTDIRMARK_RESTORE:
+           printf("--restore-mark ");
+           break;
+       default:
+           printf("ERROR: UNKNOWN CTDIRMARK MODE ");
+           break;
+       }
+}
+
+static
+struct iptables_target mark
+=3D { NULL,
+    "CTDIRMARK",
+    NETFILTER_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_ctdirmark_target_info)),
+    IPT_ALIGN(sizeof(struct ipt_ctdirmark_target_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+       register_target(&mark);
+}
