From: Arnaud Ebalard <arno@natisbad.org>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Tue, 16 Jan 2007 11:21:24 +0100
Message-ID: <87ac0jl1az.fsf@boz.loft.chdir.org>
References: <20070114192011.GA6270@clipper.ens.fr> <45ABCB29.7080600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


Patrick McHardy <kaber <at> trash.net> writes:
 > David Madore wrote:
 > > Implement TCPMSS target for IPv6 by shamelessly copying from
 > > Marc Boucher's IPv4 implementation.
 >
 > This is an x_tables port of the TCPMSS target. Care to give it a try?
 > I believe Yasuyuki is currently working on proper x_tables support
 > for userspace, but that might still take a while, so If you send me
 > your userspace port I'll add it to SVN for the time being.

Sorry for the late post. Just to say that i also _had_ to implement  
that (2.6.19.1 and iptables 1.3.7). I was testing it before pushing
it ;-) too late. Anyway, patch is below for reference.

Question : I made a specific case for AH (even if deprecated) protected
traffic to avoid clamping of that packets.  ipv6_skip_exthdr() simply
does not verify that and it seems there is no check against that. Can
you take a look at find_tcp_hdr in the patch below and tell me if i'm
wrong ? (function is based on ipv6_find_hdr(), ipv6_prepare(),
nf_ct_ipv6_skip_exthdr() and ipv6_skip_exthdr() code).

By the way, I'll take time to test your patch if it fits my 2.6.19.1  
kernel and switch to it. thx.

Regards,

a+

Patch for Kernel :

diff -Nru linux-2.6.19.1/include/linux/netfilter_ipv6/ip6t_tcpmss.h linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_tcpmss.h
--- linux-2.6.19.1/include/linux/netfilter_ipv6/ip6t_tcpmss.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_tcpmss.h	2006-12-20 22:35:16.684395279 +0100
@@ -0,0 +1,7 @@
+#ifndef _IP6T_TCPMSS_MATCH_H
+#define _IP6T_TCPMSS_MATCH_H
+
+#include <linux/netfilter/xt_tcpmss.h>
+#define ip6t_tcpmss_match_info xt_tcpmss_match_info
+
+#endif /*_IP6T_TCPMSS_MATCH_H*/
diff -Nru linux-2.6.19.1/include/linux/netfilter_ipv6/ip6t_TCPMSS.h linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_TCPMSS.h
--- linux-2.6.19.1/include/linux/netfilter_ipv6/ip6t_TCPMSS.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_TCPMSS.h	2006-12-20 22:59:49.040411779 +0100
@@ -0,0 +1,10 @@
+#ifndef _IP6T_TCPMSS_H
+#define _IP6T_TCPMSS_H
+
+struct ip6t_tcpmss_info {
+	u_int16_t mss;
+};
+
+#define IP6T_TCPMSS_CLAMP_PMTU 0xffff
+
+#endif /*_IP6T_TCPMSS_H*/
diff -Nru linux-2.6.19.1/include/linux/netfilter_ipv6/Kbuild linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/Kbuild
--- linux-2.6.19.1/include/linux/netfilter_ipv6/Kbuild	2006-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/include/linux/netfilter_ipv6/Kbuild	2006-12-21 20:00:00.068570949 +0100
@@ -15,6 +15,8 @@
 header-y += ip6t_opts.h
 header-y += ip6t_owner.h
 header-y += ip6t_policy.h
+header-y += ip6t_tcpmss.h
+header-y += ip6t_TCPMSS.h
 header-y += ip6t_physdev.h
 header-y += ip6t_rt.h
 
