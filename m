From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netlink: fix memory leak
Date: Sun, 22 Jul 2018 11:02:34 +0200
Message-ID: <20180722090234.bttpk2xmwf4d7hfo@breakpoint.cc>
References: <20180722024925.3176-1-cscnull@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, johannes.berg@intel.com, pombredanne@nexb.com,
        kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        Jason@zx2c4.com, dsahern@gmail.com, lucien.xin@gmail.com,
        ktkhai@virtuozzo.com, xiyou.wangcong@gmail.com,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, tom@quantonium.net
To: Shaochun Chen <cscnull@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180722024925.3176-1-cscnull@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Shaochun Chen <cscnull@gmail.com> wrote:

[ CC Tom Herbert ]

> and the memory which pointed by control->data will leak. so if netlink_dump
> start fail, call control->done to free the memory.

Tom, I was about to suggest moving extra allocations for dumps
into a ->start() callback whereever possible.

However, it looks like ->done() is not guaranteed to be called even if
->start() was invoked, but it seems at least ila assumes ->done always
cleans up after ->start.

I am looking at netlink_dump(); it calls ->done() only after the dump
callback was invoked.

In nf_tables_api.c case it might be possible to defer allocations until
->dump() is called for first time via cb_args but I don't think its
going to be any better than cleaning up manually after netlink_dump_start()
returned an error.

Any better ideas or advice on how to procceed?

Thanks!
