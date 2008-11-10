From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 1/2] New netfilter target to trigger LED devices
Date: Mon, 10 Nov 2008 21:55:57 +1000
Message-ID: <4918214D.9070504@shikadi.net>
References: <4916E36F.6000502@shikadi.net> <alpine.LNX.1.10.0811091439281.12658@fbirervta.pbzchgretzou.qr> <49180E44.3090808@shikadi.net> <alpine.LNX.1.10.0811101156060.32764@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2089 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYKJL4A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:56:00 -0500
In-Reply-To: <alpine.LNX.1.10.0811101156060.32764@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Does this mean I can remove those whole three lines?  Or do I still need to
>> check the value of "invert" and complain if it's specified?
> 
> You still need to check for it. If you grep for P_NO_INVERT in all .c
> files you will find the shortest possible line to do so.

Ah ok, that makes sense.  On a related note, am I doing something wrong
here?  Even when I'm not listing my target explicitly, I can get an odd
error:

$ iptables -A INPUT -j ACCEPT --test
iptables v1.4.2: Unknown arg `(null)'

> Even if the compiler could not, you could use sizeof("foo")-1 to get "3".
> That is a property of the C language.

Ha, been programming in it for years and never thought of doing that :-)

>> Maybe I should only allow alphanumerics and basic punctuation?
> 
> I thought about that - but I have come to the conclusion that most
> character should be allowed so that people can use all the
> extended characters like CJK.

So if I switch to using double-quotes then, is there anything else I'll
need to escape? (such as '$')

>> That's fine, I've never used whatever that markup is before
>> (I don't even know what it's called...!)
> 
> Read the PDF to the end and you will find out ;-)

Ah, I see now :-)  That's a very useful and well written PDF too, btw.

Cheers,
Adam.
