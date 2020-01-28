Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF117C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 12:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBDC224685
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 12:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgA1MXS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 07:23:18 -0500
Received: from correo.us.es ([193.147.175.20]:57232 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgA1MXS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 07:23:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6116C18CDD3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 13:23:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50E00DA701
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 13:23:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 46B7EDA715; Tue, 28 Jan 2020 13:23:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27112DA707;
        Tue, 28 Jan 2020 13:23:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jan 2020 13:23:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 08E6D42EE38F;
        Tue, 28 Jan 2020 13:23:14 +0100 (CET)
Date:   Tue, 28 Jan 2020 13:23:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 4/4] segtree: Refactor ei_insert()
Message-ID: <20200128122312.2mhlwu45p6jalfsn@salvia>
References: <20200123143049.13888-1-phil@nwl.cc>
 <20200123143049.13888-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123143049.13888-5-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 03:30:49PM +0100, Phil Sutter wrote:
> With all simplifications in place, reorder the code to streamline it
> further. Apart from making the second call to ei_lookup() conditional,
> debug output is slightly enhanced.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/segtree.c | 63 +++++++++++++++++++++++----------------------------
>  1 file changed, 28 insertions(+), 35 deletions(-)
> 
> diff --git a/src/segtree.c b/src/segtree.c
> index 3c0989e76093a..edec9f4ebf174 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -192,48 +192,41 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
>  {
>  	struct elementary_interval *lei, *rei;
>  
> -	/*
> -	 * Lookup the intervals containing the left and right endpoints.
> -	 */
>  	lei = ei_lookup(tree, new->left);
> -	rei = ei_lookup(tree, new->right);
> -
> -	if (segtree_debug(tree->debug_mask))
> -		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
> -
> -	if (lei != NULL && rei != NULL && lei == rei) {
> -		if (!merge)
> -			goto err;
> -
> -		ei_destroy(new);
> +	if (lei == NULL) {
> +		/* no overlaps, just add the new interval */
> +		if (segtree_debug(tree->debug_mask))
> +			pr_gmp_debug("insert: [%Zx %Zx]\n",
> +				     new->left, new->right);
> +		__ei_insert(tree, new);
>  		return 0;
> -	} else {
> -		if (lei != NULL) {
> -			if (!merge)
> -				goto err;
> -			/*
> -			 * Left endpoint is within lei, adjust it so we have:
> -			 *
> -			 * [lei_left, new_right]
> -			 */
> -			if (segtree_debug(tree->debug_mask)) {
> -				pr_gmp_debug("adjust left [%Zx %Zx]\n",
> -					     lei->left, lei->right);
> -			}
> +	}
>  
> -			mpz_set(lei->right, new->right);
> -			ei_destroy(new);
> -			return 0;
> -		}
> +	if (!merge) {
> +		errno = EEXIST;
> +		return expr_binary_error(msgs, lei->expr, new->expr,
> +					 "conflicting intervals specified");
>  	}

Not your fault, but I think this check is actually useless given that
the overlap check happens before (unless you consider to consolidate
the insertion and the overlap checks in ei_insert).

> -	__ei_insert(tree, new);
> +	/* caller sorted intervals, so rei is either equal to lei or NULL */
> +	rei = ei_lookup(tree, new->right);
> +	if (rei != lei) {

Isn't this always true? I mean rei != lei always stands true?

> +		/*
> +		 * Left endpoint is within lei, adjust it so we have:
> +		 *
> +		 * [lei_left, new_right]
> +		 */
> +		if (segtree_debug(tree->debug_mask))
> +			pr_gmp_debug("adjust right: [%Zx %Zx]\n",
> +				     lei->left, lei->right);
> +		mpz_set(lei->right, new->right);
> +	} else if (segtree_debug(tree->debug_mask)) {
> +		pr_gmp_debug("skip new: [%Zx %Zx] for old: [%Zx %Zx]\n",
> +			     new->left, new->right, lei->left, lei->right);
> +	}
>  
> +	ei_destroy(new);
>  	return 0;
> -err:
> -	errno = EEXIST;
> -	return expr_binary_error(msgs, lei->expr, new->expr,
> -				 "conflicting intervals specified");
>  }
>  
>  /*
> -- 
> 2.24.1
> 
