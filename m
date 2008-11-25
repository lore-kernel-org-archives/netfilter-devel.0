From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: Re: NF_IP_PRE_ROUTING,... not defined
Date: Tue, 25 Nov 2008 19:11:15 +0100
Message-ID: <417f50830811251011s4c5582e3j99f99ae9d699a053@mail.gmail.com>
References: <417f50830811100953i6edaa921x53de3710e956c97f@mail.gmail.com>
	 <4918792A.2070309@trash.net>
	 <417f50830811110100y2aae8e3ej99426153c6412fb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:46393 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYKYSLR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:11:17 -0500
Received: by rn-out-0910.google.com with SMTP id k40so94386rnd.17
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2008 10:11:16 -0800 (PST)
In-Reply-To: <417f50830811110100y2aae8e3ej99426153c6412fb0@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm answering to myself . The problem is that from , i think, 2.6.24
the interface of the hook function has a *skb_buff and not a
**skb_buff.


Thanks.

2008/11/11 Giant Sand Fan's <rampxxxx@gmail.com>:
> ok, thanks, added by hand.
>
> In my aim to port my netfilt-routing soft from 2.6.22 to 2.6.25 i have
> too a problem, my *skb pointers are null (skb seems ok) and i don't
> know if there is more related to thoses changes to 2.6.25 as define
> __KERNEL__ thing in netfilter_ipv4.h any clue,idea, doc about those
> complete changes.
>
> 2008/11/10 Patrick McHardy <kaber@trash.net>:
>> Giant Sand Fan's wrote:
>>>
>>> because the #ifndef __KERNEL__ tags goes beyond NT_IP_PRE_ROUTING,..
>>> defines , this change appears in 2.6.25 (because I works in 2.6.22)
>>> and I cannot compile my kernel module hook with that version.
>>>
>>> There is a way to do a correct development-compilation with this headers?
>>>
>>> I cannot find anything about this issue.Yes I can move the "#endif"
>>> but i think that must not be right thing.
>>>
>>> So sorry if I'm out of scope.
>>
>> The kernel doesn't need these definitions anymore, so they're not
>> available to avoid people using them.
>>
>> For external modules that need to compile with multiple version,
>> you can either add the necessary definitions yourself (the values
>> are part of the ABI and unchangable) or possibly use the compat
>> headers from xtables-addons.
>>
>
>
>
> --
> Please avoid sending me Word or PowerPoint attachments.
> See http://www.gnu.org/philosophy/no-word-attachments.html
>



-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
