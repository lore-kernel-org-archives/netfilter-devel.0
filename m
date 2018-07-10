From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without
 NF_TABLES_IPV6
Date: Tue, 10 Jul 2018 13:24:59 +0200
Message-ID: <20180710112459.ielgaydrgd4kxizo@salvia>
References: <20180709213537.2748896-1-arnd@arndb.de>
 <20180710080227.qwh53ahq26j6phhd@sch.bme.hu>
 <20180710080538.d7xqpjdvpksfrx6o@sch.bme.hu>
 <CAK8P3a0zYmdoMdWdFDcWprZY_4w2hbMYq4--iZB=JE4x2UiscA@mail.gmail.com>
 <20180710105605.evgtmjiq5z46zld6@salvia>
 <20180710111536.hio2xalz7pyxucc6@sch.bme.hu>
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
To: =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710111536.hio2xalz7pyxucc6@sch.bme.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 10, 2018 at 01:15:36PM +0200, Máté Eckl wrote:
> On Tue, Jul 10, 2018 at 12:56:05PM +0200, Pablo Neira Ayuso wrote:
[...]
> This patch only solves the nf_socket and nft_socket modules problem so I can
> only submit a v2 for 'netfilter: Kconfig: Change IPv6 select dependencies' but
> you already applied it so it would meen a force push. Should I do this?
> 
> I think Arnd's patch solves these problems in case we don't want to force-push
> or rebase.

You are refering to these two patches, right?

https://patchwork.ozlabs.org/patch/941374/
https://patchwork.ozlabs.org/patch/941696/

> > I think it's better if we toss your original patch in the tree and
> > rebase, ie. take the new one that fixes all issues that Arnd is
> > reporting. It would be good if we can sort out this before I send the
> > next pull request for net-next stuff.
> > 
> > I was afraid of fallout like this when I saw your original patch,
> > kbuild is always tricky.
> 
> This patch is not related to the nft_tproxy module (it seems that you refer to
> that) as Arnd didn't have that in the tree when doing this. I'll send a v4 fot
> the tproxy module, but that cannot be related to this one as it is not in tree
> yet.

No, I'm refering to 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6
select dependencies"), that is causing the issues.

Thanks.
