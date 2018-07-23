From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 12:51:59 +0200
Message-ID: <20180723105159.vpknxgam3fqeicvv@breakpoint.cc>
References: <20180722143354.23722-1-cscnull@gmail.com>
 <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net>
 <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
 <20180723091551.mwhltw4ujm4bylvj@salvia>
 <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
 <20180723093855.c4ncixsnkee6r34v@salvia>
 <20180723094228.mejwuvoyitolqktv@breakpoint.cc>
 <20180723094742.gg6e73l6aknghal7@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, cscnull@gmail.com,
        kadlec@blackhole.kfki.hu, johannes.berg@intel.com, Jason@zx2c4.com,
        ktkhai@virtuozzo.com, lucien.xin@gmail.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723094742.gg6e73l6aknghal7@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 23, 2018 at 11:42:28AM +0200, Florian Westphal wrote:
> We can also add another scratchpad area, similar to the ->cb[x] area
> that can be initialized before netlink_dump_start()? So we don't need
> the data pointer.
> 
> By passing the array of attributes, we'll need to do attribute parsing
> over and over again from each netlink_dump() call.

Its still done once, parsing is only delayed/moved to ->start().

Now:

nla_parse
control->data = kmalloc() + init
netlink_dump_start()
  ->start() /* if it returns 0, done() will be called eventually
  netlink_dump()
->done()
  free(cb->data);

Proposed fix:
control->data = &on_stack;
netlink_dump_start()
  ->start()
     nla_parse
     cb->data = kmalloc() + init
  netlink_dump()
->done()
  free(cb->data);

I've submitted a patch for nf_tables, let me know if you have a better
idea or see a problem with it.
