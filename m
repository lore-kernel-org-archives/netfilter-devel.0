Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70358C6FA90
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Sep 2022 12:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiIWMWl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Sep 2022 08:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiIWMV7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2022 08:21:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7CD135054
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2022 05:17:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1obhcZ-0004xj-6L; Fri, 23 Sep 2022 14:17:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft] tests: extend native delinearize script
Date:   Fri, 23 Sep 2022 14:17:25 +0200
Message-Id: <20220923121725.875-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Feed nft-generated ruleset to iptables-nft.
At this time, this will NOT pass. because dissector can handle

  meta l4proto tcp ip saddr 1.2.3.4
but not
  ip saddr 1.2.3.4 meta l4proto tcp

In the latter case, iptables-nft picks up the immediate value (6) as the ip
address, because the first one (1.2.3.4) gets moved as PAYLOAD_PREV due to
missing 'removal' of the CTX_PAYLOAD flag.

This is error prone, so lets rewrite the dissector to track each
register separately and auto-clear state on writes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../nft-only/0010-iptables-nft-save.txt       | 26 ++++++++++++
 .../nft-only/0010-native-delinearize_0        | 21 +---------
 .../testcases/nft-only/0010-nft-native.txt    | 41 +++++++++++++++++++
 3 files changed, 69 insertions(+), 19 deletions(-)
 create mode 100644 iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
 create mode 100644 iptables/tests/shell/testcases/nft-only/0010-nft-native.txt

diff --git a/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
new file mode 100644
index 000000000000..73d7108c5094
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
@@ -0,0 +1,26 @@
+*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+-A INPUT -s 1.2.3.4/32 -p tcp -m tcp --dport 23 -j ACCEPT
+-A INPUT -s 1.2.3.0/24 -d 0.0.0.0/32 -p udp -m udp --dport 67:69 -j DROP
+-A INPUT -s 1.0.0.0/8 -d 0.0.0.0/32 -p tcp -m tcp --sport 1024:65535 --dport 443 --tcp-flags SYN,ACK SYN -j ACCEPT
+-A INPUT -p tcp -m tcp --dport 443 ! --tcp-flags SYN NONE -m comment --comment "checks if SYN bit is set"
+-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m comment --comment "same as iptables --syn"
+-A INPUT -p tcp -m tcp --tcp-flags SYN SYN
+-A INPUT -p tcp -m tcp ! --tcp-flags SYN,ACK SYN,ACK
+-A INPUT -d 0.0.0.0/1 -m ttl --ttl-eq 1 -j DROP
+-A INPUT -d 0.0.0.0/2 -m ttl --ttl-gt 2 -j ACCEPT
+-A INPUT -d 0.0.0.0/3 -m ttl --ttl-lt 254 -j ACCEPT
+-A INPUT -d 0.0.0.0/4 -m ttl ! --ttl-eq 255 -j DROP
+-A INPUT -d 8.0.0.0/5 -p icmp -j ACCEPT
+-A INPUT -d 8.0.0.0/6 -p icmp -j ACCEPT
+-A INPUT -d 10.0.0.0/7 -p icmp -j ACCEPT
+-A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
+-A INPUT -m pkttype ! --pkt-type unicast -j DROP
+-A INPUT -p tcp
+-A INPUT -d 0.0.0.0/1 -p udp
+-A FORWARD -m limit --limit 10/day
+-A FORWARD -p udp -m udp --dport 42
+-A FORWARD -i lo -o lo+ -j NFLOG --nflog-prefix "should use NFLOG" --nflog-group 1 --nflog-size 123 --nflog-threshold 42
+COMMIT
diff --git a/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0 b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
index cca36fd88d6c..7859e76c9dd5 100755
--- a/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
+++ b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
@@ -5,22 +5,5 @@ nft -v >/dev/null || exit 0
 
 set -e
 
-nft -f - <<EOF
-table ip filter {
-	chain FORWARD {
-		type filter hook forward priority filter;
-		limit rate 10/day counter
-		udp dport 42 counter
-	}
-}
-EOF
-
-EXPECT="*filter
-:INPUT ACCEPT [0:0]
-:FORWARD ACCEPT [0:0]
-:OUTPUT ACCEPT [0:0]
--A FORWARD -m limit --limit 10/day
--A FORWARD -p udp -m udp --dport 42
-COMMIT"
-
-diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save | grep -v '^#')
+unshare -n bash -c "nft -f $(dirname $0)/0010-nft-native.txt;
+  diff -u -Z $(dirname $0)/0010-iptables-nft-save.txt <($XT_MULTI iptables-save | grep -v '^#')"
diff --git a/iptables/tests/shell/testcases/nft-only/0010-nft-native.txt b/iptables/tests/shell/testcases/nft-only/0010-nft-native.txt
new file mode 100644
index 000000000000..d37ce8733924
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0010-nft-native.txt
@@ -0,0 +1,41 @@
+table ip filter {
+	chain INPUT {
+		type filter hook input priority filter; policy accept;
+
+		ip saddr 1.2.3.4 tcp dport 23 accept
+		ip saddr 1.2.3.0/24 ip daddr 0.0.0.0 udp dport 67-69 drop
+
+		ip saddr 1.0.0.0/8 ip daddr 0.0.0.0 tcp sport 1024-65535 tcp dport 443 tcp flags syn / syn,ack accept
+		tcp dport 443 tcp flags syn comment "checks if SYN bit is set"
+		tcp flags syn / syn,rst,ack,fin comment "same as iptables --syn"
+		tcp flags & syn == syn
+		tcp flags & (syn | ack) != (syn | ack )
+
+		ip daddr 0.0.0.0/1 ip ttl 1 drop
+		ip daddr 0.0.0.0/2 ip ttl > 2 accept
+		ip daddr 0.0.0.0/3 ip ttl < 254 accept
+		ip daddr 0.0.0.0/4 ip ttl != 255 drop
+
+		ip daddr 8.0.0.0/5 icmp type 1 accept
+		ip daddr 8.0.0.0/6 icmp type 2 icmp code port-unreachable accept
+		ip daddr 10.0.0.0/7 icmp type echo-request accept
+
+		meta pkttype broadcast accept
+		meta pkttype != host drop
+
+		ip saddr 0.0.0.0/0 ip protocol tcp
+		ip daddr 0.0.0.0/1 ip protocol udp
+	}
+
+	chain FORWARD {
+		type filter hook forward priority filter;
+		limit rate 10/day counter
+		udp dport 42 counter
+
+		# FIXME: can't dissect plain syslog
+		# meta iif "lo" log prefix "just doing a log" level alert flags tcp sequence,options
+
+		# iif, not iifname, and wildcard
+		meta iif "lo" oifname "lo*" log group 1 prefix "should use NFLOG" queue-threshold 42 snaplen 123
+	}
+}
-- 
2.35.1

