From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix CONFIG_NF_REJECT_IPV6=m link error
Date: Fri, 13 Apr 2018 15:15:58 +0200
Message-ID: <20180413131558.3jw5dhub5gcyotyt@salvia>
References: <20180409105322.2247296-1-arnd@arndb.de>
 <20180409143741.dzooqrzcgi2bnvd5@salvia>
 <CAK8P3a1GH5OSu62TBh46S0OdiXTJODsvV3To5=Jp2nL+fz1Puw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ihxb5r4tqmv6zkwf"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a1GH5OSu62TBh46S0OdiXTJODsvV3To5=Jp2nL+fz1Puw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--ihxb5r4tqmv6zkwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 09, 2018 at 04:43:40PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 9, 2018 at 4:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Arnd,
> >
> > On Mon, Apr 09, 2018 at 12:53:12PM +0200, Arnd Bergmann wrote:
> >> We get a new link error with CONFIG_NFT_REJECT_INET=y and CONFIG_NF_REJECT_IPV6=m
> >
> > I think we can update NFT_REJECT_INET so it depends on NFT_REJECT_IPV4
> > and NFT_REJECT_IPV6. This doesn't allow here CONFIG_NFT_REJECT_INET=y
> > and CONFIG_NF_REJECT_IPV6=m.
> >
> > I mean, just like we do with NFT_FIB_INET.
> 
> That can only work if NFT_REJECT_INET can be made a 'tristate' symbol
> again, so that code gets built as a loadable module if
> CONFIG_NF_REJECT_IPV6=m.
> 
> > BTW, I think this problem has been is not related to the recent patch,
> > but something older that kbuild robot has triggered more easily for
> > some reason?
> 
> 02c7b25e5f54 is the one that turned NF_TABLES_INET into a 'bool'
> symbol. NFT_REJECT depends on NF_TABLES_INET, so it used to
> restricted to a loadable module with IPV6=m, but can now be
> built-in, which causes that link error.

Still one more spin on this, I would like to see if we have a way to
fix this by simplifing things a bit.

Would this one I'm attaching would work?

Thanks for you patience.

--ihxb5r4tqmv6zkwf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-CONFIG_NF_REJECT_IPV-4-6-becomes-bool-togg.patch"

>From af07bc7ff5d34ce54e7913233912c058e6699e3c Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 13 Apr 2018 10:48:40 +0200
Subject: [PATCH] netfilter: CONFIG_NF_REJECT_IPV{4,6} becomes bool toggle

Arnd reports that we get a new link error with CONFIG_NFT_REJECT_INET=y
and CONFIG_NF_REJECT_IPV6=m after larger parts of the nftables modules
are linked together:

net/netfilter/nft_reject_inet.o: In function `nft_reject_inet_eval':
nft_reject_inet.c:(.text+0x17c): undefined reference to `nf_send_unreach6'
nft_reject_inet.c:(.text+0x190): undefined reference to `nf_send_reset6'

The problem is that with NF_TABLES_INET set, we implicitly try to use
the ipv6 version as well for NFT_REJECT, but when CONFIG_IPV6 is set to
a loadable module, it's impossible to reach that.

This patch fixes this problem by building-in nf_reject_ipv{4,6}.c, IPv6
symbol dependencies for the IPv6 reject infrastructure are located in
exthdrs_core.c, ip6_checksum.c and ip6_icmp.c which are also built-in,
so let's do the same to simplify this.

Fixes: 02c7b25e5f54 ("netfilter: nf_tables: build-in filter chain type")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 3 +--
 net/ipv6/netfilter/Kconfig | 3 +--
 net/netfilter/Kconfig      | 2 ++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 280048e1e395..3e4e0ae2a9a1 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -104,8 +104,7 @@ config NF_LOG_IPV4
 	select NF_LOG_COMMON
 
 config NF_REJECT_IPV4
-	tristate "IPv4 packet rejection"
-	default m if NETFILTER_ADVANCED=n
+	bool "IPv4 packet rejection"
 
 config NF_NAT_IPV4
 	tristate "IPv4 NAT"
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index ccbfa83e4bb0..1e5d040a60b8 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -87,8 +87,7 @@ config NF_DUP_IPV6
 	  packet to be rerouted to another destination.
 
 config NF_REJECT_IPV6
-	tristate "IPv6 packet rejection"
-	default m if NETFILTER_ADVANCED=n
+	bool "IPv6 packet rejection"
 
 config NF_LOG_IPV6
 	tristate "IPv6 packet logging"
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4189f574f5ec..d7b3272fe821 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -609,6 +609,8 @@ config NFT_REJECT
 
 config NFT_REJECT_INET
 	depends on NF_TABLES_INET
+	select NF_REJECT_IPV4
+	select NF_REJECT_IPV6
 	default NFT_REJECT
 	tristate
 
-- 
2.11.0


--ihxb5r4tqmv6zkwf--
