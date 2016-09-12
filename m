From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 14:28:49 +0200
Message-ID: <20160912122849.GD27566@breakpoint.cc>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
 <20160912105313.GB6772@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56024 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756697AbcILM2y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:28:54 -0400
Content-Disposition: inline
In-Reply-To: <20160912105313.GB6772@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laura Garcia <nevola@gmail.com> wrote:
> On Sun, Sep 11, 2016 at 11:12:26PM +0200, Florian Westphal wrote:
> > Liping Zhang <zlpnobody@163.com> wrote:
> > > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > > 
> > > Currently, the user can specify the queue numbers by _QUEUE_NUM and
> > > _QUEUE_TOTAL attributes, this is enough in most situations.
> > > 
> > > But acctually, it is not very flexible, for example:
> > >   tcp dport 80 mapped to queue0
> > >   tcp dport 81 mapped to queue1
> > >   tcp dport 82 mapped to queue2
> > > In order to do this thing, we must add 3 nft rules, and more
> > > mapping means more rules ...
> > > 
> > > So similer to nft_nat, take two registers to select the queue numbers,
> > > then we can add one simple rule to mapping queues, maybe like this:
> > >   queue num tcp dport map { 80:0, 81:1, 82:2 ... }
> > 
> > I like this.
> > 
> > My first thought was that it would be better to just support one single
> > sreg (the queue number) and eventually externalize the hashing/queue
> > selection:
> > 
> > queue num jhash ip saddr . ip daddr mod ...
> > 
> > Problem is that with plain jhash we won't get a symmetric hash
> > for origin and reply, so for this we would need a new expression/hash
> > mode.
> > 
> > We would also need another expression to allow distribution
> > starting with a queue other than 0.
> 
> For such feature, I've already sent a patch "netfilter: nft_hash: Add
> hash offset value" in order to set an initial value for the hash
> expression. I think it'll be available in the tree soon.

Yes, but that means one would always need to use hash.

Maybe thats indeed sufficient since it already provides a modulo
functionality.

I was thinking

nfqueue num meta cpu ...
nfqueue num meta hash ... [ i.e. use skb->hash, not supported right now ]
nfqueue num meta mark
nfqueue num ct mark

etc.  so we would have no control over start qnum (something like
'nfqueue num (meta cpu + 10000)' ...

Admittingly, I do not see a big drawback if we'd always have to
feed it to jhash first.
