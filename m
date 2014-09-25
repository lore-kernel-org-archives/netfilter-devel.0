From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Allow to compile for < 3.17 kernel version
Date: Thu, 25 Sep 2014 19:12:57 +0200
Message-ID: <20140925171257.GA13847@salvia>
References: <1411606624-8411-1-git-send-email-vadim4j@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vadim Kochan <vadim4j@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60886 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaIYRLt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:11:49 -0400
Content-Disposition: inline
In-Reply-To: <1411606624-8411-1-git-send-email-vadim4j@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 25, 2014 at 03:57:04AM +0300, Vadim Kochan wrote:
> Added declaration checking for NFT_EXPR_LOG_LEVEL enum
> which was added for 3.17 kernel version.
> 
> Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
> ---
>  configure.ac              | 2 ++
>  src/netlink_delinearize.c | 2 ++
>  src/netlink_linearize.c   | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/configure.ac b/configure.ac
> index 3a7647f..d3971c7 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -99,6 +99,8 @@ AC_TYPE_UINT16_T
>  AC_TYPE_UINT32_T
>  AC_TYPE_UINT64_T
>  
> +AC_CHECK_DECLS([NFT_EXPR_LOG_LEVEL],[],[],[[#include <libnftnl/expr.h>]])
> +
>  # Checks for library functions.
>  AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
>  
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 796b632..cf2ec00 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -447,11 +447,13 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
>  			nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_QTHRESHOLD);
>  		stmt->log.flags |= STMT_LOG_QTHRESHOLD;
>  	}
> +#if HAVE_DECL_NFT_EXPR_LOG_LEVEL
>  	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_LEVEL)) {
>  		stmt->log.level =
>  			nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_LEVEL);
>  		stmt->log.flags |= STMT_LOG_LEVEL;
>  	}
> +#endif
>  	list_add_tail(&stmt->list, &ctx->rule->stmts);
>  }
>  

I don't want to pollute the source code with many ifdef's, sorry. And
if I apply this, more similar follow up patches will come in the
future.

I'll make a patch to some recommended libnftnl version at configure
stage using PKG_CHECK_MODULES.
