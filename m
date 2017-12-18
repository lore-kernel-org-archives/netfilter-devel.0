From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][netfilter-next] netfilter: conntrack: make struct
 nf_conntrack_l4proto_gre4 static
Date: Mon, 18 Dec 2017 11:59:15 +0100
Message-ID: <20171218105915.cjqsqe2nmahm5yji@salvia>
References: <20171210233255.15009-1-colin.king@canonical.com>
 <20171211091805.GK24449@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Colin King <colin.king@canonical.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211091805.GK24449@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 11, 2017 at 10:18:05AM +0100, Florian Westphal wrote:
> Colin King <colin.king@canonical.com> wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The structure nf_conntrack_l4proto_gre4  is local to the source and does
> > not need to be in global scope, so make it static.
> 
> This bug was added in
> commit b9679a9fd3a7d36ea3deb2864a00cc413c5aae28
> netfilter: conntrack: l4 protocol trackers can be const

I have added Fixes: ... here.

> > -struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
> > +static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
> 
> This should be 'static const'.

I have mangled this patch to make it static const.

So Colin doesn't need to resend.

If there's anything else, let me know, I'll toss it and wait for a v2,
as you prefer.

Thanks.
