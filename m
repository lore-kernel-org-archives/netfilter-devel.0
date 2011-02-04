From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: WIP/RFC: add new module ebt_NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 14:20:19 +0100
Message-ID: <4D4BFD13.8090306@edenwall.com>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-1-git-send-email-chifflier@edenwall.com> <4D4BCF5E.8020100@edenwall.com> <4D4BFA1D.4070007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:48357 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752757Ab1BDNUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:20:22 -0500
In-Reply-To: <4D4BFA1D.4070007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/04/2011 02:07 PM, Patrick McHardy wrote:
> On 04.02.2011 11:05, Pierre Chifflier wrote:
>> On 02/03/2011 03:32 PM, Pierre Chifflier wrote:
>>
>>> The current problems I'm facing are described in the previous mail,
>>> and specifically a fault in skb_free, deep inside the br_handle_frame code
>>> after a reinject.
>>> I'll try to isolate a backtrace when it happens.
>>>
>>
>> Hi,
>>
>> The backtrace is more or less the same as the one in Jan's email
>> <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
>> (Kernel crash with repeated NF invocation)
>>
>> At the moment, I'm wondering if I'm not having several cumulated
>> problems, which may be triggered more easily by my modifications ...
> 
> We can't really help debug this without seeing the code, so please
> post your current version (either privately or to the list).

Hi Patrick,

I just realized I didn't cc: you when sending the patches, but I send
them yesterday on the list (in reply to this thread)

<1296743540-8148-2-git-send-email-chifflier@edenwall.com>
[PATCH 1/3] Make the afinfo structure optional in nf_queue and nf_reinject

And the 2 following.
Sorry for the missing cc.

Pierre
