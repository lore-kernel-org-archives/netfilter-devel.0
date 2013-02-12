From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ctnetlink: don't permit ct creation with
 random tuple
Date: Tue, 12 Feb 2013 14:10:17 +0100
Message-ID: <20130212131017.GA32460@localhost>
References: <1360660958-29494-1-git-send-email-fw@strlen.de>
 <20130212122430.GA30291@localhost>
 <20130212124328.GA30105@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:49507 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933048Ab3BLNKW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:10:22 -0500
Content-Disposition: inline
In-Reply-To: <20130212124328.GA30105@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 12, 2013 at 01:43:28PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Feb 12, 2013 at 10:22:38AM +0100, Florian Westphal wrote:
> > > Userspace can cause kernel panic by not specifying orig/reply
> > > tuple: kernel will create a tuple with random stack values.
> > > 
> > > Problem is that tuple.dst.dir will be random, too, which
> > > causes nf_ct_tuplehash_to_ctrack() to return garbage.
> 
> [..]
> 
> > > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > > index 7bbfb3d..e592281 100644
> > > --- a/net/netfilter/nf_conntrack_netlink.c
> > > +++ b/net/netfilter/nf_conntrack_netlink.c
> > > @@ -1596,6 +1596,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
> > >  		if (nlh->nlmsg_flags & NLM_F_CREATE) {
> > >  			enum ip_conntrack_events events;
> > >  
> > > +			if (!cda[CTA_TUPLE_ORIG] ||
> > > +			    !cda[CTA_TUPLE_REPLY])
> > > +				return -EINVAL;
> > 
> > I think that needs to be && instead of ||.
> 
> Uh, maybe I'm too low on caffeine, but when a new conntrack
> is to be created, shouldn't userspace have to specify
> _both_ ORIG and REPLY?

You're right, it's me who is low on caffeine. Sorry.
