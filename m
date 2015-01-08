From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: rename pr_debug() to pr_gmp_debug() and use
 printf() whenever possible
Date: Thu, 8 Jan 2015 12:44:41 +0000
Message-ID: <20150108124441.GN13765@acer.localdomain>
References: <1420720738-4953-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61000 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbAHMop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:44:45 -0500
Content-Disposition: inline
In-Reply-To: <1420720738-4953-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.01, Pablo Neira Ayuso wrote:
> index 753d8b8..a72e6b8 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -220,7 +220,7 @@ static void ei_insert(struct seg_tree *tree, struct elementary_interval *new)
>  			 * [lei_left, new_left)[new_left, new_right]
>  			 */
>  			if (segtree_debug()) {
> -				pr_debug("adjust left [%Zx %Zx]\n",
> +				pr_gmp_debug("adjust left [%Zx %Zx]\n",
>  					 lei->left, lei->right);

Also please keep the parameter alignment to the opening bracket.
