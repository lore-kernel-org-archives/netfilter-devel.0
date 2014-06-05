From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/5] expr: reject: Add
 nft_rule_expr_reject_snprinf_* functions
Date: Thu, 5 Jun 2014 15:19:09 +0200
Message-ID: <20140605131909.GD20181@localhost>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
 <1401881891-4990-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFENTS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:19:18 -0400
Content-Disposition: inline
In-Reply-To: <1401881891-4990-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 04, 2014 at 01:38:07PM +0200, Ana Rey wrote:
> Code refactoring in nft_rule_expr_reject_snprinf functions. This process
> adds three new functions:
> 
> * nft_rule_expr_reject_snprinf_default
> * nft_rule_expr_reject_snprinf_xml
> * nft_rule_expr_reject_snprinf_json

Applied with minor changes.

> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  src/expr/reject.c | 42 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/src/expr/reject.c b/src/expr/reject.c
> index 62346e9..cefaf98 100644
> --- a/src/expr/reject.c
> +++ b/src/expr/reject.c
> @@ -174,24 +174,46 @@ nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
>  #endif
>  }
>  
> +static int nft_rule_expr_reject_snprintf_default(char *buf, size_t len,
> +						 struct nft_rule_expr *e)
> +{
> +	struct nft_expr_reject *reject = nft_expr_data(e);
> +
> +	return snprintf(buf, len, "type %u code %u  ",
                                                   ^
removed extra whitespace. Not your fault, but good to fix it now that
we're just passing by this code.
