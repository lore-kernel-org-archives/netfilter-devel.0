From: "Jesse Peng" <tzuhsi.peng@msa.hinet.net>
Subject: Re: P2P implementation for netfilter NAT
Date: Tue, 17 Jan 2006 00:26:44 +0800
Message-ID: <001c01c61ab9$a5eb21c0$6401a8c0@acer21ce70712f>
References: <001801c5f6b3$539b1b20$3478fea9@acer21ce70712f><1133692009.30188.27.camel@localhost.localdomain><002f01c5f972$5da353a0$6602a8c0@acer21ce70712f><001601c61210$0c50b3b0$3478fea9@acer21ce70712f>
	<1136683250.31831.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0019_01C61AFC.B22CD080"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0019_01C61AFC.B22CD080
Content-Type: text/plain; format=flowed; charset="big5"; reply-type=original
Content-Transfer-Encoding: 7bit

> Hmm, please resend...

Sorry for the late reply,here attatch the patch,Please give advice.

Thanks
Jesse

-------------first part--------------
diff -Nur linux-2.6.13.3/include/linux/netfilter_i
pv4/ip_conntrack.h linux-b/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.13.3/include/linux/netfilter_ipv4/ip_conntrack.h  2005-10-04 
07:27
:34.000000000 +0800
+++ linux-b/include/linux/netfilter_ipv4/ip_conntrack.h 2005-11-02 
18:11:00.0000
00000 +0800
@@ -65,6 +65,27 @@
        /* Both together */
        IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+       IPS_SNATP2P_SRC_BIT = 9,
+       IPS_SNATP2P_SRC = (1 << IPS_SNATP2P_SRC_BIT),
+
+       IPS_SNATP2P_DST_BIT = 10,
+       IPS_SNATP2P_DST = (1 << IPS_SNATP2P_DST_BIT),
+
+        /* Both together. */
+       IPS_SNATP2P_MASK = (IPS_SNATP2P_DST | IPS_SNATP2P_SRC),
+
+        IPS_SNATP2P_SRC_DONE_BIT = 11,
+       IPS_SNATP2P_SRC_DONE = (1 << IPS_SNATP2P_SRC_DONE_BIT),
+
+        IPS_SNATP2P_DST_DONE_BIT = 12,
+       IPS_SNATP2P_DST_DONE = (1 << IPS_SNATP2P_DST_DONE_BIT),
+
+        /* Both together. */
+       IPS_SNATP2P_DONE_MASK = (IPS_SNATP2P_DST_DONE | 
IPS_SNATP2P_SRC_DONE),
+#endif
+
 };
 #ifdef __KERNEL__
diff -Nur linux-2.6.13.3/include/linux/netfilter_i
pv4/ip_nat.h linux-b/include/linux/netfilter_ipv4/ip_nat.h
--- linux-2.6.13.3/include/linux/netfilter_ipv4/ip_nat.h        2005-10-04 
07:27
:34.000000000 +0800
+++ linux-b/include/linux/netfilter_ipv4/ip_nat.h       2005-11-07 
21:28:32.0000
00000 +0800
@@ -59,6 +59,10 @@
 {
        struct list_head bysource;
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+    struct list_head by_modified_source;
+#endif
+
        /* Helper (NULL if none). */
        struct ip_nat_helper *helper;
@@ -76,6 +80,11 @@
 extern int ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
                             const struct ip_conntrack *ignored_conntrack);
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+extern int find_appropriate_p2p_dst(const struct ip_conntrack_tuple *tuple,
+                    struct ip_conntrack_tuple *result);
+#endif
+
 /* Calculate relative checksum. */
 extern u_int16_t ip_nat_cheat_check(u_int32_t oldvalinv,
                                    u_int32_t newval,
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/Kconf
g linux-b/net/ipv4/netfilter/Kconfig
--- linux-2.6.13.3/net/ipv4/netfilter/Kconfig   2005-10-04 
07:27:34.000000000 +
800
+++ linux-b/net/ipv4/netfilter/Kconfig  2005-11-09 17:11:10.000000000 +0800
@@ -484,6 +484,14 @@
          To compile it as a module, choose M here.  If unsure, say N.
+config IP_NF_TARGET_SNATP2P
+    tristate "SNATP2P target support"
+       depends on IP_NF_NAT
+       help
+         SNATP2P is an implementation for P2P need.
+
+         To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_NETMAP
        tristate "NETMAP target support"
        depends on IP_NF_NAT
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/Makef
le linux-b/net/ipv4/netfilter/Makefile
--- linux-2.6.13.3/net/ipv4/netfilter/Makefile  2005-10-04 
07:27:34.000000000 +
800
+++ linux-b/net/ipv4/netfilter/Makefile 2005-11-09 17:13:00.000000000 +0800
@@ -68,6 +68,7 @@
 obj-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_SNATP2P) += ipt_SNATP2P.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
 obj-$(CONFIG_IP_NF_TARGET_CLASSIFY) += ipt_CLASSIFY.o
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_co
ntrack_proto_tcp.c linux-b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  2005-10-04 
07:2
:34.000000000 +0800
+++ linux-b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c 2005-11-11 
21:21:34.000
00000 +0800
@@ -979,10 +979,19 @@
            problem case, so we can delete the conntrack
            immediately.  --RR */
         if (th->rst) {
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+            /*maybe we don't need to care this condition 
anymore,Rusty?since we take care of holepunch and hairpin!*/
+            if(conntrack->status & IPS_SNATP2P_SRC_DONE){
+                timeout = 2 MINS;
+                ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
+                return NF_DROP;
+            }
+#else
             if (del_timer(&conntrack->timeout))
                 conntrack->timeout.function((unsigned long)
                                 conntrack);
             return NF_ACCEPT;
+#endif
         }
     } else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
            && (old_state == TCP_CONNTRACK_SYN_RECV
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_nat
_core.c linux-b/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_core.c     2005-10-04 
07:27:34.0000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_core.c    2005-11-09 
17:29:24.000000000 +0
800
@@ -1,4 +1,4 @@
 /* (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
@@ -47,6 +47,11 @@
 static unsigned int ip_nat_htable_size;
 static struct list_head *bysource;
+
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static struct list_head *by_modified_source;
+#endif
+
 struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];

@@ -59,6 +64,16 @@
                            tuple->dst.protonum, 0) % ip_nat_htable_size;
 }
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static inline unsigned int
+hash_by_dst(const struct ip_conntrack_tuple *tuple)
+{
+       /* Original src, to ensure we map it consistently if poss. */
+       return jhash_3words(tuple->dst.ip, tuple->dst.u.all,
+                           tuple->dst.protonum, 0) % ip_nat_htable_size;
+}
+#endif
+
 /* Noone using conntrack by the time this called. */
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
@@ -67,6 +82,10 @@
        write_lock_bh(&ip_nat_lock);
        list_del(&conn->nat.info.bysource);
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+        if ((conn->status & IPS_SNATP2P_MASK) && (conn->status & 
IPS_SNATP2P_DONE_MASK))
+                list_del(&conn->nat.info.by_modified_source);
+#endif
        write_unlock_bh(&ip_nat_lock);
 }
