From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCHv2] extensions: libxt_cluster: Add translation to nft
Date: Tue, 30 May 2017 13:55:34 +0530
Message-ID: <1496132734-3829-1-git-send-email-mayhs11saini@gmail.com>
Cc: pablo@netfilter.org, arturo@debian.org, fw@strlen.de,
        Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32944 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdE3I0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 04:26:25 -0400
Received: by mail-pf0-f196.google.com with SMTP id f27so16350529pfe.0
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 01:26:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for cluster match to nftables

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff
nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
0xffff

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff
nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
0xffff

 --debug=netlink Result
ip mangle PREROUTING
  [ meta load iifname => reg 1 ]
  [ cmp eq reg 1 0x31687465 0x00000000 0x00000000 0x00000000 ]
  [ ct load src => reg 2 , dir original ]
  [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
  [ cmp eq reg 1 0x00000000 ]
  [ immediate reg 1 0x00000000 ]
  [ meta set pkttype with reg 1 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 1 0x0000ffff ]
  [ meta set mark with reg 1 ]

For Example:

If we have  total 2 nodes (i.e, --cluster-total-nodes is 2) in the cluster then
 modulus 2 = {0, 1}

For node 1 (--cluster-local-node 1)
	jhash ct original saddr mod 2 seed 0xdeadbeef eq 0

For  node 2 (--cluster-local-node 2)
	jhash ct original saddr mod 2 seed 0xdeadbeef eq 1

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 extensions/libxt_cluster.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index 3adff12..f2abd18 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -126,6 +126,16 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
 		info->total_nodes, info->hash_seed);
 }
 
+static int cluster_xlate(struct xt_xlate *xl,
+		const struct xt_xlate_mt_params *params)
+{
+	const struct xt_cluster_match_info *info = (const struct xt_cluster_match_info *)params->match->data;
+
+	xt_xlate_add(xl, "jhash ct original saddr mod %u seed 0x%08x eq 0 meta pkttype set host",
+			info->total_nodes, info->hash_seed);
+	return 1;
+
+}
+
 static struct xtables_match cluster_mt_reg = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "cluster",
@@ -138,6 +148,7 @@ static struct xtables_match cluster_mt_reg = {
 	.x6_parse	= cluster_parse,
 	.x6_fcheck	= cluster_check,
 	.x6_options	= cluster_opts,
+	.xlate		= cluster_xlate,
 };
 
 void _init(void)
-- 
1.9.1

