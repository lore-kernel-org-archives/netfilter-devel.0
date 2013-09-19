From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables 3/3] netfilter: fix missing dependency
Date: Thu, 19 Sep 2013 22:18:53 +0200
Message-ID: <1379621933-6064-3-git-send-email-pablo@netfilter.org>
References: <1379621933-6064-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3ISUTH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:19:07 -0400
In-Reply-To: <1379621933-6064-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With CONFIG_NFT_CHAIN_NAT_IPV4=3Dy

net/ipv4/netfilter/nft_chain_nat_ipv4.c: In function =E2=80=98nf_nat_fn=
=E2=80=99:
net/ipv4/netfilter/nft_chain_nat_ipv4.c:56:1: error: =E2=80=98NF_CT_EXT=
_NAT=E2=80=99 undeclared (first use in this function)
net/ipv4/netfilter/nft_chain_nat_ipv4.c:56:1: note: each undeclared ide=
ntifier is reported only once for each function it appears in

Reported-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig |    2 +-
 net/ipv6/netfilter/Kconfig |    2 +-
 net/netfilter/Kconfig      |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 4d6f03a..1ea0da4 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -50,7 +50,7 @@ config NFT_CHAIN_ROUTE_IPV4
=20
 config NFT_CHAIN_NAT_IPV4
 	depends on NF_TABLES_IPV4
-	depends on NFT_NAT
+	depends on NF_NAT_IPV4 && NFT_NAT
 	tristate "IPv4 nf_tables nat chain support"
=20
 config NF_TABLES_ARP
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 61270d1..4863516 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -35,7 +35,7 @@ config NFT_CHAIN_ROUTE_IPV6
=20
 config NFT_CHAIN_NAT_IPV6
 	depends on NF_TABLES_IPV6
-	depends on NFT_NAT
+	depends on NF_NAT_IPV6 && NFT_NAT
 	tristate "IPv6 nf_tables nat chain support"
=20
 config IP6_NF_IPTABLES
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2e0c3f8..8e2ffe3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -464,6 +464,7 @@ config NFT_LIMIT
 config NFT_NAT
 	depends on NF_TABLES
 	depends on NF_CONNTRACK
+	depends on NF_NAT
 	tristate "Netfilter nf_tables nat module"
=20
 config NFT_COMPAT
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
