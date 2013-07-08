From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: libxt_dccp/libxt_sctp: enable debug
 tracing by DEBUG define
Date: Mon, 8 Jul 2013 04:55:10 +0200
Message-ID: <20130708025510.GA14195@localhost>
References: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
 <1372922778-12997-3-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52937 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3GHCzd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:55:33 -0400
Content-Disposition: inline
In-Reply-To: <1372922778-12997-3-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 04, 2013 at 11:26:18AM +0400, Alexey Perevalov wrote:
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  extensions/libxt_dccp.c |    4 ++--
>  extensions/libxt_sctp.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
> index a35cabb..06cd23d 100644
> --- a/extensions/libxt_dccp.c
> +++ b/extensions/libxt_dccp.c
> @@ -16,11 +16,11 @@
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/xt_dccp.h>
>  
> -#if 0
> +#ifdef DEBUG
>  #define DEBUGP(format, first...) printf(format, ##first)
>  #define static
>  #else
> -#define DEBUGP(format, fist...) 
> +#define DEBUGP(format, fist...)
>  #endif

I don't find any client of this code for libxt_dccp, better delete it
in that case.

>  enum {
> diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
> index 56a4cdf..f5959cb 100644
> --- a/extensions/libxt_sctp.c
> +++ b/extensions/libxt_sctp.c
> @@ -20,11 +20,11 @@
>  
>  #include <linux/netfilter/xt_sctp.h>
>  
> -#if 0
> +#if DEBUG
>  #define DEBUGP(format, first...) printf(format, ##first)
>  #define static
>  #else
> -#define DEBUGP(format, fist...) 
> +#define DEBUGP(format, fist...)
>  #endif
>  
>  static void
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
