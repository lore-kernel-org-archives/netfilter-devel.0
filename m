From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net v2] netfilter: nat: cope with negative port range
Date: Wed, 14 Feb 2018 16:49:56 +0100
Message-ID: <20180214154956.k2yv4ssqk5galke7@salvia>
References: <184e6d2a1ab2e474c12be6e9819d7cf2cc846f26.1518606740.git.pabeni@redhat.com>
 <1518611306.3715.193.camel@gmail.com>
 <20180214123037.GD2810@breakpoint.cc>
 <20180214135119.vmfw2jraieo3zxdg@salvia>
 <1518623131.13674.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1518623131.13674.7.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 14, 2018 at 04:45:31PM +0100, Paolo Abeni wrote:
> Hi,
> 
> On Wed, 2018-02-14 at 14:51 +0100, Pablo Neira Ayuso wrote:
> > On Wed, Feb 14, 2018 at 01:30:37PM +0100, Florian Westphal wrote:
> > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > On Wed, 2018-02-14 at 12:13 +0100, Paolo Abeni wrote:
> > > > > syzbot reported a division by 0 bug in the netfilter nat code:
> > > > > Adding the relevant check at parse time could break existing
> > > > > setup, moreover we would need to read/write such values atomically
> > > > > to avoid possible transient negative ranges at update time.
> > > > 
> > > > I do not quite follow why it is so hard to add a check at parse time.
> > > > 
> > > > Breaking buggy setups would not be a concern I think.
> > > 
> > > It would be possible for xtables but afaics in nft_nat.c case
> > > (nft_nat_eval) range.{min,max}_proto.all values are loaded from nft
> > > registers at runtime.
> > 
> > Then, restrict this from nft_nat.
> 
> If we move the check in the caller for nft, then need cope individually
> with several control paths (nf_nat_setup_info() is used by ~10 modules
> if I'm not wrong), I think keeping the check here would be better, do
> you have strong opinions against that?

You're right, this is fine.

Thanks for explaining!
