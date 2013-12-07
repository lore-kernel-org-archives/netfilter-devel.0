From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Sat, 7 Dec 2013 01:27:58 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312070126450.22122@nerf07.vanv.qr>
References: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com> <alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr> <CAK3+h2zYCdB6yfMuZE9Zv56zFdsw6a4S3p3NvOqNfjEjF87aog@mail.gmail.com> <alpine.LSU.2.11.1312062131420.18525@nerf07.vanv.qr>
 <CAK3+h2wOgK9OU57DraSF8TWeJub3iOH_8tJmtPcuYxLRH6U+Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vincent Li <vincent.mc.li@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:36768 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab3LGA2B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:28:01 -0500
In-Reply-To: <CAK3+h2wOgK9OU57DraSF8TWeJub3iOH_8tJmtPcuYxLRH6U+Rg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-12-06 23:22, Vincent Li wrote:

>maybe LINUX_VERSION_CODE is from the original ubuntu header
>/usr/include/linux/version.h ? here is the diff
>
>root@vincent-hp:/home/vincent/xtables-addons# diff -u
>/usr/include/linux/version.h
>/usr/src/linux-headers-3.13.0-rc2-custom/include/linux/version.h
>--- /usr/include/linux/version.h        2013-12-04 16:12:56.391368993 -0800
>+++ /usr/src/linux-headers-3.13.0-rc2-custom/include/linux/version.h
> 2013-10-11 12:58:33.000000000 -0700
>@@ -1,2 +1,2 @@
>-#define LINUX_VERSION_CODE 132640
>+#define LINUX_VERSION_CODE 132645
> #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))

You see your problem: 132645 is 0x20625,
so your /usr/src/linux-headers-3.13.0-rc2-custom
is some 2.6.25, not 3.13.
