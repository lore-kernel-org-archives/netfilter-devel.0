From: Vivek Kashyap <vivk@us.ibm.com>
Subject: [PATCH] RANGEMARK target
Date: Mon, 27 Oct 2003 14:57:28 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310232237350.1079-100000@w-vkashyap95.beaverton.ibm.com>
References: <20030921222853.GA30961@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030921222853.GA30961@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I wanted to MARK packets dynamically within a certain range. 
Implemented a target as follows :

-j RANGEMARK --set-rangemark <base>[-<limit>[.<s>][:r|h[,S|O|A]]]

where,
	<base> and <limit> define the range (inclusive)
	<s> is the size of the increment (default 1)
	r => random (default)
	h => porthash (if relevant protocol)
	S => set the value (default)
	O => OR it to existing value
	A => AND to existing value

The mark value can be set within the given range (<base> to <limit>)
in steps of <s> based on a given policy e.g. random. Additionally, if
<base> and <limit> are suitably chosen one could set specific
bitvalues and then OR/AND them to create 'composite' MARK values between 
rules if needed. Needless to say that additional policies can be added (I
needed random).

If none of the optional values  are used then it defaults to MARK. 

Please comment. I'll then update with necessary changes and also
add ip6t_* target. 

Thanks,
	Vivek

------------------------------------------------------------------------

