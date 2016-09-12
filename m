From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 14:09:02 +0200
Message-ID: <20160912120902.GA3654@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>, nevola@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756086AbcILMJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:09:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59F381F18E3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:09:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43D5C15D633
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:09:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A5A411C4EB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:09:08 +0200 (CEST)
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

Are you think of xor hashing to provide the symmetry? Downside is that
bad tuple selection may result in poor distribution, but this is
something we can document.

Still it would be possible to use jhash at the cost of having two
rules.

It would be great to get a new NFTA_HASH_MODE attribute and something
like:

enum nft_hash_types {
        NFT_HASH_JENKINS        = 0,
};

So we have room to make other hash algos fit into this expression.
