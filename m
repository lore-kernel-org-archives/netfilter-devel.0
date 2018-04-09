From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix CONFIG_NF_REJECT_IPV6=m link error
Date: Mon, 9 Apr 2018 16:37:41 +0200
Message-ID: <20180409143741.dzooqrzcgi2bnvd5@salvia>
References: <20180409105322.2247296-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="iojt55x3tnaul5vo"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180409105322.2247296-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--iojt55x3tnaul5vo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arnd,

On Mon, Apr 09, 2018 at 12:53:12PM +0200, Arnd Bergmann wrote:
> We get a new link error with CONFIG_NFT_REJECT_INET=y and CONFIG_NF_REJECT_IPV6=m

I think we can update NFT_REJECT_INET so it depends on NFT_REJECT_IPV4
and NFT_REJECT_IPV6. This doesn't allow here CONFIG_NFT_REJECT_INET=y
and CONFIG_NF_REJECT_IPV6=m.

I mean, just like we do with NFT_FIB_INET.

BTW, I think this problem has been is not related to the recent patch,
but something older that kbuild robot has triggered more easily for
some reason?

Thanks for your patch!

--iojt55x3tnaul5vo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d3220b43c832..b48c57bb9aaf 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -601,7 +601,8 @@ config NFT_REJECT
 
 config NFT_REJECT_INET
 	depends on NF_TABLES_INET
-	default NFT_REJECT
+	depends on NFT_REJECT_IPV4
+	depends on NFT_REJECT_IPV6
 	tristate
 
 config NFT_COMPAT

--iojt55x3tnaul5vo--
