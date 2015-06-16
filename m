From: "Harout Hedeshian" <harouth@codeaurora.org>
Subject: RE: [PATCH nf-next] netfilter: xt_socket: add XT_SOCKET_MATCHSOCKMARK flag and mark fields
Date: Mon, 15 Jun 2015 18:45:29 -0600
Message-ID: <007001d0a7cd$bef33ad0$3cd9b070$@codeaurora.org>
References: <1434148795-19937-1-git-send-email-harouth@codeaurora.org> <20150615162246.GA14375@salvia> <005801d0a7a2$f0304460$d090cd20$@codeaurora.org> <20150615205752.GA3184@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>,
	"'Lorenzo Colitti'" <lorenzo@google.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45460 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbbFPApc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 20:45:32 -0400
In-Reply-To: <20150615205752.GA3184@salvia>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Monday, June 15, 2015 2:58 PM
> To: Harout Hedeshian
> Cc: netfilter-devel@vger.kernel.org; 'Lorenzo Colitti'
> Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
> XT_SOCKET_MATCHSOCKMARK flag and mark fields
> 
> >
> > Actually, on second thought, I'm not so sure. This socket lookup is
> > happening as part of a match operation in xt_socket.c.
> > From x_tables.h, I can see that match functions are not supposed to
> > modify the skb:
> >
> > struct xt_match{
> > ...
> > bool (*match)(const struct sk_buff *skb, struct xt_action_param *);
> >
> > In that case, would this even be valid?
> > -m socket --transparent --restore-skmark
> >
> > Keeping in mind --restore-skmark is happening as part of -m socket
> >
> > I would think we would need a whole new target to handle something
> > like
> > this:
> > iptables -t mangle -I PREROUTING -m socket --transparent --no-wildcard
> > -j SOCKET --restore-skmark
> >
> > Since the target invocation would be separate, we would need a second
> > socket lookup? Seems perhaps a little overkill...
> 
> Yes, it's simply overkill to add a new target to add this.
> 
> So just cast it:
Yuck...

>         struct sk_buff *pskb = (struct sk_buff *)skb;
> 
> iptables matches were originally design not to modify anything, but it
> can lead us to situations like this. That's one of the reasons why we
> have no distinction between matches and targets in nftables anymore.

That makes sense.
> Thanks.

These 2 MATCHSOCKMARK patches should be replaced with:
[PATCH nf-next] netfilter: xt_socket: add XT_SOCKET_RESTORESKMARK flag
[PATCH iptables] xt_socket: add --restore-skmark option

Thanks,
Harout


