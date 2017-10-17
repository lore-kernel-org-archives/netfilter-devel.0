From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 13:05:07 +0200
Message-ID: <20171017110507.GA16060@salvia>
References: <20171004213640.1819-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755570AbdJQLFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:05:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B72B3249C3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:05:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A56BADA3A4
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:05:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171004213640.1819-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Wed, Oct 04, 2017 at 11:36:40PM +0200, Phil Sutter wrote:
> Implement expression printing into a FILE pointer analogous to
> nftnl_rule_fprintf().

src/libnftnl.map needs to be updated. I can do it here myself, no
problem, or feel free to send v2, as you prefer.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/libnftnl/expr.h |  1 +
>  src/expr.c              | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
> index 76f28fee7b5f7..f37f50963d6c3 100644
> --- a/include/libnftnl/expr.h
> +++ b/include/libnftnl/expr.h
> @@ -39,6 +39,7 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
>  bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
>  
>  int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
> +int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
>  
>  enum {
>  	NFTNL_EXPR_PAYLOAD_DREG	= NFTNL_EXPR_BASE,
> diff --git a/src/expr.c b/src/expr.c
> index c5fcf06492ae2..1eae70787209d 100644
> --- a/src/expr.c
> +++ b/src/expr.c
> @@ -293,3 +293,17 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
>  	return offset;
>  }
>  EXPORT_SYMBOL(nftnl_expr_snprintf);
> +
> +static int nftnl_expr_do_snprintf(char *buf, size_t size, const void *e,
> +				  uint32_t cmd, uint32_t type, uint32_t flags)
> +{
> +	return nftnl_expr_snprintf(buf, size, e, type, flags);
> +}
> +
> +int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
> +		       uint32_t flags)
> +{
> +	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
> +			     nftnl_expr_do_snprintf);
> +}
> +EXPORT_SYMBOL(nftnl_expr_fprintf);
> -- 
> 2.13.1
> 
