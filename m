From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_tables: Transaction API proposal
Date: Wed, 27 Mar 2013 17:42:00 +0100
Message-ID: <20130327164200.GA5163@localhost>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
 <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1364293144-4147-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130327163550.GA5136@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3C0QmF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:42:05 -0400
Content-Disposition: inline
In-Reply-To: <20130327163550.GA5136@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One more thing:

On Wed, Mar 27, 2013 at 05:35:50PM +0100, Pablo Neira Ayuso wrote:
[...]
> > @@ -1650,8 +1639,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
> >  	else
> >  		list_add_rcu(&rule->list, &chain->rules);
> >  
> > -	if (flags & NFT_RULE_F_COMMIT) {
> > -		err = nf_tables_dirty_add(rule, &ctx);
> > +	if (transaction != NULL) {
> > +		err = nf_tables_transaction_add(&ctx, transaction, rule);
> >  		if (err < 0) {
> >  			list_del_rcu(&rule->list);
> >  			goto err2;

We can still support incremental updates without transactions (ie.
adding/delete one single rule). However, if a non-transactional rule
update happens while there is an ongoing transaction, we'll have to
reject it with -EBUSY.
