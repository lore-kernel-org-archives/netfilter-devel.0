From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ulogd - rpm file generation
Date: Fri, 20 Jul 2012 00:29:39 +0100
Message-ID: <50089863.7000803@googlemail.com>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr> <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr> <50088FB0.4020403@googlemail.com> <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57814 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2GSX3r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:29:47 -0400
Received: by wgbdr13 with SMTP id dr13so2973371wgb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jul 2012 16:29:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> libnetfilter_acct.c: In function 'nfacct_nlmsg_build_payload':
> libnetfilter_acct.c:348: warning: implicit declaration of function 'htobe64'
>
> and htobe64(3) says htobe64 is available starting glibc-2.9.
> Additionally,
>
> ../include/linux/netfilter/nfnetlink.h:4:46: error:
> linux/netfilter/nfnetlink_compat.h: No such file or directory
>
> so it also requires linux-glibc-devel >= 2.6.24, which RHEL5 also
> does not have.
>   
OK, lets have it then, shall we?

[mockbuild@test1 ~]$ rpm -ivh libnetfilter_acct-1.0.1-0.fc13.src.rpm
   1:libnetfilter_acct      ########################################### 
[100%]
[mockbuild@test1 ~]$ cd build/SPECS/
[mockbuild@test1 SPECS]$
[mockbuild@test1 SPECS]$ rpmbuild -bb libnetfilter_acct.spec

[...lots of output skipped, but could be provided on Mr Engelhardt's 
request]

Processing files: libnetfilter_acct-1.0.1-0.fc13.x86_64
Provides: libnetfilter_acct.so.1()(64bit) 
libnetfilter_acct.so.1(LIBNETFILTER_ACCT_1.0)(64bit) 
libnetfilter_acct.so.1(LIBNETFILTER_ACCT_1.1)(64bit)
Requires(interp): /sbin/ldconfig /sbin/ldconfig
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 
rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Requires(post): /sbin/ldconfig
Requires(postun): /sbin/ldconfig
Requires: libc.so.6()(64bit) libc.so.6(GLIBC_2.2.5)(64bit) 
libc.so.6(GLIBC_2.3.4)(64bit) libmnl.so.0()(64bit) 
libmnl.so.0(LIBMNL_1.0)(64bit) libnetfilter_acct.so.1()(64bit) 
rtld(GNU_HASH)
Processing files: libnetfilter_acct-devel-1.0.1-0.fc13.x86_64
Provides: pkgconfig(libnetfilter_acct) = 1.0.1
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 
rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1 
rpmlib(VersionedDependencies) <= 3.0.3-1
Requires: /usr/bin/pkg-config libnetfilter_acct.so.1()(64bit)
Processing files: libnetfilter_acct-debuginfo-1.0.1-0.fc13.x86_64
Checking for unpackaged file(s): /usr/lib/rpm/check-files 
/builddir/build/BUILDROOT/libnetfilter_acct-1.0.1-0.fc13.x86_64
Wrote: /builddir/build/RPMS/libnetfilter_acct-1.0.1-0.fc13.x86_64.rpm
Wrote: /builddir/build/RPMS/libnetfilter_acct-devel-1.0.1-0.fc13.x86_64.rpm
Wrote: 
/builddir/build/RPMS/libnetfilter_acct-debuginfo-1.0.1-0.fc13.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.OOQQCq
+ umask 022
+ cd /builddir/build/BUILD
+ cd libnetfilter_acct-1.0.1
+ /bin/rm -rf 
/builddir/build/BUILDROOT/libnetfilter_acct-1.0.1-0.fc13.x86_64
+ exit 0

[mockbuild@test1 SPECS]$ uname -a
Linux test1.my.net 3.3.4-6.fc13.x86_64 #1 SMP Fri Jul 6 00:28:31 BST 
2012 x86_64 x86_64 x86_64 GNU/Linux

[mockbuild@test1 SPECS]$ rpm -qa | grep glibc
glibc-headers-2.12.2-1.x86_64
glibc-2.12.2-1.x86_64
glibc-common-2.12.2-1.x86_64
glibc-devel-2.12.2-1.x86_64
glibc-static-2.12.2-1.x86_64


