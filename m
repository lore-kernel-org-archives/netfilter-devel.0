From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 15 Jan 2007 21:02:02 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701152047250.23841@yvahk01.tjqt.qr>
References: <20070114192011.GA6270@clipper.ens.fr> <45ABCB29.7080600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Madore <david.madore@ens.fr>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45ABCB29.7080600@trash.net>
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


On Jan 15 2007 19:42, Patrick McHardy wrote:
>> Implement TCPMSS target for IPv6 by shamelessly copying from
>> Marc Boucher's IPv4 implementation.
>
>This is an x_tables port of the TCPMSS target. Care to give it a try?
>I believe Yasuyuki is currently working on proper x_tables support
>for userspace, but that might still take a while, so If you send me
>your userspace port I'll add it to SVN for the time being.


>+#endif /* _XT_TCPMSS_H*/
                        ^
nitpick: space

>+	  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
>+	                 -j TCPMSS --clamp-mss-to-pmtu

This should probably be --tcp-flags SYN,RST,FIN SYN or just --syn.

>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
>+MODULE_DESCRIPTION("x_tables TCP MSS modification module");
>+MODULE_ALIAS("ipt_TCPMSS");
>+MODULE_ALIAS("ip6t_TCPMSS");

One thing that comes to mind: what is the exact name of it? xtables?
x_tables? In ipt_*, one could also see "IP tables" and so on. The
actual userspace program is called 'iptables', so I'd go for
'xtables'. Though, it's just a userspace tool. Someone could come
along and make a SuperTables that still works with the existing
netfilter code in the kernel, making it 'netfilter TCP MSS
modification module' rather than 'x_tables...'. Well, before my
thoughts crumble, let me know something :)


>+static int
>+xt_tcpmss_checkentry4(const char *tablename,
>+		      const void *entry,
>+		      const struct xt_target *target,
>+		      void *targinfo,
>+		      unsigned int hook_mask)
>+{
>+	const struct xt_tcpmss_info *info = targinfo;
>+	const struct ipt_entry *e = entry;
>+
>+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
>+	    (hook_mask & ~((1 << NF_IP_FORWARD) |
>+			   (1 << NF_IP_LOCAL_OUT) |
>+			   (1 << NF_IP_POST_ROUTING))) != 0) {
>+		printk("xt_TCPMSS: path-MTU clamping only supported in "
>+		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
>+		return 0;
>+	}
>+	if (IPT_MATCH_ITERATE(e, find_syn_match))
>+		return 1;
>+	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
>+	return 0;
>+}

The hook_mask check could be done with struct xt_target->hooks, could
not it? (see this:)

>+static struct xt_target xt_tcpmss_reg[] = {
>+	{
>+		.family		= AF_INET,
>+		.name		= "TCPMSS",
>+		.checkentry	= xt_tcpmss_checkentry4,
>+		.target		= xt_tcpmss_target4,
>+		.targetsize	= sizeof(struct xt_tcpmss_info),
>+		.proto		= IPPROTO_TCP,
>+		.me		= THIS_MODULE,
		.hooks		= (1 << ...),
};


	-`J'
-- 
