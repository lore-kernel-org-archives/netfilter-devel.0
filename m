From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Fri, 6 Dec 2013 18:37:12 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr>
References: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vincent Li <vincent.mc.li@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:35703 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab3LFRhO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:37:14 -0500
In-Reply-To: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-12-06 01:14, Vincent Li wrote:
>
>I am running mainline git kernel according to link instruction
>https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>
>I also git cloned the xtables-addons and get compiling error as below:
>
>if [ -n "/lib/modules/3.13.0-rc2-custom/build" ]; then make -C
>/lib/modules/3.13.0-rc2-custom/build
>M=/usr/src/xtables-addons/extensions modules; fi;
>make[3]: Entering directory `/usr/src/linux-headers-3.13.0-rc2-custom'
>  CC [M]  /usr/src/xtables-addons/extensions/compat_xtables.o
>  CC [M]  /usr/src/xtables-addons/extensions/xt_CHAOS.o
>In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
>/usr/src/xtables-addons/extensions/compat_xtables.h:12:3: warning:
>#warning Kernels below 3.7 not supported.

What was your configure output?
