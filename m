From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] Fix compilation with JSON and XML parsing
 enabled
Date: Mon, 12 Oct 2015 18:14:52 +0200
Message-ID: <20151012161452.GA31001@salvia>
References: <1444418467-18610-1-git-send-email-subramanian.vijay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	Aaron Conole <aconole@redhat.com>
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59262 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbbJLQHz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 12:07:55 -0400
Content-Disposition: inline
In-Reply-To: <1444418467-18610-1-git-send-email-subramanian.vijay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 09, 2015 at 12:21:07PM -0700, Vijay Subramanian wrote:
> Fix missing/incorrect variables.
> Also remove unsed variables to avoid warnings.

Applied this with minor nit.

> Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
> ---
>  src/expr/dup.c   |   13 +++++--------
>  src/expr/limit.c |    2 +-
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/src/expr/dup.c b/src/expr/dup.c
> index d0fa35f..217450a 100644
> --- a/src/expr/dup.c
> +++ b/src/expr/dup.c
> @@ -115,18 +115,16 @@ static int nftnl_expr_dup_json_parse(struct nftnl_expr *e, json_t *root,
>  				     struct nftnl_parse_err *err)
>  {
>  #ifdef JSON_PARSING
> -	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
>  	uint32_t sreg_addr, sreg_dev;
> -	int datareg_type;
> +	int ret = 0;

No need to initialize this, it will be override by next function call.

> -	ret = nftnl_jansson_parse_val(root, "sreg_addr", NFT_TYPE_U32, &sreg_addr, err);
> +	ret = nftnl_jansson_parse_val(root, "sreg_addr", NFTNL_TYPE_U32, &sreg_addr, err);

