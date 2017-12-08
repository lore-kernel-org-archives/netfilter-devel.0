From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: [PATCH net-next] bridge: ebtables: Avoid resetting limit rule
 state
Date: Fri, 8 Dec 2017 06:46:06 +0100
Message-ID: <20171208054606.GE2391@otheros>
References: <20171125074418.16537-1-linus.luessing@c0d3.blue>
 <20171127233008.GA1418@salvia>
 <20171204045335.GE3307@otheros>
 <20171207002619.GB28145@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207002619.GB28145@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 07, 2017 at 01:26:19AM +0100, Pablo Neira Ayuso wrote:
> > I also had a quick look at a 4.15-rc1 kernel in a VM now. I still
> > end up in ebt_limit_mt_check() with the variables being reset
> > when editing the table somewhere.
> 
> My question is if your fix would work with 4.15-rc1.

You are absoluetly right, it's not working anymore since the
commit you mentioned initially :-(
("xtables: extend matches and targets with .usersize").
info->prev is always 0 since exactly this commit.

That means, trying tricks in ebt_limit_mt_check() is too
late now, the old values are already overwritten? (or is there
some commit scheme which installs the ebt_limit_info provided
by ebt_limit_check() some time after its call?)

Extending the usersize to include info->prev would probably be too
hackish/ugly, right?
