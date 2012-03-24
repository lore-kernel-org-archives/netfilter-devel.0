From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec) [part 2]
Date: Sat, 24 Mar 2012 02:11:44 -0700
Message-ID: <CAHo-OowdgzY5CSvJki7kvV_Gin8w4+TZ6=SDS-VgYaz5qguKSg@mail.gmail.com>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
	<1332361663.9433.8.camel@edumazet-glaptop>
	<CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
	<1332362670.9433.9.camel@edumazet-glaptop>
	<CAHo-OozsBkyQ-hq0Hkuef3uohemnHCh1qBo02By-kE5Rpt92Lg@mail.gmail.com>
	<20120322112120.GA16645@1984>
	<20120323102623.GA22440@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33805 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2CXJLo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:11:44 -0400
Received: by obbeh20 with SMTP id eh20so3149791obb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Mar 2012 02:11:44 -0700 (PDT)
In-Reply-To: <20120323102623.GA22440@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oh, sorry, I did actually send a patch with nice comments, but
apparently I ended up missing the mailing list in the cc list.

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

This is iptables-1.4.11-cloexec.patch from Fedora 18 iptables source
rpm, in particular:
 http://kojipkgs.fedoraproject.org/packages/iptables/1.4.12.2/4.fc18/sr=
c/iptables-1.4.12.2-4.fc18.src.rpm

Reasoning:

On an example Fedora 15 system:
 $ ls -alZ /sbin/ip{,6}tables* /sbin/modprobe
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/ip6tables -> ip6tables-multi
 -rwxr-xr-x. root root system_u:object_r:iptables_exec_t:s0
/sbin/ip6tables-multi
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/ip6tables-restore -> ip6tables-multi
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/ip6tables-save -> ip6tables-multi
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/iptables -> iptables-multi
 -rwxr-xr-x. root root system_u:object_r:iptables_exec_t:s0 /sbin/iptab=
les-multi
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/iptables-restore -> iptables-multi
 lrwxrwxrwx. root root system_u:object_r:bin_t:s0
/sbin/iptables-save -> iptables-multi
 -rwxr-xr-x. root root system_u:object_r:insmod_exec_t:s0   /sbin/modpr=
obe

You will note that the iptables binaries and the modprobe binaries
differ in the SELinux security context 'type'.

Since ip{,6}tables may manually fork/exec modprobe to load modules
(not everything relies on kernel module autoloading), it may trigger
a SELinux security context transition.

It is desirable to not have any unexpectedly open file descriptors
leak across this security boundary - this may just generate needless
monitoring/auditing noise (especially in extremely hardened environs).

It's also arguably just generally good programming practice to mark
all file descripters as close on exec if you are ever going to exec
(on an API level this really should have been the default state of
any new file descriptor).

In order to prevent races between file descriptor creation and exec
in multi-threaded programs, newer linux kernels now support creating
sockets as close on exec right from the initial syscall.

=46ortunately we are not multi-threaded, and thus this race condition
does not matter, and hence we do not need to implement the complex
logic of "try socket(domain, type | SOCK_CLOEXEC, protocol), if that
failed use normal socket() system call and set FD_CLOEXEC flag manually
via fcntl" which is necessary to maintain desired backwards compatibili=
ty
with older pre-2.6.27 kernels.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
