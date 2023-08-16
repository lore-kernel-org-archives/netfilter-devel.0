Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C856EC27C7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 22:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347047AbjHPWyo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347050AbjHPWyR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 18:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E4926AB;
        Wed, 16 Aug 2023 15:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 736D965199;
        Wed, 16 Aug 2023 22:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2923C433C7;
        Wed, 16 Aug 2023 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692226453;
        bh=4Dc1pPQ00w8T+b3juVWVBwfn7XCRj0VA2rEerIOG0Cs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=npRkxJP/p4JQpppL2ScYRvGf3egdej/XkDmag8vlr8UVPhZvZYZK8uYeclJeKCpfE
         aBjkq9lhwF6kGzedEpLEQZPhAl64YIFqCS2wAIxSGPhM6dYC4ss46x/iGj9znLw9Zj
         VKC+omSN9l/olm8I9ZmqkiMmil9Oetwbx3I1WSJthHifpHUENOUKqraViWtyHV476/
         46QJE4bry6xND0xY6nSFV02YeBegLZXesT1T9IdiiVsvst0rxiJ2H6jOo/bcYu1D9e
         ODKnetBn6hKhgsK1Hqu/I7NbeciW/zTR2+UjE3eAR3uHLxZ5z7xGBfn7eK+60BqZme
         EFUl81V2mwiLA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 7236BCE0593; Wed, 16 Aug 2023 15:54:13 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:54:13 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        rcu@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jiejian Wu <jiejian@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>
Subject: Re: [PATCH RFC net-next 01/14] rculist_bl: add
 hlist_bl_for_each_entry_continue_rcu
Message-ID: <9f236f42-8aee-411c-9bd4-d7029c49a0a1@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230815173031.168344-1-ja@ssi.bg>
 <20230815173031.168344-2-ja@ssi.bg>
 <958d687d-9f7f-4baf-af26-2ec351ef8699@paulmck-laptop>
 <a3bba801-5253-5ab1-4dce-43c5b7cb407c@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3bba801-5253-5ab1-4dce-43c5b7cb407c@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 16, 2023 at 07:02:39PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 15 Aug 2023, Paul E. McKenney wrote:
