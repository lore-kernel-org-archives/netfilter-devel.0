From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [ANNOUNCE] libnfnetlink release 0.0.33
Date: Mon, 10 Mar 2008 14:07:42 +0100
Message-ID: <x63aqyk9r5@gzp>
References: <47D3385C.40605@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Pablo Neira Ayuso <pablo@netfilter.org>:

| The netfilter project proudly presents libnfnetlink 0.0.33. This release
| includes minor bugfixes and updates. Changelog attached.

 gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\"
 -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\"
 -DPACKAGE=\"libnfnetlink\" -DVERSION=\"0.0.33\" -DSTDC_HEADERS=1
 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1
 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1
 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1
 -DHAVE_DLFCN_H=1 -I. -I../include -fPIC -Wall -g -O2 -MT
 libnfnetlink.lo -MD -MP -MF .deps/libnfnetlink.Tpo -c libnfnetlink.c
 -o libnfnetlink.o
In file included from ../include/libnfnetlink/libnfnetlink.h:20,
                 from libnfnetlink.c:52:
../include/libnfnetlink/linux_nfnetlink.h:81: error: expected  specifier-qualifier-list before '__be16'
libnfnetlink.c: In function 'nfnl_fill_hdr': libnfnetlink.c:429: error: 'struct nfgenmsg' has no member named 'res_id'
make[1]: *** [libnfnetlink.lo] Error 1
make[1]: Leaving directory `/home/gzp/src/libnfnetlink-0.0.33/src'

[kernel]
Linux gzp1 2.4.36.1-gzp1 #1 SMP Tue Feb 19 10:23:48 CET 2008 i686
GNU/Linux

[glibc]
GNU C Library stable release version 2.3.6, by Roland McGrath et al.
Compiled by GNU CC version 4.1.2.
Compiled on a Linux 2.4.34-gzp1 system on 2007-04-04.

[gcc]
gcc (GCC) 4.2.3

[binutils]
GNU ld (Linux/GNU Binutils) 2.18.50.0.4.20080208

[autoconf]
autoconf (GNU Autoconf) 2.61

[automake]
automake (GNU automake) 1.10.1
