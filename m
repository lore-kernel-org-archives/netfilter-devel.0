From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: Re: NF_IP_PRE_ROUTING,... not defined
Date: Tue, 11 Nov 2008 10:00:10 +0100
Message-ID: <417f50830811110100y2aae8e3ej99426153c6412fb0@mail.gmail.com>
References: <417f50830811100953i6edaa921x53de3710e956c97f@mail.gmail.com>
	 <4918792A.2070309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:42611 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYKKJAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:00:11 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2953140rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Nov 2008 01:00:10 -0800 (PST)
In-Reply-To: <4918792A.2070309@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ok, thanks, added by hand.

In my aim to port my netfilt-routing soft from 2.6.22 to 2.6.25 i have
too a problem, my *skb pointers are null (skb seems ok) and i don't
know if there is more related to thoses changes to 2.6.25 as define
__KERNEL__ thing in netfilter_ipv4.h any clue,idea, doc about those
complete changes.

2008/11/10 Patrick McHardy <kaber@trash.net>:
> Giant Sand Fan's wrote:
>>
>> because the #ifndef __KERNEL__ tags goes beyond NT_IP_PRE_ROUTING,..
>> defines , this change appears in 2.6.25 (because I works in 2.6.22)
>> and I cannot compile my kernel module hook with that version.
>>
>> There is a way to do a correct development-compilation with this headers?
>>
>> I cannot find anything about this issue.Yes I can move the "#endif"
>> but i think that must not be right thing.
>>
>> So sorry if I'm out of scope.
>
> The kernel doesn't need these definitions anymore, so they're not
> available to avoid people using them.
>
> For external modules that need to compile with multiple version,
> you can either add the necessary definitions yourself (the values
> are part of the ABI and unchangable) or possibly use the compat
> headers from xtables-addons.
>



-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
