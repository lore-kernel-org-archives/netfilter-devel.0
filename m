From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 6/6] ipset: fix spelling error
Date: Tue, 25 Jan 2011 21:43:24 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252143020.19580@blackhole.kfki.hu>
References: <20110124213631.195499507@jonathan.eitzenberger.org> <20110124214015.902503724@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40118 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1AYUnZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:43:25 -0500
In-Reply-To: <20110124214015.902503724@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Jan 2011, Holger Eitzenberger wrote:

> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> 
> Index: ipset/src/errcode.c
> ===================================================================
> --- ipset.orig/src/errcode.c
> +++ ipset/src/errcode.c
> @@ -30,14 +30,14 @@ static const struct ipset_errcode_table
>  	{ EEXIST, IPSET_CMD_CREATE,
>  	  "Set cannot be created: set with the same name already exists" },
>  	{ IPSET_ERR_FIND_TYPE, 0,
> -	  "Kernel error received: set type does not supported" },
> +	  "Kernel error received: set type not supported" },
>  	{ IPSET_ERR_MAX_SETS, 0,
>  	  "Kernel error received: maximal number of sets reached, "
>  	  "cannot create more." },
>  	{ IPSET_ERR_INVALID_NETMASK, 0,
>  	  "The value of the netmask parameter is invalid" },
>  	{ IPSET_ERR_INVALID_FAMILY, 0,
> -	  "The protocol family not supported by the set type" },
> +	  "Potocol family not supported by the set type" },
>  
>  	/* DESTROY specific error codes */
>  	{ IPSET_ERR_BUSY, IPSET_CMD_DESTROY,
> 
> --

Applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
