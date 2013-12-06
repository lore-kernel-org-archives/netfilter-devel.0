From: Vincent Li <vincent.mc.li@gmail.com>
Subject: Re: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Fri, 6 Dec 2013 14:22:03 -0800
Message-ID: <CAK3+h2wOgK9OU57DraSF8TWeJub3iOH_8tJmtPcuYxLRH6U+Rg@mail.gmail.com>
References: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com>
	<alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr>
	<CAK3+h2zYCdB6yfMuZE9Zv56zFdsw6a4S3p3NvOqNfjEjF87aog@mail.gmail.com>
	<alpine.LSU.2.11.1312062131420.18525@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51490 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161723Ab3LFWWF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:22:05 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so1512998oag.30
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Dec 2013 14:22:04 -0800 (PST)
In-Reply-To: <alpine.LSU.2.11.1312062131420.18525@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

maybe LINUX_VERSION_CODE is from the original ubuntu header
/usr/include/linux/version.h ? here is the diff


root@vincent-hp:/home/vincent/xtables-addons# diff -u
/usr/include/linux/version.h
/usr/src/linux-headers-3.13.0-rc2-custom/include/linux/version.h
--- /usr/include/linux/version.h        2013-12-04 16:12:56.391368993 -0800
+++ /usr/src/linux-headers-3.13.0-rc2-custom/include/linux/version.h
 2013-10-11 12:58:33.000000000 -0700
@@ -1,2 +1,2 @@
-#define LINUX_VERSION_CODE 132640
+#define LINUX_VERSION_CODE 132645
 #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))

I tried to symbolic link  the /usr/include/linux/version.h to
/usr/src/linux-headers-3.13.0-rc2-custom/include/linux/version.h.
didn't help.



On Fri, Dec 6, 2013 at 12:34 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Friday 2013-12-06 19:37, Vincent Li wrote:
>>checking kernel version that we will build against... 3.13.0.0 in
>>/lib/modules/3.13.0-rc2-custom/build
>>>>
>>>>if [ -n "/lib/modules/3.13.0-rc2-custom/build" ]; then make -C
>>>>/lib/modules/3.13.0-rc2-custom/build
>>>>M=/usr/src/xtables-addons/extensions modules; fi;
>>>>make[3]: Entering directory `/usr/src/linux-headers-3.13.0-rc2-custom'
>>>>  CC [M]  /usr/src/xtables-addons/extensions/compat_xtables.o
>>>>  CC [M]  /usr/src/xtables-addons/extensions/xt_CHAOS.o
>>>>In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
>>>>/usr/src/xtables-addons/extensions/compat_xtables.h:12:3: warning:
>>>>#warning Kernels below 3.7 not supported.
>
> I have no explanation for why your LINUX_VERSION_CODE evaluates
> to something < 3.7 despite /build having 3.13 in its Makefiles.
