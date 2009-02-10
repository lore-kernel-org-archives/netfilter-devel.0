From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: -m state is not working.
Date: Tue, 10 Feb 2009 12:48:57 +0100
Message-ID: <200902101248.58046.christoph.paasch@gmail.com>
References: <498AFBBC.20608@metu.edu.tr> <200902101006.02550.christoph.paasch@gmail.com> <alpine.LSU.2.00.0902101012060.21522@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, hdemir@metu.edu.tr,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:49622 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBJLtC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:49:02 -0500
Received: by ey-out-2122.google.com with SMTP id 25so592423eya.37
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 03:49:00 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902101012060.21522@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue February 10 2009, Jan Engelhardt wrote:
> It [Xtables kernel code] will not use l3proto_generic, because
>
>         if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
>                 printk(KERN_WARNING "can't load conntrack support for "
>                                     "proto=%u\n", par->match->family);
>                 return false;
>         }
>
> already catches the "mistake" (of having forgotten to build the
> _ipv4/_ipv6 module), and returns EINVAL to userspace.
Ups, didn't knew about that. Thanks... :-)

>
> In other words: always look into dmesg for messages!
>
>
> Only nf_conntrack will use l3proto_generic, but nf_conntrack is
> independent of Xtables ;-)

I'm asking me, why does xt_state needs an l3 handler different from generic? 
(the call to nf_ct_l3proto_try_module_get ensures this)
Why not trying to handle l3 and l4 in a generic way, if there is no other 
module compiled into the kernel, and so being able to access the state via 
xt_state.

In any case, in my opinion, the generic l3 handler doesn't serves anything, 
because it will return -NF_ACCEPT at the call to get_l4proto. Why not 
associate the l4 generic handler to the l3-one? That way, the tracking for 
unknown protocols (or not compiled into the kernel) can continue.

Christoph

P.S.: Jan, did you took a look at the code I sended to you? It's no problem, 
if you didn't had the time...

