From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: your mail
Date: Wed, 31 Aug 2011 13:56:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108311352450.31028@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:51535 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1HaL4h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:56:37 -0400
In-Reply-To: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sun, 28 Aug 2011, Jan Engelhardt wrote:

> libxt_SET.c requires IPSET_INVALID_ID, but this constant has moved into 
> a #ifdef __KERNEL__ section lately and is thus absent from userspace. 
> (In linux-kernel/include/linux/netfilter/ipset/ip_set.h.)

After rewieving your patches, I don't get it: what userspace tool would 
use linux-kernel/include/linux/netfilter/ipset/ip_set.h? iptables does 
definitely not use it and ipset either. So why your patches are 
required?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
