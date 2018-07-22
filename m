From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Sun, 22 Jul 2018 10:07:55 -0700 (PDT)
Message-ID: <20180722.100755.19840167505550163.davem@davemloft.net>
References: <20180722143354.23722-1-cscnull@gmail.com>
        <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: cscnull@gmail.com, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        johannes.berg@intel.com, Jason@zx2c4.com, ktkhai@virtuozzo.com,
        lucien.xin@gmail.com, xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sun, 22 Jul 2018 18:39:25 +0200

> 3. change meaning of ->done() so its always called once ->start()
>    was invoked (and returned 0), this requires audit of all
>    places that provide .done to make sure they won't trip.
> 
> 3) seems to be what Tom intended when he added .start, so probably
> best to investigate that first.

Hmmm...

Any time ->start() succeeds, we set cb_running to true.

>From that point forward, ->done() will be called at some point at all
of the locations that check if cb_running is true and set it to false.

This may be deferred all the way to socket destruction, but it will
eventually happens.

Nothing sets cb_running to false without invoking the ->done()
callback.

Just because the individual dump invocations don't call ->done() does
not mean it will not eventually happen.  The dump callbacks, and thus
the state data, is live across multiple rounds of recvmsg() calls by
the user and that is as-designed.
