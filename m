From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 7/7] netfilter: connlimit: use rbtree for per-host
 conntrack obj storage
Date: Fri, 7 Mar 2014 17:15:12 +0100
Message-ID: <20140307161512.GF17526@breakpoint.cc>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
 <1394199435-14395-8-git-send-email-fw@strlen.de>
 <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45767 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742AbaCGQPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:15:14 -0500
Content-Disposition: inline
In-Reply-To: <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2014-03-07 at 14:37 +0100, Florian Westphal wrote:
> 
> > +	/* no match, need to insert new node */
> > +	rbconn = kmem_cache_alloc(connlimit_rb_cachep, GFP_ATOMIC);
> > +	if (rbconn == NULL)
> > +		goto out;
> >  
> >  	conn = kmem_cache_alloc(connlimit_conn_cachep, GFP_ATOMIC);
> > -	if (conn == NULL)
> > -		return false;
> > +	if (conn == NULL) {
> > +		kmem_cache_free(connlimit_rb_cachep, rbconn);
> > +		goto out;
> > +	}
> > +
> >  	conn->tuple = *tuple;
> >  	conn->addr = *addr;
> > -	hlist_add_head(&conn->node, head);
> > -	return true;
> > +	rbconn->addr = *addr;
> > +
> > +	INIT_HLIST_HEAD(&rbconn->hhead);
> > +	hlist_add_head(&conn->node, &rbconn->hhead);
> > +
> > +	rb_link_node(&rbconn->node, parent, rbnode);
> > +	rb_insert_color(&rbconn->node, root);
> > +	count = 1;
> > + out:
> > +	tree_nodes_free(root, gc_nodes, gc_count);
> > +	return count;
> >  }
> 
> Very nice work Florian

Thanks Eric.

> I would call tree_nodes_free() _before_ attempting the
> kmem_cache_alloc(), so that the allocation can reuse a hot object that
> you freed right before allocation.

Hmm, that would be nice.  I need to think about it again,
problem is that moving it at this time could result in
freeing the would-be parent of the new node.
