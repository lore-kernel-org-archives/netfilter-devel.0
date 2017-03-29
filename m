From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: helper: Remove useless rcu
 lock when get expectfn
Date: Wed, 29 Mar 2017 13:49:56 +0200
Message-ID: <20170329114956.GA6697@salvia>
References: <1490148902-96508-1-git-send-email-gfree.wind@foxmail.com>
 <20170329100730.GA4131@salvia>
 <000301d2a877$4e174c50$ea45e4f0$@foxmail.com>
 <20170329104412.GA6337@salvia>
 <000601d2a87a$52bed400$f83c7c00$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755975AbdC2LuF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 07:50:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99B44E976C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:50:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89AB2DA865
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:50:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97703DA86D
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:49:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <000601d2a87a$52bed400$f83c7c00$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 06:50:46PM +0800, Gao Feng wrote:
> Hi Pablo,
> 
> > -----Original Message-----
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > Sent: Wednesday, March 29, 2017 6:44 PM
> > To: Gao Feng <gfree.wind@foxmail.com>
> > Cc: netfilter-devel@vger.kernel.org; 'Gao Feng' <fgao@ikuai8.com>
> > Subject: Re: [PATCH nf-next v2 1/1] netfilter: helper: Remove useless rcu
> lock
> > when get expectfn
> > 
> > On Wed, Mar 29, 2017 at 06:29:10PM +0800, Gao Feng wrote:
> > > Hi Pablo,
> > >
> > > > -----Original Message-----
> > > > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > > > Sent: Wednesday, March 29, 2017 6:08 PM
> > > > To: gfree.wind@foxmail.com
> > > > Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> > > > Subject: Re: [PATCH nf-next v2 1/1] netfilter: helper: Remove
> > > > useless rcu
> > > lock
> > > > when get expectfn
> > > >
> > > > On Wed, Mar 22, 2017 at 10:15:02AM +0800, gfree.wind@foxmail.com
> > wrote:
> > > > > From: Gao Feng <fgao@ikuai8.com>
> > > > >
> > > > > Because these two functions return the nf_ct_helper_expectfn
> > > > > pointer which should be protected by rcu lock. So it should makes
> > > > > sure the caller should hold the rcu lock, not inside these
> functions.
> > > > >
> > > > > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > > > > ---
> > > > >  v2: Shorter subject, per Pablo
> > > > >  v1: Initial version
> > > > >
> > > > >  net/netfilter/nf_conntrack_helper.c | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/net/netfilter/nf_conntrack_helper.c
> > > > > b/net/netfilter/nf_conntrack_helper.c
> > > > > index 6dc44d9..bce3d1f 100644
> > > > > --- a/net/netfilter/nf_conntrack_helper.c
> > > > > +++ b/net/netfilter/nf_conntrack_helper.c
> > > > > @@ -311,38 +311,36 @@ void nf_ct_helper_expectfn_unregister(struct
> > > > > nf_ct_helper_expectfn *n)  }
> > > > > EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
> > > > >
> > > > > +/* Caller should hold the rcu lock */
> > > > >  struct nf_ct_helper_expectfn *
> > > > >  nf_ct_helper_expectfn_find_by_name(const char *name)  {
> > > > >  	struct nf_ct_helper_expectfn *cur;
> > > > >  	bool found = false;
> > > > >
> > > > > -	rcu_read_lock();
> > > > >  	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list,
> head) {
> > > > >  		if (!strcmp(cur->name, name)) {
> > > > >  			found = true;
> > > > >  			break;
> > > > >  		}
> > > > >  	}
> > > > > -	rcu_read_unlock();
> > > > >  	return found ? cur : NULL;
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);
> > > >
> > > > nf_ct_helper_expectfn_find_by_name() is called from ctnetlink, via
> > > > ctnetlink_create_expect() and rcu read side lock is not held there.
> > > There are two reasons.
> > > 1. The rcu lock would be added in my patch " netfilter: helper: Add
> > > the rcu lock when call __nf_conntrack_helper_find" for nf
> > > https://patchwork.ozlabs.org/patch/741865/.
> > 
> > If you have interdependencies between two patches like this, it's better
> to
> > make it in one single go.
> > 
> > > So the ctnetlink_create_expect would hold the rcu lock after apply
> > > that patch.
> > >
> > > 2. Because these two functions return one pointer which needs RCU
> > > lock, so the caller must hold rcu lock.
> > > Or it still meets one error even though there is one rcu lock in these
> > > two functions.
> > > Because the memory which the returned pointer point to would be freed
> > > already after rcu_read_unlock.
> > > So the rcu lock is unnecessary in these functions.
> > 
> > That's right. You're fixing up a real problem, no doubt.
> > 
> > I'm just questioning that I think that if you are fixing up rcu locking,
> which
> > seems to be the case, you just do it in one single patch.
> > 
> > Thanks!
> 
> Ok, I would merge them into one patch.
> Actually I couldn't get that what modifications could be done in the nf.
> I learnt only bug fix could be accepted in net.git, so I assumed the nf.git
> did too.

Yes, fixes go to nf.git and updates go to nf-next.git.

But in this case this has to go through nf.git since both patches
(that should be one) are part of the same logical changes since they
are required to fix up the RCU read side locking there consistently.
