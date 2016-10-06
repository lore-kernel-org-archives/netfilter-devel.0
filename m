From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [GIT] Networking
Date: Thu, 6 Oct 2016 02:09:45 +0200
Message-ID: <20161006000945.GA18976@salvia>
References: <20161005.014437.1946431553783736769.davem@davemloft.net>
 <20161006092947.25ae781c@canb.auug.org.au>
 <CA+55aFzbHD95PMUk4JQfAVkDDRcwzZ6vfvMR60tZnQNSwkDE6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933400AbcJFAJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2016 20:09:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 50332C0B2A
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2016 02:09:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40F7BBAC24
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2016 02:09:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E421BBAC24
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2016 02:09:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+55aFzbHD95PMUk4JQfAVkDDRcwzZ6vfvMR60tZnQNSwkDE6A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 05, 2016 at 03:37:17PM -0700, Linus Torvalds wrote:
> On Wed, Oct 5, 2016 at 3:29 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > I have been carrying the following merge fix patch (for the merge of
> > the net-next tree with Linus' tree) for a while now which seems to have
> > got missed:
> 
> Ugh. It doesn't seem to be a merge error, because that double iph
> assignment came from the original patch that introduced this function:
> commit ddc8b6027ad0 ("netfilter: introduce nft_set_pktinfo_{ipv4,
> ipv6}_validate()").
> 
> So I wouldn't call it a merge error - it just looks like a bug in the
> network layer. So I'm not going to apply your patch even though it
> looks plausible to me, simply because it's outside my area of
> expertise.
> 
> David? Pablo?

This looks good, please take it so we speed up things.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!

P.S: Sorry for not addressing this any sooner, traveling overhead,
conferente and unstable wifi connection has been a problem here.
