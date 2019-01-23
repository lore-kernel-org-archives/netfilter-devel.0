From: Florian Westphal <fw@strlen.de>
Subject: Re: [Patch nf-next] nf_conntrack: fix error path in
 nf_conntrack_pernet_init()
Date: Wed, 23 Jan 2019 22:17:43 +0100
Message-ID: <20190123211743.dvbkizgxm3ohwkcs@breakpoint.cc>
References: <20190123205857.8107-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+fcee88b2d87f0539dfe9@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123205857.8107-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> When nf_ct_netns_get() fails, it should clean up itself,
> its caller doesn't need to call nf_conntrack_fini_net().

Thanks a lot for fixing this!
