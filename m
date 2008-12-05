From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 19:19:44 +0100
Message-ID: <493970C0.2070003@trash.net>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net> <49397007.9030809@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYLESTs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:19:48 -0500
In-Reply-To: <49397007.9030809@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Prindeville wrote:
> Patrick McHardy wrote:
>> Philip Prindeville wrote:
>>>> What about the module options?
>>
>>> http://www.amazon.de/Applied-Cryptography-Protocols-Algorithms-Source/dp/0471117099/ref=sr_1_4?ie=UTF8&s=books-intl-de&qid=1228500191&sr=1-4 
>>>
>>
>>
>> The SIP helper module options.
> 
> Oh, sorry....  just:
> 
> ports=5060:5063

Try sip_direct_media=0

> Ummm...  what's the Amazon link about?
> 

Hehe .. that slipped in from a chat window :)
