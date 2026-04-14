Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886B35C19D
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 23:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776209758; cv=none; b=kUhHHS0q0BEzsu/EgdId1dst4fjZL03Gy+YNeQpWxZLHS45pxqZj/V2qJczbmOmPYpyluxqdIYBfyx75BFr82NJ+6uAjxGzE3sw+V+bHw6b+MhnIV9yVsEzU01QEjkbrtPLNlx0ZMViY8++SJrLKGeHgxPyHXbMlXXAPrhX9cHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776209758; c=relaxed/simple;
	bh=tqlWiYAD68Gl+Hslj6H/L4RPn/LGorgQ3tkA/f3ctA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RC/USrSD6bm8WWLuIe/imtDzR+BLnVXA3FNQ3x7P81309JTje2QUoEwbwR4wj9Gdcu6omXsxzQCzA27MLajxM2V02vvPdRmbp2MwSSDBtiJvgeU3UmVbqF/MgY4W5MKHlSSOQ+x8WKH2uteNrHbnjl4btWAoZ/YmETbJd4ttoM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V23DGvM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V23DGvM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549E9C19425;
	Tue, 14 Apr 2026 23:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776209758;
	bh=tqlWiYAD68Gl+Hslj6H/L4RPn/LGorgQ3tkA/f3ctA8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=V23DGvM5zibBtPDYebFR6SeUNOFrZ7yNKmZFGv1BwKFOBnjJRAX1KyYChBZbX0MXN
	 hYV6jEnbbBxb0N04EEvtGxAJHSxOxbXI4fWR1e43HscMWoh1RXUW5tmXHjChjYqywY
	 Sm7def8fvdwsJbPP1vsZrs7MsjD6+15KngSbSkUNpbDI1AB0CC/Hi4cEeYxa7CJZ8X
	 B7DfUBEDo/kCgTYfdV1LCBX3/zjhiA8NBbvsKoAgb3lQNNf9aKMLUx4NKN5n32fQ2s
	 2nzyDzQmmMe+oSqgLnlOowANhLAxVj1jHzoavvbbtuC2VsAjyIQ3fUb8xfWL8nIHJl
	 TZ8mp2nZVSmlQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id CFC30CE13BF; Tue, 14 Apr 2026 16:35:57 -0700 (PDT)
Date: Tue, 14 Apr 2026 16:35:57 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, boqun@kernel.org, urezki@gmail.com,
	rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, fw@strlen.de
Subject: Re: [PATCH nf 1/3] rculist: add list_splice_rcu() for private lists
Message-ID: <25a270bf-0011-4784-9a32-5a62b64a6200@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260413220415.43221-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413220415.43221-1-pablo@netfilter.org>

On Tue, Apr 14, 2026 at 12:04:15AM +0200, Pablo Neira Ayuso wrote:
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
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks plausible and useful.  Please see some comments inline below.

> ---
> @I need this to fix a unsafe list_splice() of a private list to an
> existing RCU-protected list. This is based on an existing idiom in
> __list_splice_init_rcu().
> 
>  include/linux/rculist.h | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 2abba7552605..3c18c3336459 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -261,6 +261,41 @@ static inline void list_replace_rcu(struct list_head *old,
>  	old->prev = LIST_POISON2;
>  }
>  
> +/**
> + * __list_splice_rcu - join a non-RCU list into an existing list.
> + * @list:	the RCU-protected list to splice

This is actually not RCU-protected, correct?  Sure, its elements
(aside from the list header) are RCU-protected upon exit from this
function, but by then they are in the {@prev,@next} list, not in
this @list.

> + * @prev:	points to the last element of the existing list
> + * @next:	points to the first element of the existing list
> + *
> + * The list pointed to by @prev and @next can be RCU-read traversed
> + * concurrently with this function.

Doesn't this last sentence also need to go into the list_splice_rcu()
function's kernel-doc header?  But please see below.

> + */
> +static inline void __list_splice_rcu(struct list_head *list,
> +				     struct list_head *prev,
> +				     struct list_head *next)
> +{
> +	struct list_head *first = list->next;
> +	struct list_head *last = list->prev;
> +
> +	last->next = next;
> +	rcu_assign_pointer(list_next_rcu(prev), first);
> +	first->prev = prev;
> +	next->prev = last;

Although putting these last two after the rcu_assign_pointer() is safe,
given that RCU readers do not traverse ->prev pointers, it would be
better to place them before the rcu_assign_pointer() in order to avoid
false sharing between this code path and any concurrent RCU readers.

> +}
> +
> +/**
> + * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
> + *                   designed for stacks.
> + * @list:	the non RCU-protected list to splice
> + * @head:	the place in the existing list to splice the first list into

Please add something about @head being RCU-protected.

> + */
> +static inline void list_splice_rcu(struct list_head *list,
> +				   struct list_head *head)
> +{
> +	if (!list_empty(list))
> +		__list_splice_rcu(list, head, head->next);
> +}

I don't understand the purpose of having __list_splice_rcu() split out
from list_splice_rcu().  If you are planning to add more callers of
__list_splice_rcu(), you can always do the split when you add the first
such caller.  In the meantime, why the extra code?

Yes, we do have __list_splice_init_rcu(), but that is because it is
called from both list_splice_init_rcu() and list_splice_tail_init_rcu().

> +
>  /**
>   * __list_splice_init_rcu - join an RCU-protected list into an existing list.
>   * @list:	the RCU-protected list to splice
> -- 
> 2.47.3
> 
