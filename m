From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net v2] netfilter: nat: cope with negative port range
Date: Wed, 14 Feb 2018 14:51:19 +0100
Message-ID: <20180214135119.vmfw2jraieo3zxdg@salvia>
References: <184e6d2a1ab2e474c12be6e9819d7cf2cc846f26.1518606740.git.pabeni@redhat.com>
 <1518611306.3715.193.camel@gmail.com>
 <20180214123037.GD2810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030221AbeBNNvY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 08:51:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 671A511773E
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 14:51:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A9D0DA3FC
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 14:51:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180214123037.GD2810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 01:30:37PM +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Wed, 2018-02-14 at 12:13 +0100, Paolo Abeni wrote:
> > > syzbot reported a division by 0 bug in the netfilter nat code:
> > 
> > > Adding the relevant check at parse time could break existing
> > > setup, moreover we would need to read/write such values atomically
> > > to avoid possible transient negative ranges at update time.
> > 
> > I do not quite follow why it is so hard to add a check at parse time.
> > 
> > Breaking buggy setups would not be a concern I think.
> 
> It would be possible for xtables but afaics in nft_nat.c case
> (nft_nat_eval) range.{min,max}_proto.all values are loaded from nft
> registers at runtime.

Then, restrict this from nft_nat.
