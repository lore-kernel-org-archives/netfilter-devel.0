From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] lookup: Add support for the flag attribute
Date: Thu, 17 Jul 2014 17:40:39 +0200
Message-ID: <20140717154039.GA3279@salvia>
References: <1405610250-6631-1-git-send-email-yshuiv7@gmail.com>
 <1405610250-6631-3-git-send-email-yshuiv7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59746 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145AbaGQPkt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:40:49 -0400
Content-Disposition: inline
In-Reply-To: <1405610250-6631-3-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:17:29PM +0800, Yuxuan Shui wrote:
> Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
> ---
>  include/libnftnl/expr.h             |  1 +
>  include/linux/netfilter/nf_tables.h | 10 +++++++++
>  src/expr/lookup.c                   | 44 +++++++++++++++++++++++++++++++++++--
>  3 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
> index cfa5c66..e3c045b 100644
> --- a/include/libnftnl/expr.h
> +++ b/include/libnftnl/expr.h
> @@ -107,6 +107,7 @@ enum {
>  	NFT_EXPR_LOOKUP_DREG,
>  	NFT_EXPR_LOOKUP_SET,
>  	NFT_EXPR_LOOKUP_SET_ID,
> +	NFT_EXPR_LOOKUP_FLAG,

I didn't notice so far, please rename this to NFT_EXPR_LOOKUP_FLAGS.

Thanks.
