From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/3] doc: Linux 2.6.39 already has the defs
Date: Wed, 4 Jan 2012 15:07:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201041506410.925@blackhole.kfki.hu>
References: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40088 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab2ADOHU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:07:20 -0500
In-Reply-To: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sun, 1 Jan 2012, Jan Engelhardt wrote:

All patches are applied and pushed, thanks.

Best regards,
Jozsef

> ---
>  README |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/README b/README
> index e5c0ddf..dd6e66b 100644
> --- a/README
> +++ b/README
> @@ -4,7 +4,7 @@ instructions too.
>  
>  0. You need the source tree of your kernel (version >= 2.6.34)
>     and it have to be configured with ip6tables support enabled,
> -   modules compiled. For kernel versions <= 2.6.39 please apply
> +   modules compiled. For kernel versions < 2.6.39 please apply
>     the netlink.patch against your kernel tree, which adds the
>     new subsystem identifier for ipset.
>  
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
