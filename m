From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 3 Apr 2008 15:40:59 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031520250.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de> <47F4C686.2000700@trash.net> <alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr>
 <47F4D8F3.70606@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48123 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYDCNlA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:41:00 -0400
In-Reply-To: <47F4D8F3.70606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 15:17, Patrick McHardy wrote:
>> >  Is this used by userspace? If not, why change it?
>>
>>  Change, because NF_ARP is used to wrongly index into xt_afinfo -- it
>>  overlaps with PF_UNSPEC. Since NF_ARP is only used very internally in
>>  the kernel, it can be changed. To avoid problems, PF_ARP gets a
>>  proper slot.
>
> and arp isn't an address family.

Neither is PF_BRIDGE, yet this is also used.

> I would suggest to
> just define something kernel-internally that doesn't clash,
> like using AF_MAX + X as base.

Then we'd have to insert a bunch of if()s in hotpaths that
filter out the nonconformists again, or have a higher
memory footprint.

> I don't like exporting this since, as you say, userspace doesn't
> need it

Somehow you have to say that an extension if for arp only.
We could abuse ETH_P_ARP, but using just the same name and value
across both user and kernelspace seems just more logical.

static struct xtables_target new_arp_mangle = {
 	.family = ETH_P_ARP,
};
