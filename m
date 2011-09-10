From: Julien Lafaye <jlafaye@gmail.com>
Subject: Building standalone xtable extension shared library
Date: Sat, 10 Sep 2011 23:35:28 +0200
Message-ID: <CAFAca_AcCg3WRSC9jGpf-SHm6SGwVvQ2-7H=krE+sTGg-osOCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64694 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab1IJVf2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:35:28 -0400
Received: by vxi9 with SMTP id 9so1934261vxi.19
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2011 14:35:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I would like to report that I followed the instruction of the
(excellent) guide on how to write netfilter modules (rev Feb. 7 2011).

I had difficulties  compiling an xtable extension shared library. It
turns out that using the gcc provided with my distribution, gcc
(Debian 4.6.0-9) 4.6.1 20110524 (prerelease) the options -DPIC -fPIC
are required when building the object file.

The instructions page 27 should be updated with the following Makefile lines:

CFLAGS = -O2 -Wall
lib%.so: lib%.o
gcc -shared -o $@ $^;
lib%.o: lib%.c
gcc ${CFLAGS} -D_INIT=lib$*_init -c -o $@ $<;
