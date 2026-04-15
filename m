Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ED6314A82;
	Wed, 15 Apr 2026 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776274774; cv=none; b=cXuOVk+hPoFuJK2uplairrauGIkdR07WzQz9K+PxeMiPeWQtp4UfoRL+zyP8VOnkeZ9kkbT3FdBRgElR7HIqWlh3jk4Y9VaPZJGkj5zDshyj1/T9thV8vdWFPnVscDODK2SJZoT1WKFk+cgBiftp94hM86F/osNyV4JD6tdNWDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776274774; c=relaxed/simple;
	bh=gPGHF3cu/RG4HIb6IsiMrXmvpuVwVLlNLA7KZZAJZV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUWzop2pTq1ZFzBOkfUl6hQKfcyiOXs/W8zljI9mUCHlvQsqkU8pTXixDB9Itcik8e7nu740ZgNsPl4A8Qbbldl+XmPzJO97v3AwTP4XfWGWPYs4Dbw6khpya8admKSxbaZ+QJ0XG5lgI7pVmP2b/xuxQZIwCjkCd5KsSOKxagA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvNpJEJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvNpJEJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004B1C19424;
	Wed, 15 Apr 2026 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776274774;
	bh=gPGHF3cu/RG4HIb6IsiMrXmvpuVwVLlNLA7KZZAJZV8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=KvNpJEJTZzxeF/asC9lOsWr0VJ1wskeSDoV2h1oqRp/5db6vmR7BrvVG0JAtoA6IQ
	 lq+LvzuKaCZeJ99zWBdaLQ1vO4Lb0Gqu4XXx7hXOEv0YkDwjkaxwxtuvHBi3i0gtLk
	 LHxK5KUs2mGDZfm801QCIhJgbpa71orsntHgjztcUNS/m4IAC5O+8IG7Crckij9M7N
	 AzdrLbcI3LKsRwK/dfCV8nvw7Fz78fy2FSySWe/SgA3jfoJtlghab5SAifpiPn33Br
	 lesJNG/6BtmsymgG52TBzAgxJ8vv1oogI3Cpyy3gHPh1sgjaPHFwJa3Ywe6kpzAYuJ
	 YkNdGG0aedeEw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 93032CE0781; Wed, 15 Apr 2026 10:39:33 -0700 (PDT)
Date: Wed, 15 Apr 2026 10:39:33 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de, horms@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
	urezki@gmail.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/3] rculist: add list_splice_rcu() for private
 lists
Message-ID: <9210a276-8158-40f4-b3b5-6431f5f13541@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260415170844.41355-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415170844.41355-1-pablo@netfilter.org>

On Wed, Apr 15, 2026 at 07:08:44PM +0200, Pablo Neira Ayuso wrote:
> This patch adds a helper function, list_splice_rcu(), to safely splice
> a private (non-RCU-protected) list into an RCU-protected list.
> 
> The function ensures that only the pointer visible to RCU readers
> (prev->next) is updated using rcu_assign_pointer(), while the rest of
> the list manipulations are performed with regular assignments, as the
> source list is private and not visible to concurrent RCU readers.
> 
> This is useful for moving elements from a private list into a global
> RCU-protected list, ensuring safe publication for RCU readers.
> Subsystems with some sort of batching mechanism from userspace can
> benefit from this new function.
> 
> The function __list_splice_rcu() has been added for clarity and to
> follow the same pattern as in the existing list_splice*() interfaces,
> where there is a check to ensure that that the list to splice is not
> empty. Note that __list_splice_rcu() has no documentation for this
> reason.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: including comments by Paul McKenney.
> 
>     Except, I have deliberately keep back the suggestion to squash
>     __list_splice_rcu() into list_splice_rcu(), I instead removed
>     the documentation for __list_splice_rcu(). I am looking
>     at other existing list_splice*() function in list.h and rculist.h
>     to get this aligned with __list_splice(), which also has no users
>     in the tree and no documentation. I find it easier to read with
>     __list_splice(), but if this explaination is not sound so...
> 
>     @Paul: I can post v3 squashing __list_splice_rcu(), just let me
>            know.

Removing the comment addresses most of my concerns.  I do have a slight
but not overwhelming preference for the squashed version, but either way:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

Or if you want this to go in via RCU, please let us know.  My guess is
that it would be easier for you to take it in with the code using it.

							Thanx, Paul

>     Thanks!
> 
>  include/linux/rculist.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 2abba7552605..e3bc44225692 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -261,6 +261,35 @@ static inline void list_replace_rcu(struct list_head *old,
>  	old->prev = LIST_POISON2;
>  }
>  
> +static inline void __list_splice_rcu(struct list_head *list,
> +				     struct list_head *prev,
> +				     struct list_head *next)
> +{
> +	struct list_head *first = list->next;
> +	struct list_head *last = list->prev;
> +
> +	last->next = next;
> +	first->prev = prev;
> +	next->prev = last;
> +	rcu_assign_pointer(list_next_rcu(prev), first);
> +}
> +
> +/**
> + * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
> + *                   designed for stacks.
> + * @list:	the non RCU-protected list to splice
> + * @head:	the place in the existing RCU-protected list to splice
> + *
> + * The list pointed to by @head can be RCU-read traversed concurrently with
> + * this function.
> + */
> +static inline void list_splice_rcu(struct list_head *list,
> +				   struct list_head *head)
> +{
> +	if (!list_empty(list))
> +		__list_splice_rcu(list, head, head->next);
> +}
> +
>  /**
>   * __list_splice_init_rcu - join an RCU-protected list into an existing list.
>   * @list:	the RCU-protected list to splice
> -- 
> 2.47.3
> 
> 
