From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Why this hook_func could not run correctly?
Date: Wed, 3 Mar 2010 15:18:50 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003031517040.18047@obet.zrqbmnf.qr>
References: <28efc0211003030559u7accf278n61535c8ef33b46e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44693 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab0CCOSw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:18:52 -0500
In-Reply-To: <28efc0211003030559u7accf278n61535c8ef33b46e2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-03 14:59, supercodeing35271 supercodeing35271 wrote:
>
>this is my code:
>#include <linux/module.h>	
>#include <linux/kernel.h>	
>#include <linux/init.h>		
>#include <linux/netfilter.h>
>#include <linux/netfilter_ipv4.h>
>#include <linux/ip.h>
>#include <linux/tcp.h>
>static struct tcphdr *tcp;

This is terribly SMP-unsafe/racey.

>static unsigned int hook_func(unsigned int hooknum,
>		       struct sk_buff *skb,
>		       const struct net_device *in,
>		       const struct net_device *out,
>		       int (*okfn)(struct sk_buff *))
>{
>    if(skb->dev == out)
>    {
>	return NF_ACCEPT;
>    }
>    tcp = tcp_hdr(skb);

The packet might be fragmented, or incomplete. Thus you have a potential
access-beyond end-of-packet here.

>    if(tcp->syn == 1 && (tcp->fin == 1 || tcp->rst == 1))
>    {
>	printk("1drop1drop \n");
>	return NF_DROP;
>    }
>    if(tcp->fin == 1 && (tcp->rst == 1 || tcp->ack == 0))
>    {
>	printk("2drop2drop \n");
>	return NF_DROP;
>    }
>    if(tcp->ack == 0 && (tcp->psh == 1 || tcp->urg == 1))
>    {
>	printk("3drop3drop \n");
>	return NF_DROP;
>    }
>    return NF_ACCEPT;
>}
>static int __init myfirewall_init(void)
>{
>    /* Fill in our hook structure */
>    nfho.pf  = PF_INET;
>    nfho.priority = 1;
>    nfho.hooknum = NF_INET_PRE_ROUTING;
>    nfho.hook = hook_func;
>    nf_register_hook(&nfho);
>    return 0;	
>}
>static void __exit myfirewall_exit(void)
>{
>    nf_unregister_hook(&nfho);
>}
>module_init(myfirewall_init);
>module_exit(myfirewall_exit);
>
>The iptables's rules is ok(which is found in the book <<Linux
>Firewalls, Third Edition>>),the problem is that my code could not run
>correctly in the kernel.When i insmod the code,the browser could not
>open any site.
>So who can tell me that where in my code is not right.........
