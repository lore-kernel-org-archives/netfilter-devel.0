From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH v2] netfilter: ebt_ip6: allow matching on ipv6-icmp types/codes
Date: Tue, 18 Jan 2011 21:10:41 +0100
Message-ID: <4D35F3C1.7040108@pandora.be>
References: <1292857067-1595-1-git-send-email-fw@strlen.de> <4D0F9D9F.7090608@pandora.be> <4D2E1A01.1060105@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:44625 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1ARUKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:10:45 -0500
In-Reply-To: <4D2E1A01.1060105@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12-01-11 22:15, Pablo Neira Ayuso wrote:
> On 20/12/10 19:17, Bart De Schuymer wrote:
>> Op 20/12/2010 15:57, Florian Westphal schreef:
>>> To avoid adding a new match revision icmp type/code are stored
>>> in the sport/dport area.
>>>
>>> Signed-off-by: Florian Westphal<fw@strlen.de>
>>> Reviewed-by: Holger Eitzenberger<holger@eitzenberger.org>
>>> ---
>>>    Changes since v1:
>>>     - use u16 where appropriate
>>>     - use proper () in if condition
>>>     - renamed _ports to _pkthdr
>>>     - add comment that sizeof(_pktheader) is also ok in ICMP6 case.
>>>
>>>    include/linux/netfilter_bridge/ebt_ip6.h |   15 ++++++++--
>>>    net/bridge/netfilter/ebt_ip6.c           |   46
>>> ++++++++++++++++++++++--------
>>>    2 files changed, 46 insertions(+), 15 deletions(-)
>>>
>> OK for me.
>>
>> Reviewed-by: Bart De Schuymer<bdschuym@pandora.be>
>
> Applied, thanks!
>
> Did you already included the user-space part to ebtables?

I've applied the userspace patch, thanks again.

Bart



-- 
Bart De Schuymer
www.artinalgorithms.be
