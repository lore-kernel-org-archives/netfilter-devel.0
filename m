From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Mon, 22 Mar 2010 17:58:48 +0100
Message-ID: <4BA7A1C8.8050402@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0CVQ6v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:58:51 -0400
In-Reply-To: <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 14:35, Patrick McHardy wrote:
>>> +	/*
>>> +	 * Normally, we would just use ip_local_out. Because iph->check is
>>> +	 * already correct, we could take a shortcut and call dst_output
>>> +	 * [forwards to ip_output] directly. ip_output however will invoke
>>> +	 * Netfilter hooks
>>>       
> [ok we can skip these with IPSKB_REROUTED]
>
>   
>>>         and cause reentrancy. So we skip that too and go
>>> +	 * directly to ip_finish_output.
>>>       
>
> And since we don't want fragmentation, we would need to call
> ip_finish_output2. That function is not exported, so it is copied. I
> am not even sure what the IPv4 layer does when it has to fragment a
> fragment (because fragments don't seem to carry IP_DF).
>   

I guess whether someone wants fragmentation is a question of the specific
use case. In many possible cases conntrack might have defragmented the
packet previously to reaching TEE, so it might actually be necessary to
refragment the packet.
> Setting IP_DF on the cloned skb could possibly lead to a Packet Too
> Big being sent back to the original sender - which should probably be
> avoided too.
>   

Indeed. This might also happen if the packet is passed through another
router of course.
>
> So removing the copied code does not look that easy.
>   
Well, worst case export the original function in case of duplicating it.
