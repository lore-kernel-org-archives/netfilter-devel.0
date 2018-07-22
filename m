From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netlink: fix memory leak
Date: Sun, 22 Jul 2018 10:12:46 +0200
Message-ID: <20180722081246.udphfijsnfnshrsc@breakpoint.cc>
References: <20180722024925.3176-1-cscnull@gmail.com>
 <CAHmME9pLNd5GeR4kq_KHcarPKh3mkS5Cv-2s-tiQsPG6GcZ6sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cscnull@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@blackhole.kfki.hu, Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        kstewart@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dsahern@gmail.com, lucien.xin@gmail.com, ktkhai@virtuozzo.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Netdev <netdev@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9pLNd5GeR4kq_KHcarPKh3mkS5Cv-2s-tiQsPG6GcZ6sw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Sun, Jul 22, 2018 at 4:51 AM Shaochun Chen <cscnull@gmail.com> wrote:
> But even if you moved it somehow to the if(ret), I'm still not sure
> it'd be correct; start cbs should either succeed, or they should error
> out and cleanup entirely after themselves.

I agree, ->done() should not be called if cb->dump() was never invoked.

All ctnetlink and nf_tables spots need to cleanup after themselves.
