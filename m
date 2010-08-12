From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-4.2 compilation fails with recent kernel
Date: Thu, 12 Aug 2010 09:01:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1008120900420.15863@blackhole.kfki.hu>
References: <AANLkTi=cY4pJpVELPg9Pfjf=HB8kaWHDUuuWrtT1DJ8Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nort Obor <obornort@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54185 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0HLHH6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:07:58 -0400
In-Reply-To: <AANLkTi=cY4pJpVELPg9Pfjf=HB8kaWHDUuuWrtT1DJ8Y@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Aug 2010, Nort Obor wrote:

> trying to compile ipset-4.2 / linux-2.6.35 with gcc-4.5.1, i get:
> 
> ...
> make[1]: Entering directory `/usr/src/linux-2.6.35'
>   CC [M]  /usr/src/ipset/kernel/ip_set.o
>   CC [M]  /usr/src/ipset/kernel/ipt_set.o
> /usr/src/ipset/kernel/ipt_set.c:89:20: warning: 'struct
> xt_match_param' declared inside parameter list
> /usr/src/ipset/kernel/ipt_set.c:89:20: warning: its scope is only this
> definition or declaration, which is probably not what you want
> /usr/src/ipset/kernel/ipt_set.c: In function 'match':
> /usr/src/ipset/kernel/ipt_set.c:95:45: error: dereferencing pointer to
> incomplete type
> /usr/src/ipset/kernel/ipt_set.c: At top level:
> /usr/src/ipset/kernel/ipt_set.c:215:2: warning: initialization from
> incompatible pointer type
> /usr/src/ipset/kernel/ipt_set.c:217:2: warning: initialization from
> incompatible pointer type
> make[2]: *** [/usr/src/ipset/kernel/ipt_set.o] Error 1

Yes, the kernel interface changed. There'll be a new release of ipset 
somewhere around the weekend.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
