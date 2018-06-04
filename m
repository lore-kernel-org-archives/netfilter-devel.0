From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: fix null-ptr-deref in
 nf_nat_decode_session
Date: Mon, 4 Jun 2018 10:01:09 +0200
Message-ID: <20180604080109.pwj46x6w7hqsbud7@salvia>
References: <20180528091449.7508-1-bhole_prashant_q7@lab.ntt.co.jp>
 <20180528105249.36pvoyo5loqjjmsa@breakpoint.cc>
 <3c408f33-9c9c-b16f-3433-8931ea3e4bae@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3c408f33-9c9c-b16f-3433-8931ea3e4bae@lab.ntt.co.jp>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 04, 2018 at 10:10:08AM +0900, Prashant Bhole wrote:
> CC netfilter-devel
> 
> On 5/28/2018 7:52 PM, Florian Westphal wrote:
> > Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp> wrote:
> > > Add null check for nat_hook in nf_nat_decode_session()
> > 
> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> Hi Pablo,
> Just pinging in case this patch was missed.

The original submission was missing Cc: netfilter-devel@vger.kernel.org,
so patchwork didn't catch it:

http://patchwork.ozlabs.org/project/netfilter-devel/list/

Will include this patch in the next batch. Thanks.
