From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCEMENT] ipset-3.2
Date: Sat, 22 Aug 2009 15:35:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908221527190.7819@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0908211609150.6879@blackhole.kfki.hu> <alpine.LSU.2.00.0908212012250.24079@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0908212012250.24079@fbirervta.pbzchgretzou.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Aug 2009, Jan Engelhardt wrote:

> 
> On Friday 2009-08-21 16:12, Jozsef Kadlecsik wrote:
> >
> >- Mixed up formats in ip_set_iptree.c fixed (Rob Sterenborg)
> >- Don't use 'bool' for backward compatibility reasons (Rob Sterenborg)
> 
> What actually is it that bool can't be used?

The 'bool' typedef was introduced in 2.6.19. However, some centos kernel 
releases versioned as 2.6.18 included the patch too. So without 
autoconfig it is not possible to figure out, just by checking the kernel 
version numbers, whether the kernel supports bool or not.

I want to support kernels as widely as possible and I do not really rely 
on 'bool', therefore decided to avoid it in the kernel part of ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
