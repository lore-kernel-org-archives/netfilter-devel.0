From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: fix build with musl
Date: Tue, 26 Sep 2017 09:32:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709260930500.17493@blackhole.kfki.hu>
References: <20170925050901.31033-1-stijn@linux-ipv6.be> <alpine.DEB.2.11.1709252012550.16418@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stijn Tintel <stijn@linux-ipv6.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39261 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966729AbdIZHcW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 03:32:22 -0400
In-Reply-To: <alpine.DEB.2.11.1709252012550.16418@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 25 Sep 2017, Jozsef Kadlecsik wrote:

> > Include sys/types.h for u_int8_t and define _GNU_SOURCE for musl to
> > expose it.
> > 
> > Fixes: 54802b2c2826 ("Report if the option is supported by a newer kernel release")
> > Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
> 
> Patch is applied in ipset git tree, thanks.

I reverted your patch and applied the proper fix: replaced the last 
occurence of u_int8_t in the ipset userspace tree with uint8_t.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
