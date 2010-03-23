From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 13:04:26 +0100
Message-ID: <4BA8AE4A.5090805@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr> <4BA7A1C8.8050402@trash.net> <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56307 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0CWME0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:04:26 -0400
In-Reply-To: <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-03-22 17:58, Patrick McHardy wrote:
>>>   
>>>>>         and cause reentrancy. So we skip that too and go
>>>>> +	 * directly to ip_finish_output.
>>> And since we don't want fragmentation, we would need to call
>>> ip_finish_output2. That function is not exported, so it is copied. I
>>> am not even sure what the IPv4 layer does when it has to fragment a
>>> fragment (because fragments don't seem to carry IP_DF).
>> I guess whether someone wants fragmentation is a question of the specific
>> use case. In many possible cases conntrack might have defragmented the
>> packet previously to reaching TEE, so it might actually be necessary to
>> refragment the packet.
> 
> Aww..true.
> 
>>> Setting IP_DF on the cloned skb could possibly lead to a Packet Too
>>> Big being sent back to the original sender - which should probably be
>>> avoided too.
>> Indeed. This might also happen if the packet is passed through another
>> router of course.
> 
> Right. So let's set IP_DF on the teed packet and let the sender
> reduce its packet size to accomodate for the (hidden) tee route :)
> 
> Is it ok if the Packet Too Big notification is received by the
> original sender much later than an acknowledgement in reception to
> the packet?

I think its the responsibility of the admin to make sure that
doesn't happen.
