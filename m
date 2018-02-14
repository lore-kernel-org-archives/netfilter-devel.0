From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net v2] netfilter: nat: cope with negative port range
Date: Wed, 14 Feb 2018 13:30:37 +0100
Message-ID: <20180214123037.GD2810@breakpoint.cc>
References: <184e6d2a1ab2e474c12be6e9819d7cf2cc846f26.1518606740.git.pabeni@redhat.com>
 <1518611306.3715.193.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41776 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967541AbeBNMeA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 07:34:00 -0500
Content-Disposition: inline
In-Reply-To: <1518611306.3715.193.camel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2018-02-14 at 12:13 +0100, Paolo Abeni wrote:
> > syzbot reported a division by 0 bug in the netfilter nat code:
> 
> > Adding the relevant check at parse time could break existing
> > setup, moreover we would need to read/write such values atomically
> > to avoid possible transient negative ranges at update time.
> 
> I do not quite follow why it is so hard to add a check at parse time.
> 
> Breaking buggy setups would not be a concern I think.

It would be possible for xtables but afaics in nft_nat.c case
(nft_nat_eval) range.{min,max}_proto.all values are loaded from nft
registers at runtime.
