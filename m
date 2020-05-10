Return-Path: <SRS0=uppk=6Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A210C38A2A
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 22:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA7C20731
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 22:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEJWEA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 May 2020 18:04:00 -0400
Received: from correo.us.es ([193.147.175.20]:35202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgEJWEA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 May 2020 18:04:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1262B6338
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 00:03:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1D8211540C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 00:03:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 973FF2040D; Mon, 11 May 2020 00:03:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93540A6A0;
        Mon, 11 May 2020 00:03:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 00:03:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7610242EF4E0;
        Mon, 11 May 2020 00:03:56 +0200 (CEST)
Date:   Mon, 11 May 2020 00:03:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_set_rbtree: Add missing expired checks
Message-ID: <20200510220356.GA10133@salvia>
References: <20200506111107.29778-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506111107.29778-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, May 06, 2020 at 01:11:07PM +0200, Phil Sutter wrote:
> Expired intervals would still match and be dumped to user space until
> garbage collection wiped them out. Make sure they stop matching and
> disappear (from users' perspective) as soon as they expire.
> 
> Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nft_set_rbtree.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 3ffef454d4699..8efcea03a4cbb 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -75,7 +75,8 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
>  		} else if (d > 0)
>  			parent = rcu_dereference_raw(parent->rb_right);
>  		else {
> -			if (!nft_set_elem_active(&rbe->ext, genmask)) {
> +			if (!nft_set_elem_active(&rbe->ext, genmask) ||
> +			    nft_set_elem_expired(&rbe->ext)) {

It seems _insert() does not allow for duplicates. I think it's better
if you just:

        return false;

in case in case the element has expired, right?

Same thing in _get.

Thanks.

>  				parent = rcu_dereference_raw(parent->rb_left);
>  				continue;
>  			}
> @@ -94,6 +95,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
>  
>  	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
>  	    nft_set_elem_active(&interval->ext, genmask) &&
> +	    !nft_set_elem_expired(&interval->ext) &&
>  	    nft_rbtree_interval_start(interval)) {
>  		*ext = &interval->ext;
>  		return true;
> @@ -149,7 +151,8 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
>  			if (flags & NFT_SET_ELEM_INTERVAL_END)
>  				interval = rbe;
>  		} else {
> -			if (!nft_set_elem_active(&rbe->ext, genmask)) {
> +			if (!nft_set_elem_active(&rbe->ext, genmask) ||
> +			    nft_set_elem_expired(&rbe->ext)) {
>  				parent = rcu_dereference_raw(parent->rb_left);
>  				continue;
>  			}
> @@ -170,6 +173,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
>  
>  	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
>  	    nft_set_elem_active(&interval->ext, genmask) &&
> +	    !nft_set_elem_expired(&interval->ext) &&
>  	    ((!nft_rbtree_interval_end(interval) &&
>  	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
>  	     (nft_rbtree_interval_end(interval) &&
> @@ -418,6 +422,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
>  
>  		if (iter->count < iter->skip)
>  			goto cont;
> +		if (nft_set_elem_expired(&rbe->ext))
> +			goto cont;
>  		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
>  			goto cont;
>  
> -- 
> 2.25.1
> 
