From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 7/7] netfilter: connlimit: use rbtree for per-host
 conntrack obj storage
Date: Fri, 07 Mar 2014 06:47:57 -0800
Message-ID: <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
	 <1394199435-14395-8-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47508 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGOr7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:47:59 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so4242053pab.4
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 06:47:58 -0800 (PST)
In-Reply-To: <1394199435-14395-8-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Florian Westphal wrote:

> +	/* no match, need to insert new node */
> +	rbconn = kmem_cache_alloc(connlimit_rb_cachep, GFP_ATOMIC);
> +	if (rbconn == NULL)
> +		goto out;
>  
>  	conn = kmem_cache_alloc(connlimit_conn_cachep, GFP_ATOMIC);
> -	if (conn == NULL)
> -		return false;
> +	if (conn == NULL) {
> +		kmem_cache_free(connlimit_rb_cachep, rbconn);
> +		goto out;
> +	}
> +
>  	conn->tuple = *tuple;
>  	conn->addr = *addr;
> -	hlist_add_head(&conn->node, head);
> -	return true;
> +	rbconn->addr = *addr;
> +
> +	INIT_HLIST_HEAD(&rbconn->hhead);
> +	hlist_add_head(&conn->node, &rbconn->hhead);
> +
> +	rb_link_node(&rbconn->node, parent, rbnode);
> +	rb_insert_color(&rbconn->node, root);
> +	count = 1;
> + out:
> +	tree_nodes_free(root, gc_nodes, gc_count);
> +	return count;
>  }

Very nice work Florian

I would call tree_nodes_free() _before_ attempting the
kmem_cache_alloc(), so that the allocation can reuse a hot object that
you freed right before allocation.



