From: =?gb2312?B?uN+35Q==?= <fgao@ikuai8.com>
Subject: RE: [PATCH net-next 1/1] netfilter: helper: Remove the rcu lock in nf_ct_helper_expectfn_find_by_name and nf_ct_helper_expectfn_find_by_symbol.
Date: Tue, 21 Mar 2017 22:36:55 +0800
Message-ID: <005801d2a250$96e35550$c4a9fff0$@ikuai8.com>
References: <1489480145-54411-1-git-send-email-fgao@ikuai8.com> <20170321143010.GA17014@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <gfree.wind@gmail.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg321.qq.com ([14.17.32.30]:55916 "EHLO smtpbg321.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932882AbdCUOqb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:46:31 -0400
In-Reply-To: <20170321143010.GA17014@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Tuesday, March 21, 2017 10:30 PM
> To: fgao@ikuai8.com
> Cc: netfilter-devel@vger.kernel.org; gfree.wind@gmail.com
> Subject: Re: [PATCH net-next 1/1] netfilter: helper: Remove the rcu lock
in
> nf_ct_helper_expectfn_find_by_name and
> nf_ct_helper_expectfn_find_by_symbol.
> 
> On Tue, Mar 14, 2017 at 04:29:05PM +0800, fgao@ikuai8.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > Because these two functions return the nf_ct_helper_expectfn pointer
> > which should be protected by rcu lock. So it should makes sure the
> > caller should hold the rcu lock, not inside these functions.
> >
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  net/netfilter/nf_conntrack_helper.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_helper.c
> > b/net/netfilter/nf_conntrack_helper.c
> > index 6dc44d9..bce3d1f 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -311,38 +311,36 @@ void nf_ct_helper_expectfn_unregister(struct
> > nf_ct_helper_expectfn *n)  }
> > EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
> >
> > +/* Caller should hold the rcu lock */
> >  struct nf_ct_helper_expectfn *
> >  nf_ct_helper_expectfn_find_by_name(const char *name)  {
> >  	struct nf_ct_helper_expectfn *cur;
> >  	bool found = false;
> >
> > -	rcu_read_lock();
> >  	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
> >  		if (!strcmp(cur->name, name)) {
> >  			found = true;
> >  			break;
> >  		}
> >  	}
> > -	rcu_read_unlock();
> >  	return found ? cur : NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);
> 
> You have to collapse this patch to:
> 
> http://patchwork.ozlabs.org/patch/740576/
> 
> Please... use shorter patch subject names, around 80 chars long. There is
no
> strict limit that I know, but this subject looks too long.

Ok. I would make it shorter, and send another update.

> 
> I think rcu read side is missing in every invocations to:
> 
> __nf_conntrack_helper_find()
> 
> in ctnetlink. So this patch would be larger, have a closer look and fix
this in one
> go, please.

No problem, I would check all callers. 

Best Regards
Feng


