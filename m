From: John Haxby <john.haxby@oracle.com>
Subject: Re: libxt_string: fix undefined behavior/incorrect patlen calculation
Date: Mon, 02 Mar 2009 09:16:00 +0000
Message-ID: <49ABA3D0.1060906@oracle.com>
References: <20090301223735.GA25389@safeTpin.homeunix.org> <alpine.LSU.2.00.0903020324590.10419@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pud <pud@subnet666.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:36483 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZCBJQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:16:17 -0500
In-Reply-To: <alpine.LSU.2.00.0903020324590.10419@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2009-03-01 23:37, pud wrote:
>   
>> (sorry, msg-id lost)
>>
>>     
>>> commit 19b0cd770d1e042c85bf0b278261a61d4cea8193
>>> Author: Jan Engelhardt <jeng...@medozas.de>
>>> Date: Thu Feb 12 01:18:35 2009 +0100
>>>       
>> ...
>>     
>>> - stringinfo->patlen=strlen((char *)&stringinfo->pattern);
>>> + stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
>>> +                           sizeof(stringinfo->patlen));
>>>       
>> sorry, this doesn't work here, did you mean
>> sizeof(stringinfo->pattern)?
>>     
>
> What do you mean "doesnot work"?
>   

It looks very weird to me as well.   I may well be confused, but

    stringinfo->patlen = strnlen((char *)&stringinfo->pattern, 
sizeof(stringinfo->patlen))

looks like something roughly equivalent to this:

    char pattern[256];
    int patlen;
    patlen = strlen(pattern, 4);

The "4" is sizeof(int) rather than the size of "pattern"

jch
   
