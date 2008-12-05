From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 19:13:04 +0100
Message-ID: <49396F30.3@trash.net>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61532 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYLESNG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:13:06 -0500
In-Reply-To: <49396E91.1060403@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Prindeville wrote:
> Patrick McHardy wrote:
>> Philip Prindeville wrote:
>>> Patrick McHardy wrote:
>>>> What module options are you using for the SIP helper and how is call
>>>> setup in asterisk configured (directrtpsetup, canreinvite, ...)?
>>>>
>>>
>>> For the PSTN's switch:
>>>
>>>  CanReinvite  : Yes
>>
>> I vaguely recall some problem in the implementation of this feature,
>> something with missing bridging of the RTP streams that was still
>> necessary under some circumstances. Might be worth to try turning
>> it off.
>>
>> What about the module options?

> http://www.amazon.de/Applied-Cryptography-Protocols-Algorithms-Source/dp/0471117099/ref=sr_1_4?ie=UTF8&s=books-intl-de&qid=1228500191&sr=1-4


The SIP helper module options.
