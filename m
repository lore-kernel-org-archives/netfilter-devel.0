From: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Subject: Why this hook_func could not run correctly?
Date: Wed, 3 Mar 2010 21:59:47 +0800
Message-ID: <28efc0211003030559u7accf278n61535c8ef33b46e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:27195 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab0CCN7s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:59:48 -0500
Received: by qw-out-2122.google.com with SMTP id 8so186974qwh.37
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Mar 2010 05:59:47 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,i am in trouble.what i do is that write a hook function which have
the same impression of the iptables's rules below:
# SYN and FIN are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
# SYN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# FIN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
# FIN is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
# PSH is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
# URG is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP

this is my code:
#include <linux/module.h>	
#include <linux/kernel.h>	
#include <linux/init.h>		
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/tcp.h>
static struct nf_hook_ops nfho;
static struct tcphdr *tcp;
static unsigned int hook_func(unsigned int hooknum,
		       struct sk_buff *skb,
		       const struct net_device *in,
		       const struct net_device *out,
		       int (*okfn)(struct sk_buff *))
{
    if(skb->dev == out)
    {
	return NF_ACCEPT;
    }
    tcp = tcp_hdr(skb);
    if(tcp->syn == 1 && (tcp->fin == 1 || tcp->rst == 1))
    {
	printk("1drop1drop \n");
	return NF_DROP;
    }
    if(tcp->fin == 1 && (tcp->rst == 1 || tcp->ack == 0))
    {
	printk("2drop2drop \n");
	return NF_DROP;
    }
    if(tcp->ack == 0 && (tcp->psh == 1 || tcp->urg == 1))
    {
	printk("3drop3drop \n");
	return NF_DROP;
    }
    return NF_ACCEPT;
}
static int __init myfirewall_init(void)
{
    /* Fill in our hook structure */
    nfho.pf  = PF_INET;
    nfho.priority = 1;
    nfho.hooknum = NF_INET_PRE_ROUTING;
    nfho.hook = hook_func;
    nf_register_hook(&nfho);
    return 0;	
}
static void __exit myfirewall_exit(void)
{
    nf_unregister_hook(&nfho);
}
module_init(myfirewall_init);
module_exit(myfirewall_exit);

The iptables's rules is ok(which is found in the book <<Linux
Firewalls, Third Edition>>),the problem is that my code could not run
correctly in the kernel.When i insmod the code,the browser could not
open any site.
So who can tell me that where in my code is not right.........
