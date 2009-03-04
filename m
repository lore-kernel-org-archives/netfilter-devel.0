From: Fred Moyer <fred@redhotpenguin.com>
Subject: build error when compiling nfsim against 2.6.23.17
Date: Wed, 4 Mar 2009 12:23:35 -0800
Message-ID: <ad28918e0903041223t7edb61d3hb479b3ca3c91ed26@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:60702 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZCDUXh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:23:37 -0500
Received: by rv-out-0506.google.com with SMTP id g37so3477044rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Mar 2009 12:23:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm developing a connection tracking module for the 2.6.23.17 kernel
using the nf_conntrack helper examples (actually porting a nat module
I had for 2.4.30) and am trying to use the nfsim test framework
instead of my previous crude method of sending packets through the
machine.

I checked out a copy of nfsim and nfsim-testsuite from netfilter trunk
svn, and configured nfism with the command './configure
--kerneldir=../linux-2.6.23.17'.  However I encountered an error when
running make.  Should I be looking for an older tag of nfsim?  I'm
guessing that I have a version conflict which is causing this failure.
 I've also inlined my  gcc and make version (centos 5.2 linux
environment).

[phred@aircloud nfsim]$ make
doc/gen-help tools/config.c
Faking up config-help:config
gcc -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -ggdb
-Wa,-W -I. -I/home/phred/SL-Kernel/nfsim/core
-I/home/phred/SL-Kernel/nfsim/kernelenv/include
-I/home/phred/SL-Kernel/nfsim/netfilter/include  -c -o tools/config.o
tools/config.c; ret=$?; rm -f `basename tools/config.c .c`-help*; exit
$ret
In file included from tools/config.c:26:
/home/phred/SL-Kernel/nfsim/netfilter/include/linux/netfilter_ipv4.h:78:
error: conflicting types for 'ip_route_me_harder'
/home/phred/SL-Kernel/nfsim/core/ipv4/ipv4.h:711: error: previous
declaration of 'ip_route_me_harder' was here
/home/phred/SL-Kernel/nfsim/netfilter/include/linux/netfilter_ipv4.h:80:
error: expected '=', ',', ';', 'asm' or '__attribute__' before
'nf_ip_checksum'
make: *** [tools/config.o] Error 1


[phred@aircloud nfsim]$ gcc -v
Using built-in specs.
Target: i386-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--enable-checking=release --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-libgcj-multifile
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada
--enable-java-awt=gtk --disable-dssi --enable-plugin
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
--with-cpu=generic --host=i386-redhat-linux
Thread model: posix
gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)
[phred@aircloud nfsim]$ make -v
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i686-redhat-linux-gnu
