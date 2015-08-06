From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: per network namespace nfacct
Date: Thu, 6 Aug 2015 15:42:10 +0200
Message-ID: <20150806134210.GA3379@salvia>
References: <1438789905-5716-1-git-send-email-aschultz@tpip.net>
 <20150806100713.GA18520@salvia>
 <55C33D46.4080902@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbbHFNgK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 09:36:10 -0400
Content-Disposition: inline
In-Reply-To: <55C33D46.4080902@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 06, 2015 at 12:56:06PM +0200, Andreas Schultz wrote:
> On 08/06/2015 12:07 PM, Pablo Neira Ayuso wrote:
> >On Wed, Aug 05, 2015 at 05:51:45PM +0200, Andreas Schultz wrote:
> 
> [..]
> 
> >>+static void __net_exit nfnl_acct_net_exit(struct net *net)
> >>+{
> >>+	struct nf_acct *cur, *tmp;
> >>+
> >>+	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
> >>+		list_del_rcu(&cur->head);
> >>+
> >>+		if (atomic_dec_and_test(&cur->refcnt))
> >>+			kfree_rcu(cur, rcu_head);
> >>+	}
> >>+}
> >
> >You better use nfnl_acct_put() here, otherwise we leak a module
> >refcount.
> 
> The module refcount is only taken in nfnl_acct_find_get. The initial
> insert into the list in nfnl_acct_new is not taking the module
> refcount.
> 
> Releasing the module refcount here would IMHO release one recount to
> many. Or do I miss something?

With netns in place, we don't know in what order the __net_exit
functions are called, ie. We may still have references to objects from
xt_nfacct.
