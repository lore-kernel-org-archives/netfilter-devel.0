From: Vincent Li <vincent.mc.li@gmail.com>
Subject: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Thu, 5 Dec 2013 16:14:15 -0800
Message-ID: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37155 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3LFAOP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:14:15 -0500
Received: by mail-ob0-f170.google.com with SMTP id wp18so18832857obc.29
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 16:14:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am running mainline git kernel according to link instruction
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

I also git cloned the xtables-addons and get compiling error as below:

if [ -n "/lib/modules/3.13.0-rc2-custom/build" ]; then make -C
/lib/modules/3.13.0-rc2-custom/build
M=3D/usr/src/xtables-addons/extensions modules; fi;
make[3]: Entering directory `/usr/src/linux-headers-3.13.0-rc2-custom'
  CC [M]  /usr/src/xtables-addons/extensions/compat_xtables.o
  CC [M]  /usr/src/xtables-addons/extensions/xt_CHAOS.o
In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
/usr/src/xtables-addons/extensions/compat_xtables.h:12:3: warning:
#warning Kernels below 3.7 not supported.
In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
/usr/src/xtables-addons/extensions/compat_xtables.h:59: error:
redefinition of =91file_inode=92
include/linux/fs.h:2290: note: previous definition of =91file_inode=92 =
was here
/usr/src/xtables-addons/extensions/compat_xtables.h:67: error: static
declaration of =91proc_set_user=92 follows non-static declaration
include/linux/proc_fs.h:38: note: previous declaration of
=91proc_set_user=92 was here
/usr/src/xtables-addons/extensions/compat_xtables.h: In function
=91proc_set_user=92:
/usr/src/xtables-addons/extensions/compat_xtables.h:69: error:
dereferencing pointer to incomplete type
/usr/src/xtables-addons/extensions/compat_xtables.h:70: error:
dereferencing pointer to incomplete type
/usr/src/xtables-addons/extensions/compat_xtables.h: At top level:
/usr/src/xtables-addons/extensions/compat_xtables.h:73: error:
conflicting types for =91PDE_DATA=92
include/linux/proc_fs.h:39: note: previous declaration of =91PDE_DATA=92=
 was here
/usr/src/xtables-addons/extensions/compat_xtables.h: In function =91PDE=
_DATA=92:
/usr/src/xtables-addons/extensions/compat_xtables.h:75: error:
implicit declaration of function =91PDE=92
/usr/src/xtables-addons/extensions/compat_xtables.h:75: error: invalid
type argument of =91->=92 (have =91int=92)
/usr/src/xtables-addons/extensions/compat_xtables.h: At top level:
/usr/src/xtables-addons/extensions/compat_xtables.h:78: error: static
declaration of =91proc_remove=92 follows non-static declaration
include/linux/proc_fs.h:41: note: previous declaration of =91proc_remov=
e=92 was here
/usr/src/xtables-addons/extensions/compat_xtables.h: In function =91pro=
c_remove=92:
/usr/src/xtables-addons/extensions/compat_xtables.h:81: error:
dereferencing pointer to incomplete type
/usr/src/xtables-addons/extensions/compat_xtables.h:81: error:
dereferencing pointer to incomplete type
make[4]: *** [/usr/src/xtables-addons/extensions/xt_CHAOS.o] Error 1
make[3]: *** [_module_/usr/src/xtables-addons/extensions] Error 2
make[3]: Leaving directory `/usr/src/linux-headers-3.13.0-rc2-custom'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/usr/src/xtables-addons/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/usr/src/xtables-addons'
make: *** [all] Error 2

root@vincent-hp:/usr/src/xtables-addons# uname -a
Linux vincent-hp 3.13.0-rc2-custom #27 SMP Wed Dec 4 15:22:08 PST 2013
i686 GNU/Linux


I have no problem compiling the xtables-addons on centos6.4 running
mainline git kernel, any idea would help. thanks

Vincent
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
