From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: nf_conntrack: improve nf_conn object
 traceability
Date: Mon, 3 Dec 2012 13:50:36 +0100
Message-ID: <20121203125036.GA30523@1984>
References: <1354197082-8431-1-git-send-email-pablo@netfilter.org>
 <1354197082-8431-2-git-send-email-pablo@netfilter.org>
 <20121203110610.GA11627@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2LCMun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:50:43 -0500
Content-Disposition: inline
In-Reply-To: <20121203110610.GA11627@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 03, 2012 at 12:06:10PM +0100, Florian Westphal wrote:
> pablo@netfilter.org <pablo@netfilter.org> wrote:
> 
> Hi Pablo,
> 
> I have one question related to ct object destruction: 
> 
> > @@ -247,6 +245,9 @@ void nf_ct_delete_from_lists(struct nf_conn *ct)
> >  	 * Otherwise we can get spurious warnings. */
> >  	NF_CT_STAT_INC(net, delete_list);
> >  	clean_from_lists(ct);
> > +	/* add this conntrack to the dying list */
> > +	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
> > +			     &net->ct.dying);
> >  	spin_unlock_bh(&nf_conntrack_lock);
> 
> i.o.w., conntrack objects that were in hash table are now always moved
> to the dying list.  Shouldn't nf_ct_release_dying_list() be adjusted,
> too?  It still seems to assume that the dying list only contains
> alive conntack objects whose events have not been delivered yet.

I see, you mean that nf_ct_release_dying_list should delete objects
from the dying list. Yes, I'll fix that. Thanks for the spot.
