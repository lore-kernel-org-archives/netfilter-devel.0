From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] Versioning (aka release) stuff for iptables
Date: Sat, 01 Jan 2005 22:56:18 +0100
Message-ID: <41D71C82.7060101@eurodev.net>
References: <41CDDC3F.2060708@eurodev.net>
	<1104301816.8383.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000200010704040007020500"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1104301816.8383.14.camel@localhost.localdomain>
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
--------------000200010704040007020500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:

>On Sat, 2004-12-25 at 22:31 +0100, Pablo Neira wrote:
>  
>
>>Hi Rusty,
>>
>>I've been working on the versioning stuff last days. I've tested with 
>>the mark target.
>>    
>>
>
>Hi Pablo,
>
>	I've taken your patches and hacked on them again.  I thought for a long
>time about the compatibility question, and decided that we need a kernel
>mechanism for querying versions of things as well.  This makes life much
>easier, as then all versions can register with iptables and it can
>figure out which one to use.
>  
>

I agree, I like your autoprobing version stuff.

>Enclosed is a series of four kernel patches, and one iptables patch:
>
>[...snip...]
>        
>It seems to work here... thoughts?
>  
>

I've given some spins to your patches on x86 box and everything works 
fine for me. I've also cook a patch to add a new version to multiport to 
test that versioning stuff works fine with matches.

multiport-remove-late-check.patch:
Remove a checking in kernel space which makes sures that the parameters 
passed are correct, that's already done in user space where this thing 
really belongs.

multiport_v2.patch:
the revision 1 of multiport. Actually this merges current mport in the 
SVN repository to multiport.

iptables-multiport_v2.patch:
iptables user space part.

multiport.sim:
a testsuite to check that new version works fine (incomplete).

Hope to see the versioning stuff pushed forward soon.

BTW, if you need this. Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------000200010704040007020500
Content-Type: text/x-patch;
 name="multiport-remove-late-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multiport-remove-late-check.patch"

===== net/ipv4/netfilter/ipt_multiport.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ipt_multiport.c	2004-08-19 02:14:53 +02:00
+++ edited/net/ipv4/netfilter/ipt_multiport.c	2005-01-01 18:58:25 +01:00
@@ -88,19 +88,7 @@
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct ipt_multiport *multiinfo = matchinfo;
-
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_multiport)))
-		return 0;
-
-	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
-	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->invflags & IPT_INV_PROTO)
-		&& matchsize == IPT_ALIGN(sizeof(struct ipt_multiport))
-		&& (multiinfo->flags == IPT_MULTIPORT_SOURCE
-		    || multiinfo->flags == IPT_MULTIPORT_DESTINATION
-		    || multiinfo->flags == IPT_MULTIPORT_EITHER)
-		&& multiinfo->count <= IPT_MULTI_PORTS;
+	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport)));
 }
 
 static struct ipt_match multiport_match = {

--------------000200010704040007020500
Content-Type: text/x-patch;
 name="multiport_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multiport_v2.patch"

--- linux-2.5/net/ipv4/netfilter/ipt_multiport.c	2005-01-01 19:03:25.000000000 +0100
+++ revision/net/ipv4/netfilter/ipt_multiport.c	2005-01-01 19:03:13.000000000 +0100
@@ -46,16 +46,55 @@
 	return 0;
 }
 
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
+/* Returns 1 if the port is matched by the test, 0 otherwise. */
+static inline int
+ports_match_v1(const struct ipt_multiport_v1 *minfo,
+	       u_int16_t src, u_int16_t dst)
+{
+	unsigned int i;
+	u_int16_t s, e;
+
+	for (i=0; i < minfo->count; i++) {
+		s = minfo->ports[i];
+
+		if (minfo->pflags[i]) {
+			/* range port matching */
+			e = minfo->ports[++i];
+			duprintf("src or dst matches with %d-%d?\n", s, e);
+
+			if (minfo->flags == IPT_MULTIPORT_SOURCE
+			    && src >= s && src <= e)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_DESTINATION
+			    && dst >= s && dst <= e)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_EITHER
+			    && dst >= s && dst <= e)
+				return 1;
+		} else {
+			/* exact port matching */
+			duprintf("src or dst matches with %d?\n", s);
+			if (minfo->flags == IPT_MULTIPORT_SOURCE
+			    && src == s)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_DESTINATION
+			    && dst == s)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_EITHER
+			    && (src == s || dst == s))
+				return 1;
+		}
+	}
+ 
+ 	return 0;
+}
+
+static u16 *
+__match(const struct sk_buff *skb,
+	const void *matchinfo,
+	int offset)
 {
 	u16 _ports[2], *pptr;
-	const struct ipt_multiport *multiinfo = matchinfo;
 
 	/* Must not be a fragment. */
 	if (offset)
@@ -65,6 +104,21 @@
            them at the start). */
 	pptr = skb_header_pointer(skb, skb->nh.iph->ihl * 4,
 				  sizeof(_ports), &_ports[0]);
