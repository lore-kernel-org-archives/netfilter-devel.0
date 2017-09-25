From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: fix build with musl
Date: Mon, 25 Sep 2017 20:13:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709252012550.16418@blackhole.kfki.hu>
References: <20170925050901.31033-1-stijn@linux-ipv6.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stijn Tintel <stijn@linux-ipv6.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:38493 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753917AbdIYSNi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2017 14:13:38 -0400
In-Reply-To: <20170925050901.31033-1-stijn@linux-ipv6.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Stijn,

On Mon, 25 Sep 2017, Stijn Tintel wrote:

> Include sys/types.h for u_int8_t and define _GNU_SOURCE for musl to
> expose it.
> 
> Fixes: 54802b2c2826 ("Report if the option is supported by a newer kernel release")
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
> ---
>  src/ipset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/ipset.c b/src/ipset.c
> index 79f56b8..8d70abc 100644
> --- a/src/ipset.c
> +++ b/src/ipset.c
> @@ -14,6 +14,8 @@
>  #include <stdio.h>			/* fprintf, fgets */
>  #include <stdlib.h>			/* exit */
>  #include <string.h>			/* str* */
> +#define _GNU_SOURCE
> +#include <sys/types.h>			/* u_int8_t */
>  
>  #include <config.h>
>  
> -- 

Patch is applied in ipset git tree, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
