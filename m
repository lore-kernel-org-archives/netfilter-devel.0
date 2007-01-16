From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Tue, 16 Jan 2007 13:20:17 +0100
Message-ID: <45ACC301.9030701@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr> <45ABCB29.7080600@trash.net>
	<Pine.LNX.4.61.0701152047250.23841@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: David Madore <david.madore@ens.fr>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701152047250.23841@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Jan 15 2007 19:42, Patrick McHardy wrote:
> 
>>+#endif /* _XT_TCPMSS_H*/
> 
>                         ^
> nitpick: space
> 
> 
>>+	  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
>>+	                 -j TCPMSS --clamp-mss-to-pmtu
> 
> 
> This should probably be --tcp-flags SYN,RST,FIN SYN or just --syn.

Both fixed, thanks.

> 
> 
>>+MODULE_LICENSE("GPL");
>>+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
>>+MODULE_DESCRIPTION("x_tables TCP MSS modification module");
>>+MODULE_ALIAS("ipt_TCPMSS");
>>+MODULE_ALIAS("ip6t_TCPMSS");
> 
> 
> One thing that comes to mind: what is the exact name of it? xtables?
> x_tables? In ipt_*, one could also see "IP tables" and so on. The
> actual userspace program is called 'iptables', so I'd go for
> 'xtables'. Though, it's just a userspace tool. Someone could come
> along and make a SuperTables that still works with the existing
> netfilter code in the kernel, making it 'netfilter TCP MSS
> modification module' rather than 'x_tables...'. Well, before my
> thoughts crumble, let me know something :)

Most modules use x_tables in their description. I don't care
at all.

>>+static int
>>+xt_tcpmss_checkentry4(const char *tablename,
>>+		      const void *entry,
>>+		      const struct xt_target *target,
>>+		      void *targinfo,
>>+		      unsigned int hook_mask)
>>+{
>>+	const struct xt_tcpmss_info *info = targinfo;
>>+	const struct ipt_entry *e = entry;
>>+
>>+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
>>+	    (hook_mask & ~((1 << NF_IP_FORWARD) |
>>+			   (1 << NF_IP_LOCAL_OUT) |
>>+			   (1 << NF_IP_POST_ROUTING))) != 0) {
>>+		printk("xt_TCPMSS: path-MTU clamping only supported in "
>>+		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
>>+		return 0;
>>+	}
>>+	if (IPT_MATCH_ITERATE(e, find_syn_match))
>>+		return 1;
>>+	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
>>+	return 0;
>>+}
> 
> 
> The hook_mask check could be done with struct xt_target->hooks, could
> not it? (see this:)

No, the hooks only matter for pmtu clamping.
