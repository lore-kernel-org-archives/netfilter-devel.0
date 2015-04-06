From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Mon, 06 Apr 2015 11:01:36 +0200
Message-ID: <55224B70.1070309@ahsoftware.de>
References: <551FC211.6000907@ahsoftware.de> <1428145986-15421-1-git-send-email-holler@ahsoftware.de> <20150404115550.GA5832@salvia> <20150405113214.GA23433@acer.localdomain> <20150405121104.GD23433@acer.localdomain> <552187FB.60904@ahsoftware.de> <20150406015128.GA20515@acer.localdomain> <55224776.4040108@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:45419 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbDFJBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 05:01:43 -0400
Received: from wandq.ahsoftware (p4FC37568.dip0.t-ipconnect.de [79.195.117.104])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 9E76D2C9C1BF
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2015 11:01:41 +0200 (CEST)
In-Reply-To: <55224776.4040108@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 06.04.2015 um 10:44 schrieb Alexander Holler:
> Am 06.04.2015 um 03:51 schrieb Patrick McHardy:
>> On 05.04, Alexander Holler wrote:
>>> Am 05.04.2015 um 14:11 schrieb Patrick McHardy:
>>>> On 05.04, Patrick McHardy wrote:
>>>
>>>>> Basically this involves splitting the expression types into lhs
>>>>> (non-const)
>>>>> and rhs (const) parts. Keywords on the RHS side can be caught using an
>>>>> error statement and deferred to resolution during runtime.
>>>
>>> Sounds like trial and error. ;)
>>
>> The approach is, the patch isn't, it changes the grammar to have
>> these kinds of errors in a defined state. The patch I sent
>> however is, but I'm quite sure i understand the implications.
>
> Just to mention it, there is still the possibility to define and use
> keywords for all the icmp type names.

Preferable with names as used in icmp.h and icmpv6.h. As these are 
defines in C-headers, there is very high probability that these names 
are unique, even across a large number of different sets of type or 
other names.

