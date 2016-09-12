From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 14:39:22 +0200
Message-ID: <20160912123922.GA9962@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
 <20160912105313.GB6772@sonyv>
 <20160912122849.GD27566@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia <nevola@gmail.com>, Liping Zhang <zlpnobody@163.com>,
        netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55866 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758071AbcILMjc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:39:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BC2A2EFEAD
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:39:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32774114D62
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:39:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E177B100A7F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:39:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160912122849.GD27566@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 02:28:49PM +0200, Florian Westphal wrote:
> Laura Garcia <nevola@gmail.com> wrote:
> > On Sun, Sep 11, 2016 at 11:12:26PM +0200, Florian Westphal wrote:
> > > Liping Zhang <zlpnobody@163.com> wrote:
> > > > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > > > 
> > > > Currently, the user can specify the queue numbers by _QUEUE_NUM and
> > > > _QUEUE_TOTAL attributes, this is enough in most situations.
> > > > 
> > > > But acctually, it is not very flexible, for example:
> > > >   tcp dport 80 mapped to queue0
> > > >   tcp dport 81 mapped to queue1
> > > >   tcp dport 82 mapped to queue2
> > > > In order to do this thing, we must add 3 nft rules, and more
> > > > mapping means more rules ...
> > > > 
> > > > So similer to nft_nat, take two registers to select the queue numbers,
> > > > then we can add one simple rule to mapping queues, maybe like this:
> > > >   queue num tcp dport map { 80:0, 81:1, 82:2 ... }
> > > 
> > > I like this.
> > > 
> > > My first thought was that it would be better to just support one single
> > > sreg (the queue number) and eventually externalize the hashing/queue
> > > selection:
> > > 
> > > queue num jhash ip saddr . ip daddr mod ...
> > > 
> > > Problem is that with plain jhash we won't get a symmetric hash
> > > for origin and reply, so for this we would need a new expression/hash
> > > mode.
> > > 
> > > We would also need another expression to allow distribution
> > > starting with a queue other than 0.
> > 
> > For such feature, I've already sent a patch "netfilter: nft_hash: Add
> > hash offset value" in order to set an initial value for the hash
> > expression. I think it'll be available in the tree soon.
> 
> Yes, but that means one would always need to use hash.
> 
> Maybe thats indeed sufficient since it already provides a modulo
> functionality.
> 
> I was thinking
> 
> nfqueue num meta cpu ...
> nfqueue num meta hash ... [ i.e. use skb->hash, not supported right now ]
> nfqueue num meta mark
> nfqueue num ct mark
> 
> etc.  so we would have no control over start qnum (something like
> 'nfqueue num (meta cpu + 10000)' ...
>
> Admittingly, I do not see a big drawback if we'd always have to
> feed it to jhash first.

I think it would be easy to add this offset support to meta and ct, so
we adding this value to whatever we fetch. I think a generic
arithmetic expression that allows us to add two values from two
registers is too much.
