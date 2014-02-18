From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH 1/6] rule: make family2str() public
Date: Tue, 18 Feb 2014 02:01:53 +0100
Message-ID: <20140218010153.GA4445@localhost>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231811.19943.19489.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaBRBCD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:02:03 -0500
Content-Disposition: inline
In-Reply-To: <20140217231811.19943.19489.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 12:18:11AM +0100, Arturo Borrero Gonzalez wrote:
> Make family2str() public so the function can be called from
> other files.

This patch is too small and we follow a different policy when making
patches: Export function and first usage should happen in the same
patch.

I think you can collapse this patch with 1/2.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/rule.h |    2 ++
>  src/rule.c     |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index e06444e..4891dc1 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -125,6 +125,8 @@ extern void chain_add_hash(struct chain *chain, struct table *table);
>  extern struct chain *chain_lookup(const struct table *table,
>  				  const struct handle *h);
>  
> +extern const char *family2str(unsigned int family);
> +
>  /**
>   * struct rule - nftables rule
>   *
> diff --git a/src/rule.c b/src/rule.c
> index ab96e62..9ff2dd3 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -279,7 +279,7 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
>  	return NULL;
>  }
>  
> -static const char *family2str(unsigned int family)
> +const char *family2str(unsigned int family)
>  {
>  	switch (family) {
>  		case NFPROTO_IPV4:
> 
