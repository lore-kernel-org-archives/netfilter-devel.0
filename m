From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: ctnetlink: don't permit ct creation
 with random tuple
Date: Tue, 12 Feb 2013 13:43:28 +0100
Message-ID: <20130212124328.GA30105@breakpoint.cc>
References: <1360660958-29494-1-git-send-email-fw@strlen.de>
 <20130212122430.GA30291@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39476 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932927Ab3BLMn3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:43:29 -0500
Content-Disposition: inline
In-Reply-To: <20130212122430.GA30291@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 12, 2013 at 10:22:38AM +0100, Florian Westphal wrote:
> > Userspace can cause kernel panic by not specifying orig/reply
> > tuple: kernel will create a tuple with random stack values.
> > 
> > Problem is that tuple.dst.dir will be random, too, which
> > causes nf_ct_tuplehash_to_ctrack() to return garbage.

[..]

> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 7bbfb3d..e592281 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -1596,6 +1596,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
> >  		if (nlh->nlmsg_flags & NLM_F_CREATE) {
> >  			enum ip_conntrack_events events;
> >  
> > +			if (!cda[CTA_TUPLE_ORIG] ||
> > +			    !cda[CTA_TUPLE_REPLY])
> > +				return -EINVAL;
> 
> I think that needs to be && instead of ||.

Uh, maybe I'm too low on caffeine, but when a new conntrack
is to be created, shouldn't userspace have to specify
_both_ ORIG and REPLY?
