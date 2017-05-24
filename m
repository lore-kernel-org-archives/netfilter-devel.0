From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Wed, 24 May 2017 18:01:51 +0530
Message-ID: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
Cc: pablo@netfilter.org, arturo@debian.org, fw@strlen.de,
        Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34740 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764715AbdEXMcQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 08:32:16 -0400
Received: by mail-pg0-f42.google.com with SMTP id u28so65223860pgn.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 05:32:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for cluster to nft

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff

nft add rule ip mangle PREROUTING iifname eth1 ct state {new,established, related, untracked} ct direction original mark set jhash ip saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff

nft add rule ip mangle PREROUTING iifname eth1 ct state {new,established, related, untracked} ct direction original mark set jhash ip saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff

--debug=netlink result
__set%d mangle 3
__set%d mangle 0
	element 00000008  : 0 [end]	element 00000002  : 0 [end]
element 00000004  : 0 [end]	element 00000040  : 0 [end]
ip mangle PREROUTING
  [ meta load iifname => reg 1 ]
  [ cmp eq reg 1 0x31687465 0x00000000 0x00000000 0x00000000 ]
  [ ct load state => reg 1 ]
  [ lookup reg 1 set __set%d ]
  [ ct load direction => reg 1 ]
  [ cmp eq reg 1 0x00000000 ]
  [ payload load 4b @ network header + 12 => reg 2 ]
  [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 offset 1 ]
  [ meta set mark with reg 1 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 1 0x0000ffff ]
  [ meta set mark with reg 1 ]

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 extensions/libxt_cluster.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index 3adff12..8891f47 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -126,6 +126,17 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
 		info->total_nodes, info->hash_seed);
 }
 
+static int 
+cluster_xlate(struct xt_xlate *xl, const struct xt_entry_match *match, int numeric)
+{
+	char ct_statement[256] = "ct state {new,established, related, untracked} ct direction original";
+	const struct xt_cluster_match_info *info = (void *)match->data;
+	xt_xlate_add(xl, "%s mark set jhash ip saddr mod %u seed 0x%x offset %u",
+			ct_statement, info->total_nodes, info->hash_seed, info->node_mask);
+	return 1;
+
+}
+
 static struct xtables_match cluster_mt_reg = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "cluster",
@@ -138,6 +149,7 @@ static struct xtables_match cluster_mt_reg = {
 	.x6_parse	= cluster_parse,
 	.x6_fcheck	= cluster_check,
 	.x6_options	= cluster_opts,
+	.xlate		= cluster_xlate,
 };
 
 void _init(void)
-- 
1.9.1

