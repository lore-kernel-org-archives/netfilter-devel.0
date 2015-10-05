From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Mon, 5 Oct 2015 17:39:25 +0200
Message-ID: <20151005153925.GA22976@salvia>
References: <20151002013240.GA21692@oxygen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57550 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbJEPc0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:32:26 -0400
Content-Disposition: inline
In-Reply-To: <20151002013240.GA21692@oxygen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 02, 2015 at 08:32:40AM +0700, Neutron Soutmun wrote:
> diff --git a/src/internal.h b/src/internal.h
> index 3a88d1a..1012df2 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -2,11 +2,5 @@
>  #define INTERNAL_H 1
>  
>  #include "config.h"
> -#ifdef HAVE_VISIBILITY_HIDDEN
> -#	define __visible	__attribute__((visibility("default")))
> -#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
> -#else
> -#	define EXPORT_SYMBOL
> -#endif
>  
>  #endif

Could you git rm src/internal.h there and resubmit?

BTW, I would *really* appreciate if you send me similar patches for
other libraries in the tree, to leave things in consistent state.

Thanks.
