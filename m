From: =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
Subject: Re: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without
 NF_TABLES_IPV6
Date: Tue, 10 Jul 2018 13:15:36 +0200
Message-ID: <20180710111536.hio2xalz7pyxucc6@sch.bme.hu>
References: <20180709213537.2748896-1-arnd@arndb.de>
 <20180710080227.qwh53ahq26j6phhd@sch.bme.hu>
 <20180710080538.d7xqpjdvpksfrx6o@sch.bme.hu>
 <CAK8P3a0zYmdoMdWdFDcWprZY_4w2hbMYq4--iZB=JE4x2UiscA@mail.gmail.com>
 <20180710105605.evgtmjiq5z46zld6@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Leitner <fbl@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710105605.evgtmjiq5z46zld6@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 10, 2018 at 12:56:05PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 10, 2018 at 11:10:40AM +0200, Arnd Bergmann wrote:
> > On Tue, Jul 10, 2018 at 10:05 AM, Máté Eckl <ecklm94@gmail.com> wrote:
> > > On Tue, Jul 10, 2018 at 10:02:27AM +0200, Máté Eckl wrote:
> > >> On Mon, Jul 09, 2018 at 11:35:09PM +0200, Arnd Bergmann wrote:
> > >> > It is now possible to build the nft_socket module as built-in when
> > >> > NF_TABLES_IPV6 is disabled, and have NF_SOCKET_IPV6=m set manually.
> > >> >
> > >> > In this case, the NF_SOCKET_IPV6 functionality will be useless according
> > >> > to the explanation in commit 35bf1ccecaaa ("netfilter: Kconfig: Change
> > >> > IPv6 select dependencies"), but on top of that it also causes a link
> > >> > error:
> > >> >
> > >> > net/netfilter/nft_socket.o: In function `nft_socket_eval':
> > >> > nft_socket.c:(.text+0x162): undefined reference to `nf_sk_lookup_slow_v6'
> > >> >
> > >> > This changes the compile-time check so we don't attempt to use
> > >> > the NF_SOCKET_IPV6 code when it cannot be used, and make it all
> > >> > compile again. That may lead to unexpected behavior when a user
> > >> > enables NF_SOCKET_IPV6 but cannot use it, but seems to be the
> > >> > logical conclusion of the 35bf1ccecaaa change.
> > >> >
> > >> > Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
> > >> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > >>
> > >> I think this should be fixed in the Kconfig rather than inside the module(s).
> > 
> > Should we revert your patch then, or do you have a better idea?
> 
> Máté, would you resubmit a new patch that addresses all the problems
> that Arnd is reporting in one go?

This patch only solves the nf_socket and nft_socket modules problem so I can
only submit a v2 for 'netfilter: Kconfig: Change IPv6 select dependencies' but
you already applied it so it would meen a force push. Should I do this?

I think Arnd's patch solves these problems in case we don't want to force-push
or rebase.

> I think it's better if we toss your original patch in the tree and
> rebase, ie. take the new one that fixes all issues that Arnd is
> reporting. It would be good if we can sort out this before I send the
> next pull request for net-next stuff.
> 
> I was afraid of fallout like this when I saw your original patch,
> kbuild is always tricky.

This patch is not related to the nft_tproxy module (it seems that you refer to
that) as Arnd didn't have that in the tree when doing this. I'll send a v4 fot
the tproxy module, but that cannot be related to this one as it is not in tree
yet.

> Please Cc Arnd, Florian and me for review.
> 
> Thanks!
