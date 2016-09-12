From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 12:53:14 +0200
Message-ID: <20160912105313.GB6772@sonyv>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34893 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757388AbcILKxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 06:53:19 -0400
Received: by mail-wm0-f67.google.com with SMTP id a6so13029726wmc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 03:53:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160911211226.GB6572@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 11:12:26PM +0200, Florian Westphal wrote:
> Liping Zhang <zlpnobody@163.com> wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > 
> > Currently, the user can specify the queue numbers by _QUEUE_NUM and
> > _QUEUE_TOTAL attributes, this is enough in most situations.
> > 
> > But acctually, it is not very flexible, for example:
> >   tcp dport 80 mapped to queue0
> >   tcp dport 81 mapped to queue1
> >   tcp dport 82 mapped to queue2
> > In order to do this thing, we must add 3 nft rules, and more
> > mapping means more rules ...
> > 
> > So similer to nft_nat, take two registers to select the queue numbers,
> > then we can add one simple rule to mapping queues, maybe like this:
> >   queue num tcp dport map { 80:0, 81:1, 82:2 ... }
> 
> I like this.
> 
> My first thought was that it would be better to just support one single
> sreg (the queue number) and eventually externalize the hashing/queue
> selection:
> 
> queue num jhash ip saddr . ip daddr mod ...
> 
> Problem is that with plain jhash we won't get a symmetric hash
> for origin and reply, so for this we would need a new expression/hash
> mode.
> 
> We would also need another expression to allow distribution
> starting with a queue other than 0.

For such feature, I've already sent a patch "netfilter: nft_hash: Add
hash offset value" in order to set an initial value for the hash
expression. I think it'll be available in the tree soon.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