> 
> > On Tue, Aug 15, 2023 at 08:30:18PM +0300, Julian Anastasov wrote:
> > > Add hlist_bl_for_each_entry_continue_rcu and hlist_bl_next_rcu
> > > 
> > > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > > ---
> > >  include/linux/rculist_bl.h | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> > > index 0b952d06eb0b..93a757793d83 100644
> > > --- a/include/linux/rculist_bl.h
> > > +++ b/include/linux/rculist_bl.h
> > > @@ -24,6 +24,10 @@ static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> > >  		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> > >  }
> > >  
> > > +/* return the next element in an RCU protected list */
> > > +#define hlist_bl_next_rcu(node)	\
> > > +	(*((struct hlist_bl_node __rcu **)(&(node)->next)))
> > > +
> > >  /**
> > >   * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
> > >   * @n: the element to delete from the hash list.
> > > @@ -98,4 +102,17 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
> > >  		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> > >  		pos = rcu_dereference_raw(pos->next))
> > >  
> > > +/**
> > > + * hlist_bl_for_each_entry_continue_rcu - iterate over a list continuing after
> > > + *   current point
> > 
> > Please add a comment to the effect that the element continued from
> > must have been either: (1) Iterated to within the same RCU read-side
> > critical section or (2) Nailed down using some lock, reference count,
> > or whatever suffices to keep the continued-from element from being freed
> > in the meantime.
> 
> 	I created 2nd version which has more changes. I'm not sure
> what are the desired steps for this patch, should I keep it as part
> of my patchset if accepted? Or should I post it separately? Here it
> is v2 for comments.

This looks plausible to me, but of course needs more eyes and more
testing.

						Thanx, Paul

> [PATCHv2 RFC] rculist_bl: add hlist_bl_for_each_entry_continue_rcu
> 
> Change the old hlist_bl_first_rcu to hlist_bl_first_rcu_dereference
> to indicate that it is a RCU dereference.
> 
> Add hlist_bl_next_rcu and hlist_bl_first_rcu to use RCU pointers
> and use them to fix sparse warnings.
> 
> Add hlist_bl_for_each_entry_continue_rcu.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  include/linux/rculist_bl.h | 49 +++++++++++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> index 0b952d06eb0b..36363b876e53 100644
> --- a/include/linux/rculist_bl.h
> +++ b/include/linux/rculist_bl.h
> @@ -8,21 +8,31 @@
>  #include <linux/list_bl.h>
>  #include <linux/rcupdate.h>
>  
> +/* return the first ptr or next element in an RCU protected list */
> +#define hlist_bl_first_rcu(head)	\
> +	(*((struct hlist_bl_node __rcu **)(&(head)->first)))
> +#define hlist_bl_next_rcu(node)	\
> +	(*((struct hlist_bl_node __rcu **)(&(node)->next)))
> +
>  static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
>  					struct hlist_bl_node *n)
>  {
>  	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
>  	LIST_BL_BUG_ON(((unsigned long)h->first & LIST_BL_LOCKMASK) !=
>  							LIST_BL_LOCKMASK);
> -	rcu_assign_pointer(h->first,
> +	rcu_assign_pointer(hlist_bl_first_rcu(h),
>  		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
>  }
>  
> -static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> -{
> -	return (struct hlist_bl_node *)
> -		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> -}
> +#define hlist_bl_first_rcu_dereference(head)				\
> +({									\
> +	struct hlist_bl_head *__head = (head);				\
> +									\
> +	(struct hlist_bl_node *)					\
> +	((unsigned long)rcu_dereference_check(hlist_bl_first_rcu(__head), \
> +					      hlist_bl_is_locked(__head)) & \
> +					      ~LIST_BL_LOCKMASK);	\
> +})
>  
>  /**
>   * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
> @@ -73,7 +83,7 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
>  {
>  	struct hlist_bl_node *first;
>  
> -	/* don't need hlist_bl_first_rcu because we're under lock */
> +	/* don't need hlist_bl_first_rcu* because we're under lock */
>  	first = hlist_bl_first(h);
>  
>  	n->next = first;
> @@ -93,9 +103,30 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
>   *
>   */
>  #define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
> -	for (pos = hlist_bl_first_rcu(head);				\
> +	for (pos = hlist_bl_first_rcu_dereference(head);		\
>  		pos &&							\
>  		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> -		pos = rcu_dereference_raw(pos->next))
> +		pos = rcu_dereference_raw(hlist_bl_next_rcu(pos)))
> +
> +/**
> + * hlist_bl_for_each_entry_continue_rcu - continue iteration over list of given
> + *   type
> + * @tpos:	the type * to use as a loop cursor.
> + * @pos:	the &struct hlist_bl_node to use as a loop cursor.
> + * @member:	the name of the hlist_bl_node within the struct.
> + *
> + * Continue to iterate over list of given type, continuing after
> + * the current position which must have been in the list when the RCU read
> + * lock was taken.
> + * This would typically require either that you obtained the node from a
> + * previous walk of the list in the same RCU read-side critical section, or
> + * that you held some sort of non-RCU reference (such as a reference count)
> + * to keep the node alive *and* in the list.
> + */
> +#define hlist_bl_for_each_entry_continue_rcu(tpos, pos, member)		\
> +	for (pos = rcu_dereference_raw(hlist_bl_next_rcu(&(tpos)->member)); \
> +	     pos &&							\
> +	     ({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> +	     pos = rcu_dereference_raw(hlist_bl_next_rcu(pos)))
>  
>  #endif
> -- 
> 2.41.0
> 
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
