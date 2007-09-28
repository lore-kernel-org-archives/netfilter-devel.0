From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 16:16:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36649 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXI1OQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:16:50 -0400
In-Reply-To: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 28 2007 08:56, Sven Schnelle wrote:
>
>i stumbled across a sitiuation where i had to strip of a specific TCP
>option from the TCP Header. As i've found no target in current xtables,
>i wrote an TCPOPTSTRIP target, that does this.
>
>Maybe this is useful for others (or for integration in the current
>xtables) i'm attaching it to this mail. Comments?
>
Send patches preferably inline.

>Index: extensions/libxt_TCPOPTSTRIP.c
>===================================================================
>--- extensions/libxt_TCPOPTSTRIP.c	(revision 0)
>+++ extensions/libxt_TCPOPTSTRIP.c	(revision 0)
>@@ -0,0 +1,120 @@
>+/* Shared library add-on to iptables to add TCPOPTSTRIP target support.

There is a "IPV4OPTSSTRIP" module in POM-NG.
Perhaps you could call yours TCPOPTSSTRIP? Just a thought,
I am kind of impartial whether it should be two S or one S.

>+struct optinfo {
>+	struct xt_entry_target t;
>+	struct xt_tcpoptstrip_info option;
>+};

Not sure what this is supposed to do.

>+
>+/* Function which prints out usage message. */
>+static void help(void)
>+{
>+    printf("TCPOPTSTRIP target options:\n"
>+	   "  --strip-tcp-option value      strip tcp option 'value' from TCP Header\n");
>+}
>+
>+static const struct option opts[] = {
>+	{ "strip-tcp-option", 1, NULL, '1' },
>+	{ }
>+};
>+
>+/* Initialize the target. */
>+static void init(struct xt_entry_target *t)
>+{
>+}
>+
>+/* Function which parses command options; returns true if it
>+   ate an option */
>+static int parse(int c, char **argv, int invert, unsigned int *flags,
>+      const void *entry, struct xt_entry_target **target)
>+{
>+    struct xt_tcpoptstrip_info *optinfo
>+	= (struct xt_tcpoptstrip_info *)(*target)->data;

	struct xt_tcpoptstrip_info *info = (void *)(*target)->data;

>+	switch (c) {
>+		unsigned int option;
>+

Huh, what's that option doing there? It looks out of place.

>+	case '1':
>+	    if (string_to_number(optarg, 0, 255, &option) == -1)
>+		exit_error(PARAMETER_PROBLEM, "Bad TCPOPTSTRIP value `%s'", optarg);
>+	    optinfo->tcpoption = option;
>+	    *flags = 1;
>+	    break;

How about allowing to strip multiple TCP options at once?
(Which perhaps then decies whether it is OPTSTRIP or OPTSSTRIP :-)

>+/* Prints out the targinfo. */
>+static void print(const void *ip,const struct xt_entry_target *target,
>+      int numeric)
>+{
>+	const struct xt_tcpoptstrip_info *optinfo =
>+		(const struct xt_tcpoptstrip_info *)target->data;

(const void *) makes it shorter and does the same. Try it.

>+	printf("TCPOPTSTRIP option %u ", optinfo->tcpoption);
>+}
>+
>+/* Saves the union ipt_targinfo in parsable form to stdout. */
>+static void save(const void *ip, const struct xt_entry_target *target)
>+{
>+    const struct xt_tcpoptstrip_info *optinfo =
>+	(const struct xt_tcpoptstrip_info *)target->data;
>+
>+    printf("--strip-tcp-option %u ", optinfo->tcpoption);
>+}
>+
>+static struct xtables_target tcpopt = {
>+	.family		= AF_INET,
>+	.name		= "TCPOPTSTRIP",
>+	.version	= IPTABLES_VERSION,
>+	.size		= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
>+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
>+	.help		= &help,
>+	.init		= &init,
>+	.parse		= &parse,
>+	.final_check	= &final_check,
>+	.print		= &print,
>+	.save		= &save,
>+	.extra_opts	= opts
>+};

Better name these tcpoptstrip_help (no need for the &), tcpoptstrip_init,
etc. so these symbols can be unambiguously resolved when attaching gdb.



--- 8< ---

>diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
>new file mode 100644
>index 0000000..97678e8
>--- /dev/null
>+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
>@@ -0,0 +1,9 @@
>+#ifndef _XT_TCPOPTSTRIP_H
>+#define _XT_TCPOPTSTRIP_H
>+
>+struct xt_tcpoptstrip_info {
>+	int tcpoption;
>+};

Should be a fixed type (uint8_t, uint16_t, uint32_t...etc)

>diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>index 3599770..44c6e17 100644
>--- a/net/netfilter/Kconfig
>+++ b/net/netfilter/Kconfig
>@@ -411,6 +411,13 @@ config NETFILTER_XT_TARGET_TCPMSS
> 
> 	  To compile it as a module, choose M here.  If unsure, say N.
> 
>+config NETFILTER_XT_TARGET_TCPOPTSTRIP
>+	tristate '"TCPOPTSTRIP" target support'
>+	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)

I do not think the IPv6 splitoff is necessary. Only a few other
(stray?) modules do it and I am not sure why. Take xt_string.c
for example, there is no #ifdef ipv6 or so.

>+#include <linux/netfilter_ipv4/ip_tables.h>
>+#include <linux/netfilter_ipv6/ip6_tables.h>

Not sure, but I think these can go - you have x_tables.h.

>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>");
>+MODULE_DESCRIPTION("x_tables TCPOPTSTRIP module");
>+MODULE_ALIAS("ipt_TCPOPTSTRIP");
>+MODULE_ALIAS("ip6t_TCPOPTSRIP");

"SRIP" seems not quite right.

>+static int tcpoptstrip_mangle_packet(struct sk_buff **pskb, const void *info,
>+				    unsigned int tcphoff, unsigned int minlen)
>+{
>+    struct xt_tcpoptstrip_info *tinfo = (struct xt_tcpoptstrip_info *)info;
>+    struct tcphdr *tcph;
>+    const u8 newopt = TCPOPT_NOP;
>+    unsigned int optl, tcplen, i,j;
>+    u8 *opt;
>+
>+    if (!skb_make_writable(pskb, (*pskb)->len))
>+	return -1;
>+
>+    tcplen = (*pskb)->len - tcphoff;
>+    tcph = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
>+
>+    if (tcplen != tcph->doff*4 && net_ratelimit()) {
>+	printk(KERN_ERR "xt_TCPOPTSTRIP: bad length (%u bytes)\n", (*pskb)->len);
>+	return -1;
>+    }
>+
>+    opt = (u_int8_t *)tcph;
>+
>+    for(i = sizeof(struct tcphdr); i < tcph->doff*4; i += optl) {
>+	optl = optlen(opt, i);
>+
>+	if(optl + i > tcph->doff*4)
>+	    break;
>+
>+	if (opt[i] == tinfo->tcpoption) {
>+	    for(j = 0; j < optl; j++)
>+		fast_csum(&tcph->check, opt+i+j, &newopt, i+j);
>+	    if(optl & 1)
>+		fast_csum(&tcph->check, &newopt, &newopt, i+j);
>+	    memset(opt+i, newopt, optl);
>+	    break;
>+	}
>+    }
>+    return 0;
>+}

Try CodingStyle.
>+
>+static unsigned int xt_tcpoptstrip_target4(struct sk_buff **pskb,
>+		  const struct net_device *in, const struct net_device *out,
>+		  unsigned int hooknum, const struct xt_target *target, const void *targinfo)
>+{
>+    struct iphdr *iph = ip_hdr(*pskb);
>+
>+
>+    tcpoptstrip_mangle_packet(pskb, targinfo, iph->ihl * 4,
>+			     sizeof(*iph) + sizeof(struct tcphdr));
>+    return XT_CONTINUE;
>+}
>+
>+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
>+static unsigned int
>+xt_tcpoptstrip_target6(struct sk_buff **pskb, const struct net_device *in, const struct net_device *out,
>+		  unsigned int hooknum, const struct xt_target *target, const void *targinfo)
>+{
>+    struct ipv6hdr *ipv6h = ipv6_hdr(*pskb);
>+    u8 nexthdr;
>+    int tcphoff;
>+
>+    nexthdr = ipv6h->nexthdr;
>+    tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
>+    if (tcphoff < 0) {
>+	WARN_ON(1);
>+	return NF_DROP;
>+    }
>+
>+    tcpoptstrip_mangle_packet(pskb, targinfo, tcphoff,
>+			     sizeof(*ipv6h) + sizeof(struct tcphdr));
>+    return XT_CONTINUE;
>+}
>+#endif
>+
>+static struct xt_target xt_tcpoptstrip_reg[] __read_mostly = {
>+    {
>+	.family		= AF_INET,
>+	.name		= "TCPOPTSTRIP",
>+	.target		= xt_tcpoptstrip_target4,
>+	.targetsize	= sizeof(struct xt_tcpoptstrip_info),
>+	.proto		= IPPROTO_TCP,
>+	.table          = "mangle",
>+	.me		= THIS_MODULE,
>+    },
>+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
>+    {
>+	.family		= AF_INET6,
>+	.name		= "TCPOPTSTRIP",
>+	.target		= xt_tcpoptstrip_target6,
>+	.targetsize	= sizeof(struct xt_tcpoptstrip_info),
>+	.proto		= IPPROTO_TCP,
>+	.table          = "mangle",
>+	.me		= THIS_MODULE,
>+    },
>+#endif
>+};
>+
>+static int __init xt_tcpoptstrip_init(void)
>+{
>+    return xt_register_targets(xt_tcpoptstrip_reg, ARRAY_SIZE(xt_tcpoptstrip_reg));
>+}
>+
>+static void __exit xt_tcpoptstrip_fini(void)
>+{
>+    xt_unregister_targets(xt_tcpoptstrip_reg, ARRAY_SIZE(xt_tcpoptstrip_reg));
>+}
>+
>+module_init(xt_tcpoptstrip_init);
>+module_exit(xt_tcpoptstrip_fini);
