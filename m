From: =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
Subject: Re: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without
 NF_TABLES_IPV6
Date: Tue, 10 Jul 2018 10:02:27 +0200
Message-ID: <20180710080227.qwh53ahq26j6phhd@sch.bme.hu>
References: <20180709213537.2748896-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Leitner <fbl@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180709213537.2748896-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 09, 2018 at 11:35:09PM +0200, Arnd Bergmann wrote:
> It is now possible to build the nft_socket module as built-in when
> NF_TABLES_IPV6 is disabled, and have NF_SOCKET_IPV6=m set manually.
> 
> In this case, the NF_SOCKET_IPV6 functionality will be useless according
> to the explanation in commit 35bf1ccecaaa ("netfilter: Kconfig: Change
> IPv6 select dependencies"), but on top of that it also causes a link
> error:
> 
> net/netfilter/nft_socket.o: In function `nft_socket_eval':
> nft_socket.c:(.text+0x162): undefined reference to `nf_sk_lookup_slow_v6'
> 
> This changes the compile-time check so we don't attempt to use
> the NF_SOCKET_IPV6 code when it cannot be used, and make it all
> compile again. That may lead to unexpected behavior when a user
> enables NF_SOCKET_IPV6 but cannot use it, but seems to be the
> logical conclusion of the 35bf1ccecaaa change.
> 
> Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I think this should be fixed in the Kconfig rather than inside the module(s).

I did some investigation and it turns out that you missed a circumstance. This
link error occures only if NFT_SOCKET=y && NF_SOCKET_IPV6=m && NF_TABLES_IPV6=y
(cannot be m here if NFT_SOCKET is y). And probably the same with
iptables-related modules. Probably this possibility should be eliminated.
