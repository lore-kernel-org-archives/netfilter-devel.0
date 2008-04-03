From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 15:44:58 +0200
Message-ID: <47F4DF5A.8090907@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de> <47F4C686.2000700@trash.net> <alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr> <47F4D8F3.70606@trash.net> <alpine.LNX.1.10.0804031520250.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYDCNpE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:45:04 -0400
In-Reply-To: <alpine.LNX.1.10.0804031520250.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Thursday 2008-04-03 15:17, Patrick McHardy wrote:
>>> >  Is this used by userspace? If not, why change it?
>>>
>>>  Change, because NF_ARP is used to wrongly index into xt_afinfo -- it
>>>  overlaps with PF_UNSPEC. Since NF_ARP is only used very internally in
>>>  the kernel, it can be changed. To avoid problems, PF_ARP gets a
>>>  proper slot.
>>
>> and arp isn't an address family.
> 
> Neither is PF_BRIDGE, yet this is also used.

That has a different reason and is not ideal either.

>> I would suggest to
>> just define something kernel-internally that doesn't clash,
>> like using AF_MAX + X as base.
> 
> Then we'd have to insert a bunch of if()s in hotpaths that
> filter out the nonconformists again, or have a higher
> memory footprint.

You don't need any new conditions for this.

>> I don't like exporting this since, as you say, userspace doesn't
>> need it
> 
> Somehow you have to say that an extension if for arp only.
> We could abuse ETH_P_ARP, but using just the same name and value
> across both user and kernelspace seems just more logical.
> 
> static struct xtables_target new_arp_mangle = {
>     .family = ETH_P_ARP,
> };

Whats the problem with moving NF_ARP outside userspace
visibility and defining it to AF_MAX + 1?


