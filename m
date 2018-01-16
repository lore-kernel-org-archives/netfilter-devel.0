From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 2/2] netfilter: nf_defrag: move NF_CONNTRACK
 bits into #ifdef
Date: Tue, 16 Jan 2018 01:48:17 +0100
Message-ID: <20180116004817.4w43d7pflzbw6ubv@salvia>
References: <20180115154918.4176669-1-arnd@arndb.de>
 <20180115154918.4176669-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180115154918.4176669-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 15, 2018 at 04:49:06PM +0100, Arnd Bergmann wrote:
> We cannot access the skb->_nfct field when CONFIG_NF_CONNTRACK is
> disabled:
> 
> net/ipv4/netfilter/nf_defrag_ipv4.c: In function 'ipv4_conntrack_defrag':
> net/ipv4/netfilter/nf_defrag_ipv4.c:83:9: error: 'struct sk_buff' has no member named '_nfct'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'ipv6_defrag':
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:68:9: error: 'struct sk_buff' has no member named '_nfct'
> 
> Both functions already have an #ifdef for this, so let's move the
> check in there.

Also applied, thanks.
