From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Wed, 16 Mar 2011 17:03:50 +0100
Message-ID: <4D80DF66.1020902@trash.net>
References: <1300214971-20345-1-git-send-email-fw@strlen.de> <1300214971-20345-2-git-send-email-fw@strlen.de> <4D80C12E.4010107@trash.net> <20110316141948.GA13371@Chamillionaire.breakpoint.cc> <20110316155957.GB13371@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1CPQDx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:03:53 -0400
In-Reply-To: <20110316155957.GB13371@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.03.2011 16:59, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> Patrick McHardy <kaber@trash.net> wrote:
>>>> +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
>>>
>>> Florian, I just noticed that this will pull in the IPv6 module just
>>> by loading the xt_addrtype module.
>>
>> Yes...
>>
>>> Can we convert this to use
>>> nf_ip6_afinfo->route() instead?
>>
>> I agree that it would be much nicer, thanks for the
>> suggestion.
>>
>> I'll look into this on Saturday.
> 
> Regardless if this works or not, we'd also
> need to find an alternative to ipv6_addr_type, no?

No, addrconf_core.o is statically linked regardless of whether
IPv6 is a module or not.
