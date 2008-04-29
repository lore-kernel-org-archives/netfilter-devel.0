From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 12:22:31 +0200
Message-ID: <4816F6E7.5040009@trash.net>
References: <4816B5A1.8050906@snapgear.com>	<4816B829.9080206@trash.net>	<4816DF00.8060704@snapgear.com> <20080429.032008.163377774.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: philipc@snapgear.com, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49116 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYD2KWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:22:33 -0400
In-Reply-To: <20080429.032008.163377774.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Philip Craig <philipc@snapgear.com>
> Date: Tue, 29 Apr 2008 18:40:32 +1000
>
>   
>> Patrick McHardy wrote:
>>     
>>> I think the memset-solution is preferrable, using byte-wise
>>> accesses to the entire tuple would really suck.
>>>       
>> Here's the memset patch.
>>     
>
> Looks good to me, Patrick?
>   

Yes, please apply. I'm travelling, so I can't test myself, but
I'll also have a closer look once I return home. Thanks.



