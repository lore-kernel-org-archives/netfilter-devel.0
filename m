From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [Iptables PATCH] extensions: Add test for cluster nft translation
Date: Tue, 16 Jan 2018 21:50:13 +0530
Message-ID: <1516119613-9709-1-git-send-email-mayhs11saini@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Shyam Saini <mayhs11saini@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36857 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbeAPQUa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:20:30 -0500
Received: by mail-pg0-f65.google.com with SMTP id k68so2105151pga.3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 08:20:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test cases for iptables to nft translation of cluster match
This adds all test cases including corner cases.

Run these test cases like:

	$ ./xlate-test.py extensions/libxt_cluster.txlate

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 extensions/libxt_cluster.txlate | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 extensions/libxt_cluster.txlate

diff --git a/extensions/libxt_cluster.txlate b/extensions/libxt_cluster.txlate
new file mode 100644
index 0000000..5ce698a
--- /dev/null
+++ b/extensions/libxt_cluster.txlate
@@ -0,0 +1,26 @@
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 1 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 1 --cluster-local-nodemask 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-node 32 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 32 seed 0xdeadbeef eq 32 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-nodemask 32 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 32 seed 0xdeadbeef eq 6 meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-nodemask 5 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 32 seed 0xdeadbeef { 0, 2 } meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 7 --cluster-local-nodemask 9 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 7 seed 0xdeadbeef { 0, 3 } meta pkttype set host counter meta mark set 0xffff 
+
+iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 7 --cluster-local-node 5 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
+nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set 0xffff 
-- 
1.9.1

