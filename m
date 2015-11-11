From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft 4/6] set_elem: parse expressions attached to set
 elements
Date: Wed, 11 Nov 2015 16:18:15 +0000
Message-ID: <20151111161815.GA4059@macbook.localdomain>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
 <1446834863-18610-5-git-send-email-kaber@trash.net>
 <20151111123753.GA2920@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:40280 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbbKKQST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 11:18:19 -0500
Content-Disposition: inline
In-Reply-To: <20151111123753.GA2920@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.11, Pablo Neira Ayuso wrote:
> On Fri, Nov 06, 2015 at 06:34:21PM +0000, Patrick McHardy wrote:
> >  static void set_elem_expr_destroy(struct expr *expr)
> > diff --git a/src/netlink.c b/src/netlink.c
> > index ad86084..3bef5f4 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -1472,6 +1472,8 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
> >  		expr->comment = xmalloc(len);
> >  		memcpy((char *)expr->comment, data, len);
> >  	}
> > +	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR))
> > +		expr->stmt = netlink_parse_set_expr(set, (void *)nftnl_set_elem_get(nlse, NFT_SET_ELEM_ATTR_EXPR, NULL));
> 
> 
> Minor nit I just noticed: please use NFTNL_SET_ELEM_EXPR here instead,
> the old constant definitions will go after a couple of libnftnl
> releases, they have been left there just to make the transition a bit
> less traumatic.

Sure, fixed it. Thanks.
