From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 12:43:27 +0200
Message-ID: <20180723104327.rmptoqx7gzvwvbra@salvia>
References: <20180722143354.23722-1-cscnull@gmail.com>
 <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net>
 <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
 <20180723091551.mwhltw4ujm4bylvj@salvia>
 <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
 <CAKDdixCx5za07R9KdyohsZjJqzdTpE3mR1+4TwY5xjeBGVeTjg@mail.gmail.com>
 <CAKDdixBBd08eKvk-hJtwPy46u2uzihRCh_KdEMF3xG1ZJ6oNsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        kadlec <kadlec@blackhole.kfki.hu>,
        "johannes.berg" <johannes.berg@intel.com>, jason <Jason@zx2c4.com>,
        ktkhai <ktkhai@virtuozzo.com>,
        "lucien.xin" <lucien.xin@gmail.com>,
        "xiyou.wangcong" <xiyou.wangcong@gmail.com>,
        dsahern <dsahern@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        tom <tom@quantonium.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: shaochun chen <cscnull@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKDdixBBd08eKvk-hJtwPy46u2uzihRCh_KdEMF3xG1ZJ6oNsg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2018 at 06:34:36PM +0800, shaochun chen wrote:
> I have a question: we will try_module_get in __netlink_dump_start(),
> but why we need to call try_module_get again in  nft_netlink_dump_start ??

Because they refer to two different modules. nfnetlink is multiplexing
all netfilter subsystem through one single netlink bus.

At the time that decision was made, there were concerns about netlink
running out of busses.
