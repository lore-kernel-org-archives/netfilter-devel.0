From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libiptc: fix retry path in TC_INIT
Date: Thu, 19 Apr 2012 01:12:42 +0200
Message-ID: <20120418231242.GB12354@1984>
References: <1334651363.10712.6.camel@mgo-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Miguel GAIO <miguel.gaio@efixo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2DRXMx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:12:53 -0400
Content-Disposition: inline
In-Reply-To: <1334651363.10712.6.camel@mgo-thinkpad>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Miguel,

On Tue, Apr 17, 2012 at 10:29:23AM +0200, Miguel GAIO wrote:
> Hi,
> 
> There is an issue on TC_INIT retry path:
> In error case, TC_FREE is called and close sockfd.
> The retry does not reopen then always fail.
> 
> The proposing patch reopen sockfd in retry patch.
> 
> 
> Miguel
>
> From 6dbb1a9f16c70a60c06559b31eac7ab3af789fa1 Mon Sep 17 00:00:00 2001
> From: Miguel GAIO <miguel.gaio@efixo.com>
> Date: Tue, 17 Apr 2012 10:16:28 +0200
> Subject: [PATCH 2008/2008]  libiptc: TC_INIT fix retry
> 
> ---
>  libiptc/libiptc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index 63965e7..cd2ad9d 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -1314,6 +1314,7 @@ TC_INIT(const char *tablename)
>  		return NULL;
>  	}
>  
> +retry:

Still iptc_fn is set to TC_FREE. We have to move up to the beginning
of TC_INIT.
