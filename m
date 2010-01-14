From: Patrick McHardy <kaber@trash.net>
Subject: Re: Port back 2.6 kernel patch to 2.4 which fixed bridge module panic
 	when received special fragments
Date: Thu, 14 Jan 2010 09:46:01 +0100
Message-ID: <4B4ED9C9.90309@trash.net>
References: <3104bfb61001130130s4fbf1649oa9a12e7c855cc6e@mail.gmail.com>	 <4B4D9355.5000907@trash.net> <3104bfb61001130142p5011c1cj6b01bf80ea9aee21@mail.gmail.com> <4B4D9619.1010803@trash.net> <4B4E22B1.2020207@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Dong Wei <dwei.zh@gmail.com>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60487 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab0ANIqD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:46:03 -0500
In-Reply-To: <4B4E22B1.2020207@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Patrick McHardy schreef:
>> Dong Wei wrote:
>>   
>>> Hi, Patrick
>>>
>>> Thanks for your reply.
>>>
>>> I checked the ebtables website, but the mail-list just point to the
>>> netfilter mail list.
>>>
>>> So, would you please tell me who should I send this mail to ?
>>>     
>> Try Bart De Schuymer <bdschuym@pandora.be>.
>>   
> netfilter-devel works too :)
> I didn't know the patch was still in use, nice to hear... I'll add the
> fix and put a new file on the website. I should be able to do this by
> the end of the upcoming weekend.

I guess you should include the patch to check CAP_NET_ADMIN in
ebtables sent by Florian Westphal a couple of days ago as well.
