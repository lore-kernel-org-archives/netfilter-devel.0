From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 40/47] netfilter: nf_tables: build-in filter chain type
Date: Wed, 4 Apr 2018 17:38:31 +0200
Message-ID: <CAK8P3a1nEJ450Ori2-xPnC8WDPcHxiQR_844ArqOgZ2eRGpcbw@mail.gmail.com>
References: <20180330114619.18797-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 30, 2018 at 1:46 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> One module per supported filter chain family type takes too much memory
> for very little code - too much modularization - place all chain filter
> definitions in one single file.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Pablo,

I've bisected a link error to this patch:

net/netfilter/nft_reject_inet.o: In function `nft_reject_inet_eval':
nft_reject_inet.c:(.text+0xa7): undefined reference to `nf_send_unreach6'
nft_reject_inet.c:(.text+0x10c): undefined reference to `nf_send_unreach6'
nft_reject_inet.c:(.text+0x138): undefined reference to `nf_send_reset6'

Unfortunately I don't immediately see what went wrong, maybe you
can spot it.

       Arnd
