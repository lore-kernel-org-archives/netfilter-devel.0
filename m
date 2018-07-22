From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Sun, 22 Jul 2018 18:39:25 +0200
Message-ID: <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
References: <20180722143354.23722-1-cscnull@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, johannes.berg@intel.com, Jason@zx2c4.com,
        ktkhai@virtuozzo.com, lucien.xin@gmail.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Shaochun Chen <cscnull@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180722143354.23722-1-cscnull@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Shaochun Chen <cscnull@gmail.com> wrote:

[ CC ing Tom, as he added ->start() ]

> 1) if netlink_dump_start start fail, the memory of c->data will leak.
> so free manually after netlink_dump_start return error.
> 
> 2) In netlink_dump_start, ignore the return of netlink_dump.
> Because if cb_running is set to true, cb->dump will be call in anyway.
> so if netlink_dump_start start successfully, just return -EINTR.

This now requires ->start() to not return -EINVAL, else we won't
release resources either, this seems fragile to me.

I can only think of three ways to address this:

1. Kill ->start() and force all users to defer
   state allocation to first ->dump() invocation, so existing
   ->done() can be used to release resources.

OR
2. add ->stop() and have core always pair it with ->start(),
   no matter if dump() got called or not, then convert all
   places that provide .start to use .stop, not .done.

OR
3. change meaning of ->done() so its always called once ->start()
   was invoked (and returned 0), this requires audit of all
   places that provide .done to make sure they won't trip.

3) seems to be what Tom intended when he added .start, so probably
best to investigate that first.
