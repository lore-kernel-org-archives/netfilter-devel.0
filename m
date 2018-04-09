From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] netfilter: fix CONFIG_NF_REJECT_IPV6=m link error
Date: Mon, 9 Apr 2018 16:43:40 +0200
Message-ID: <CAK8P3a1GH5OSu62TBh46S0OdiXTJODsvV3To5=Jp2nL+fz1Puw@mail.gmail.com>
References: <20180409105322.2247296-1-arnd@arndb.de> <20180409143741.dzooqrzcgi2bnvd5@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409143741.dzooqrzcgi2bnvd5@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Apr 9, 2018 at 4:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Arnd,
>
> On Mon, Apr 09, 2018 at 12:53:12PM +0200, Arnd Bergmann wrote:
>> We get a new link error with CONFIG_NFT_REJECT_INET=y and CONFIG_NF_REJECT_IPV6=m
>
> I think we can update NFT_REJECT_INET so it depends on NFT_REJECT_IPV4
> and NFT_REJECT_IPV6. This doesn't allow here CONFIG_NFT_REJECT_INET=y
> and CONFIG_NF_REJECT_IPV6=m.
>
> I mean, just like we do with NFT_FIB_INET.

That can only work if NFT_REJECT_INET can be made a 'tristate' symbol
again, so that code gets built as a loadable module if
CONFIG_NF_REJECT_IPV6=m.

> BTW, I think this problem has been is not related to the recent patch,
> but something older that kbuild robot has triggered more easily for
> some reason?

02c7b25e5f54 is the one that turned NF_TABLES_INET into a 'bool'
symbol. NFT_REJECT depends on NF_TABLES_INET, so it used to
restricted to a loadable module with IPV6=m, but can now be
built-in, which causes that link error.

      Arnd
