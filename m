From: Ratnaraj Mirgal <ratnaraj20@gmail.com>
Subject: queuing pkts using nf_queue_handler in bridge (PF_BRIDGE) mode not
	working in 2.6 kernel
Date: Wed, 18 Feb 2009 09:24:48 +0530
Message-ID: <c6c752b20902171954k4439c1dsc7c311c4863deaef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47988 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZBRDyv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:54:51 -0500
Received: by ey-out-2122.google.com with SMTP id 25so404687eya.37
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2009 19:54:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

i'm trying a simple lkm tht register a hook in PF_BRIDGE protocol,
also registers a queue_handler for the same.
the hook function simply returns NF_QUEUE for all IP pakcets.

i'm trying this out in 2.6.18-8.el5 (centos 5.0)

it seems like pkts are queuing up, but the _problem_ is queue_handler
is not getting invoked.
plz refer to the code below.

(NOTE: the same program worked fine in my rh9 (ie 2.4 kernel), of
course with minor nf API modification)

-------------------------------------------------
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/skbuff.h>
#include <linux/if_ether.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/list.h>
#include <linux/netfilter.h>
#include <linux/netfilter_bridge.h>
#include <linux/netfilter_ipv4.h>
#include <linux/spinlock.h>

static unsigned int ebq_hook(unsigned int hook,
struct sk_buff **pskb,
const struct net_device *in,
const struct net_device *out,
int (*okfn)(struct sk_buff *))
{
if(ntohs(ETH_P_IP) != eth_hdr(*pskb)->h_proto)
{
printk(KERN_WARNING "caught non-IP packet\n");
return NF_ACCEPT;
}
//printk(KERN_INFO "src_ip: %d.%d.%d.%d dst_ip: %d.%d.%d.%d\n",
//NIPQUAD((*pskb)->nh.iph->saddr),
//NIPQUAD((*pskb)->nh.iph->daddr));
return NF_QUEUE;
}

static struct nf_hook_ops ebq_ops =
{
.hook = ebq_hook,
.owner = THIS_MODULE,
.pf = PF_BRIDGE,
.hooknum = NF_BR_FORWARD,
.priority = NF_BR_PRI_FIRST
};

static int ebq_enqueue(struct sk_buff *skb, struct nf_info *info,
unsigned int queuenum, void *data) //start queueing.....
{
int status = -EINVAL;

printk(KERN_INFO "ebq_enqueue: inside ebq_enqueue\n");
printk(KERN_INFO "src_ip: %d.%d.%d.%d dst_ip: %d.%d.%d.%d\n",
NIPQUAD(skb->nh.iph->saddr), NIPQUAD(skb->nh.iph->daddr));

nf_reinject(skb, info, NF_ACCEPT); // :-)
status = 0;

return status; //arey... return zero directly na...
}

static struct nf_queue_handler ebq_handler =
{
.name = "testicles",
.data = NULL,
.outfn = ebq_enqueue,
};

int enter_da_dragon(void) //module loading....
{
int status = -ENOMEM;

printk(KERN_INFO "eb_queue: registering hook handler\n");

status = nf_register_hook(&ebq_ops);
if(status < 0)
{
printk(KERN_ERR "eb_queue: failed to register hook\n");
return -EINVAL;
}

printk(KERN_INFO "eb_queue: registering queue handler\n");
status = nf_register_queue_handler(PF_BRIDGE, &ebq_handler);
if(status < 0)
{
printk(KERN_ERR "eb_queue: failed 2 reg queue handler\n");
goto err_queue;
}

return status;

err_queue:
nf_unregister_hook(&ebq_ops);

return status;
}

void exit_da_dragon(void) //module exitin....
{
printk(KERN_INFO "eb_queue: unregistering queue handler\n");
nf_unregister_queue_handler(PF_BRIDGE);
printk(KERN_INFO "eb_queue: unregistering hook handler\n");
nf_unregister_hook(&ebq_ops);
}

module_init(enter_da_dragon);
module_exit(exit_da_dragon);

MODULE_DESCRIPTION("bridge mode hook!!!");
MODULE_LICENSE("GPL");
-----------------------------------------------------

i tried to search the solution for this in kernel/net/bridge
directory, but didn't find it (or wasn't able to locate it)

is there any other way to do this??

TIA,
Ratnaraj
