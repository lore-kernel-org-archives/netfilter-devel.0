From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 10:32:30 -0800
Message-ID: <493973BE.9010001@redfish-solutions.com>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net> <49397007.9030809@redfish-solutions.com> <493970C0.2070003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:52860 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbYLESci (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:32:38 -0500
In-Reply-To: <493970C0.2070003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Philip Prindeville wrote:
>> Patrick McHardy wrote:
>>> Philip Prindeville wrote:
>>>>> What about the module options?
>>>
>>>> http://www.amazon.de/Applied-Cryptography-Protocols-Algorithms-Source/dp/0471117099/ref=sr_1_4?ie=UTF8&s=books-intl-de&qid=1228500191&sr=1-4 
>>>>
>>>
>>>
>>> The SIP helper module options.
>>
>> Oh, sorry....  just:
>>
>> ports=5060:5063
>
> Try sip_direct_media=0

That's not an option in 2.6.25.19...  when did it get introduced?  Do we 
need to run a more recent version to pick up useful fixes?

Also, does 2.6.25.19 include the port-range helpers?

Unless I'm misunderstanding something....

-Philip

>
>> Ummm...  what's the Amazon link about?
>>
>
> Hehe .. that slipped in from a chat window :)

