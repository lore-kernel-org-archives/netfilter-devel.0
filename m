From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
Date: Sun, 02 Nov 2008 12:44:12 -0800
Message-ID: <490E111C.9060006@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:48468 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbYKBVCY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:02:24 -0500
Received: from [192.168.10.6] (tosh.redfish-solutions.com [63.224.43.239])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.2/8.14.2) with ESMTP id mA2KiCbn019603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sun, 2 Nov 2008 13:44:13 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm trying to build iptables 1.3.8 in a cross-compile environment for 
linux 2.6.25.19 on an x86, but I'm seeing:

/home/philipp/kernel/build_i586/staging_dir/bin/i586-linux-uclibc-gcc -Os -pipe -fomit-frame-pointer  -Wall -Wunused -I/home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include -Iinclude/ -DIPTABLES_VERSION=\"1.3.8\"  -DNO_SHARED_LIBS=1 -DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32 -D_INIT=ipt_ah_init -c -o extensions/libipt_ah.o extensions/libipt_ah.c
In file included from /home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter_ipv4.h:9,
                 from /home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter_ipv4/ip_tables.h:27,
                 from include/libiptc/libiptc.h:7,
                 from include/iptables.h:6,
                 from iptables.c:40:
/home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter.h:54: error: expected specifier-qualifier-list before '__u32'
make[1]: *** [iptables.o] Error 1
make[1]: *** Waiting for unfinished jobs....
In file included from /home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter_ipv4.h:9,
                 from /home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter_ipv4/ip_tables.h:27,
                 from include/libiptc/libiptc.h:7,
                 from include/iptables.h:6,
                 from extensions/libipt_ah.c:9:
