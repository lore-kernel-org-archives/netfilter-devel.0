From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ebtables issue in compat mode
Date: Sat, 3 May 2014 03:23:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1405030229270.24006@nerf08.vanv.qr>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com> <20140501100229.GS31953@breakpoint.cc> <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com> <20140502223139.GA3514@breakpoint.cc> <alpine.LSU.2.11.1405030032510.21781@nerf08.vanv.qr>
 <20140502223757.GB3514@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sharat Masetty <sharat04@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:44373 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaECBXU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 21:23:20 -0400
In-Reply-To: <20140502223757.GB3514@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2014-05-03 00:37, Florian Westphal wrote:
>> >Sharat Masetty <sharat04@gmail.com> wrote:
>> >> We are using a 3.10.0 kernel version which has CONFIG_COMPAT enabled.
>> >> The ebtables version is 2.0.10-4.  This is arm 63/32 not x86.
>> >
>> >FWIW i have no issues with 2.0.10-4 either (on x86), so its hard
>> >for me to debug this since I don't have access to a aarch64/arm64
>> >machine.
>> 
>> This has occurred so regularly now that it's likely to be one and the 
>> same ABI issue all again where some user has more than 2 ABIs in the 
>> system.
>
>I must have missed something, what are you refering to?

Oh, my post from April 18.
http://www.spinics.net/lists/netfilter-devel/msg31526.html

I also found http://bugs.debian.org/690548 in my archives, as an example 
where the same occurred with a MIPS box.


As for x86, if i386 and x32 did not have the same alignment, it would 
probably also show on x86.
