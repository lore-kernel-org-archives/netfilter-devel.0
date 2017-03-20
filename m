From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf 1/1] netfilter: helper: Fix possible panic caused
 by invoking expectfn unloaded
Date: Mon, 20 Mar 2017 13:50:40 +0100
Message-ID: <20170320125040.GA12416@salvia>
References: <1489822845-109818-1-git-send-email-fgao@ikuai8.com>
 <20170320104442.GA10855@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753581AbdCTMu5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 08:50:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A8A16B191
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 13:50:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 378D8DA729
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 13:50:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1ECE7DA871
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 13:50:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170320104442.GA10855@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 11:44:42AM +0100, Pablo Neira Ayuso wrote:
> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> > index 6dc44d9..6c840af 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
> >  	return NULL;
> >  }
> >  
> > +static void
> > +nf_ct_remove_expect_refer_dying_module(const struct module *me)
> > +{
> > +	struct nf_conntrack_expect *exp;
> > +	const struct hlist_node *next;
> > +	u32 i;
> > +
> > +	if (!me)
> > +		return;
> > +
> > +	/* Make sure no one is still using the moudule unless
> > +	 * its a connection in the hash.
> > +	 */
> > +	synchronize_rcu();
> > +
> > +	/* Get rid of expectations */
> > +	spin_lock_bh(&nf_conntrack_expect_lock);
> > +	for (i = 0; i < nf_ct_expect_hsize; i++) {
> > +		hlist_for_each_entry_safe(exp, next,
> > +					  &nf_ct_expect_hash[i], hnode) {
> > +			struct nf_conn_help *master_help = nfct_help(exp->master);
> > +
> > +			if ((master_help->helper && master_help->helper->me == me) ||
> > +			    (exp->helper && exp->helper->me == me) ||
> > +			    exp->expectfn_module == me) {

Are you also sure this is correct?

me can be nf_nat_sip, while exp->helper->me points to
nf_conntrack_sip.
