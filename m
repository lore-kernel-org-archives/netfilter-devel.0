From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Fri, 6 Dec 2013 21:34:27 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312062131420.18525@nerf07.vanv.qr>
References: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com> <alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr> <CAK3+h2zYCdB6yfMuZE9Zv56zFdsw6a4S3p3NvOqNfjEjF87aog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vincent Li <vincent.mc.li@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:36198 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab3LFUe2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:34:28 -0500
In-Reply-To: <CAK3+h2zYCdB6yfMuZE9Zv56zFdsw6a4S3p3NvOqNfjEjF87aog@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-12-06 19:37, Vincent Li wrote:
>checking kernel version that we will build against... 3.13.0.0 in
>/lib/modules/3.13.0-rc2-custom/build
>>>
>>>if [ -n "/lib/modules/3.13.0-rc2-custom/build" ]; then make -C
>>>/lib/modules/3.13.0-rc2-custom/build
>>>M=/usr/src/xtables-addons/extensions modules; fi;
>>>make[3]: Entering directory `/usr/src/linux-headers-3.13.0-rc2-custom'
>>>  CC [M]  /usr/src/xtables-addons/extensions/compat_xtables.o
>>>  CC [M]  /usr/src/xtables-addons/extensions/xt_CHAOS.o
>>>In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
>>>/usr/src/xtables-addons/extensions/compat_xtables.h:12:3: warning:
>>>#warning Kernels below 3.7 not supported.

I have no explanation for why your LINUX_VERSION_CODE evaluates
to something < 3.7 despite /build having 3.13 in its Makefiles.
