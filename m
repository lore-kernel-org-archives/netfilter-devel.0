From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Building standalone xtable extension shared library
Date: Sun, 11 Sep 2011 00:19:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109110017100.1917@frira.zrqbmnf.qr>
References: <CAFAca_AcCg3WRSC9jGpf-SHm6SGwVvQ2-7H=krE+sTGg-osOCg@mail.gmail.com> <CAFAca_ATOWczLJ33S1=QWX5j7K6LaA=mEpYgMvPE_p_rVH4vSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Julien Lafaye <jlafaye@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56401 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810Ab1IJWTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Sep 2011 18:19:53 -0400
In-Reply-To: <CAFAca_ATOWczLJ33S1=QWX5j7K6LaA=mEpYgMvPE_p_rVH4vSw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-09-10 23:38, Julien Lafaye wrote:

>Sorry, I send an incomplete email by mistake:
>
>The correct Makefile, working on my setup is:
>LAGS = -O2 -Wall
> lib%.so: lib%.o
>     gcc -shared -o $@ $^;
> lib%.o: lib%.c
>     gcc ${CFLAGS} -DPIC -fPIC -D_INIT=lib$*_init -c -o $@ $<;
>
>I guess this might seem obvious to many of you but the problem I had
>initially was a segfault when parsing command line arguments.

Segfaults are usually a sign of a flaw somewhere; the absence of PIC is 
usually caught in the linker stage already. Therefore I highly suggest 
that you also submit your code so that we can improve iptables's 
robustness.
And thanks for the hint, yes, -fPIC should indeed be specified.

thanks,
Jan
