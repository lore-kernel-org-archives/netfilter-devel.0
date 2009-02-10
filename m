From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: -m state is not working.
Date: Tue, 10 Feb 2009 10:15:07 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902101012060.21522@fbirervta.pbzchgretzou.qr>
References: <498AFBBC.20608@metu.edu.tr> <4990638A.1090208@trash.net> <499127AB.2050702@metu.edu.tr> <200902101006.02550.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hdemir@metu.edu.tr, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZBJJPJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:15:09 -0500
In-Reply-To: <200902101006.02550.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-10 10:06, Christoph Paasch wrote:
>On Tue February 10 2009, Husnu Demir wrote:
>>
>> I forgat to add that support :) But xt_state should not be seen if
>> nf_conntrack_ipv4 is not selected on the kernel config. It is useless
>> without nf_conntrack_ipv4 support.
>
>Well, xt_state doesn't depends on nf_conntrack_ipv4, it can also be use 
>nf_conntrack_ipv6 or any other module you write yourself. The thing is that 
>without nf_conntrack_ipv4 (or *_ipv6), it uses nf_conntrack_l3proto_generic, 
>which won't be tracked, because get_l4proto(...) returns -NF_ACCEPT.

It [Xtables kernel code] will not use l3proto_generic, because

        if (nf_ct_l3proto_try_module_get(par->match->family) < 0) { 
                printk(KERN_WARNING "can't load conntrack support for " 
                                    "proto=%u\n", par->match->family); 
                return false; 
        } 

already catches the "mistake" (of having forgotten to build the
_ipv4/_ipv6 module), and returns EINVAL to userspace.

In other words: always look into dmesg for messages!


Only nf_conntrack will use l3proto_generic, but nf_conntrack is
independent of Xtables ;-)
