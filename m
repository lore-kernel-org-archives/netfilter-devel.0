From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Mon, 22 Mar 2010 18:45:50 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr> <4BA7A1C8.8050402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43850 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab0CVRpv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:45:51 -0400
In-Reply-To: <4BA7A1C8.8050402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-03-22 17:58, Patrick McHardy wrote:
>>   
>>>>         and cause reentrancy. So we skip that too and go
>>>> +	 * directly to ip_finish_output.
>>
>> And since we don't want fragmentation, we would need to call
>> ip_finish_output2. That function is not exported, so it is copied. I
>> am not even sure what the IPv4 layer does when it has to fragment a
>> fragment (because fragments don't seem to carry IP_DF).
>
>I guess whether someone wants fragmentation is a question of the specific
>use case. In many possible cases conntrack might have defragmented the
>packet previously to reaching TEE, so it might actually be necessary to
>refragment the packet.

Aww..true.

>> Setting IP_DF on the cloned skb could possibly lead to a Packet Too
>> Big being sent back to the original sender - which should probably be
>> avoided too.
>
>Indeed. This might also happen if the packet is passed through another
>router of course.

Right. So let's set IP_DF on the teed packet and let the sender
reduce its packet size to accomodate for the (hidden) tee route :)

Is it ok if the Packet Too Big notification is received by the
original sender much later than an acknowledgement in reception to
the packet?

# Topology
digraph {
   A -- internet_cloud;
   internet_cloud -- R;
   R -- B [label="mtu=1500"];
   R -- C [label="mtu=1480"];
};

1. A->B TCP received by R
2. R clones to C
3. B receives and responds with TCP ACK
4. A receives ACK
5. A receives the PMTU update from R while trying to send to C
