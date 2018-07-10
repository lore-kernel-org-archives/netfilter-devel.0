From: =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
Subject: Re: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without
 NF_TABLES_IPV6
Date: Tue, 10 Jul 2018 11:51:22 +0200
Message-ID: <20180710095122.6ee4wxfg4sabhcvw@sch.bme.hu>
References: <20180709213537.2748896-1-arnd@arndb.de>
 <20180710080227.qwh53ahq26j6phhd@sch.bme.hu>
 <20180710080538.d7xqpjdvpksfrx6o@sch.bme.hu>
 <CAK8P3a0zYmdoMdWdFDcWprZY_4w2hbMYq4--iZB=JE4x2UiscA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Leitner <fbl@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0zYmdoMdWdFDcWprZY_4w2hbMYq4--iZB=JE4x2UiscA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 10, 2018 at 11:10:40AM +0200, Arnd Bergmann wrote:
> On Tue, Jul 10, 2018 at 10:05 AM, Máté Eckl <ecklm94@gmail.com> wrote:
> > On Tue, Jul 10, 2018 at 10:02:27AM +0200, Máté Eckl wrote:
> >> On Mon, Jul 09, 2018 at 11:35:09PM +0200, Arnd Bergmann wrote:
> >> > It is now possible to build the nft_socket module as built-in when
> >> > NF_TABLES_IPV6 is disabled, and have NF_SOCKET_IPV6=m set manually.
> >> >
> >> > In this case, the NF_SOCKET_IPV6 functionality will be useless according
> >> > to the explanation in commit 35bf1ccecaaa ("netfilter: Kconfig: Change
> >> > IPv6 select dependencies"), but on top of that it also causes a link
> >> > error:
> >> >
> >> > net/netfilter/nft_socket.o: In function `nft_socket_eval':
> >> > nft_socket.c:(.text+0x162): undefined reference to `nf_sk_lookup_slow_v6'
> >> >
> >> > This changes the compile-time check so we don't attempt to use
> >> > the NF_SOCKET_IPV6 code when it cannot be used, and make it all
> >> > compile again. That may lead to unexpected behavior when a user
> >> > enables NF_SOCKET_IPV6 but cannot use it, but seems to be the
> >> > logical conclusion of the 35bf1ccecaaa change.
> >> >
> >> > Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
> >> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >>
> >> I think this should be fixed in the Kconfig rather than inside the module(s).
> 
> Should we revert your patch then, or do you have a better idea?
> 
> >> I did some investigation and it turns out that you missed a circumstance. This
> >> link error occures only if NFT_SOCKET=y && NF_SOCKET_IPV6=m && NF_TABLES_IPV6=y
> >> (cannot be m here if NFT_SOCKET is y).
> 
> No, if NF_TABLES_IPV6=y the problem cannot happen, since NFT_SOCKET then
> selects NF_SOCKET_IPV6=y as well. Before your patch, it would always select
> NF_SOCKET_IPV6 when it could, so it worked in all configurations.

Sorry I wanted to write NF_TABLES_IPV6=n...
So: NFT_SOCKET=y && NF_SOCKET_IPV6=m && NF_TABLES_IPV6=n causes linkage error.
NFT_SOCKET=m && NF_SOCKET_IPV6=m && NF_TABLES_IPV6=n compiles fine.

> >>  And probably the same with
> >> iptables-related modules. Probably this possibility should be eliminated.
> >
> > NF_TPROXY_IPV6 might be in the same situation.
> 
> I tried coming up with a combination that is broken for NF_TPROXY_IPV6=m
> but could not. From what I can see with
> 
> config NETFILTER_XT_TARGET_TPROXY
>        tristate '"TPROXY" target transparent proxying support'
>        depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
>        select NF_TPROXY_IPV6 if IP6_NF_IPTABLES
> 
> and
> 
> #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> 
> inside of net/netfilter/xt_TPROXY.c, there is no way we can end up with
> xt_TPROXY calling into the nf_tproxy_ipv6 loadable module from
> a built-in context. This is the same approach I used in my patch,
> just with IP6_NF_IPTABLES instead of NF_SOCKET_IPV6, in both
> the Kconfig dependency and the module.

Right, I see your point. I have an alternative solution which seems more robust
to me, but I might be overthinking this situation.

So
Accepted-by: Máté Eckl <ecklm94@gmail.com>

>       Arnd
