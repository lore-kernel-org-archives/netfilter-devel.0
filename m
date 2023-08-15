Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAFBC001B0
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 18:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbjHOSkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbjHOSjr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 14:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9310E1BEE;
        Tue, 15 Aug 2023 11:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4BB465EFE;
        Tue, 15 Aug 2023 18:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54923C433C7;
        Tue, 15 Aug 2023 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692124784;
        bh=Pgizj0LFdMrJQmmpDQUSLN1qFP0xOur9LnBf40ch4vM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=h5A0+8gj8pfZVw52EdSoZq3KmyXa1EZptPQKeimmZyvCGh/jCp5aaiSU6II6Ju4sg
         c1/+BHDfpXOWA710NI8DBUcXp7cqPKYjxMx+09WKZdc5uYVaVFtY5kte1D5znCunw0
         WfVQ6g591PlfhjPnE+q2wOQ2LUUw50p96HK2Q5j5pU193PEN/yOIZhJ3CRY6kMldKr
         MD0uh1EtXO71LHfKjNGHajVN66K0ltMsFb/D6a9aF1RGKHzfkKeoO5qRLrqS7Y+Iit
         4/Ln4Ov1lQ+2X8COKJrQp575/+3r/YkCI5c7fQa8Lhxhi+XYtZZBQa4QZseX794M0/
         OhY2T9mnbVYng==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E9B5BCE09C4; Tue, 15 Aug 2023 11:39:43 -0700 (PDT)
Date:   Tue, 15 Aug 2023 11:39:43 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        rcu@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jiejian Wu <jiejian@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>
Subject: Re: [PATCH RFC net-next 01/14] rculist_bl: add
 hlist_bl_for_each_entry_continue_rcu
Message-ID: <958d687d-9f7f-4baf-af26-2ec351ef8699@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230815173031.168344-1-ja@ssi.bg>
 <20230815173031.168344-2-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815173031.168344-2-ja@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 15, 2023 at 08:30:18PM +0300, Julian Anastasov wrote:
> Add hlist_bl_for_each_entry_continue_rcu and hlist_bl_next_rcu
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  include/linux/rculist_bl.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> index 0b952d06eb0b..93a757793d83 100644
> --- a/include/linux/rculist_bl.h
> +++ b/include/linux/rculist_bl.h
> @@ -24,6 +24,10 @@ static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
>  		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
>  }
>  
> +/* return the next element in an RCU protected list */
> +#define hlist_bl_next_rcu(node)	\
> +	(*((struct hlist_bl_node __rcu **)(&(node)->next)))
> +
>  /**
>   * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
>   * @n: the element to delete from the hash list.
> @@ -98,4 +102,17 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
>  		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
>  		pos = rcu_dereference_raw(pos->next))
>  
> +/**
> + * hlist_bl_for_each_entry_continue_rcu - iterate over a list continuing after
> + *   current point

Please add a comment to the effect that the element continued from
must have been either: (1) Iterated to within the same RCU read-side
critical section or (2) Nailed down using some lock, reference count,
or whatever suffices to keep the continued-from element from being freed
in the meantime.

							Thanx, Paul

> + * @tpos:	the type * to use as a loop cursor.
> + * @pos:	the &struct hlist_bl_node to use as a loop cursor.
> + * @member:	the name of the hlist_bl_node within the struct.
> + */
> +#define hlist_bl_for_each_entry_continue_rcu(tpos, pos, member)		\
> +	for (pos = rcu_dereference_raw(hlist_bl_next_rcu(&(tpos)->member)); \
> +	     pos &&							\
> +	     ({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> +	     pos = rcu_dereference_raw(hlist_bl_next_rcu(pos)))
> +
>  #endif
> -- 
> 2.41.0
> 
> 
