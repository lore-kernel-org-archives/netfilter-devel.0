From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 10:16:39 -0800
Message-ID: <49397007.9030809@redfish-solutions.com>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:59305 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbYLESQq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:16:46 -0500
In-Reply-To: <49396F30.3@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Philip Prindeville wrote:
>> Patrick McHardy wrote:
>>> Philip Prindeville wrote:
>>>> Patrick McHardy wrote:
>>>>> What module options are you using for the SIP helper and how is call
>>>>> setup in asterisk configured (directrtpsetup, canreinvite, ...)?
>>>>>
>>>>
>>>> For the PSTN's switch:
>>>>
>>>>  CanReinvite  : Yes
>>>
>>> I vaguely recall some problem in the implementation of this feature,
>>> something with missing bridging of the RTP streams that was still
>>> necessary under some circumstances. Might be worth to try turning
>>> it off.
>>>
>>> What about the module options?
>
>> http://www.amazon.de/Applied-Cryptography-Protocols-Algorithms-Source/dp/0471117099/ref=sr_1_4?ie=UTF8&s=books-intl-de&qid=1228500191&sr=1-4 
>>
>
>
> The SIP helper module options.

Oh, sorry....  just:

ports=5060:5063

Ummm...  what's the Amazon link about?

