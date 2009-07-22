From: Giacomo <delleceste@gmail.com>
Subject: problems with linux/tcp.h and g++
Date: Wed, 22 Jul 2009 16:03:12 +0200
Message-ID: <885896af0907220703o61920562n6cdb106c4dd0e3fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57283 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZGVODO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:03:14 -0400
Received: by ewy26 with SMTP id 26so226095ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2009 07:03:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all!

I developed a kernel module which needs linux/tcp.h and a userspace
program that
communicates with it via netlink.

Kernel code uses linux/tcp.h

userspace C code correctly uses linux/tcp.h

A gui written in C++, using linux/tcp.h produces a compilation error:

In file included from ../common/defs/ipfi_structures.h:9,
                 from ../ipfi/src/includes/ipfire_structs.h:20,
                 from iqlistener.h:4,
                 from iqlistener.cpp:1:
/usr/include/linux/tcp.h:72: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:72: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:73: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:73: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:74: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:74: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:75: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:75: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:76: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:76: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:77: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:77: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:78: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:78: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:79: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:79: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:80: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:80: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:81: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:81: error: a function call cannot appear in a
constant-expression

The same code used to compile until a recent update.

Now I am including netinet/tcp.h instead of linux/tcp.h to compile in userspace.

Is there any known issue with linux/tcp.h?

Which is the differece between linux/ and netinet/includes and which
is more correct to use?

Thanks for any hint.

Kernel 2.6.30
gcc version 4.3.3
glibc 2.10.1
sys-kernel/linux-headers 2.6.30

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
