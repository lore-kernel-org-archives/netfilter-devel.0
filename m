From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 15:22:03 +0200
Message-ID: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0H3NWF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:22:05 -0400
Received: by wyb35 with SMTP id 35so6594519wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 06:22:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all!
I've write the following  (and dummy) module that drops all packet...
but...now? after i write the module i can use it?
for example: i want digit:
iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
but i don't know how create this new target...
I've modified the netfilter makefile e Kbuild file (in net/netfilter),
and then i've do 'make' 'make modules' 'make modules_install' but
after i digit iptables i have this message

"iptables v1.4.2: Couldn't load target `TAR':/lib/xtables/libipt_TAR.
so: cannot open shared object file: No such file or directory"

what's my problem?


code:
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/netfilter/x_tables.h>

static unsigned int xt_tar_target(unsigned int hook,
                                                 struct sk_buff **skb,
                                                 const struct net_device *in,
                                                 const struct net_device *out,
                                                 int (*okfn)(struct sk_buff*))
{
    printk(KERN_INFO "ciaociao");
    return NF_DROP;
}

static struct xt_target xt_tar_reg = {
    .name       = "TAR",
    .family     = AF_INET,
    .proto      = IPPROTO_TCP,
    .target     = xt_tar_target,
    .me         = THIS_MODULE,
};

static int __init xt_tar_init(void)
{
    return xt_register_target(&xt_tar_reg);
}

static void __exit xt_tar_exit(void)
{
    xt_unregister_target(&xt_tar_reg);
}

module_init(xt_tar_init);
module_exit(xt_tar_exit);

MODULE_DESCRIPTION("np des");
MODULE_LICENSE("GPL");
MODULE_ALIAS("xt_TAR");
