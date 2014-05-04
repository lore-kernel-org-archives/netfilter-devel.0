From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables issue in compat mode
Date: Sun, 04 May 2014 23:05:44 +0200
Message-ID: <5366ABA8.1050906@pandora.be>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>	<20140501100229.GS31953@breakpoint.cc>	<CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>	<20140502223139.GA3514@breakpoint.cc>	<alpine.LSU.2.11.1405030032510.21781@nerf08.vanv.qr>	<20140502223757.GB3514@breakpoint.cc> <CAJzFV35yO+N_1Hxqn742VrQEi=djutgL6Xbs9FugsLKQXzH6Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Sharat Masetty <sharat04@gmail.com>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:33769 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaEDVFt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 17:05:49 -0400
In-Reply-To: <CAJzFV35yO+N_1Hxqn742VrQEi=djutgL6Xbs9FugsLKQXzH6Ww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sharat Masetty schreef op 3/05/2014 3:06:
> Thanks for the suggestions, I will dig into it and see if I can
> provide relevant logs here.
>
> Do we have to enabled this define in the userspace?
> KERNEL_64_USERSPACE_32, Tried enabling it and it fails at some other
> location in the kernel. So its unclear whether to enable this or
> not...

That option was introduced and has only been tested for Sparc32/64, so 
odds are it doesn't work for your setup (note that you need the 
ebtables.h version that comes with the ebtables userspace package). But 
a hack similar to that will probably make it work for you (it's a matter 
of getting the offsets of the struct members right and translating 
32-bit pointers into 64-bit pointers). I thought the whole compat layer 
would make this stuff irrelevant. Guess not.

cheers,
Bart