+	return pptr;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	u16 *pptr;
+	const struct ipt_multiport *multiinfo = matchinfo;
+
+	pptr = __match(skb, matchinfo, offset);
 	if (pptr == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
@@ -80,6 +134,31 @@
 			   ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static int
+match_v1(const struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 const void *matchinfo,
+	 int offset,
+	 int *hotdrop)
+{
+	u16 *pptr;
+	const struct ipt_multiport_v1 *multiinfo = matchinfo;
+
+	pptr = __match(skb, matchinfo, offset);
+	if (pptr == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("ipt_multiport:"
+			 " Dropping evil offset=0 tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
+}
+
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
@@ -91,21 +170,50 @@
 	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport)));
 }
 
+static int
+checkentry_v1(const char *tablename,
+	      const struct ipt_ip *ip,
+	      void *matchinfo,
+	      unsigned int matchsize,
+	      unsigned int hook_mask)
+{
+	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport_v1)));
+}
+
 static struct ipt_match multiport_match = {
 	.name		= "multiport",
+	.revision	= 0,
 	.match		= &match,
 	.checkentry	= &checkentry,
 	.me		= THIS_MODULE,
 };
 
+static struct ipt_match multiport_match_v1 = {
+	.name		= "multiport",
+	.revision	= 1,
+	.match		= &match_v1,
+	.checkentry	= &checkentry_v1,
+	.me		= THIS_MODULE,
+};
+
 static int __init init(void)
 {
-	return ipt_register_match(&multiport_match);
+	int err;
+
+	err = ipt_register_match(&multiport_match);
+	if (!err) {
+		err = ipt_register_match(&multiport_match_v1);
+		if (err)
+			ipt_unregister_match(&multiport_match);
+	}
+
+	return err;
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&multiport_match);
+	ipt_unregister_match(&multiport_match_v1);
 }
 
 module_init(init);
--- linux-2.5/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-01 19:03:21.000000000 +0100
+++ revision/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-01 19:03:13.000000000 +0100
@@ -18,4 +18,12 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 };
+
+struct ipt_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+};
 #endif /*_IPT_MULTIPORT_H*/

--------------000200010704040007020500
Content-Type: text/x-patch;
 name="iptables-multiport_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-multiport_v2.patch"

Index: include/linux/netfilter_ipv4/ipt_multiport.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_multiport.h	(revision 0)
+++ include/linux/netfilter_ipv4/ipt_multiport.h	(revision 0)
@@ -0,0 +1,28 @@
+#ifndef _IPT_MULTIPORT_H
+#define _IPT_MULTIPORT_H
+
+enum ipt_multiport_flags
+{
+	IPT_MULTIPORT_SOURCE,
+	IPT_MULTIPORT_DESTINATION,
+	IPT_MULTIPORT_EITHER
+};
+
+#define IPT_MULTI_PORTS	15
+
+/* Must fit inside union ipt_matchinfo: 16 bytes */
+struct ipt_multiport
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
+};
+
+struct ipt_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+};
+#endif /*_IPT_MULTIPORT_H*/
Index: extensions/libipt_multiport.c
===================================================================
--- extensions/libipt_multiport.c	(revision 3514)
+++ extensions/libipt_multiport.c	(working copy)
@@ -5,7 +5,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_multiport.h>
+/* To ensure that iptables compiles with an old kernel */
+#include "../include/linux/netfilter_ipv4/ipt_multiport.h"
 
 /* Function which prints out usage message. */
 static void
