From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v4 1/3] expr: log: Rename variables in
 nft_rule_expr_log_json_parse functions
Date: Thu, 5 Jun 2014 15:17:22 +0200
Message-ID: <20140605131722.GA20181@localhost>
References: <1401792116-17742-1-git-send-email-anarey@gmail.com>
 <1401792116-17742-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41502 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaFENRd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:17:33 -0400
Content-Disposition: inline
In-Reply-To: <1401792116-17742-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 03, 2014 at 12:41:54PM +0200, Ana Rey wrote:
> Renames some variables for code readability reasons.
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  src/expr/log.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/src/expr/log.c b/src/expr/log.c
> index a61a8d3..eaba1d6 100644
> --- a/src/expr/log.c
> +++ b/src/expr/log.c
> @@ -166,7 +166,8 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
>  #ifdef JSON_PARSING
>  	const char *prefix;
>  	uint32_t snaplen;
> -	uint16_t uval16;
> +	uint16_t group;
> +	uint16_t qthreshold;

Applied, but I have merge the two variable definitions above.
