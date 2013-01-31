From: pablo@netfilter.org
Subject: [nftables 9/9] netfilter: nf_tables: statify chain definition to fix sparse warning
Date: Thu, 31 Jan 2013 01:04:05 +0100
Message-ID: <1359590645-4703-9-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:52058 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:37 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

  CHECK   net/ipv4/netfilter/nft_chain_route_ipv4.c
net/ipv4/netfilter/nft_chain_route_ipv4.c:63:22: warning: symbol 'nft_chain_route_ipv4' was not declared. Should it be static?

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nft_chain_nat_ipv4.c   |    2 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c |    2 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c   |    2 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index e42d6d9..cf2c792 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -164,7 +164,7 @@ static unsigned int nf_nat_output(const struct nf_hook_ops *ops,
 	return ret;
 }
 
-struct nf_chain_type nft_chain_nat_ipv4 = {
+static struct nf_chain_type nft_chain_nat_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index 4b4fd08..8c55ba3 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -60,7 +60,7 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 	return ret;
 }
 
-struct nf_chain_type nft_chain_route_ipv4 = {
+static struct nf_chain_type nft_chain_route_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.name		= "route",
 	.type		= NFT_CHAIN_T_ROUTE,
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index 9f283dd..e86dcd7 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -170,7 +170,7 @@ static unsigned int nf_nat_ipv6_output(const struct nf_hook_ops *ops,
 	return ret;
 }
 
-struct nf_chain_type nft_chain_nat_ipv6 = {
+static struct nf_chain_type nft_chain_nat_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index c70d2de..dc4e2dd 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -58,7 +58,7 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 	return ret;
 }
 
-struct nf_chain_type nft_chain_route_ipv6 = {
+static struct nf_chain_type nft_chain_route_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.name		= "route",
 	.type		= NFT_CHAIN_T_ROUTE,
-- 
1.7.10.4