@@ -24,6 +25,22 @@
 IPTABLES_VERSION);
 }
 
+static void
+help_v1(void)
+{
+	printf(
+"multiport v%s options:\n"
+" --source-ports port[,port:port,port...]\n"
+" --sports ...\n"
+"				match source port(s)\n"
+" --destination-ports port[,port:port,port...]\n"
+" --dports ...\n"
+"				match destination port(s)\n"
+" --ports port[,port:port,port]\n"
+"				match both source and destination port(s)\n",
+IPTABLES_VERSION);
+}
+
 static struct option opts[] = {
 	{ "source-ports", 1, 0, '1' },
 	{ "sports", 1, 0, '1' }, /* synonym */
@@ -77,6 +94,46 @@
 	return i;
 }
 
+static void
+parse_multi_ports_v1(const char *portstring, 
+		     struct ipt_multiport_v1 *multiinfo,
+		     const char *proto)
+{
+	char *buffer, *cp, *next, *range;
+	unsigned int i;
+	u_int16_t m;
+
+	buffer = strdup(portstring);
+	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+
+	for (i=0; i<IPT_MULTI_PORTS; i++)
+		multiinfo->pflags[i] = 0;
+ 
+	for (cp=buffer, i=0; cp && i<IPT_MULTI_PORTS; cp=next, i++) {
+		next=strchr(cp, ',');
+ 		if (next) *next++='\0';
+		range = strchr(cp, ':');
+		if (range) {
+			if (i == IPT_MULTI_PORTS-1)
+				exit_error(PARAMETER_PROBLEM,
+					   "too many ports specified");
+			*range++ = '\0';
+		}
+		multiinfo->ports[i] = parse_port(cp, proto);
+		if (range) {
+			multiinfo->pflags[i] = 1;
+			multiinfo->ports[++i] = parse_port(range, proto);
+			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
+				exit_error(PARAMETER_PROBLEM,
+					   "invalid portrange specified");
+			m <<= 1;
+		}
+ 	}
+	multiinfo->count = i;
+ 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+ 	free(buffer);
+}
+
 /* Initialize the match. */
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
@@ -153,6 +210,56 @@
 	return 1;
 }
 
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+	 const struct ipt_entry *entry,
+	 unsigned int *nfcache,
+	 struct ipt_entry_match **match)
+{
+	const char *proto;
+	struct ipt_multiport_v1 *multiinfo
+		= (struct ipt_multiport_v1 *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IPT_MULTIPORT_SOURCE;
+		*nfcache |= NFC_IP_SRC_PT;
+		break;
+
+	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
+		*nfcache |= NFC_IP_DST_PT;
+		break;
+
+	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IPT_MULTIPORT_EITHER;
+		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
+
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport can only have one option");
+	*flags = 1;
+	return 1;
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -221,6 +328,46 @@
 	printf(" ");
 }
 
+static void
+print_v1(const struct ipt_ip *ip,
+	 const struct ipt_entry_match *match,
+	 int numeric)
+{
+	const struct ipt_multiport_v1 *multiinfo
+		= (const struct ipt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	printf("multiport ");
+
+	switch (multiinfo->flags) {
+	case IPT_MULTIPORT_SOURCE:
+		printf("sports ");
+		break;
+
+	case IPT_MULTIPORT_DESTINATION:
+		printf("dports ");
+		break;
+
+	case IPT_MULTIPORT_EITHER:
+		printf("ports ");
+		break;
+
+	default:
+		printf("ERROR ");
+		break;
+	}
+
+	for (i=0; i < multiinfo->count; i++) {
+		printf("%s", i ? "," : "");
+		print_port(multiinfo->ports[i], ip->proto, numeric);
+		if (multiinfo->pflags[i]) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, numeric);
+		}
+	}
+	printf(" ");
+}
+
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
@@ -249,9 +396,42 @@
 	printf(" ");
 }
 
