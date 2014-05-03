From: Sharat Masetty <sharat04@gmail.com>
Subject: Re: ebtables issue in compat mode
Date: Fri, 2 May 2014 19:06:06 -0600
Message-ID: <CAJzFV35yO+N_1Hxqn742VrQEi=djutgL6Xbs9FugsLKQXzH6Ww@mail.gmail.com>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
	<20140501100229.GS31953@breakpoint.cc>
	<CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
	<20140502223139.GA3514@breakpoint.cc>
	<alpine.LSU.2.11.1405030032510.21781@nerf08.vanv.qr>
	<20140502223757.GB3514@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42946 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaECBGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 21:06:07 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so692371wgh.12
        for <netfilter-devel@vger.kernel.org>; Fri, 02 May 2014 18:06:06 -0700 (PDT)
In-Reply-To: <20140502223757.GB3514@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the suggestions, I will dig into it and see if I can
provide relevant logs here.

Do we have to enabled this define in the userspace?
KERNEL_64_USERSPACE_32, Tried enabling it and it fails at some other
location in the kernel. So its unclear whether to enable this or
not...

Thanks
Sharat

On Fri, May 2, 2014 at 4:37 PM, Florian Westphal <fw@strlen.de> wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
>> On Saturday 2014-05-03 00:31, Florian Westphal wrote:
>>
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
> I must have missed something, what are you refering to?
