From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] New netfilter target to trigger LED devices
Date: Mon, 10 Nov 2008 13:45:17 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811101343230.9822@fbirervta.pbzchgretzou.qr>
References: <4916E36F.6000502@shikadi.net> <alpine.LNX.1.10.0811091439281.12658@fbirervta.pbzchgretzou.qr> <49180E44.3090808@shikadi.net> <alpine.LNX.1.10.0811101156060.32764@fbirervta.pbzchgretzou.qr> <4918214D.9070504@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44686 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbYKJMpU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:45:20 -0500
In-Reply-To: <4918214D.9070504@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-10 12:55, Adam Nielsen wrote:

>> > Does this mean I can remove those whole three lines?  Or do I still need to
>> > check the value of "invert" and complain if it's specified?
>> 
>> You still need to check for it. If you grep for P_NO_INVERT in all .c
>> files you will find the shortest possible line to do so.
>
> Ah ok, that makes sense.  On a related note, am I doing something wrong
> here?  Even when I'm not listing my target explicitly, I can get an odd
> error:
>
> $ iptables -A INPUT -j ACCEPT --test
> iptables v1.4.2: Unknown arg `(null)'

This is a known one. IIRC Pablo addressed this with a patch (but I don't 
see it in the git repo!?)


>> > Maybe I should only allow alphanumerics and basic punctuation?
>> 
>> I thought about that - but I have come to the conclusion that most
>> character should be allowed so that people can use all the
>> extended characters like CJK.
>
> So if I switch to using double-quotes then, is there anything else I'll
> need to escape? (such as '$')

Nope. Just '"', and obviously '\'.
