From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ulogd - rpm file generation
Date: Fri, 20 Jul 2012 02:06:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207200150310.3054@frira.zrqbmnf.qr>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr>
 <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr> <50088FB0.4020403@googlemail.com> <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr>
 <50089863.7000803@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:33112 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2GTAGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:06:50 -0400
In-Reply-To: <50089863.7000803@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-07-20 01:29, Mr Dash Four wrote:

>> libnetfilter_acct.c: In function 'nfacct_nlmsg_build_payload':
>> libnetfilter_acct.c:348: warning: implicit declaration of function 'htobe64'
>>
>> and htobe64(3) says htobe64 is available starting glibc-2.9.
>> Additionally,
>>
>> ../include/linux/netfilter/nfnetlink.h:4:46: error:
>> linux/netfilter/nfnetlink_compat.h: No such file or directory
>>
>> so it also requires linux-glibc-devel >= 2.6.24, which RHEL5 also
>> does not have.
>>  
> OK, lets have it then, shall we?
>
> [mockbuild@test1 ~]$ rpm -ivh libnetfilter_acct-1.0.1-0.fc13.src.rpm
>  1:libnetfilter_acct      ########################################### [100%]
> [mockbuild@test1 ~]$ cd build/SPECS/
> [mockbuild@test1 SPECS]$
> [mockbuild@test1 SPECS]$ rpmbuild -bb libnetfilter_acct.spec
>
> [...lots of output skipped, but could be provided on Mr Engelhardt's request]
>
> Processing files: libnetfilter_acct-1.0.1-0.fc13.x86_64

No idea what you patched in the package, or otherwise did to your
system. On a pure Centos 5.8. I did *NOT* talk about fc13.

make[2]: Entering directory `/root/libnetfilter_acct-1.0.0/src'
  CC     libnetfilter_acct.lo
In file included from libnetfilter_acct.c:18:
../include/linux/netfilter/nfnetlink.h:4:46: error:
linux/netfilter/nfnetlink_compat.h: No such file or directory
libnetfilter_acct.c: In function 'nfacct_nlmsg_build_payload':
libnetfilter_acct.c:348: warning: implicit declaration of function 'htobe64'
libnetfilter_acct.c: In function 'nfacct_nlmsg_parse_payload':
libnetfilter_acct.c:408: warning: implicit declaration of function 'be64toh'
make[2]: *** [libnetfilter_acct.lo] Error 1
make[2]: Leaving directory `/root/libnetfilter_acct-1.0.0/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/root/libnetfilter_acct-1.0.0'
make: *** [all] Error 2
[root@vjng-centos5 libnetfilter_acct-1.0.0]# rpm -q glibc kernel-headers
glibc-2.5-81.el5_8.4
glibc-2.5-81.el5_8.4
kernel-headers-2.6.18-308.11.1.el5
