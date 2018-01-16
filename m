From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: flow_offload depends on flow_table
Date: Tue, 16 Jan 2018 01:48:52 +0100
Message-ID: <20180116004852.ly4nzjgkhspdzftd@salvia>
References: <20180112155033.3694504-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Manuel Messner <mm@skelett.io>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112155033.3694504-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 12, 2018 at 04:50:26PM +0100, Arnd Bergmann wrote:
> Without CONFIG_NF_FLOW_TABLE, the new nft_flow_offload module produces
> a link error:
> 
> net/netfilter/nft_flow_offload.o: In function `nft_flow_offload_iterate_cleanup':
> nft_flow_offload.c:(.text+0xb0): undefined reference to `nf_flow_table_iterate'
> net/netfilter/nft_flow_offload.o: In function `flow_offload_iterate_cleanup':
> nft_flow_offload.c:(.text+0x160): undefined reference to `flow_offload_dead'
> net/netfilter/nft_flow_offload.o: In function `nft_flow_offload_eval':
> nft_flow_offload.c:(.text+0xc4c): undefined reference to `flow_offload_alloc'
> nft_flow_offload.c:(.text+0xc64): undefined reference to `flow_offload_add'
> nft_flow_offload.c:(.text+0xc94): undefined reference to `flow_offload_free'
> 
> This adds a Kconfig dependency for it.

Applied, thanks Arnd.