diff -urN iptables-1.2.9rc1.orig/extensions/libipt_RANGEMARK.c iptables-1.2.9rc1/extensions/libipt_RANGEMARK.c
--- iptables-1.2.9rc1.orig/extensions/libipt_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/extensions/libipt_RANGEMARK.c	2003-10-27 11:21:07.000000000 -0800
@@ -0,0 +1,300 @@
+/* Shared library add-on to iptables to add RANGEMARK target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_RANGEMARK.h>
+
+struct rangemarkinfo {
+    struct ipt_entry_target t;
+    struct ipt_rangemark_target_info rangemark;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+    printf(
+"RANGEMARK target v%s options:\n"
+"  --set-rangemark base[-limit[.s][:r]][,S|O|A]] Set random nfmark within range"
+"\n"
+"  --set-rangemark base[-limit[.s][:h]][,S|O|A]] Set nfmark based on ports"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+    { "set-rangemark", 1, 0, '1' },
+    { 0 }
+};
+
+static char *
+get_val(char *s, unsigned long *val)
+{
+    char *ep = s;
+    
+    if (NULL == s)
+        return NULL;
+
+    if (*s == '\0') 
+        exit_error(PARAMETER_PROBLEM, "Invalid base-limit specified");
+
+    while(isalnum(*ep++));
+
+    /*
+     * Out of range values are clipped at ULONG_MAX
+     */
+    *val  = strtoul(s,&ep,0);
+
+    return ep;
+}
+
+static char *
+get_baseval(char *s, unsigned long *val, unsigned int *flags)
+{
+    if (*flags & RANGEMARK_FLAG_BASE)
+        exit_error(PARAMETER_PROBLEM, "set-rangemark: Base specified twice");
+
+    *flags |= RANGEMARK_FLAG_BASE;
+
+    return get_val(s, val);
+}
+
+static char *
+get_limitval(char *s, unsigned long *val, unsigned int *flags)
+{
+    if (*flags & RANGEMARK_FLAG_LIMIT)
+        exit_error(PARAMETER_PROBLEM, "set-rangemark: Limit specified twice");
+
+    *flags |= RANGEMARK_FLAG_LIMIT;
+
+    return get_val(s, val);
+}
+
+static char *
+get_skipval(char *s, unsigned long *val, unsigned int *flags)
+{
+    if (*flags & RANGEMARK_FLAG_SKIPVALUE)
+        exit_error(PARAMETER_PROBLEM, "set-rangemark: Skipval specified twice");
+
+    *flags |= RANGEMARK_FLAG_SKIPVALUE;
+
+    return get_val(s, val);
+}
+
+static char *
+get_policy(char *s, unsigned int *policy, unsigned int *flags)
+{
+    if (*flags & RANGEMARK_FLAG_POLICY)
+        exit_error(PARAMETER_PROBLEM, "set-rangemark: Policy specified twice");
+
+    *flags |= RANGEMARK_FLAG_POLICY;
+
+    switch(*s) {
+        case 'r': /* random */
+            *policy = RANGEMARK_POLICY_RANDOM;
+            break;
+
+        case 'h': /* port hash */
+            *policy = RANGEMARK_POLICY_PORTHASH;
+            break;
+
+        default: /* unrecognised */
+            exit_error(PARAMETER_PROBLEM, "set-rangemark: Unrecognised policy");
+            return NULL;
+    }
+
+    return ++s;
+}
+
+    
+static char *
+get_op(char *s, unsigned int *op, unsigned *flags)
+{
+    if (*flags & RANGEMARK_FLAG_OP)
+        exit_error(PARAMETER_PROBLEM, "set-rangemark: Policy specified twice");
+
+    *flags |= RANGEMARK_FLAG_OP;
+
+    switch(*s) {
+        case 'S': /* Set the value overwriting any existing value */
+            *op = RANGEMARK_OP_SET;
+            break;
+
+        case 'O': /* OR the value with the existing value */
+            *op = RANGEMARK_OP_OR;
+            break;
+
+        case 'A': /* AND the value with the existing value */
+            *op = RANGEMARK_OP_AND;
+            break;
+
+        default: /* unrecognised */
+            exit_error(PARAMETER_PROBLEM, 
+                "set-rangemark: Unrecognised operation");
+            return NULL;
+    }
+
+    return ++s;
+}
+    
+
+static int
+parse_params(int c, struct ipt_rangemark_target_info *rinfo, char **argv, 
+            unsigned int *flags)
+{
+
+    char *ptr = NULL;
+    unsigned long mask;
+
+    switch(c) {
+        case '1': 
+            /* Calculate the base value */
+            ptr = get_baseval(optarg, &rinfo->base, flags);
+
+            /* Get the limit if present */
+            if (ptr && *ptr == '-') {
+                ptr = get_limitval(++ptr, &rinfo->limit, flags);
+            }
+
+            /* Get the skip value if present */
+            if (ptr && *ptr == '.') {
+                ptr = get_skipval(++ptr, &rinfo->skip, flags);
+            }
+
+            /* Get the policy if specified */
+            if (ptr && ( *ptr == ':')){
+                    ptr = get_policy(++ptr, &rinfo->policy, flags);
+            }
+
+            /* Get the operation if specified */
+            if (ptr && *ptr == ',') {
+                ptr = get_op(++ptr, &rinfo->op, flags);
+            }
+
+            if (ptr && *ptr) {
+                exit_error(PARAMETER_PROBLEM, 
+                    "set-rangemark: Unrecognised option");
+            }
+
+            if (!(*flags & RANGEMARK_FLAG_LIMIT))
+                rinfo->limit = rinfo->base;
+            if (!(*flags & RANGEMARK_FLAG_SKIPVALUE))
+                rinfo->skip = 1;
+            if (!(*flags & RANGEMARK_FLAG_POLICY))
+                rinfo->policy = RANGEMARK_POLICY_RANDOM;
+            if (!(*flags & RANGEMARK_FLAG_OP))
+                rinfo->op = RANGEMARK_OP_SET;
+
+            /*
+             * Set the mask 
+             */
+            mask = rinfo->limit - rinfo->base;
+            rinfo->mask = 1;
+            while(mask >>= 1)
+                rinfo->mask = (rinfo->mask << 1) | 1;
+            break;
+
+        default:
+            return 0;
+    }
+
+    return 1;
+}
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
+
+int ret = 0;
+
+struct ipt_rangemark_target_info *rangeinfo
+    = (struct ipt_rangemark_target_info *)(*target)->data;
+
+    switch (c) {
+    case '1':
+        if (invert)
+            exit_error(PARAMETER_PROBLEM, "set-rangemark: invert flag used\n");
+        ret = parse_params(c, rangeinfo, argv, flags);
+        break;
+
+    default:
+        return 0;
+    }
+
+    return ret;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+
+static void
+print_rangemark(struct ipt_rangemark_target_info *r)
+{
+    printf("Base:   %lu %lx\n", r->base, r->base);
+    printf("Limit:  %lu %lx\n", r->limit, r->limit);
+    printf("rsize:  %lu %lx\n", r->rsize, r->rsize);
+    printf("skipvalue:  %lu %lx\n", r->skip, r->skip);
+    printf("mask:  %lu %lx\n", r->mask, r->mask);
+    printf("policy: %d\n", r->policy);
+    printf("op:     %d\n", r->op);
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+    struct ipt_rangemark_target_info *rinfo =
+        (struct ipt_rangemark_target_info *)target->data;
+    print_rangemark(rinfo);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+    struct ipt_rangemark_target_info *rinfo =
+        (struct ipt_rangemark_target_info *)target->data;
+
+    print_rangemark(rinfo);
+}
+
+static
+struct iptables_target rangemark
+= { NULL,
+    "RANGEMARK",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)),
+    IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)),
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
+    register_target(&rangemark);
+}
diff -urN iptables-1.2.9rc1.orig/extensions/Makefile iptables-1.2.9rc1/extensions/Makefile
--- iptables-1.2.9rc1.orig/extensions/Makefile	2003-10-24 01:15:20.000000000 -0700
+++ iptables-1.2.9rc1/extensions/Makefile	2003-10-24 01:10:25.000000000 -0700
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG 
+PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG RANGEMARK
 
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK TRACE
 
