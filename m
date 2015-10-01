From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Thu, 1 Oct 2015 18:50:35 +0200
Message-ID: <20151001165035.GB2107@salvia>
References: <20151001110521.GA11642@oxygen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39939 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbbJAQnn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 12:43:43 -0400
Content-Disposition: inline
In-Reply-To: <20151001110521.GA11642@oxygen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 01, 2015 at 06:05:21PM +0700, Neutron Soutmun wrote:
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

Do we need the internal.h file anymore?
