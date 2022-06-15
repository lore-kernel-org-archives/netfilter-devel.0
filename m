Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F858C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 19:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348484AbiFOTgR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 15:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347585AbiFOTgQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 15:36:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF77046651
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 12:36:15 -0700 (PDT)
Date:   Wed, 15 Jun 2022 21:36:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] intervals: Do not sort cached set elements over and
 over again
Message-ID: <Yqo0q2gh/NSE1QwC@salvia>
References: <20220615173329.8595-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220615173329.8595-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 15, 2022 at 07:33:29PM +0200, Phil Sutter wrote:
> When adding element(s) to a non-empty set, code merged the two lists and
> sorted the result. With many individual 'add element' commands this
> causes substantial overhead. Make use of the fact that
> existing_set->init is sorted already, sort only the list of new elements
> and use list_splice_sorted() to merge the two sorted lists.
> 
> A test case adding ~25k elements in individual commands completes in
> about 1/4th of the time with this patch applied.

Good.

Do you still like the idea of coalescing set element commands whenever
possible?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220613160536.127441-1-pablo@netfilter.org/

Thanks.

> Fixes: 3da9643fb9ff9 ("intervals: add support to automerge with kernel elements")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expression.h |  1 +
>  src/intervals.c      | 10 ++++++----
>  src/mergesort.c      |  2 +-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index 2c3818e89b791..0f7ffb3a0a623 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -480,6 +480,7 @@ extern struct expr *compound_expr_alloc(const struct location *loc,
>  extern void compound_expr_add(struct expr *compound, struct expr *expr);
>  extern void compound_expr_remove(struct expr *compound, struct expr *expr);
>  extern void list_expr_sort(struct list_head *head);
> +extern void list_splice_sorted(struct list_head *list, struct list_head *head);
>  
>  extern struct expr *concat_expr_alloc(const struct location *loc);
>  
> diff --git a/src/intervals.c b/src/intervals.c
> index bc414d6c87976..a18967ee21061 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -589,19 +589,21 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
>  	struct expr *i, *n, *clone;
>  	int err;
>  
> +	set_to_range(init);
> +	list_expr_sort(&init->expressions);
> +
>  	if (existing_set) {
>  		if (existing_set->init) {
> -			list_splice_init(&existing_set->init->expressions,
> +			set_to_range(existing_set->init);
> +			list_splice_sorted(&existing_set->init->expressions,
>  					 &init->expressions);
> +			init_list_head(&existing_set->init->expressions);
>  		} else {
>  			existing_set->init = set_expr_alloc(&internal_location,
>  							    set);
>  		}
>  	}
>  
> -	set_to_range(init);
> -	list_expr_sort(&init->expressions);
> -
>  	err = setelem_overlap(msgs, set, init);
>  
>  	list_for_each_entry_safe(i, n, &init->expressions, list) {
> diff --git a/src/mergesort.c b/src/mergesort.c
> index 8e6aac5fb24ed..dca71422dd947 100644
> --- a/src/mergesort.c
> +++ b/src/mergesort.c
> @@ -70,7 +70,7 @@ static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
>  	return ret;
>  }
>  
> -static void list_splice_sorted(struct list_head *list, struct list_head *head)
> +void list_splice_sorted(struct list_head *list, struct list_head *head)
>  {
>  	struct list_head *h = head->next;
>  	struct list_head *l = list->next;
> -- 
> 2.34.1
> 
