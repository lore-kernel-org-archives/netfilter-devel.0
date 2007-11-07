From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Wed, 07 Nov 2007 11:33:04 +0100
Message-ID: <47319460.8040305@trash.net>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: ron lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57452 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXKGKdV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:33:21 -0500
In-Reply-To: <47318A3C.5070701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> ron lai wrote:
>> I've verified that the module works fine if no bridge is used. 
>> Unfortunately the patch doesn't fix the 2-calls-of-the-helper-function 
>> problem if a bridge is applied to the system.
> 
> 
> Strange, I can't reproduce this. To clarify - you're using only a
> single bridge with one device, or two bridges with one device each?


I can reproduce this with forwarding between two bridges.
The reason is that skb->nf_bridge still contains the data
from the first bridge and so br_netfilter thinks this is
a bridged packet. I don't know how this is supposed to work,
but it seems to me that on packets going out a bridge device
this should be reset in case it originates from a different
bridge (actually I think it should be reset unconditionally
but that would probably break bridged DNAT).

Bart, what do you think about changing this:

static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff 
*skb, ...
{
	...
         nf_bridge = skb->nf_bridge;
         if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
                 return NF_ACCEPT;

to:

         if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
		nf_bridge_put(skb->nf_bridge),
		skb->nf_bridge = NULL;
		return NF_ACCEPT;
	}

?
