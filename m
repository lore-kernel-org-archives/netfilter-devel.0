From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] extensions: add IPv6 MASQUERADE extension
Date: Thu, 9 Aug 2012 23:30:10 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208092329260.26308@stinky-local.trash.net>
References: <1344543073-11660-1-git-send-email-kaber@trash.net>
 <1344543073-11660-3-git-send-email-kaber@trash.net>
 <alpine.LNX.2.01.1208092310250.10514@frira.zrqbmnf.qr>
 <Pine.GSO.4.63.1208092319250.25804@stinky-local.trash.net>
 <alpine.LNX.2.01.1208092325410.10514@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33041 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab2HIVaM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:30:12 -0400
In-Reply-To: <alpine.LNX.2.01.1208092325410.10514@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 9 Aug 2012, Jan Engelhardt wrote:

>
> On Thursday 2012-08-09 23:22, Patrick McHardy wrote:
>>>
>>> Is it perhaps feasible to rename libipt_DNAT.c to libxt_DNAT.c
>>> and thus have the v4 and v6 parts in the same file? In userspace
>>> we do not have to fear depending on ipv6.ko like for kernel modules.
>>
>> I did that at first, but they use different structures
>> (nf_nat_ipv4_multi_range_compat vs. nf_nat_range), so there's actually
>> almost no code which can be shared.
>
> Will we be able to use nf_nat_range for IPv4 NAT parts
> in the future as well?

I've added a v1 version of SNAT/DNAT, which use nf_nat_range.
We certainly can do this for MASQUERADE as well.
