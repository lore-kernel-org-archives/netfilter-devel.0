From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 11:47:42 +0200
Message-ID: <20180723094742.gg6e73l6aknghal7@salvia>
References: <20180722143354.23722-1-cscnull@gmail.com>
 <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net>
 <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
 <20180723091551.mwhltw4ujm4bylvj@salvia>
 <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
 <20180723093855.c4ncixsnkee6r34v@salvia>
 <20180723094228.mejwuvoyitolqktv@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, cscnull@gmail.com,
        kadlec@blackhole.kfki.hu, johannes.berg@intel.com, Jason@zx2c4.com,
        ktkhai@virtuozzo.com, lucien.xin@gmail.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723094228.mejwuvoyitolqktv@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2018 at 11:42:28AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > As David pointed out, once ->start() returns 0 we set cb_running, i.e.
> > > only after successful ->start() netlink core will call ->dump() again.
> > > 
> > > So I see no problem setting ->data to onstack cookie and then
> > > duplicating it to heap via kmemdup in ->start().
> > > 
> > > As far as I can see netlink core offers all functionality already,
> > > so we only need to switch netfilter to make use of it.
> > > 
> > > If you disagree please let me know, otherwise I will cook up
> > > a patch along this pattern for net/netfilter/*.
> > 
> > Why not just call ->done from netlink_dump_start() when it fails?
> 
> Not sure thats safe for all users, we will also still need to call
> it in nft_netlink_dump_start and we need to play guess game wrt
> EINTR (which can mean 'dump was now started, do not send ack').

We can also add another scratchpad area, similar to the ->cb[x] area
that can be initialized before netlink_dump_start()? So we don't need
the data pointer.

By passing the array of attributes, we'll need to do attribute parsing
over and over again from each netlink_dump() call.
