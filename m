From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: make header files usable from userspace (v2)
Date: Wed, 31 Aug 2011 16:01:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108311600580.31028@blackhole.kfki.hu>
References: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:35891 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1HaOBZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:01:25 -0400
In-Reply-To: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Wed, 31 Aug 2011, Jan Engelhardt wrote:

> While refreshing iptables's header files with new ones from the
> kernel, libxt_SET fails to compile because some definitions were
> locked away in __KERNEL__ sections when they should not have been.
> 
> >In the second patch please move the type id and the ip_set_dim enum
> >together outside of the __KERNEL__ section. Thus a single #ifdef
> >section suffices. Thanks!
> 
> done so now.

Thanks, the patches are applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
