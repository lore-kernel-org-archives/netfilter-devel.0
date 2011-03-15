From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 2/2] netfilter: xt_addrtype: ipv6 support.
Date: Tue, 15 Mar 2011 14:30:03 +0100
Message-ID: <4D7F69DB.7070606@trash.net>
References: <1299619045-4027-1-git-send-email-fw@strlen.de> <1299619045-4027-2-git-send-email-fw@strlen.de> <20110310222204.GZ8821@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab1CONaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:30:04 -0400
In-Reply-To: <20110310222204.GZ8821@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.03.2011 23:22, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
>> index e89c0b8..2220b85 100644
>> --- a/net/netfilter/xt_addrtype.c
>> +++ b/net/netfilter/xt_addrtype.c
> [..]
>> +	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
>> +	     XT_ADDRTYPE_UNREACHABLE) & mask) {
>> +		struct rt6_info *rt;
>> +		u32 type;
>> +		int ifindex = dev ? dev->ifindex : 0;
>> +
>> +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
>> +
> 
> This needs a Kconfig
> 	 depends on (IPV6 || IPV6=n)
> 
> to avoid linker errors for the ipv6=m and xt_addrtype=y case.
> 
> Patrick, I'll refrain from sending v3 for now in case any other changes
> might be needed.
> 
> Please let me know if you want me to send a V3 with the Kconfig change
> only.

Please do, I plan to submit my remaining patches for 2.6.39 tonight.