diff -Nru linux-2.6.19.1/net/ipv6/netfilter/ip6t_TCPMSS.c linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/ip6t_TCPMSS.c
--- linux-2.6.19.1/net/ipv6/netfilter/ip6t_TCPMSS.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/ip6t_TCPMSS.c	2006-12-23 22:00:31.257249420 +0100
@@ -0,0 +1,274 @@
+/*
+ * Module is used for setting the MSS option in TCP SYN packets.
+ *
+ * Ported to IPv6 by Arnaud Ebalard  <arnaud.ebalard@eads.net>
+ * Based on IPv4 TCPMSS module by Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_TCPMSS.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arnaud Ebalard <arnaud.ebalard@eads.net>");
+MODULE_DESCRIPTION("ip6tables TCP MSS clamping module");
+
+static inline unsigned int
+optlen(const u_int8_t *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+/* 
+ * Find offset of TCP header in skbuff. If return value is 0, 'offset' parameter 
+ * contains that offset. Otherwise, TCP header was not found (various possible 
+ * reasons).
+ * 
+ * It is only intended for TCP MSS clamping use: 
+ *  - Packets containing Fragment header are not considered 
+ *  - Packets containing  Auth Header are not considered. MSS Clamping 
+ *    would make them incorrect.
+ * 
+*/
+static int
+find_tcphdr(struct sk_buff *skb, unsigned int *offset)
+{
+        unsigned int start = (u8*)(skb->nh.ipv6h + 1) - skb->data;
+        u8 nexthdr = skb->nh.ipv6h->nexthdr;
+	unsigned int len = skb->len - start;
+	struct ipv6_opt_hdr hdr, *hp;
+	unsigned int hdrlen;
+
+	/* Skip all extension headers. If NEXTHDR_NONE, NEXTHDR_AUTH
+	 * or NEXTHDR_FRAGMENT is encountered, give up. We won't be able to 
+	 * clamp -- AE 
+	 */
+	while (nexthdr != IPPROTO_TCP) {
+
+	  if (len < (int)sizeof(struct ipv6_opt_hdr) ||
+	      !ipv6_ext_hdr(nexthdr) ||
+	      nexthdr == NEXTHDR_FRAGMENT || 
+	      nexthdr == NEXTHDR_NONE || 
+	      nexthdr == NEXTHDR_AUTH) 
+	    return -1;
+
+	  hp = skb_header_pointer(skb, start, sizeof(hdr), &hdr);
+	  if (hp == NULL)
+	    return -1;
+
+	  hdrlen = ipv6_optlen(hp);
+	  nexthdr = hp->nexthdr;
+	  len -= hdrlen;
+	  start += hdrlen;
+	}
+
+	*offset = start;
+	return 0;
+}
+  
+static unsigned int
+ip6t_tcpmss_target(struct sk_buff **pskb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  unsigned int hooknum,
+		  const struct xt_target *target,
+		  const void *targinfo)
+{
+	const struct ip6t_tcpmss_info *tcpmssinfo = targinfo;
+	struct tcphdr *tcph;
+	struct ipv6hdr *ip6h;
+	u_int16_t tcplen, newmss;
+	__be16 oldval;
+	unsigned int offset, i;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+	  return NF_DROP;
+
+	ip6h = (*pskb)->nh.ipv6h;
+
+	if (find_tcphdr(*pskb, &offset))
+	  return NF_DROP;
+
+	tcph = (void *)(*pskb)->data + offset ;
+	tcplen = (u_int16_t)((*pskb)->len - offset);
+
+	/* It passed flags test in tcp match. It's not a fragment, 
+	   and data >= tcp header length.  
+	   SYN packets should not contain data: if they did, then we risk
+	   running over MTU. Furthermore, MTU being at least 1280 bytes 
+	   on IPv6 links, only _very_ unusual packets will match */
+	if (tcplen != tcph->doff*4) {
+		if (net_ratelimit())
+			printk(KERN_ERR
+			       "ip6t_tcpmss_target: bad length (%d bytes)\n",
+			       (*pskb)->len);
+		return NF_DROP;
+	}
+
+	if (tcpmssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU) {
+	  /* TODO : check if that test make sense. Basically, IPv6 link have a 
+	   *        minimum MTU of 1280 bytes. For that reason, if enforced by 
+	   *        the kernel, we do not need that. Leave it anyway at the 
+	   *        moment -- AE */
+	  
+	  if (dst_mtu((*pskb)->dst) <= sizeof(struct ipv6hdr) + 
+	                               sizeof(struct tcphdr)) {
+	    if (net_ratelimit())
+	      printk(KERN_ERR "ip6t_tcpmss_target: "
+		     "unknown or invalid path-MTU (%d)\n",
+		     dst_mtu((*pskb)->dst));
+	    return NF_DROP; 
+	  }
+	  
+	  newmss = dst_mtu((*pskb)->dst) - sizeof(struct ipv6hdr) - 
+	                                   sizeof(struct tcphdr);
+	} else
+	  newmss = tcpmssinfo->mss;
+
+ 	opt = (u_int8_t *)tcph;
+	for (i = sizeof(struct tcphdr); i < tcph->doff*4; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && tcph->doff*4 - i >= TCPOLEN_MSS &&
+		    opt[i+1] == TCPOLEN_MSS) {
+			u_int16_t oldmss;
+
+			oldmss = (opt[i+2] << 8) | opt[i+3];
+
+			if (tcpmssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU &&
+			    oldmss <= newmss)
+				return IP6T_CONTINUE;
+
+			opt[i+2] = (newmss & 0xff00) >> 8;
+			opt[i+3] = (newmss & 0x00ff);
+
+			tcph->check = nf_proto_csum_update(*pskb,
+							   htons(oldmss)^htons(0xFFFF),
+							   htons(newmss),
+							   tcph->check, 0);
+			return IP6T_CONTINUE;
+		}
+	}
+
+	/*
+	 * MSS Option not found ?! add it..
+	 */
+	if (skb_tailroom((*pskb)) < TCPOLEN_MSS) {
+		struct sk_buff *newskb;
+
+		newskb = skb_copy_expand(*pskb, skb_headroom(*pskb),
+					 TCPOLEN_MSS, GFP_ATOMIC);
+		if (!newskb)
+			return NF_DROP;
+		kfree_skb(*pskb);
+		*pskb = newskb;
+		ip6h = (*pskb)->nh.ipv6h;
+		find_tcphdr(*pskb, &offset);
+		tcph = (void *)(*pskb)->data + offset ;
+	}
+
+	skb_put((*pskb), TCPOLEN_MSS);
+
+ 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
+
+	tcph->check = nf_proto_csum_update(*pskb,
+					   htons(tcplen) ^ htons(0xFFFF),
+				           htons(tcplen + TCPOLEN_MSS),
+					   tcph->check, 1);
+	opt[0] = TCPOPT_MSS;
+	opt[1] = TCPOLEN_MSS;
+	opt[2] = (newmss & 0xff00) >> 8;
+	opt[3] = (newmss & 0x00ff);
+
+	tcph->check = nf_proto_csum_update(*pskb, htonl(~0), *((__be32 *)opt),
+					   tcph->check, 0);
+
+	oldval = ((__be16 *)tcph)[6];
+	tcph->doff += TCPOLEN_MSS/4;
+	tcph->check = nf_proto_csum_update(*pskb,
+					   oldval ^ htons(0xFFFF),
+					   ((__be16 *)tcph)[6],
+					   tcph->check, 0);
+
+	ip6h->payload_len = htons(ntohs(ip6h->payload_len) + TCPOLEN_MSS);
+	return IP6T_CONTINUE;
+}
+
+#define TH_SYN 0x02
+
+static inline int find_syn_match(const struct ip6t_entry_match *m)
+{
+	const struct ip6t_tcp *tcpinfo = (const struct ip6t_tcp *)m->data;
+
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TH_SYN &&
+	    !(tcpinfo->invflags & IP6T_TCP_INV_FLAGS))
+		return 1;
+
+	return 0;
+}
+
+/* Must specify -p tcp --syn/--tcp-flags SYN */
+static int
+ip6t_tcpmss_checkentry(const char *tablename,
+		      const void *e_void,
+		      const struct xt_target *target,
+		      void *targinfo,
+		      unsigned int hook_mask)
+{
+	const struct ip6t_tcpmss_info *tcpmssinfo = targinfo;
+	const struct ip6t_entry *e = e_void;
+
+	if (tcpmssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU &&
+	    (hook_mask & ~((1 << NF_IP6_FORWARD) |
+			   (1 << NF_IP6_LOCAL_OUT) |
+			   (1 << NF_IP6_POST_ROUTING))) != 0) {
+		printk("TCPMSS: path-MTU clamping only supported in "
+		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return 0;
+	}
+
+	if (IP6T_MATCH_ITERATE(e, find_syn_match))
+		return 1;
+	printk("TCPMSS: Only works on TCP SYN packets\n");
+	return 0;
+}
+
+static struct ip6t_target ip6t_tcpmss_reg = {
+	.name		= "TCPMSS",
+	.target		= ip6t_tcpmss_target,
+	.targetsize	= sizeof(struct ip6t_tcpmss_info),
+	.proto		= IPPROTO_TCP,
+	.checkentry	= ip6t_tcpmss_checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init ip6t_tcpmss_init(void)
+{
+	return ip6t_register_target(&ip6t_tcpmss_reg);
+}
+
+static void __exit ip6t_tcpmss_fini(void)
+{
+	ip6t_unregister_target(&ip6t_tcpmss_reg);
+}
+
+module_init(ip6t_tcpmss_init);
+module_exit(ip6t_tcpmss_fini);
diff -Nru linux-2.6.19.1/net/ipv6/netfilter/Kconfig linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/Kconfig
--- linux-2.6.19.1/net/ipv6/netfilter/Kconfig	2006-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/Kconfig	2006-12-21 18:44:47.374545199 +0100
@@ -153,6 +153,33 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_TARGET_TCPMSS
+	tristate "TCPMSS target support"
+	depends on IP6_NF_IPTABLES
+	---help---
+	  This option adds a `TCPMSS' target, which allows you to alter the
+	  MSS value of TCP SYN packets, to control the maximum size for that
+	  connection (usually limiting it to your outgoing interface's MTU
+	  minus 60).
+
+	  This is used to overcome criminally braindead ISPs or servers which
+	  block ICMPv6 Packet Too Big packets or are unable to send them. The 
+	  symptoms of this problem are that everything works fine from your 
+	  Linux firewall/router, but machines behind it can never exchange 
+ 	  large packets:
+
+	  	1) Web browsers connect, then hang with no data received.
+	  	2) Small mail works fine, but large emails hang.
+	  	3) ssh works fine, but scp hangs after initial handshaking.
+
+	  Workaround: activate this option and add a rule to your firewall
+	  configuration like:
+
+	  ip6tables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
+	            -j TCPMSS --clamp-mss-to-pmtu
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP6_NF_IPTABLES
diff -Nru linux-2.6.19.1/net/ipv6/netfilter/Makefile linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/Makefile
--- linux-2.6.19.1/net/ipv6/netfilter/Makefile	2006-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/Makefile	2006-12-18 00:10:26.434896581 +0100
@@ -16,6 +16,7 @@
 obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_TARGET_TCPMSS) += ip6t_TCPMSS.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
diff -Nru linux-2.6.19.1/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.19.1/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-IPv6-TCPMSS/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-12-21 09:30:04.087382280 +0100
@@ -85,7 +85,7 @@
 }
 
 /*
- * Based on ipv6_skip_exthdr() in net/ipv6/exthdr.c
+ * Based on ipv6_skip_exthdr() in net/ipv6/exthdrs_core.c
  *
  * This function parses (probably truncated) exthdr set "hdr"
  * of length "len". "nexthdrp" initially points to some place,
Binary files linux-2.6.19.1/scripts/kconfig/mconf and linux-2.6.19.1-IPv6-TCPMSS/scripts/kconfig/mconf differ








Patch for iptables :







diff -Nru iptables-1.3.7/extensions/libip6t_tcpmss.c iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_tcpmss.c
--- iptables-1.3.7/extensions/libip6t_tcpmss.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_tcpmss.c	2006-12-21 20:26:30.619974199 +0100
@@ -0,0 +1,152 @@
+/* Shared library add-on to iptables to add tcp MSS matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_tcpmss.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"tcpmss match v%s options:\n"
+"[!] --mss value[:value]	Match TCP MSS range.\n"
+"				(only valid for TCP SYN or SYN/ACK packets)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mss", 1, 0, '1' },
+	{0}
+};
+
+static u_int16_t
+parse_tcp_mssvalue(const char *mssvalue)
+{
+	unsigned int mssvaluenum;
+
+	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
+		return (u_int16_t)mssvaluenum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "Invalid mss `%s' specified", mssvalue);
+}
+
+static void
+parse_tcp_mssvalues(const char *mssvaluestring,
+		    u_int16_t *mss_min, u_int16_t *mss_max)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(mssvaluestring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		*mss_min = *mss_max = parse_tcp_mssvalue(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		*mss_min = buffer[0] ? parse_tcp_mssvalue(buffer) : 0;
+		*mss_max = cp[0] ? parse_tcp_mssvalue(cp) : 0xFFFF;
+	}
+	free(buffer);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_tcpmss_match_info *mssinfo =
+		(struct ip6t_tcpmss_match_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--mss' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_mssvalues(argv[optind-1],
+				    &mssinfo->mss_min, &mssinfo->mss_max);
+		if (invert)
+			mssinfo->invert = 1;
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, int invert, int numeric)
+{
+	if (invert)
+		printf("! ");
+
+	if (mss_min == mss_max)
+		printf("%u ", mss_min);
+	else
+		printf("%u:%u ", mss_min, mss_max);
+}
+
+/* Final check; must have specified --mss. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "tcpmss match: You must specify `--mss'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ip6t_ip6 *ip6,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_tcpmss_match_info *mssinfo =
+		(const struct ip6t_tcpmss_match_info *)match->data;
+
+	printf("tcpmss match ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, numeric);
+}
+
+/* Saves the union ip6t_matchinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip6, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_tcpmss_match_info *mssinfo =
+		(const struct ip6t_tcpmss_match_info *)match->data;
+
+	printf("--mss ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, 0);
+}
+
+static struct ip6tables_match tcpmss = {
+	.next		= NULL,
+	.name		= "tcpmss",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_match_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_match_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match6(&tcpmss);
+}
diff -Nru iptables-1.3.7/extensions/libip6t_TCPMSS.c iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_TCPMSS.c
--- iptables-1.3.7/extensions/libip6t_TCPMSS.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_TCPMSS.c	2006-12-21 20:26:30.619974199 +0100
@@ -0,0 +1,134 @@
+/* Shared library add-on to iptables to add TCPMSS target support.
+ *
+ * Copyright (c) 2000 Marc Boucher
+*/
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_TCPMSS.h>
+
+struct mssinfo {
+	struct ip6t_entry_target t;
+	struct ip6t_tcpmss_info mss;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"TCPMSS target v%s mutually-exclusive options:\n"
+"  --set-mss value               explicitly set MSS option to specified value\n"
+"  --clamp-mss-to-pmtu           automatically clamp MSS value to (path_MTU - 60)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "set-mss", 1, 0, '1' },
+	{ "clamp-mss-to-pmtu", 0, 0, '2' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      struct ip6t_entry_target **target)
+{
+	struct ip6t_tcpmss_info *mssinfo
+		= (struct ip6t_tcpmss_info *)(*target)->data;
+
+	switch (c) {
+		unsigned int mssval;
+
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "TCPMSS target: Only one option may be specified");
+		if (string_to_number(optarg, 0, 65535 - 60, &mssval) == -1)
+			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
+		
+		mssinfo->mss = mssval;
+		*flags = 1;
+		break;
+
+	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "TCPMSS target: Only one option may be specified");
+		mssinfo->mss = IP6T_TCPMSS_CLAMP_PMTU;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPMSS target: At least one parameter is required");
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip6,
+      const struct ip6t_entry_target *target,
+      int numeric)
+{
+	const struct ip6t_tcpmss_info *mssinfo =
+		(const struct ip6t_tcpmss_info *)target->data;
+	if(mssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU)
+		printf("TCPMSS clamp to PMTU ");
+	else
+		printf("TCPMSS set %u ", mssinfo->mss);
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+{
+	const struct ip6t_tcpmss_info *mssinfo =
+		(const struct ip6t_tcpmss_info *)target->data;
+
+	if(mssinfo->mss == IP6T_TCPMSS_CLAMP_PMTU)
+		printf("--clamp-mss-to-pmtu ");
+	else
+		printf("--set-mss %u ", mssinfo->mss);
+}
+
+static struct ip6tables_target mss = {
+	.next		= NULL,
+	.name		= "TCPMSS",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target6(&mss);
+}
diff -Nru iptables-1.3.7/extensions/libip6t_tcpmss.man iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_tcpmss.man
--- iptables-1.3.7/extensions/libip6t_tcpmss.man	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_tcpmss.man	2006-12-21 20:26:30.607973449 +0100
@@ -0,0 +1,4 @@
+This matches the TCP MSS (maximum segment size) field of the TCP header.  You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.
+.TP
+.BI "[!] "--mss " "value[:value]"
+Match a given TCP MSS value or range.
diff -Nru iptables-1.3.7/extensions/libip6t_TCPMSS.man iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_TCPMSS.man
--- iptables-1.3.7/extensions/libip6t_TCPMSS.man	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/extensions/libip6t_TCPMSS.man	2006-12-21 20:26:30.607973449 +0100
@@ -0,0 +1,42 @@
+This target allows to alter the MSS value of TCP SYN packets, to control
+the maximum size for that connection (usually limiting it to your
+outgoing interface's MTU minus 60).  Of course, it can only be used
+in conjunction with
+.BR "-p tcp" .
+It is only valid in the
+.BR mangle
+table.
+.br
+This target is used to overcome criminally braindead ISPs or servers
+which block ICMPv6 Packet Too Big packets or are unable to send them.
+The symptoms of this problem are that everything works fine from your 
+Linux firewall/router, but machines behind it can never exchange large
+packets:
+.PD 0
+.RS 0.1i
+.TP 0.3i
+1)
+Web browsers connect, then hang with no data received.
+.TP
+2)
+Small mail works fine, but large emails hang.
+.TP
+3)
+ssh works fine, but scp hangs after initial handshaking.
+.RE
+.PD
+Workaround: activate this option and add a rule to your firewall
+configuration like:
+.nf
+ ip6tables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
+             -j TCPMSS --clamp-mss-to-pmtu
+.fi
+.TP
+.BI "--set-mss " "value"
+Explicitly set MSS option to specified value.
+.TP
+.B "--clamp-mss-to-pmtu"
+Automatically clamp MSS value to (path_MTU - 60).
+.TP
+These options are mutually exclusive.
+
diff -Nru iptables-1.3.7/extensions/Makefile iptables-1.3.7-IPv6-TCPMSS/extensions/Makefile
--- iptables-1.3.7/extensions/Makefile	2006-12-04 12:15:19.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/extensions/Makefile	2006-12-21 20:26:30.071939949 +0100
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
-PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TRACE
+PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp tcpmss CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff -Nru iptables-1.3.7/include/linux/netfilter_ipv6/ip6t_tcpmss.h iptables-1.3.7-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_tcpmss.h
--- iptables-1.3.7/include/linux/netfilter_ipv6/ip6t_tcpmss.h	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_tcpmss.h	2006-12-21 20:26:29.955932699 +0100
@@ -0,0 +1,9 @@
+#ifndef _IP6T_TCPMSS_MATCH_H
+#define _IP6T_TCPMSS_MATCH_H
+
+struct ip6t_tcpmss_match_info {
+    u_int16_t mss_min, mss_max;
+    u_int8_t invert;
+};
+
+#endif /*_IP6T_TCPMSS_MATCH_H*/
diff -Nru iptables-1.3.7/include/linux/netfilter_ipv6/ip6t_TCPMSS.h iptables-1.3.7-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_TCPMSS.h
--- iptables-1.3.7/include/linux/netfilter_ipv6/ip6t_TCPMSS.h	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.7-IPv6-TCPMSS/include/linux/netfilter_ipv6/ip6t_TCPMSS.h	2006-12-21 20:26:29.955932699 +0100
@@ -0,0 +1,10 @@
+#ifndef _IP6T_TCPMSS_H
+#define _IP6T_TCPMSS_H
+
+struct ip6t_tcpmss_info {
+	u_int16_t mss;
+};
+
+#define IP6T_TCPMSS_CLAMP_PMTU 0xffff
+
+#endif /*_IP6T_TCPMSS_H*/
