From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: your mail
Date: Wed, 31 Aug 2011 14:49:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108311447070.31028@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311352450.31028@blackhole.kfki.hu> <alpine.LNX.2.01.1108311409060.2589@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311414470.31028@blackhole.kfki.hu>
 <alpine.LNX.2.01.1108311444300.30915@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54297 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1HaMtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:49:41 -0400
In-Reply-To: <alpine.LNX.2.01.1108311444300.30915@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 31 Aug 2011, Jan Engelhardt wrote:

> On Wednesday 2011-08-31 14:16, Jozsef Kadlecsik wrote:
> 
> >On Wed, 31 Aug 2011, Jan Engelhardt wrote:
> >
> >> On Wednesday 2011-08-31 13:56, Jozsef Kadlecsik wrote:
> >> 
> >> >On Sun, 28 Aug 2011, Jan Engelhardt wrote:
> >> >
> >> >> libxt_SET.c requires IPSET_INVALID_ID, but this constant has moved into 
> >> >> a #ifdef __KERNEL__ section lately and is thus absent from userspace. 
> >> >> (In linux-kernel/include/linux/netfilter/ipset/ip_set.h.)
> >> >
> >> >After rewieving your patches, I don't get it: what userspace tool would 
> >> >use linux-kernel/include/linux/netfilter/ipset/ip_set.h? iptables does 
> >> >definitely not use it and ipset either. So why your patches are 
> >> >required?
> >> 
> >> iptables/extensions/xt_SET.c #includes <netfilter/xt_set.h> which 
> >> #includes ip_set.h to get at the definition of ip_set.h.
> >> Patch will be resent.
> >
> >iptables/extensions/libxt_SET.c includes <linux/netfilter/xt_set.h> and 
> >xt_set.h includes nothing.
> 
> 14:44 seven:../linux/netfilter > git show v3.0:include/linux/netfilter/xt_set.h | grep includ
> #include <linux/types.h>
> #include <linux/netfilter/ipset/ip_set.h>

This is the kernel source tree. You wrote about libxt_SET.c and userspace:

kadlec@mentat:/usr/src/git/iptables$ rgrep ip_set.h *
kadlec@mentat:/usr/src/git/iptables$ 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
