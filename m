From: Julien Lafaye <jlafaye@gmail.com>
Subject: Re: Building standalone xtable extension shared library
Date: Sat, 10 Sep 2011 23:38:34 +0200
Message-ID: <CAFAca_ATOWczLJ33S1=QWX5j7K6LaA=mEpYgMvPE_p_rVH4vSw@mail.gmail.com>
References: <CAFAca_AcCg3WRSC9jGpf-SHm6SGwVvQ2-7H=krE+sTGg-osOCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:46432 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab1IJVif (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:38:35 -0400
Received: by vws10 with SMTP id 10so2932616vws.2
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2011 14:38:34 -0700 (PDT)
In-Reply-To: <CAFAca_AcCg3WRSC9jGpf-SHm6SGwVvQ2-7H=krE+sTGg-osOCg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, I send an incomplete email by mistake:

The correct Makefile, working on my setup is:
LAGS = -O2 -Wall
 lib%.so: lib%.o
     gcc -shared -o $@ $^;
 lib%.o: lib%.c
     gcc ${CFLAGS} -DPIC -fPIC -D_INIT=lib$*_init -c -o $@ $<;

I guess this might seem obvious to many of you but the problem I had
initially was a segfault when parsing command line arguments.

Regards,

Julien Lafaye

On 9/10/11, Julien Lafaye <jlafaye@gmail.com> wrote:
> Hello,
>
> I would like to report that I followed the instruction of the
> (excellent) guide on how to write netfilter modules (rev Feb. 7 2011).
>
> I had difficulties  compiling an xtable extension shared library. It
> turns out that using the gcc provided with my distribution, gcc
> (Debian 4.6.0-9) 4.6.1 20110524 (prerelease) the options -DPIC -fPIC
> are required when building the object file.
>
> The instructions page 27 should be updated with the following Makefile
> lines:
>
> CFLAGS = -O2 -Wall
> lib%.so: lib%.o
> gcc -shared -o $@ $^;
> lib%.o: lib%.c
> gcc ${CFLAGS} -D_INIT=lib$*_init -c -o $@ $<;
>
