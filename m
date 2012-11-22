From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: support for Linux 3.7 UAPI
Date: Thu, 22 Nov 2012 21:29:46 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211222128390.1514@blackhole.kfki.hu>
References: <1353539142-31631-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55461 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2KVU3s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:29:48 -0500
In-Reply-To: <1353539142-31631-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Thu, 22 Nov 2012, Jan Engelhardt wrote:

> In Linux 3.7, nfnetlink.h moved below include/uapi/. Make configure
> recognize that. Furthermore, we can drop the unnecessary indirection
> via backticks and just ask grep directly if there was any result.

The patch is applied and pushed into the ipset git tree, thanks.

Best regards,
Jozsef 

> diff --git a/configure.ac b/configure.ac
> index 7a6aa33..dea392d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -68,7 +68,8 @@ fi
>  
>  AC_PROG_GREP
>  
> -if test "X`$GREP 'NFNL_SUBSYS_IPSET' $ksourcedir/include/linux/netfilter/nfnetlink.h`" = "X"
> +if ! $GREP -q "NFNL_SUBSYS_IPSET" "$ksourcedir/include/linux/netfilter/nfnetlink.h" && \
> +   ! $GREP -q "NFNL_SUBSYS_IPSET" "$ksourcedir/include/uapi/linux/netfilter/nfnetlink.h";
>  then
>  	AC_MSG_ERROR([The kernel source directory $ksourcedir is not patched with netlink.patch to support ipset])
>  fi
> -- 
> 1.7.10.4
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
