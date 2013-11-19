From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] expr: log: fixed error in nft_rule_expr_parse
Date: Tue, 19 Nov 2013 20:09:57 +0100
Message-ID: <1384888197.25788.5.camel@tiger2>
References: <1384862476-3413-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59400 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3KSTKI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:10:08 -0500
In-Reply-To: <1384862476-3413-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Good catch. ACK.

Small thing, please modify the subject prefix so we know what is the
target of this patch. For example, use [libnftables PATCH] instead of
[PATCH]. You can use --subject-prefix of git to do so.

On Tue, 2013-11-19 at 13:01 +0100, Ana Rey wrote:
> I fix it by allocating the correct value.
> ---
>  src/expr/log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/expr/log.c b/src/expr/log.c
> index 2d3e0cf..495c1bd 100644
> --- a/src/expr/log.c
> +++ b/src/expr/log.c
> @@ -142,7 +142,7 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  			xfree(log->prefix);
>  
>  		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
> -		e->flags |= (1 << NFT_EXPR_LOG_GROUP);
> +		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
>  	}
>  	if (tb[NFTA_LOG_GROUP]) {
>  		log->group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

