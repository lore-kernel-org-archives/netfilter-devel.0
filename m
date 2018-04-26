From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix nf_tables filter chain type build
Date: Fri, 27 Apr 2018 00:15:15 +0200
Message-ID: <20180426221515.56pyozqb2nf6jadw@salvia>
References: <c8e42e35-ccff-471c-8c45-61f44855e21a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        kbuild test robot <lkp@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c8e42e35-ccff-471c-8c45-61f44855e21a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Apr 21, 2018 at 09:10:09PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors due to a missing Kconfig dependency term.
> Fixes these build errors:
> 
> net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_nat_do_chain':
> net/ipv6/netfilter/nft_chain_nat_ipv6.c:37: undefined reference to `nft_do_chain'
> net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_chain_nat_ipv6_exit':
> net/ipv6/netfilter/nft_chain_nat_ipv6.c:94: undefined reference to `nft_unregister_chain_type'
> net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_chain_nat_ipv6_init':
> net/ipv6/netfilter/nft_chain_nat_ipv6.c:87: undefined reference to `nft_register_chain_type'

Thanks for sending a patch for this Randy.

We have a patch to address this that should fix this:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=39f2ff0816e5421476c2bc538b68b4bb0708a78e

Thanks!
