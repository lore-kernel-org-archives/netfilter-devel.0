From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] src: xml: add versioning
Date: Mon, 27 May 2013 14:51:09 +0200
Message-ID: <20130527125109.GB16382@localhost>
References: <20130524112756.13209.37625.stgit@nfdev.cica.es>
 <20130524112846.13209.99752.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50140 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab3E0MvR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 08:51:17 -0400
Content-Disposition: inline
In-Reply-To: <20130524112846.13209.99752.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 24, 2013 at 01:28:46PM +0200, Arturo Borrero wrote:
> All XML chunks now have a "version" attribute to help in future changes.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftables/chain.h |    2 ++
>  include/libnftables/rule.h  |    2 ++
>  include/libnftables/table.h |    2 ++
>  src/chain.c                 |   18 +++++++++++++++---
>  src/rule.c                  |   17 +++++++++++++++--
>  src/table.c                 |   18 ++++++++++++++++--
>  6 files changed, 52 insertions(+), 7 deletions(-)
> 
> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
> index b12474f..a789e8b 100644
> --- a/include/libnftables/chain.h
> +++ b/include/libnftables/chain.h
> @@ -45,6 +45,8 @@ enum {
>  	NFT_CHAIN_O_XML,
>  };
>  
> +#define NFT_CHAIN_XML_VERSION 0

This definition is only used internally, so it should not be exported.
Move it to internal.h.
