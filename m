From: ratheesh kannoth <ratheesh.ksz@gmail.com>
Subject: track dns udp packet
Date: Tue, 25 Oct 2011 22:57:32 +0530
Message-ID: <CAGZFCEH4eexuN36PDaacGPkAxZ2KW90g86Jh1dvmMubes-ntFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62108 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1JYR1d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:27:33 -0400
Received: by faan17 with SMTP id n17so746813faa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2011 10:27:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I wrote a  module to track the udp dns query. It is not working, what
could be the problem ?

#include <linux/module.h>
#include <linux/kernel.h>
#include <net/netfilter/nf_conntrack.h>
#include <net/netfilter/nf_conntrack_helper.h>
#include <linux/ip.h>
#include <net/netfilter/nf_conntrack_expect.h>

MODULE_LICENSE("GPL");


static const struct nf_conntrack_expect_policy my_expect_policy = {
        .max_expected           = 1,
};

static int foo_help(struct sk_buff *skb,
                    unsigned int protoff,
                   struct nf_conn *ct,
                    enum ip_conntrack_info conntrackinfo)
{

        printk (KERN_ALERT "A dns query is sent out \n");
        return NF_ACCEPT;
}

static struct nf_conntrack_helper foo;



int init_conntrack_module(void)
{
        int ret = -1;
        memset(&foo, 0, sizeof(struct nf_conntrack_helper));
        foo.name = "foo";
        foo.me = THIS_MODULE;
        foo.tuple.dst.protonum = IPPROTO_UDP;
        foo.tuple.dst.u.udp.port = htons(53);
        foo.help = foo_help;
        foo.expect_policy = &my_expect_policy;
        ret = nf_conntrack_helper_register(&foo);
        printk ("Registration ret = %d\n", ret);
        return ret;
}

void  fini_conntrack_module(void)
{
        nf_conntrack_helper_unregister(&foo);
}

module_init(init_conntrack_module);
module_exit(fini_conntrack_module);