@@ -93,6 +112,14 @@
           We could keep a separate hash if this proves too slow. */
        struct ip_conntrack_tuple reply;
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+    if((ignored_conntrack->status & IPS_SNATP2P_SRC)
+                     && !(ignored_conntrack->status & 
IPS_SNATP2P_SRC_DONE))
+        if (modified_src_occupied(tuple,ignored_conntrack))
+            return 1;
+#endif
+
+
        invert_tuplepr(&reply, tuple);
        return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
@@ -160,6 +187,77 @@
        return 0;
 }
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static inline int
+same_modified_src(const struct ip_conntrack *ct,
+        const struct ip_conntrack_tuple *tuple)
+{
+       if (ct->status & IPS_SNATP2P_DST)
+           return (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
+                   == tuple->dst.protonum
+                   && ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip
+                   == tuple->src.ip
+                   && ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.all
+                   == tuple->src.u.all);
+       else
+       /*must be ct->status & IPS_SNATP2P_SRC*/
+           return (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum
+                   == tuple->dst.protonum
+                   && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip
+                   == tuple->src.ip
+                   && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
+                   == tuple->src.u.all);
+}
+
+static int
+modified_src_occupied(const struct ip_conntrack_tuple *tuple,
+                    const struct ip_conntrack *conntrack)
+{
+       unsigned int h = hash_by_src(tuple);
+       struct ip_conntrack *ct;
+
+       read_lock_bh(&ip_nat_lock);
+       list_for_each_entry(ct, &by_modified_source[h], 
nat.info.by_modified_source) {
+               if (same_modified_src(ct, tuple)) {
+                       if (same_src(ct, 
&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+                           /*that's an appropriate source*/
+                           next;
+                       read_unlock_bh(&ip_nat_lock);
+                       return 1;
+               }
+       }
+       read_unlock_bh(&ip_nat_lock);
+       return 0;
+}
+
+int
+find_appropriate_p2p_dst(const struct ip_conntrack_tuple *tuple,
+                    struct ip_conntrack_tuple *result)
+{
+       unsigned int h = hash_by_src(tuple);
+       struct ip_conntrack *ct;
+
+       read_lock_bh(&ip_nat_lock);
+       list_for
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_nat
_rule.c linux-b/net/ipv4/netfilter/ip_nat_rule.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_rule.c     2005-10-04 
07:27:34.0000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_rule.c    2005-11-07 
21:26:44.000000000 +0
800
@@ -267,9 +267,30 @@
        ret = ipt_do_table(pskb, hooknum, in, out, &nat_table, NULL);
        if (ret == NF_ACCEPT) {
-               if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
-                       /* NUL mapping */
-                       ret = alloc_null_binding(ct, info, hooknum);
+           if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum))){
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+               if ((HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST)){
+                   struct ip_conntrack_tuple reply_tuple, new_tuple;
+                   invert_tuplepr(&reply_tuple,
+                       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+                   if (find_appropriate_p2p_dst(&reply_tuple, &new_tuple){
+                       struct ip_nat_range range;
+                       /* This must be a fresh one. */
+                       BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+                       ct->status |= IPS_SNATP2P_DST;
+                       range.flags = (IP_NAT_RANGE_MAP_IPS | 
IP_NAT_RANGE_PROTO_SPECIFIED);
+                       range.min = range.max = new_tuple.dst.u;
+                       range.min_ip = range.max_ip
+                           = new_tuple.dst.ip;
+                       ret = ip_nat_setup_info(ct, &range, 
NF_IP_PRE_ROUTING);
+                   }
+               }
+               if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
+
+#endif
+                /* NUL mapping */
+                           ret = alloc_null_binding(ct, info, hooknum);
+           }
        }
        return ret;
 }
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_na
_standalone.c linux-b/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_standalone.c       2005-10-04 
07:2
:34.000000000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_standalone.c      2005-11-07 
21:28:10.000
00000 +0800
@@ -393,6 +393,9 @@
 module_init(init);
 module_exit(fini);
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+EXPORT_SYMBOL(find_appropriate_p2p_dst);
+#endif
 EXPORT_SYMBOL(ip_nat_setup_info);
 EXPORT_SYMBOL(ip_nat_protocol_register);
 EXPORT_SYMBOL(ip_nat_protocol_unregister);
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ipt_S
ATP2P.c linux-b/net/ipv4/netfilter/ipt_SNATP2P.c
--- linux-2.6.13.3/net/ipv4/netfilter/ipt_SNATP2P.c     1970-01-01 
08:00:00.000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ipt_SNATP2P.c    2005-11-11 
20:12:02.000000000 +
800
@@ -0,0 +1,95 @@
+/* This is a module which is used for source-NAT-P2P.
+ */
+#include <linux/netfilter_ipv4.h>
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_core.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+
+static unsigned int ipt_snatp2p_target(struct sk_buff **pskb,
+                                   const struct net_device *in,
+                                   const struct net_device *out,
+                                   unsigned int hooknum,
+                                   const void *targinfo,
+                                   void *userinfo)
+{
+       struct ip_conntrack *ct;
+       enum ip_conntrack_info ctinfo;
+       const struct ip_nat_multi_range_compat *mr = targinfo;
+
+       IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
+
+       ct = ip_conntrack_get(*pskb, &ctinfo);
+
+       /* Connection must be valid and new. */
+       IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED
+                           || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
+       IP_NF_ASSERT(out);
+       ct->status |= IPS_SNATP2P_SRC;
+       return ip_nat_setup_info(ct, &mr->range[0], hooknum);
+}
+
+static int ipt_snatp2p_checkentry(const char *tablename,
+                              const struct ipt_entry *e,
+                              void *targinfo,
+                              unsigned int targinfosize,
+                              unsigned int hook_mask)
+{
+       struct ip_nat_multi_range_compat *mr = targinfo;
+
+       /* Must be a valid range */
+       if (mr->rangesize != 1) {
+               printk("SNATP2P: multiple ranges no longer supported\n");
+               return 0;
+       }
+
+       if (targinfosize != IPT_ALIGN(sizeof(struct 
ip_nat_multi_range_compat))
 {
+               DEBUGP("SNATP2P: Target size %u wrong for %u ranges\n",
+                      targinfosize, mr->rangesize);
+               return 0;
+       }
+
+       /* Only allow these for NAT. */
+       if (strcmp(tablename, "nat") != 0) {
+               DEBUGP("SNATP2P: wrong table %s\n", tablename);
+               return 0;
+       }
+
+       if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
+               DEBUGP("SNATP2P: hook mask 0x%x bad\n", hook_mask);
+               return 0;
+       }
+       return 1;
+}
+
+static struct ipt_target ipt_snatp2p_reg = {
+       .name           = "SNATP2P",
+       .target         = ipt_snatp2p_target,
+       .checkentry     = ipt_snatp2p_checkentry,
+};
+
+static int __init init(void)
+{
+       if (ipt_register_target(&ipt_snatp2p_reg))
+               return -EINVAL;
+
+       return 0;
+}
+
+static void __exit fini(void)
+{
+       ipt_unregister_target(&ipt_snatp2p_reg);
+}
+
+module_init(init);
+module_exit(fini);
-------------Second Part------------
diff -Nur iptables-1.3.4/extensions/libi
t_SNATP2P.c iptables-b/extensions/libipt_SNATP2P.c
--- iptables-1.3.4/extensions/libipt_SNATP2P.c  1970-01-01 
08:00:00.000000000 +
800
+++ iptables-b/extensions/libipt_SNATP2P.c      2005-11-09 
17:32:58.000000000 +
800
@@ -0,0 +1,249 @@
+/* Shared library add-on to iptables to add source-NAT-P2P support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+/* Source NAT data consists of a multi-range, indicating where to map
+   to. */
+struct ipt_natinfo
+{
+       struct ipt_entry_target t;
+       struct ip_nat_multi_range mr;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+       printf(
+"SNATP2P v%s options:\n"
+" --to-source <ipaddr>[-<ipaddr>][:port-port]\n"
+"                              Address to map source to.\n"
+"                              (You can use this more than once)\n\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+       { "to-source", 1, 0, '1' },
+       { 0 }
+};
+
+static struct ipt_natinfo *
+append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
+{
+       unsigned int size;
+
+       /* One rangesize already in struct ipt_natinfo */
+       size = IPT_ALIGN(sizeof(*info) + info->mr.rangesize * 
sizeof(*range));
+
+       info = realloc(info, size);
+       if (!info)
+               exit_error(OTHER_PROBLEM, "Out of memory\n");
+
+       info->t.u.target_size = size;
+       info->mr.range[info->mr.rangesize] = *range;
+       info->mr.rangesize++;
+
+       return info;
+}
+
+/* Ranges expected in network order. */
+static struct ipt_entry_target *
+parse_to(char *arg, int portok, struct ipt_natinfo *info)
+{
+       struct ip_nat_range range;
+       char *colon, *dash, *error;
+       struct in_addr *ip;
+
+       memset(&range, 0, sizeof(range));
+       colon = strchr(arg, ':');
+
+       if (colon) {
+               int port;
+
+               if (!portok)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Need TCP or UDP with port 
specification");
+
+               range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+
+               port = atoi(colon+1);
+               if (port <= 0 || port > 65535)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Port `%s' not valid\n", colon+1);
+
+               error = strchr(colon+1, ':');
+               if (error)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Invalid port:port syntax - use dash\n");
+
+               dash = strchr(colon, '-');
+               if (!dash) {
+                       range.min.tcp.port
+                               = range.max.tcp.port
+                               = htons(port);
+               } else {
+                       int maxport;
+
+                       maxport = atoi(dash + 1);
+                       if (maxport <= 0 || maxport > 65535)
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Port `%s' not valid\n", dash+1);
+                       if (maxport < port)
+                               /* People are stupid. */
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Port range `%s' funky\n", 
colon+1);
+                       range.min.tcp.port = htons(port);
+                       range.max.tcp.port = htons(maxport);
+               }
+               /* Starts with a colon? No IP info...*/
+               if (colon == arg)
+                       return &(append_range(info, &range)->t);
+               *colon = '\0';
+       }
+
+       range.flags |= IP_NAT_RANGE_MAP_IPS;
+       dash = strchr(arg, '-');
+       if (colon && dash && dash > colon)
+               dash = NULL;
+
+       if (dash)
+               *dash = '\0';
+
+       ip = dotted_to_addr(arg);
+       if (!ip)
+               exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+                          arg);
+       range.min_ip = ip->s_addr;
+       if (dash) {
+               ip = dotted_to_addr(dash+1);
+               if (!ip)
+                       exit_error(PARAMETER_PROBLEM, "Bad IP address 
`%s'\n",
+                                  dash+1);
+               range.max_ip = ip->s_addr;
+       } else
+               range.max_ip = range.min_ip;
+
+       return &(append_range(info, &range)->t);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+       struct ipt_natinfo *info = (void *)*target;
+       int portok;
+
+       if (entry->ip.proto == IPPROTO_TCP
+           || entry->ip.proto == IPPROTO_UDP
+           || entry->ip.proto == IPPROTO_ICMP)
+               portok = 1;
+       else
+               portok = 0;
+
+       switch (c) {
+       case '1':
+               if (check_inverse(optarg, &invert, NULL, 0))
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Unexpected `!' after --to-source");
+
+               if (*flags) {
+                       if (!kernel_version)
+                               get_kernel_version();
+                       if (kernel_version > LINUX_VERSION(2, 6, 10))
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Multiple --to-source not 
supported"
;
+               }
+               *target = parse_to(optarg, portok, info);
+               *flags = 1;
+               return 1;
+
+       default:
+               return 0;
+       }
+}
+
+/* Final check; must have specfied --to-source. */
+static void final_check(unsigned int flags)
+{
+       if (!flags)
+               exit_error(PARAMETER_PROBLEM,
+                          "You must specify --to-source");
+}
+
+static void print_range(const struct ip_nat_range *r)
+{
+       if (r->flags & IP_NAT_RANGE_MAP_IPS) {
+               struct in_addr a;
+
+               a.s_addr = r->min_ip;
+               printf("%s", addr_to_dotted(&a));
+               if (r->max_ip != r->min_ip) {
+                       a.s_addr = r->max_ip;
+                       printf("-%s", addr_to_dotted(&a));
+               }
+       }
+       if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+               printf(":");
+               printf("%hu", ntohs(r->min.tcp.port));
+               if (r->max.tcp.port != r->min.tcp.port)
+                       printf("-%hu", ntohs(r->max.tcp.port));
+       }
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+       struct ipt_natinfo *info = (void *)target;
+       unsigned int i = 0;
+
+       printf("to:");
+       for (i = 0; i < info->mr.rangesize; i++) {
+               print_range(&info->mr.range[i]);
+               printf(" ");
+       }
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+       struct ipt_natinfo *info = (void *)target;
+       unsigned int i = 0;
+
+       for (i = 0; i < info->mr.rangesize; i++) {
+               printf("--to-source ");
+               print_range(&info->mr.range[i]);
+               printf(" ");
+       }
+}
+
+static struct iptables_target snatp2p = {
+       .next           = NULL,
+       .name           = "SNATP2P",
+       .version        = IPTABLES_VERSION,
+       .size           = IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
+       .userspacesize  = IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
+       .help           = &help,
+       .parse          = &parse,
+       .final_check    = &final_check,
+       .print          = &print,
+       .save           = &save,
+       .extra_opts     = opts
+};
+
+void _init(void)
+{
+       register_target(&snatp2p);
+} 

------=_NextPart_000_0019_01C61AFC.B22CD080
Content-Type: application/octet-stream;
	name="Netfilter_P2P_Implement_Patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Netfilter_P2P_Implement_Patch"

-------------first part--------------
diff -Nur linux-2.6.13.3/include/linux/netfilter_i
pv4/ip_conntrack.h linux-b/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.13.3/include/linux/netfilter_ipv4/ip_conntrack.h  =
2005-10-04 07:27
:34.000000000 +0800
+++ linux-b/include/linux/netfilter_ipv4/ip_conntrack.h 2005-11-02 =
18:11:00.0000
00000 +0800
@@ -65,6 +65,27 @@

        /* Both together */
        IPS_NAT_DONE_MASK =3D (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+       IPS_SNATP2P_SRC_BIT =3D 9,
+       IPS_SNATP2P_SRC =3D (1 << IPS_SNATP2P_SRC_BIT),
+
+       IPS_SNATP2P_DST_BIT =3D 10,
+       IPS_SNATP2P_DST =3D (1 << IPS_SNATP2P_DST_BIT),
+
+        /* Both together. */
+       IPS_SNATP2P_MASK =3D (IPS_SNATP2P_DST | IPS_SNATP2P_SRC),
+
+        IPS_SNATP2P_SRC_DONE_BIT =3D 11,
+       IPS_SNATP2P_SRC_DONE =3D (1 << IPS_SNATP2P_SRC_DONE_BIT),
+
+        IPS_SNATP2P_DST_DONE_BIT =3D 12,
+       IPS_SNATP2P_DST_DONE =3D (1 << IPS_SNATP2P_DST_DONE_BIT),
+
+        /* Both together. */
+       IPS_SNATP2P_DONE_MASK =3D (IPS_SNATP2P_DST_DONE | =
IPS_SNATP2P_SRC_DONE),
+#endif
+
 };

 #ifdef __KERNEL__
diff -Nur linux-2.6.13.3/include/linux/netfilter_i
pv4/ip_nat.h linux-b/include/linux/netfilter_ipv4/ip_nat.h
--- linux-2.6.13.3/include/linux/netfilter_ipv4/ip_nat.h        =
2005-10-04 07:27
:34.000000000 +0800
+++ linux-b/include/linux/netfilter_ipv4/ip_nat.h       2005-11-07 =
21:28:32.0000
00000 +0800
@@ -59,6 +59,10 @@
 {
        struct list_head bysource;

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+    struct list_head by_modified_source;
+#endif
+
        /* Helper (NULL if none). */
        struct ip_nat_helper *helper;

@@ -76,6 +80,11 @@
 extern int ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
                             const struct ip_conntrack =
*ignored_conntrack);

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+extern int find_appropriate_p2p_dst(const struct ip_conntrack_tuple =
*tuple,
+                    struct ip_conntrack_tuple *result);
+#endif
+
 /* Calculate relative checksum. */
 extern u_int16_t ip_nat_cheat_check(u_int32_t oldvalinv,
                                    u_int32_t newval,
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/Kconf
g linux-b/net/ipv4/netfilter/Kconfig
--- linux-2.6.13.3/net/ipv4/netfilter/Kconfig   2005-10-04 =
07:27:34.000000000 +
800
+++ linux-b/net/ipv4/netfilter/Kconfig  2005-11-09 17:11:10.000000000 =
+0800
@@ -484,6 +484,14 @@

          To compile it as a module, choose M here.  If unsure, say N.

+config IP_NF_TARGET_SNATP2P
+    tristate "SNATP2P target support"
+       depends on IP_NF_NAT
+       help
+         SNATP2P is an implementation for P2P need.
+
+         To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_NETMAP
        tristate "NETMAP target support"
        depends on IP_NF_NAT
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/Makef
le linux-b/net/ipv4/netfilter/Makefile
--- linux-2.6.13.3/net/ipv4/netfilter/Makefile  2005-10-04 =
07:27:34.000000000 +
800
+++ linux-b/net/ipv4/netfilter/Makefile 2005-11-09 17:13:00.000000000 =
+0800
@@ -68,6 +68,7 @@
 obj-$(CONFIG_IP_NF_TARGET_MARK) +=3D ipt_MARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) +=3D ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_SNATP2P) +=3D ipt_SNATP2P.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) +=3D ipt_NETMAP.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) +=3D ipt_SAME.o
 obj-$(CONFIG_IP_NF_TARGET_CLASSIFY) +=3D ipt_CLASSIFY.o
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_co
ntrack_proto_tcp.c linux-b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  =
2005-10-04 07:2
:34.000000000 +0800
+++ linux-b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c 2005-11-11 =
21:21:34.000
00000 +0800
@@ -979,10 +979,19 @@
            problem case, so we can delete the conntrack
            immediately.  --RR */
         if (th->rst) {
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+            /*maybe we don't need to care this condition =
anymore,Rusty?since we take care of holepunch and hairpin!*/
+            if(conntrack->status & IPS_SNATP2P_SRC_DONE){
+                timeout =3D 2 MINS;
+                ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
+                return NF_DROP;
+            }
+#else
             if (del_timer(&conntrack->timeout))
                 conntrack->timeout.function((unsigned long)
                                 conntrack);
             return NF_ACCEPT;
+#endif
         }
     } else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
            && (old_state =3D=3D TCP_CONNTRACK_SYN_RECV
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_nat
_core.c linux-b/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_core.c     2005-10-04 =
07:27:34.0000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_core.c    2005-11-09 =
17:29:24.000000000 +0
800
@@ -1,4 +1,4 @@

 /* (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
@@ -47,6 +47,11 @@
 static unsigned int ip_nat_htable_size;

 static struct list_head *bysource;
+
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static struct list_head *by_modified_source;
+#endif
+
 struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];


@@ -59,6 +64,16 @@
                            tuple->dst.protonum, 0) % =
ip_nat_htable_size;
 }

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static inline unsigned int
+hash_by_dst(const struct ip_conntrack_tuple *tuple)
+{
+       /* Original src, to ensure we map it consistently if poss. */
+       return jhash_3words(tuple->dst.ip, tuple->dst.u.all,
+                           tuple->dst.protonum, 0) % =
ip_nat_htable_size;
+}
+#endif
+
 /* Noone using conntrack by the time this called. */
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
@@ -67,6 +82,10 @@

        write_lock_bh(&ip_nat_lock);
        list_del(&conn->nat.info.bysource);
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+        if ((conn->status & IPS_SNATP2P_MASK) && (conn->status & =
IPS_SNATP2P_DONE_MASK))
+                list_del(&conn->nat.info.by_modified_source);
+#endif
        write_unlock_bh(&ip_nat_lock);
 }

@@ -93,6 +112,14 @@
           We could keep a separate hash if this proves too slow. */
        struct ip_conntrack_tuple reply;

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+    if((ignored_conntrack->status & IPS_SNATP2P_SRC)
+                     && !(ignored_conntrack->status & =
IPS_SNATP2P_SRC_DONE))
+        if (modified_src_occupied(tuple,ignored_conntrack))
+            return 1;
+#endif
+
+
        invert_tuplepr(&reply, tuple);
        return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
@@ -160,6 +187,77 @@
        return 0;
 }

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+static inline int
+same_modified_src(const struct ip_conntrack *ct,
+        const struct ip_conntrack_tuple *tuple)
+{
+       if (ct->status & IPS_SNATP2P_DST)
+           return (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
+                   =3D=3D tuple->dst.protonum
+                   && ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip
+                   =3D=3D tuple->src.ip
+                   && ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.all
+                   =3D=3D tuple->src.u.all);
+       else
+       /*must be ct->status & IPS_SNATP2P_SRC*/
+           return (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum
+                   =3D=3D tuple->dst.protonum
+                   && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip
+                   =3D=3D tuple->src.ip
+                   && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
+                   =3D=3D tuple->src.u.all);
+}
+
+static int
+modified_src_occupied(const struct ip_conntrack_tuple *tuple,
+                    const struct ip_conntrack *conntrack)
+{
+       unsigned int h =3D hash_by_src(tuple);
+       struct ip_conntrack *ct;
+
+       read_lock_bh(&ip_nat_lock);
+       list_for_each_entry(ct, &by_modified_source[h], =
nat.info.by_modified_source) {
+               if (same_modified_src(ct, tuple)) {
+                       if (same_src(ct, =
&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+                           /*that's an appropriate source*/
+                           next;
+                       read_unlock_bh(&ip_nat_lock);
+                       return 1;
+               }
+       }
+       read_unlock_bh(&ip_nat_lock);
+       return 0;
+}
+
+int
+find_appropriate_p2p_dst(const struct ip_conntrack_tuple *tuple,
+                    struct ip_conntrack_tuple *result)
+{
+       unsigned int h =3D hash_by_src(tuple);
+       struct ip_conntrack *ct;
+
+       read_lock_bh(&ip_nat_lock);
+       list_for
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_nat
_rule.c linux-b/net/ipv4/netfilter/ip_nat_rule.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_rule.c     2005-10-04 =
07:27:34.0000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_rule.c    2005-11-07 =
21:26:44.000000000 +0
800
@@ -267,9 +267,30 @@
        ret =3D ipt_do_table(pskb, hooknum, in, out, &nat_table, NULL);

        if (ret =3D=3D NF_ACCEPT) {
-               if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
-                       /* NUL mapping */
-                       ret =3D alloc_null_binding(ct, info, hooknum);
+           if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum))){
+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+               if ((HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST)){
+                   struct ip_conntrack_tuple reply_tuple, new_tuple;
+                   invert_tuplepr(&reply_tuple,
+                       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+                   if (find_appropriate_p2p_dst(&reply_tuple, =
&new_tuple){
+                       struct ip_nat_range range;
+                       /* This must be a fresh one. */
+                       BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+                       ct->status |=3D IPS_SNATP2P_DST;
+                       range.flags =3D (IP_NAT_RANGE_MAP_IPS | =
IP_NAT_RANGE_PROTO_SPECIFIED);
+                       range.min =3D range.max =3D new_tuple.dst.u;
+                       range.min_ip =3D range.max_ip
+                           =3D new_tuple.dst.ip;
+                       ret =3D ip_nat_setup_info(ct, &range, =
NF_IP_PRE_ROUTING);
+                   }
+               }
+               if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
+
+#endif
+                /* NUL mapping */
+                           ret =3D alloc_null_binding(ct, info, =
hooknum);
+           }
        }
        return ret;
 }
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ip_na
_standalone.c linux-b/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.6.13.3/net/ipv4/netfilter/ip_nat_standalone.c       =
2005-10-04 07:2
:34.000000000 +0800
+++ linux-b/net/ipv4/netfilter/ip_nat_standalone.c      2005-11-07 =
21:28:10.000
00000 +0800
@@ -393,6 +393,9 @@
 module_init(init);
 module_exit(fini);

+#if defined(CONFIG_IP_NF_TARGET_SNATP2P)
+EXPORT_SYMBOL(find_appropriate_p2p_dst);
+#endif
 EXPORT_SYMBOL(ip_nat_setup_info);
 EXPORT_SYMBOL(ip_nat_protocol_register);
 EXPORT_SYMBOL(ip_nat_protocol_unregister);
diff -Nur linux-2.6.13.3/net/ipv4/netfilter/ipt_S
ATP2P.c linux-b/net/ipv4/netfilter/ipt_SNATP2P.c
--- linux-2.6.13.3/net/ipv4/netfilter/ipt_SNATP2P.c     1970-01-01 =
08:00:00.000
00000 +0800
+++ linux-b/net/ipv4/netfilter/ipt_SNATP2P.c    2005-11-11 =
20:12:02.000000000 +
800
@@ -0,0 +1,95 @@
+/* This is a module which is used for source-NAT-P2P.
+ * with concept helped by Rusty Russel <rusty@rustcorp.com.au>
+ * and with code by Jesse Peng <tzuhsi.peng@msa.hinet.net>
+ */
+#include <linux/netfilter_ipv4.h>
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_core.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+
+static unsigned int ipt_snatp2p_target(struct sk_buff **pskb,
+                                   const struct net_device *in,
+                                   const struct net_device *out,
+                                   unsigned int hooknum,
+                                   const void *targinfo,
+                                   void *userinfo)
+{
+       struct ip_conntrack *ct;
+       enum ip_conntrack_info ctinfo;
+       const struct ip_nat_multi_range_compat *mr =3D targinfo;
+
+       IP_NF_ASSERT(hooknum =3D=3D NF_IP_POST_ROUTING);
+
+       ct =3D ip_conntrack_get(*pskb, &ctinfo);
+
+       /* Connection must be valid and new. */
+       IP_NF_ASSERT(ct && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D =
IP_CT_RELATED
+                           || ctinfo =3D=3D IP_CT_RELATED + =
IP_CT_IS_REPLY));
+       IP_NF_ASSERT(out);
+       ct->status |=3D IPS_SNATP2P_SRC;
+       return ip_nat_setup_info(ct, &mr->range[0], hooknum);
+}
+
+static int ipt_snatp2p_checkentry(const char *tablename,
+                              const struct ipt_entry *e,
+                              void *targinfo,
+                              unsigned int targinfosize,
+                              unsigned int hook_mask)
+{
+       struct ip_nat_multi_range_compat *mr =3D targinfo;
+
+       /* Must be a valid range */
+       if (mr->rangesize !=3D 1) {
+               printk("SNATP2P: multiple ranges no longer =
supported\n");
+               return 0;
+       }
+
+       if (targinfosize !=3D IPT_ALIGN(sizeof(struct =
ip_nat_multi_range_compat))
 {
+               DEBUGP("SNATP2P: Target size %u wrong for %u ranges\n",
+                      targinfosize, mr->rangesize);
+               return 0;
+       }
+
+       /* Only allow these for NAT. */
+       if (strcmp(tablename, "nat") !=3D 0) {
+               DEBUGP("SNATP2P: wrong table %s\n", tablename);
+               return 0;
+       }
+
+       if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
+               DEBUGP("SNATP2P: hook mask 0x%x bad\n", hook_mask);
+               return 0;
+       }
+       return 1;
+}
+
+static struct ipt_target ipt_snatp2p_reg =3D {
+       .name           =3D "SNATP2P",
+       .target         =3D ipt_snatp2p_target,
+       .checkentry     =3D ipt_snatp2p_checkentry,
+};
+
+static int __init init(void)
+{
+       if (ipt_register_target(&ipt_snatp2p_reg))
+               return -EINVAL;
+
+       return 0;
+}
+
+static void __exit fini(void)
+{
+       ipt_unregister_target(&ipt_snatp2p_reg);
+}
+
+module_init(init);
+module_exit(fini);

-------------Second Part------------
diff -Nur iptables-1.3.4/extensions/libi
t_SNATP2P.c iptables-b/extensions/libipt_SNATP2P.c
--- iptables-1.3.4/extensions/libipt_SNATP2P.c  1970-01-01 =
08:00:00.000000000 +
800
+++ iptables-b/extensions/libipt_SNATP2P.c      2005-11-09 =
17:32:58.000000000 +
800
@@ -0,0 +1,249 @@
+/* Shared library add-on to iptables to add source-NAT-P2P support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+/* Source NAT data consists of a multi-range, indicating where to map
+   to. */
+struct ipt_natinfo
+{
+       struct ipt_entry_target t;
+       struct ip_nat_multi_range mr;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+       printf(
+"SNATP2P v%s options:\n"
+" --to-source <ipaddr>[-<ipaddr>][:port-port]\n"
+"                              Address to map source to.\n"
+"                              (You can use this more than once)\n\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] =3D {
+       { "to-source", 1, 0, '1' },
+       { 0 }
+};
+
+static struct ipt_natinfo *
+append_range(struct ipt_natinfo *info, const struct ip_nat_range =
*range)
+{
+       unsigned int size;
+
+       /* One rangesize already in struct ipt_natinfo */
+       size =3D IPT_ALIGN(sizeof(*info) + info->mr.rangesize * =
sizeof(*range));
+
+       info =3D realloc(info, size);
+       if (!info)
+               exit_error(OTHER_PROBLEM, "Out of memory\n");
+
+       info->t.u.target_size =3D size;
+       info->mr.range[info->mr.rangesize] =3D *range;
+       info->mr.rangesize++;
+
+       return info;
+}
+
+/* Ranges expected in network order. */
+static struct ipt_entry_target *
+parse_to(char *arg, int portok, struct ipt_natinfo *info)
+{
+       struct ip_nat_range range;
+       char *colon, *dash, *error;
+       struct in_addr *ip;
+
+       memset(&range, 0, sizeof(range));
+       colon =3D strchr(arg, ':');
+
+       if (colon) {
+               int port;
+
+               if (!portok)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Need TCP or UDP with port =
specification");
+
+               range.flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
+
+               port =3D atoi(colon+1);
+               if (port <=3D 0 || port > 65535)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Port `%s' not valid\n", colon+1);
+
+               error =3D strchr(colon+1, ':');
+               if (error)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Invalid port:port syntax - use =
dash\n");
+
+               dash =3D strchr(colon, '-');
+               if (!dash) {
+                       range.min.tcp.port
+                               =3D range.max.tcp.port
+                               =3D htons(port);
+               } else {
+                       int maxport;
+
+                       maxport =3D atoi(dash + 1);
+                       if (maxport <=3D 0 || maxport > 65535)
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Port `%s' not valid\n", =
dash+1);
+                       if (maxport < port)
+                               /* People are stupid. */
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Port range `%s' funky\n", =
colon+1);
+                       range.min.tcp.port =3D htons(port);
+                       range.max.tcp.port =3D htons(maxport);
+               }
+               /* Starts with a colon? No IP info...*/
+               if (colon =3D=3D arg)
+                       return &(append_range(info, &range)->t);
+               *colon =3D '\0';
+       }
+
+       range.flags |=3D IP_NAT_RANGE_MAP_IPS;
+       dash =3D strchr(arg, '-');
+       if (colon && dash && dash > colon)
+               dash =3D NULL;
+
+       if (dash)
+               *dash =3D '\0';
+
+       ip =3D dotted_to_addr(arg);
+       if (!ip)
+               exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+                          arg);
+       range.min_ip =3D ip->s_addr;
+       if (dash) {
+               ip =3D dotted_to_addr(dash+1);
+               if (!ip)
+                       exit_error(PARAMETER_PROBLEM, "Bad IP address =
`%s'\n",
+                                  dash+1);
+               range.max_ip =3D ip->s_addr;
+       } else
+               range.max_ip =3D range.min_ip;
+
+       return &(append_range(info, &range)->t);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+       struct ipt_natinfo *info =3D (void *)*target;
+       int portok;
+
+       if (entry->ip.proto =3D=3D IPPROTO_TCP
+           || entry->ip.proto =3D=3D IPPROTO_UDP
+           || entry->ip.proto =3D=3D IPPROTO_ICMP)
+               portok =3D 1;
+       else
+               portok =3D 0;
+
+       switch (c) {
+       case '1':
+               if (check_inverse(optarg, &invert, NULL, 0))
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Unexpected `!' after --to-source");
+
+               if (*flags) {
+                       if (!kernel_version)
+                               get_kernel_version();
+                       if (kernel_version > LINUX_VERSION(2, 6, 10))
+                               exit_error(PARAMETER_PROBLEM,
+                                          "Multiple --to-source not =
supported"
;
+               }
+               *target =3D parse_to(optarg, portok, info);
+               *flags =3D 1;
+               return 1;
+
+       default:
+               return 0;
+       }
+}
+
+/* Final check; must have specfied --to-source. */
+static void final_check(unsigned int flags)
+{
+       if (!flags)
+               exit_error(PARAMETER_PROBLEM,
+                          "You must specify --to-source");
+}
+
+static void print_range(const struct ip_nat_range *r)
+{
+       if (r->flags & IP_NAT_RANGE_MAP_IPS) {
+               struct in_addr a;
+
+               a.s_addr =3D r->min_ip;
+               printf("%s", addr_to_dotted(&a));
+               if (r->max_ip !=3D r->min_ip) {
+                       a.s_addr =3D r->max_ip;
+                       printf("-%s", addr_to_dotted(&a));
+               }
+       }
+       if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+               printf(":");
+               printf("%hu", ntohs(r->min.tcp.port));
+               if (r->max.tcp.port !=3D r->min.tcp.port)
+                       printf("-%hu", ntohs(r->max.tcp.port));
+       }
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+       struct ipt_natinfo *info =3D (void *)target;
+       unsigned int i =3D 0;
+
+       printf("to:");
+       for (i =3D 0; i < info->mr.rangesize; i++) {
+               print_range(&info->mr.range[i]);
+               printf(" ");
+       }
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+       struct ipt_natinfo *info =3D (void *)target;
+       unsigned int i =3D 0;
+
+       for (i =3D 0; i < info->mr.rangesize; i++) {
+               printf("--to-source ");
+               print_range(&info->mr.range[i]);
+               printf(" ");
+       }
+}
+
+static struct iptables_target snatp2p =3D {
+       .next           =3D NULL,
+       .name           =3D "SNATP2P",
+       .version        =3D IPTABLES_VERSION,
+       .size           =3D IPT_ALIGN(sizeof(struct =
ip_nat_multi_range)),
+       .userspacesize  =3D IPT_ALIGN(sizeof(struct =
ip_nat_multi_range)),
+       .help           =3D &help,
+       .parse          =3D &parse,
+       .final_check    =3D &final_check,
+       .print          =3D &print,
+       .save           =3D &save,
+       .extra_opts     =3D opts
+};
+
+void _init(void)
+{
+       register_target(&snatp2p);
+}                                            
------=_NextPart_000_0019_01C61AFC.B22CD080--