diff -urN iptables-1.2.9rc1.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_RANGEMARK.h
--- iptables-1.2.9rc1.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	2003-10-27 10:45:18.000000000 -0800
@@ -0,0 +1,35 @@
+#ifndef _IPT_RANGEMARK_H_target
+#define _IPT_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+enum rangemark_policy {
+	RANGEMARK_POLICY_RANDOM = 1,
+	RANGEMARK_POLICY_PORTHASH,
+};
+
+enum rangemark_op {
+	RANGEMARK_OP_SET = 1,
+	RANGEMARK_OP_OR,
+	RANGEMARK_OP_AND,
+};
+
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_SKIPVALUE = 16,
+};
+
+struct ipt_rangemark_target_info {
+	unsigned long 			base;
+	unsigned long 			limit;
+	unsigned long			rsize;
+	unsigned long			skip;
+	signed   long           mask;
+	enum rangemark_policy 	policy;
+	enum rangemark_op 		op;
+};
+
+#endif /*_IPT_RANGEMARK_H_target*/


diff -urN linux-2.4.22.orig/net/ipv4/netfilter/Config.in linux-2.4.22/net/ipv4/netfilter/Config.in
--- linux-2.4.22.orig/net/ipv4/netfilter/Config.in	2003-08-25 04:44:44.000000000 -0700
+++ linux-2.4.22/net/ipv4/netfilter/Config.in	2003-10-27 13:44:06.000000000 -0800
@@ -104,6 +104,7 @@
     dep_tristate '    DSCP target support' CONFIG_IP_NF_TARGET_DSCP $CONFIG_IP_NF_MANGLE
  
     dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CONFIG_IP_NF_MANGLE
+    dep_tristate '    RANGEMARK target support' CONFIG_IP_NF_TARGET_RANGEMARK $CONFIG_IP_NF_MANGLE
   fi
   dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG $CONFIG_IP_NF_IPTABLES
