From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the netfilter-next
 tree
Date: Wed, 8 Nov 2017 19:00:52 +1100
Message-ID: <20171108190052.63dfd8ce@canb.auug.org.au>
References: <20171107110248.7f1924a7@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
To: David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107110248.7f1924a7@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

On Tue, 7 Nov 2017 11:02:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
> 
> After merging the netfilter-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> net/netfilter/nf_conntrack_netlink.c:536:15: warning: 'ctnetlink_proto_size' defined but not used [-Wunused-function]
>  static size_t ctnetlink_proto_size(const struct nf_conn *ct)
>                ^
> 
> Introduced by commit
> 
>   5caaed151a68 ("netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size")

I assume that this warning will now be in the net-next tree ...

-- 
Cheers,
Stephen Rothwell
