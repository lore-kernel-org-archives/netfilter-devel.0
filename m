From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: (pull) pending patches
Date: Mon, 16 Mar 2009 17:49:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903161748170.15852@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr> <49BE0FF3.5090906@netfilter.org> <alpine.LSU.2.00.0903161153030.26752@fbirervta.pbzchgretzou.qr> <49BE567F.1020704@trash.net> <alpine.LSU.2.00.0903161441001.4673@fbirervta.pbzchgretzou.qr>
 <49BE574E.8070202@trash.net> <alpine.LSU.2.00.0903161739080.15852@fbirervta.pbzchgretzou.qr> <49BE81E2.2030805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48264 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbZCPQtS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:49:18 -0400
In-Reply-To: <49BE81E2.2030805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-16 17:44, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> On Monday 2009-03-16 14:42, Patrick McHardy wrote:
>>
>>> Jan Engelhardt wrote:
>>>> On Monday 2009-03-16 14:39, Patrick McHardy wrote:
>>>>
>>>>> We used to have ip_nat_range(_compat) for compatibility for that reason
>>>>> IIRC. The kernel doesn't need anymore, so I think userspace should carry
>>>>> a copy as long as ipt_SAME is still supported.
>>>>>
>>>> But that only makes it harder to keep files in sync :-/
>>> There is nothing to keep in sync, ipt_SAME doesn't exist in the kernel
>>> anymore. And a structure kept purely to maintain compatibility with old
>>> kernels will obviously never change.
>>>
>> All NAT modules -- libipt_DNAT, SNAT, MASQUERADE, NETMAP, REDIRECT --
>> use struct nf_nat_multi_range, which is also only in nf_nat.h.
>
> Indeed, that one should be exported. But in order to that is should
> be moved to include/linux/netfilter instead of using include/net
> includes in userspace.
>
I agree. If however it does not make it into 2.6.29 I would suggest
going with the proposed iptables tree with a manually-copied
nf_nat.h, though.
