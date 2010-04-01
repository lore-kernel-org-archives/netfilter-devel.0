From: Mark Ryden <markryde@gmail.com>
Subject: netfilter module and shared libraries
Date: Thu, 1 Apr 2010 14:46:57 +0300
Message-ID: <m2zdac45061004010446o99e12733m645008caac88873c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40626 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab0DALq7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:46:59 -0400
Received: by bwz1 with SMTP id 1so769444bwz.21
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Apr 2010 04:46:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I wrote a simple, short (35 lines) netfilter module (XTable target)
The code is below.
I build it and insmoded it.
When I try to add this iptables rule:

iptables -A OUTPUT -p UDP --dport 9998 -j ECHO

I get this error:

iptables v1.4.5: Couldn't load target `ECHO':/lib64/xtables/libipt_ECHO.so:
cannot open shared object file: No such file or directory


My question is: for a simple netfilter module like this ("ECHO"), must
I create a
corresponding shared library  (libipt_ECHO.so)?

Is there a way to avoid this when adding such a rule,
using some default mechansim ?
	
here is the code for the kernel module I wrote:	

// echoTarget.c

#include "linux/netfilter/x_tables.h"

static unsigned int echo_tg4(struct sk_buff *skb,
														 const struct xt_target_param *par)
{
	printk("in %s %s\n",__FUNCTION__,__FILE__);
	return NF_DROP;
}

static struct xt_target echo_tg_reg = {
	.name     = "ECHO",
	.revision = 0,
	.family   = NFPROTO_IPV4,
	.proto    = IPPROTO_UDP,
	.target   = echo_tg4,
	.me       = THIS_MODULE,
};

static int __init echo_tg_init(void)
{
	return xt_register_target(&echo_tg_reg);
	
}

static void __exit echo_tg_exit(void)
{
	xt_unregister_target(&echo_tg_reg);
}

module_init(echo_tg_init);
module_exit(echo_tg_exit);

MODULE_AUTHOR ("test");
MODULE_DESCRIPTION ("tartet");
MODULE_LICENSE("GPL");
