From: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.2-rc1
Date: Thu, 24 Jul 2008 12:40:32 +0100 (BST)
Message-ID: <Pine.LNX.4.58.0807241231520.30125@mail3.jubileegroup.co.uk>
References: <488734A3.3090401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter <netfilter@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:56631 "EHLO
	mail3.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYGXLkf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:40:35 -0400
In-Reply-To: <488734A3.3090401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

On Wed, 23 Jul 2008, Patrick McHardy wrote:

> The netfilter coreteam presents:
>
>      iptables version 1.4.2-rc1

No problems here, built and installed fine right out of the box with
./configure
make
make install

I'm curious about the ipset userspace tool - will it eventually find
its way to the iptables tarball?  Right now it seems that you get it
kind of incidentally when you apply the kernel patch, which seems to
me a little odd.

8<----------------------------------------------------------------------

[ged]$ gcc -v
Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2.2/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
  --infodir=/usr/share/info --enable-shared --enable-threads=posix
  --disable-checking --with-system-zlib --enable-__cxa_atexit
  --host=i386-redhat-linux
Thread model: posix
gcc version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)

8<----------------------------------------------------------------------

[ged]$ /lib/libc.so.6
GNU C Library stable release version 2.3.2, by Roland McGrath et al.
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
Compiled by GNU CC version 3.2.2 20030222 (Red Hat Linux 3.2.2-5).
Compiled on a Linux 2.4.20 system on 2003-03-13.
Available extensions:
        GNU libio by Per Bothner
        crypt add-on version 2.1 by Michael Glad and others
        linuxthreads-0.10 by Xavier Leroy
        BIND-8.2.3-T5B
        libthread_db work sponsored by Alpha Processor Inc
        NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
Thread-local storage support included.
Report bugs using the `glibcbug' script to <bugs@gnu.org>.

8<----------------------------------------------------------------------

--

73,
Ged.
