From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft 4/6] set_elem: parse expressions attached to set
 elements
Date: Wed, 11 Nov 2015 13:37:53 +0100
Message-ID: <20151111123753.GA2920@salvia>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
 <1446834863-18610-5-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41573 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbbKKMh6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 07:37:58 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BAFC11714E0
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 13:37:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA6E3C882C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 13:37:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C6BAB1FE3C2
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 13:37:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1446834863-18610-5-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2015 at 06:34:21PM +0000, Patrick McHardy wrote:
>  static void set_elem_expr_destroy(struct expr *expr)
> diff --git a/src/netlink.c b/src/netlink.c
> index ad86084..3bef5f4 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -1472,6 +1472,8 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
>  		expr->comment = xmalloc(len);
>  		memcpy((char *)expr->comment, data, len);
>  	}
> +	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR))
> +		expr->stmt = netlink_parse_set_expr(set, (void *)nftnl_set_elem_get(nlse, NFT_SET_ELEM_ATTR_EXPR, NULL));


Minor nit I just noticed: please use NFTNL_SET_ELEM_EXPR here instead,
the old constant definitions will go after a couple of libnftnl
releases, they have been left there just to make the transition a bit
less traumatic.

Thanks.
