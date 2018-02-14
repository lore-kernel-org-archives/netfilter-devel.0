From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net v2] netfilter: nat: cope with negative port range
Date: Wed, 14 Feb 2018 05:24:12 -0800
Message-ID: <1518614652.3715.195.camel@gmail.com>
References: <184e6d2a1ab2e474c12be6e9819d7cf2cc846f26.1518606740.git.pabeni@redhat.com>
         <1518611306.3715.193.camel@gmail.com> <20180214123037.GD2810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46206 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967713AbeBNNYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 08:24:16 -0500
In-Reply-To: <20180214123037.GD2810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2018-02-14 at 13:30 +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Wed, 2018-02-14 at 12:13 +0100, Paolo Abeni wrote:
> > > syzbot reported a division by 0 bug in the netfilter nat code:
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

I prefer this explanation much more, I suggest we update the changelog
to explain the real reason.

Thanks Florian.