/home/philipp/kernel/build_i586/linux-2.6.25.19-astlinux/include/linux/netfilter.h:54: error: expected specifier-qualifier-list before '__u32'
make[1]: *** [extensions/libipt_ah.o] Error 1
make[1]: Leaving directory `/home/philipp/kernel/build_i586/iptables-1.3.8'
make: *** [/home/philipp/kernel/build_i586/iptables-1.3.8/iptables] Error 2


Is this a known issue?  Is there a patch for this?

I tried bumping to 1.4.2, but that dies with a different issue:

  CC       libxt_TCPOPTSTRIP.oo
  CC       libxt_time.oo
  CC       libxt_tos.oo
libxt_time.c: In function 'time_save':
libxt_time.c:400: warning: inlining failed in call to 'divide_time': --param max-inline-insns-single limit reached
libxt_time.c:449: warning: called from here
libxt_time.c:400: warning: inlining failed in call to 'divide_time': --param max-inline-insns-single limit reached
libxt_time.c:451: warning: called from here
libxt_time.c: In function 'time_print':
libxt_time.c:400: warning: inlining failed in call to 'divide_time': --param max-inline-insns-single limit reached
libxt_time.c:417: warning: called from here
libxt_time.c:400: warning: inlining failed in call to 'divide_time': --param max-inline-insns-single limit reached
libxt_time.c:419: warning: called from here
  CC       libxt_TOS.oo
  CC       libxt_TRACE.oo
  CC       libxt_u32.oo
  CC       libxt_udp.oo
  CC       libipt_addrtype.oo
  CC       libipt_ah.oo
  CC       libipt_CLUSTERIP.oo
  CC       libipt_DNAT.oo
  CC       libipt_ecn.oo
  CC       libipt_ECN.oo
  CC       libipt_icmp.oo
  CC       libipt_IMQ.oo
  CC       libipt_LOG.oo
  CC       libipt_MASQUERADE.oo
libipt_IMQ.c: In function 'help':
libipt_IMQ.c:18: error: 'IPTABLES_VERSION' undeclared (first use in this function)
libipt_IMQ.c:18: error: (Each undeclared identifier is reported only once
libipt_IMQ.c:18: error: for each function it appears in.)
libipt_IMQ.c: At top level:
libipt_IMQ.c:83: error: variable 'imq' has initializer but incomplete type
libipt_IMQ.c:84: error: unknown field 'next' specified in initializer
libipt_IMQ.c:84: warning: excess elements in struct initializer
libipt_IMQ.c:84: warning: (near initialization for 'imq')
libipt_IMQ.c:85: error: unknown field 'name' specified in initializer
libipt_IMQ.c:85: warning: excess elements in struct initializer
libipt_IMQ.c:85: warning: (near initialization for 'imq')
libipt_IMQ.c:86: error: unknown field 'version' specified in initializer
libipt_IMQ.c:86: error: 'IPTABLES_VERSION' undeclared here (not in a function)
libipt_IMQ.c:86: warning: excess elements in struct initializer
libipt_IMQ.c:86: warning: (near initialization for 'imq')
libipt_IMQ.c:87: error: unknown field 'size' specified in initializer
libipt_IMQ.c:87: warning: excess elements in struct initializer
libipt_IMQ.c:87: warning: (near initialization for 'imq')
libipt_IMQ.c:88: error: unknown field 'userspacesize' specified in initializer
libipt_IMQ.c:88: warning: excess elements in struct initializer
libipt_IMQ.c:88: warning: (near initialization for 'imq')
libipt_IMQ.c:89: error: unknown field 'help' specified in initializer
libipt_IMQ.c:89: warning: excess elements in struct initializer
libipt_IMQ.c:89: warning: (near initialization for 'imq')
libipt_IMQ.c:90: error: unknown field 'init' specified in initializer
libipt_IMQ.c:90: warning: excess elements in struct initializer
libipt_IMQ.c:90: warning: (near initialization for 'imq')
libipt_IMQ.c:91: error: unknown field 'parse' specified in initializer
libipt_IMQ.c:91: warning: excess elements in struct initializer
libipt_IMQ.c:91: warning: (near initialization for 'imq')
libipt_IMQ.c:92: error: unknown field 'final_check' specified in initializer
libipt_IMQ.c:92: warning: excess elements in struct initializer
libipt_IMQ.c:92: warning: (near initialization for 'imq')
libipt_IMQ.c:93: error: unknown field 'print' specified in initializer
libipt_IMQ.c:93: warning: excess elements in struct initializer
libipt_IMQ.c:93: warning: (near initialization for 'imq')
libipt_IMQ.c:94: error: unknown field 'save' specified in initializer
libipt_IMQ.c:94: warning: excess elements in struct initializer
libipt_IMQ.c:94: warning: (near initialization for 'imq')
libipt_IMQ.c:95: error: unknown field 'extra_opts' specified in initializer
libipt_IMQ.c:96: warning: excess elements in struct initializer
libipt_IMQ.c:96: warning: (near initialization for 'imq')
libipt_IMQ.c:99: error: static declaration of 'libipt_IMQ_init' follows non-static declaration
../include/xtables/internal.h:64: error: previous declaration of 'libipt_IMQ_init' was here
libipt_IMQ.c: In function 'libipt_IMQ_init':
libipt_IMQ.c:100: warning: implicit declaration of function 'register_target'
make[3]: *** [libipt_IMQ.oo] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: Leaving directory `/home/philipp/kernel/build_i586/iptables-1.4.2/extensions'
make[2]: *** [all-recursive] Error 1
make[2]: Leaving directory `/home/philipp/kernel/build_i586/iptables-1.4.2'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/home/philipp/kernel/build_i586/iptables-1.4.2'
make: *** [/home/philipp/kernel/build_i586/iptables-1.4.2/iptables] Error 2


This is with the 2.6.25.7 IMQ patches.

Building 1.4.1 also craps out similarly.

Anyone have a suggestion? I'm trying to update the distro to go from 
Linux 2.6.20 to 2.6.25 and don't have a lot of time to dig deeper.

Thanks,

-Philip

