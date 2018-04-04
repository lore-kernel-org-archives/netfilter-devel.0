From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 40/47] netfilter: nf_tables: build-in filter chain type
Date: Wed, 4 Apr 2018 17:46:57 +0200
Message-ID: <20180404154657.jjirlgjgdmzqg5hr@salvia>
References: <20180330114619.18797-1-pablo@netfilter.org>
 <CAK8P3a1nEJ450Ori2-xPnC8WDPcHxiQR_844ArqOgZ2eRGpcbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a1nEJ450Ori2-xPnC8WDPcHxiQR_844ArqOgZ2eRGpcbw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Apr 04, 2018 at 05:38:31PM +0200, Arnd Bergmann wrote:
> On Fri, Mar 30, 2018 at 1:46 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > One module per supported filter chain family type takes too much memory
> > for very little code - too much modularization - place all chain filter
> > definitions in one single file.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Pablo,
> 
> I've bisected a link error to this patch:
> 
> net/netfilter/nft_reject_inet.o: In function `nft_reject_inet_eval':
> nft_reject_inet.c:(.text+0xa7): undefined reference to `nf_send_unreach6'
> nft_reject_inet.c:(.text+0x10c): undefined reference to `nf_send_unreach6'
> nft_reject_inet.c:(.text+0x138): undefined reference to `nf_send_reset6'
> 
> Unfortunately I don't immediately see what went wrong, maybe you
> can spot it.

Can you pass me your .config file? I will have a look at it. Thanks.
Looks like some missing Kconfig stuff.
