From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4.7 released
Date: Fri, 30 Jan 2009 23:32:10 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0901302326460.10249@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0901282210030.22866@blackhole.kfki.hu> <Pine.LNX.4.58.0901301304350.27805@mail3.jubileegroup.co.uk> <Pine.LNX.4.58.0901302206040.5038@mail3.jubileegroup.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53892 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbZA3WcN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:32:13 -0500
In-Reply-To: <Pine.LNX.4.58.0901302206040.5038@mail3.jubileegroup.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 30 Jan 2009, G.W. Haywood wrote:

> > And it seems to work fine with kernel 2.4.37 ...
> 
> Hmmmmm - except for
> 
> gcc -D__KERNEL__ -I/mnt/hde3/gwh/src/linux/linux-2.4.37/include -Wall  \
>  -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing           \
>  -fno-common -fno-builtin-strpbrk -fno-builtin-sprintf                 \
>  -fomit-frame-pointer  -pipe -mpreferred-stack-boundary=2 -march=i686  \
>  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_set_setlist -c -o \
>  ip_set_setlist.o ip_set_setlist.c
> ip_set_setlist.c:25: parse error before "next_index_eq"
> ip_set_setlist.c:26: warning: return type defaults to `int'
> ip_set_setlist.c:176: parse error before "unshift_setlist"
> ip_set_setlist.c:177: warning: return type defaults to `int'
> make[3]: *** [ip_set_setlist.o] Error 1

'bool' is not recognized - I'm going to fix it.
 
> This is an otherwise vanilla non-modular kernel.  You're welcome to
> have the .config if you need it.  I have no need for ip_set_setlist,
> everything else compiles fine, so I've just disabled it.
> 
> $ gcc -v
> Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2.2/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man   \
>  --infodir=/usr/share/info --enable-shared --enable-threads=posix     \
>  --disable-checking --with-system-zlib --enable-__cxa_atexit          \
>  --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)
> 
> I had to tweak the Makefile to compile ipsets with this compiler
> because your new warning switches aren't recognized, but I'm sure
> that's of no concern - few people will be using such a compiler so
> old as this.

Could you send me the list of the switches which are not recognized?
I could add a simple workaround to exclude those at compile time.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
