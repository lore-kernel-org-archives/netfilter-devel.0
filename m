From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 05/13] netfilter: nf_tables: add missing module references to chain types
Date: Thu,  9 Jan 2014 18:42:35 +0000
Message-ID: <1389292963-4089-6-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAISnS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:18 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In some cases we neither take a reference to the AF info nor to the
chain type, allowing the module to be unloaded while in use.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/bridge/netfilter/nf_tables_bridge.c | 1 +
 net/ipv4/netfilter/nf_tables_arp.c      | 1 +
 net/ipv4/netfilter/nf_tables_ipv4.c     | 1 +
 net/ipv6/netfilter/nf_tables_ipv6.c     | 1 +
 net/netfilter/nf_tables_inet.c          | 1 +
 5 files changed, 5 insertions(+)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 003c1e9..f97222e 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -72,6 +72,7 @@ static struct nf_chain_type filter_bridge = {
 	.family		= NFPROTO_BRIDGE,
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
+	.me		= THIS_MODULE,
 	.hook_mask	= (1 << NF_BR_LOCAL_IN) |
 			  (1 << NF_BR_FORWARD) |
 			  (1 << NF_BR_LOCAL_OUT),
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 36d27fc..228df00 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -72,6 +72,7 @@ static struct nf_chain_type filter_arp = {
 	.family		= NFPROTO_ARP,
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
+	.me		= THIS_MODULE,
 	.hook_mask	= (1 << NF_ARP_IN) |
 			  (1 << NF_ARP_OUT) |
 			  (1 << NF_ARP_FORWARD),
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index da927dc..d6fc1b4 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -95,6 +95,7 @@ static struct nf_chain_type filter_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
+	.me		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 025e7f4..a340276 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -94,6 +94,7 @@ static struct nf_chain_type filter_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
+	.me		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index ac0edcb..280d3a2 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -70,6 +70,7 @@ static struct nf_chain_type filter_inet = {
 	.family		= NFPROTO_INET,
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
+	.me		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
-- 
1.8.4.2

