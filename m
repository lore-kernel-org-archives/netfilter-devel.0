From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch nf-next] nf_conntrack: fix error path in
 nf_conntrack_pernet_init()
Date: Mon, 28 Jan 2019 11:18:32 +0100
Message-ID: <20190128101832.rvdego4wxgcib6w4@salvia>
References: <20190123205857.8107-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+fcee88b2d87f0539dfe9@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123205857.8107-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 23, 2019 at 12:58:57PM -0800, Cong Wang wrote:
> When nf_ct_netns_get() fails, it should clean up itself,
> its caller doesn't need to call nf_conntrack_fini_net().
> 
> nf_conntrack_init_net() is called after registering sysctl
> and proc, so its cleanup function should be called before
> unregistering sysctl and proc.

Applies, thanks.
