From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Mon, 12 Sep 2016 14:32:53 +0200
Message-ID: <20160912123253.GA9791@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
 <20160911211226.GB6572@breakpoint.cc>
 <20160912120902.GA3654@salvia>
 <20160912122257.GC27566@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>, nevola@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756756AbcILMc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:32:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F8872EFEAB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:32:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F22B1153FC
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:32:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F39B9100A6A
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 14:32:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160912122257.GC27566@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 02:22:57PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Sep 11, 2016 at 11:12:26PM +0200, Florian Westphal wrote:
> > > My first thought was that it would be better to just support one single
> > > sreg (the queue number) and eventually externalize the hashing/queue
> > > selection:
> > > 
> > > queue num jhash ip saddr . ip daddr mod ...
> > > 
> > > Problem is that with plain jhash we won't get a symmetric hash
> > > for origin and reply, so for this we would need a new expression/hash
> > > mode.
> > 
> > Are you think of xor hashing to provide the symmetry? Downside is that
> > bad tuple selection may result in poor distribution, but this is
> > something we can document.
> 
> No, I was thinking of a new hash mode to do this, e.g. just do same
> what current nfqueue selection does: hash lower address first.

Currently we have one single register pointing to the entire tuple
concatenation that we hash, we would need to support multiple
registers as input, check that they are consecutive. Then, the logic
to compare the data. And a way to express this in syntax.
