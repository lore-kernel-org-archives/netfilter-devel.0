From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/4] tests: regression: log.t: this works for bridge and arp since 3.17
Date: Sun, 14 Dec 2014 18:01:03 +0100
Message-ID: <1418576463-3606-5-git-send-email-pablo@netfilter.org>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45151 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaLNQ7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:59:08 -0500
In-Reply-To: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So tests log statement for those two families too and remove the
tests/selectors that are ip and ip6 specific, they don't belong here.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/log.t |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tests/regression/any/log.t b/tests/regression/any/log.t
index 2bc2543..0eed580 100644
--- a/tests/regression/any/log.t
+++ b/tests/regression/any/log.t
@@ -1,11 +1,10 @@
 *ip;test-ip4
 *ip6;test-ip6
 *inet;test-inet
-- *arp;test-arp
-- *bridge;test-bridge
+*arp;test-arp
+*bridge;test-bridge
 :output;type filter hook output priority 0
 
-ct direction original log;ok
 log;ok
 log level emerg;ok
 log level alert;ok
@@ -19,9 +18,9 @@ log level debug;ok
 log level emerg group 2;fail
 log level alert group 2 prefix "log test2";fail
 
-udp dport 200 log prefix aaaaa-aaaaaa group 2 snaplen 33;ok;udp dport 200 log prefix "aaaaa-aaaaaa" group 2 snaplen 33
+log prefix aaaaa-aaaaaa group 2 snaplen 33;ok;log prefix "aaaaa-aaaaaa" group 2 snaplen 33
 # TODO: Add an exception: 'queue-threshold' attribute needs 'group' attribute
 # The correct rule is log group 2 queue-threshold 2
 log group 2 queue-threshold 2;ok
 log group 2 snaplen 33;ok
-tcp dport 300 log group 2 prefix \"IPTABLES-NFT SSH\";ok;tcp dport 300 log prefix "IPTABLES-NFT SSH" group 2
+log group 2 prefix \"nft-test: \";ok;log prefix "nft-test: " group 2
-- 
1.7.10.4