+static void save_v1(const struct ipt_ip *ip, 
+		    const struct ipt_entry_match *match)
+{
+	const struct ipt_multiport_v1 *multiinfo
+		= (const struct ipt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	switch (multiinfo->flags) {
+	case IPT_MULTIPORT_SOURCE:
+		printf("--sports ");
+		break;
+
+	case IPT_MULTIPORT_DESTINATION:
+		printf("--dports ");
+		break;
+
+	case IPT_MULTIPORT_EITHER:
+		printf("--ports ");
+		break;
+	}
+
+	for (i=0; i < multiinfo->count; i++) {
+		printf("%s", i ? "," : "");
+		print_port(multiinfo->ports[i], ip->proto, 1);
+		if (multiinfo->pflags[i]) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, 1);
+		}
+	}
+	printf(" ");
+}
+
 static struct iptables_match multiport = { 
 	.next		= NULL,
 	.name		= "multiport",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_multiport)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_multiport)),
@@ -264,8 +444,25 @@
 	.extra_opts	= opts
 };
 
+static struct iptables_match multiport_v1 = { 
+	.next		= NULL,
+	.name		= "multiport",
+	.version	= IPTABLES_VERSION,
+	.revision	= 1,
+	.size		= IPT_ALIGN(sizeof(struct ipt_multiport_v1)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_multiport_v1)),
+	.help		= &help_v1,
+	.init		= &init,
+	.parse		= &parse_v1,
+	.final_check	= &final_check,
+	.print		= &print_v1,
+	.save		= &save_v1,
+	.extra_opts	= opts
+};
+
 void
 _init(void)
 {
 	register_match(&multiport);
+	register_match(&multiport_v1);
 }

--------------000200010704040007020500
Content-Type: text/plain;
 name="multiport.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multiport.sim"

#test old style

iptables -I INPUT -p 6 -m multiport --sports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 -j DROP
iptables -D INPUT -p tcp -m multiport --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 -j DROP

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.
168.0.1 0 6 15 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 15 1 SYN

#test new version

iptables -I INPUT -p 6 -m multiport --sports 1:10,1000 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 4 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 4 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 11 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 11 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 999 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 999 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1001 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1001 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1000 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1000 1 SYN

iptables -D INPUT -p 6 -m multiport --sports 1:10,1000 -j DROP

iptables -I INPUT -p 6 -m multiport --sports 1:10,1000,1500:1501,2000:2005 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1500 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1500 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1501 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1501 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1499 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1499 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1502 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1502 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 2000 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 2000 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 2003 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 2003 1 SYN

iptables -D INPUT -p 6 -m multiport --sports 1:10,1000,1500:1501,2000:2005 -j DROP

iptables -I INPUT -p 6 -m multiport --ports 1:10,1000,1500:1501,2000:2005 -j DROP

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 2003 1 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 2003 1 SYN

expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1 2003  SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1 2003 SYN

iptables -D INPUT -p 6 -m multiport --sports 1:10,1000,1500:1501,2000:2005 -j DROP

iptables -I INPUT -p 6 -m multiport --sports 1:10,20:30,40:50,60,70,80,90,100,110,120:1200,15000 -j DROP

iptables -D INPUT -p 6 -m multiport --sports 1:10,20:30,40:50,60,70,80,90,100,110,120:1200,15000 -j DROP

expect iptables iptables: command failed
iptables -I INPUT -p 6 -m multiport --sports 1:10:30,40 -j DROP

--------------000200010704040007020500--