diff -urN linux-2.4.22.orig/net/ipv4/netfilter/ipt_RANGEMARK.c linux-2.4.22/net/ipv4/netfilter/ipt_RANGEMARK.c
--- linux-2.4.22.orig/net/ipv4/netfilter/ipt_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/net/ipv4/netfilter/ipt_RANGEMARK.c	2003-10-27 13:42:59.000000000 -0800
@@ -0,0 +1,212 @@
+/* This is a module which is used for setting the NFMARK field of an skb. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_RANGEMARK.h>
+
+void get_random_bytes(void *buf, int nbytes);
+
+unsigned short
+rangemark_hash(unsigned short s, unsigned short d)
+{
+    char s1 = s & 0x1;
+    char d1 = d & 0x1;
+
+    s1 = s1 ^ d1;
+    s = (s>>1)^(d>>1);
+             
+    return s1 ? 0x8000 | s : s;
+}
+
+int
+rangemark_get_size(int a, int b)
+{
+    int k = b-a;
+    int i=0;
+
+    if (k) 
+    do 
+        i++;
+    while (k >>= 8);
+    return i;
+}
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+    const struct ipt_rangemark_target_info *rinfo = targinfo;
+
+    unsigned long base = rinfo->base;
+    unsigned long limit = rinfo->limit;
+    int policy = rinfo->policy;
+    int op = rinfo->op;
+    unsigned long markval;
+    void *iptr;
+    long random = 0;
+
+
+    switch(policy) {
+        case RANGEMARK_POLICY_RANDOM:
+                if (rinfo->rsize) {
+                    get_random_bytes(&random, rinfo->rsize);
+                    markval = base + (random & rinfo->mask);
+                }
+                else 
+                    markval = base;
+
+            break;
+        
+        case RANGEMARK_POLICY_PORTHASH:
+            /*
+             * Skip non IP packets 
+             */
+            iptr = (void *)(*pskb)->nh.iph;
+            if ((((struct iphdr *)iptr)->version != 6) && 
+                    (((struct iphdr *)iptr)->version != 4)){
+                return IPT_CONTINUE;
+            }
+            
+            /*
+             * determine the hash value
+             */
+            if (((struct iphdr *)iptr)->protocol == IPPROTO_UDP) {
+                iptr = (void *)(*pskb)->h.uh;
+                markval = rangemark_hash(((struct udphdr *)iptr)->source,
+                                            ((struct udphdr *)iptr)->dest);
+            }
+            else if (((struct iphdr *)iptr)->protocol == IPPROTO_TCP) {
+                iptr = (void *)(*pskb)->h.th;
+                markval = rangemark_hash(((struct tcphdr *)iptr)->source,
+                                            ((struct tcphdr *)iptr)->dest);
+            }
+            else {
+                /*
+                 * Not for us
+                 */
+                return IPT_CONTINUE;    
+            }
+            break;
+                
+        default:
+            return IPT_CONTINUE;
+    }
+
+    markval &= ~(rinfo->skip -1);
+    if (markval < base)
+        markval = base;
+    else if (markval > limit)
+        markval = limit;
+
+    switch(op) {
+        case RANGEMARK_OP_SET:
+            if ((*pskb)->nfmark != markval) {
+                (*pskb)->nfmark = markval;
+                (*pskb)->nfcache |= NFC_ALTERED;
+            }
+            break;
+
+        case RANGEMARK_OP_AND:
+            (*pskb)->nfmark &= markval;
+            (*pskb)->nfcache |= NFC_ALTERED;
+            break;
+
+        case RANGEMARK_OP_OR:
+            (*pskb)->nfmark |= markval;
+            (*pskb)->nfcache |= NFC_ALTERED;
+        break;
+
+        default:
+            break;
+    }
+    return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+       const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+
+    struct ipt_rangemark_target_info * rinfo;
+
+    if (targinfosize != IPT_ALIGN(sizeof(struct ipt_rangemark_target_info))) {
+        printk(KERN_WARNING "RANGEMARK: targinfosize %u != %Zu\n",
+               targinfosize,
+               IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)));
+        return 0;
+    }
+
+    if (strcmp(tablename, "mangle") != 0) {
+        printk(KERN_WARNING 
+                "RANGEMARK: can only be called from \"mangle\" table,"
+                "not \"%s\"\n", tablename);
+        return 0;
+    }
+
+    rinfo = (struct ipt_rangemark_target_info *) targinfo;
+
+    switch(rinfo->policy) {
+            case RANGEMARK_POLICY_RANDOM:
+            case RANGEMARK_POLICY_PORTHASH:
+                break;
+
+            default:
+                printk(KERN_WARNING 
+                    "RANGEMARK: random is the only supported policy\n");
+                return 0;
+    }
+
+    if (rinfo->base != rinfo->limit) {
+        if (rinfo->skip == 0) {
+            printk(KERN_WARNING "RANGEMARK: invalid skip value\n");
+            return 0;
+        }
+
+        if ((rinfo->skip + rinfo->base) > rinfo->limit){
+            printk(KERN_WARNING "RANGEMARK: skip value too large\n");
+            return 0;
+        }
+
+    }
+    rinfo->rsize = rangemark_get_size(rinfo->base, rinfo->limit);
+    return 1;
+}
+
+static struct ipt_target ipt_rangemark_reg = {
+    .name        = "RANGEMARK",
+    .target        = target,
+    .checkentry    = checkentry,
+    .me        = THIS_MODULE,
+};
+
+static int __init init(void)
+{
+    if (ipt_register_target(&ipt_rangemark_reg))
+        return -EINVAL;
+
+    return 0;
+}
+
+static void __exit fini(void)
+{
+    ipt_unregister_target(&ipt_rangemark_reg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vivek Kashyap<kashyapv@us.ibm.com>");
+MODULE_DESCRIPTION("Set mark from a range of values");
diff -urN linux-2.4.22.orig/net/ipv4/netfilter/Makefile linux-2.4.22/net/ipv4/netfilter/Makefile
--- linux-2.4.22.orig/net/ipv4/netfilter/Makefile	2003-08-25 04:44:44.000000000 -0700
+++ linux-2.4.22/net/ipv4/netfilter/Makefile	2003-10-27 13:44:13.000000000 -0800
@@ -94,6 +94,7 @@
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP.o
 obj-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK.o
+obj-$(CONFIG_IP_NF_TARGET_RANGEMARK) += ipt_RANGEMARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_NAT_SNMP_BASIC) += ip_nat_snmp_basic.o
diff -urN linux-2.4.22.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h linux-2.4.22/include/linux/netfilter_ipv4/ipt_RANGEMARK.h
--- linux-2.4.22.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	2003-10-27 13:11:02.000000000 -0800
@@ -0,0 +1,35 @@
+#ifndef _IPT_RANGEMARK_H_target
+#define _IPT_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+enum rangemark_policy {
+	RANGEMARK_POLICY_RANDOM = 1,
+	RANGEMARK_POLICY_PORTHASH,
+};
+
+enum rangemark_op {
+	RANGEMARK_OP_SET = 1,
+	RANGEMARK_OP_OR,
+	RANGEMARK_OP_AND,
+};
+
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_SKIPVALUE = 16,
+};
+
+struct ipt_rangemark_target_info {
+	unsigned long 			base;
+	unsigned long 			limit;
+	unsigned long			rsize;
+	unsigned long			skip;
+	signed   long           mask;
+	enum rangemark_policy 	policy;
+	enum rangemark_op 		op;
+};
+
+#endif /*_IPT_RANGEMARK_H_target*/
