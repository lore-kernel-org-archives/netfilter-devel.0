From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: fix NETFILTER_XT_TARGET_TEE
 dependencies
Date: Fri, 6 Jul 2018 14:48:27 +0200
Message-ID: <20180706124827.xwho2rgu3jkk3hp5@salvia>
References: <20180706123805.2852900-1-arnd@arndb.de>
 <20180706124542.jybscbmzixyt4rx2@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706124542.jybscbmzixyt4rx2@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 06, 2018 at 02:45:42PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 06, 2018 at 02:37:58PM +0200, Arnd Bergmann wrote:
> > With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
> > error when referencing the NF_DUP_IPV6 module:
> > 
> > net/netfilter/xt_TEE.o: In function `tee_tg6':
> > xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'
> > 
> > The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
> > that forces NF_DUP_IPV6 to be =m as well rather than setting it
> > to =y as was intended here. Adding a soft dependency on
> > IP6_NF_IPTABLES avoids that broken configuration.
> 
> Applied to nf.git, thanks Arnd.

Sorry, let me reconsider.

We many need similar patches to other spots in 35bf1ccecaaa ?

If so, it would be good to fix in the one go.

Thanks!
