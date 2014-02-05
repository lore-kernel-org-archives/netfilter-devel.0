From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Wed, 5 Feb 2014 17:38:06 +0100
Message-ID: <20140205163806.GA4575@localhost>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140205154843.GA31493@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52938 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaBEQiM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:38:12 -0500
Content-Disposition: inline
In-Reply-To: <20140205154843.GA31493@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 03:48:46PM +0000, Patrick McHardy wrote:
> On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> > As a side effect, we save memory as we don't need rcu_head per rule
> > anymore.
> 
> We can also save some memory for now unnecessary families in the private
> structs since we have the context available during destruction again.

Right, that was only needed with when we were using call_rcu. I'll
revisit that.

> > @@ -1809,9 +1803,6 @@ static int nf_tables_commit(struct sk_buff *skb)
> >  	synchronize_rcu();
> >  
> >  	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
> > -		/* Delete this rule from the dirty list */
> > -		list_del(&rupd->list);
> > -
> >  		/* This rule was inactive in the past and just became active.
> >  		 * Clear the next bit of the genmask since its meaning has
> >  		 * changed, now it is the future.
> > @@ -1822,6 +1813,7 @@ static int nf_tables_commit(struct sk_buff *skb)
> >  					      rupd->chain, rupd->rule,
> >  					      NFT_MSG_NEWRULE, 0,
> >  					      rupd->family);
> > +			list_del(&rupd->list);
> >  			kfree(rupd);
> >  			continue;
> >  		}
> > @@ -1831,7 +1823,15 @@ static int nf_tables_commit(struct sk_buff *skb)
> >  		nf_tables_rule_notify(skb, rupd->nlh, rupd->table, rupd->chain,
> >  				      rupd->rule, NFT_MSG_DELRULE, 0,
> >  				      rupd->family);
> > +	}
> > +
> > +	/* Make sure we don't see any packet traversing old rules */
> > +	synchronize_rcu();
> > +
> > +	/* Now we can safely release unused old rules */
> > +	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
> >  		nf_tables_rule_destroy(rupd->rule);
> > +		list_del(&rupd->list);
> >  		kfree(rupd);
> >  	}
> >  
> > @@ -1844,20 +1844,26 @@ static int nf_tables_abort(struct sk_buff *skb)
> >  	struct nft_rule_trans *rupd, *tmp;
> >  
> >  	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
> > -		/* Delete all rules from the dirty list */
> > -		list_del(&rupd->list);
> > -
> >  		if (!nft_rule_is_active_next(net, rupd->rule)) {
> >  			nft_rule_clear(net, rupd->rule);
> > +			list_del(&rupd->list);
> >  			kfree(rupd);
> >  			continue;
> >  		}
> >  
> >  		/* This rule is inactive, get rid of it */
> >  		list_del_rcu(&rupd->rule->list);
> > +	}
> > +
> > +	/* Make sure we don't see any packet accessing aborted rules */
> > +	synchronize_rcu();
> > +
> > +	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
> >  		nf_tables_rule_destroy(rupd->rule);
> > +		list_del(&rupd->list);
> >  		kfree(rupd);
> >  	}
> 
> I have to admit this all seems slightly confusing to me, we now have three
> synhronize_rcu()s in this function, are all those really needed?

There are only two to separate the different stages. To my
understanding, the first one ensures that all packets has left the
previous generation before we start purging out old rules. Then, the
second one makes sure that no packets are still checking the old rule
genmask that have just been deleted, so we can safely release it.

Before this patch, we only needed one since we were using call_rcu
after deleting the rules from the list.
