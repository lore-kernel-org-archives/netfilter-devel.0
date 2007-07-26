From: Giacomo <delleceste@gmail.com>
Subject: REGISTERING with netfilter hooks - strange behaviour
Date: Thu, 26 Jul 2007 17:04:37 +0200
Message-ID: <885896af0707260804l18b7019ai399026d0a8906fe4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi!

I have written a kernel module which registers with netfilter hooks

Since kernel 2.6.22, i noticed that in the PRE/INPUT case

the transport data which i receive is not correct:


EXAMPLE:

/* THIS IS THE CALLBACK registered by nf_register_hook() */
unsigned int
deliver_process_by_direction(unsigned int hooknum,
		struct sk_buff **skb,
		const struct net_device *in,
		const struct net_device *out,
		int (*okfn) (struct sk_buff *))
{
	struct tcphdr* tcph;
	struct iphdr *iph;
	if(*skb != NULL)
	{
		iph = (struct iphdr*) skb_network_header(*skb);
		if(iph != NULL)
		{
			if (iph->protocol == IPPROTO_TCP)
			{
				tcph = (struct tcphdr *)skb_transport_header(*skb);
				printk("SOURCE: %d - DEST: %d ",
				       ntohs(tcph->source), ntohs(tcph->dest) );
			}
		}
	}


/* THE printk() writes  values  that look like they were uninitialized */
THe same happens with

ip_hdr(*skb)
and tcp_hdr();

This happens in NF_PRE and NF_IN

Thanks for any suggestion.

The registering happens here:

int register_hooks(void)
{
	printk("_____________REGISTERING HOOKS\n");
	/* pre routing */
	nfh_pre.pf = PF_INET;
	nfh_pre.hooknum = NF_IP_PRE_ROUTING;
	/* make our function last (packets will arrive defragmented..) */
	nfh_pre.priority = NF_IP_PRI_LAST;	
	nfh_pre.hook = deliver_process_by_direction;
	nf_register_hook(&nfh_pre);
	/* input */
	nfh_in.pf = PF_INET;
	nfh_in.hooknum = NF_IP_LOCAL_IN;
	nfh_in.priority = NF_IP_PRI_FIRST;	/* make our function first */
	nfh_in.hook = deliver_process_by_direction;
	nf_register_hook(&nfh_in);
	/* forward */
	nfh_fwd.pf = PF_INET;
	nfh_fwd.hooknum = NF_IP_FORWARD;
	nfh_fwd.priority = NF_IP_PRI_FIRST;	/* make our function first */
	nfh_fwd.hook = deliver_process_by_direction;
	nf_register_hook(&nfh_fwd);
	/* output */
	nfh_out.pf = PF_INET;
	nfh_out.hooknum = NF_IP_LOCAL_OUT;
	nfh_out.priority = NF_IP_PRI_FIRST;	/* make our function first */
	nfh_out.hook = deliver_process_by_direction;
	nf_register_hook(&nfh_out);
	/* post routing */
	nfh_post.pf = PF_INET;
	nfh_post.hooknum = NF_IP_POST_ROUTING;
	nfh_post.priority = NF_IP_PRI_LAST;	/* make our function first */
	nfh_post.hook = deliver_process_by_direction;
	nf_register_hook(&nfh_post);
	return 0;
}

thanks a lot in advance

Giacomo






-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

IPFIREwall (http://www.giacomos.it/ipfire) viene presentato
all'Universita` degli Studi di Udine, il 28 ottobre, in occasione del
Linux Day 2006:
http://iglu.cc.uniud.it/linuxday

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
