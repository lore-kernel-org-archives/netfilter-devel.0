From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
 XT_SOCKET_MATCHSOCKMARK flag and mark fields
Date: Mon, 15 Jun 2015 22:57:52 +0200
Message-ID: <20150615205752.GA3184@salvia>
References: <1434148795-19937-1-git-send-email-harouth@codeaurora.org>
 <20150615162246.GA14375@salvia>
 <005801d0a7a2$f0304460$d090cd20$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	'Lorenzo Colitti' <lorenzo@google.com>
To: Harout Hedeshian <harouth@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbbFOUwf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 16:52:35 -0400
Content-Disposition: inline
In-Reply-To: <005801d0a7a2$f0304460$d090cd20$@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:39:03PM -0600, Harout Hedeshian wrote:
> 
> 
> > -----Original Message-----
> > From: Harout Hedeshian [mailto:harouth@codeaurora.org]
> > Sent: Monday, June 15, 2015 11:42 AM
> > To: 'Pablo Neira Ayuso'
> > Cc: 'netfilter-devel@vger.kernel.org'; 'Lorenzo Colitti'
> > Subject: RE: [PATCH nf-next] netfilter: xt_socket: add
> > XT_SOCKET_MATCHSOCKMARK flag and mark fields
> > 
> > 
> > 
> > > -----Original Message-----
> > > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > > Sent: Monday, June 15, 2015 10:23 AM
> > > To: Harout Hedeshian
> > > Cc: netfilter-devel@vger.kernel.org; Lorenzo Colitti
> > > Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
> > > XT_SOCKET_MATCHSOCKMARK flag and mark fields
> > >
> > > On Fri, Jun 12, 2015 at 04:39:55PM -0600, Harout Hedeshian wrote:
> > > > xt_socket is useful for matching sockets with IP_TRANSPARENT and
> > > > taking some action on the matching packets. However, it lacks the
> > > > ability to match only a small subset of transparent sockets.
> > > >
> > > > Suppose there are 2 applications, each with its own set of
> > > > transparent sockets. The first application wants all matching
> > > > packets dropped, while the second application wants them forwarded
> > somewhere else.
> > > >
> > > > Add the ability to match sockets based on the socket mark.
> > > >
> > > > Now the 2 hypothetical applications can differentiate their sockets
> > > > based on a mark value set with SO_MARK.
> > > >
> > > > iptables -t mangle -I PREROUTING -m socket --transparent --mark 10
> > > > -J
> > > > act1 iptables -t mangle -I PREROUTING -m socket --transparent --mark
> > > > 11 -J act2
> > >
> > > Wouldn't it be better to restore the sk_mark to skb->mark? I mean:
> > >
> > >         iptables -t mangle -I PREROUTING \
> > >                 -m socket --transparent --restore-skmark -j myskchain
> > >	
> > > Thus, you can use -m mark from the 'myskchain' without having to fetch
> > > and inspect the sk over and over again as it happens with this
> > > extension.
> > 
> > Yes, I think that can work. Let me try that out and I'll submit a new
> > patch.
> 
> Actually, on second thought, I'm not so sure. This socket lookup is
> happening as part of a match operation in xt_socket.c.
> From x_tables.h, I can see that match functions are not supposed to modify
> the skb:
> 
> struct xt_match{
> ...
> bool (*match)(const struct sk_buff *skb, struct xt_action_param *);
>
> In that case, would this even be valid?
> -m socket --transparent --restore-skmark
> 
> Keeping in mind --restore-skmark is happening as part of -m socket
> 
> I would think we would need a whole new target to handle something like
> this:
> iptables -t mangle -I PREROUTING -m socket --transparent --no-wildcard -j
> SOCKET --restore-skmark
> 
> Since the target invocation would be separate, we would need a second socket
> lookup? Seems perhaps a little overkill...

Yes, it's simply overkill to add a new target to add this.

So just cast it:

        struct sk_buff *pskb = (struct sk_buff *)skb;

iptables matches were originally design not to modify anything, but it
can lead us to situations like this. That's one of the reasons why we
have no distinction between matches and targets in nftables anymore.

Thanks.
