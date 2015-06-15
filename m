From: "Harout Hedeshian" <harouth@codeaurora.org>
Subject: RE: [PATCH nf-next] netfilter: xt_socket: add XT_SOCKET_MATCHSOCKMARK flag and mark fields
Date: Mon, 15 Jun 2015 11:41:51 -0600
Message-ID: <004101d0a792$90acec60$b206c520$@codeaurora.org>
References: <1434148795-19937-1-git-send-email-harouth@codeaurora.org> <20150615162246.GA14375@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>,
	"'Lorenzo Colitti'" <lorenzo@google.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57328 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbbFORly (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 13:41:54 -0400
In-Reply-To: <20150615162246.GA14375@salvia>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Monday, June 15, 2015 10:23 AM
> To: Harout Hedeshian
> Cc: netfilter-devel@vger.kernel.org; Lorenzo Colitti
> Subject: Re: [PATCH nf-next] netfilter: xt_socket: add
> XT_SOCKET_MATCHSOCKMARK flag and mark fields
> 
> On Fri, Jun 12, 2015 at 04:39:55PM -0600, Harout Hedeshian wrote:
> > xt_socket is useful for matching sockets with IP_TRANSPARENT and
> > taking some action on the matching packets. However, it lacks the
> > ability to match only a small subset of transparent sockets.
> >
> > Suppose there are 2 applications, each with its own set of transparent
> > sockets. The first application wants all matching packets dropped,
> > while the second application wants them forwarded somewhere else.
> >
> > Add the ability to match sockets based on the socket mark.
> >
> > Now the 2 hypothetical applications can differentiate their sockets
> > based on a mark value set with SO_MARK.
> >
> > iptables -t mangle -I PREROUTING -m socket --transparent --mark 10 -J
> > act1 iptables -t mangle -I PREROUTING -m socket --transparent --mark
> > 11 -J act2
> 
> Wouldn't it be better to restore the sk_mark to skb->mark? I mean:
> 
>         iptables -t mangle -I PREROUTING \
>                 -m socket --transparent --restore-skmark -j myskchain
> 
> Thus, you can use -m mark from the 'myskchain' without having to fetch
> and inspect the sk over and over again as it happens with this
> extension.

Yes, I think that can work. Let me try that out and I'll submit a new patch.

