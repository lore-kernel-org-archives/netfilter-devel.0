From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: add tests for masquerade
Date: Wed, 15 Oct 2014 12:01:27 +0200
Message-ID: <20141015100127.26222.55158.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: anarey@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35346 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751793AbaJOKBp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:01:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's test the new masquerade option in nftables.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/regression/ip/masquerade.t  |   25 +++++++++++++++++++++++++
 tests/regression/ip6/masquerade.t |   25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+)
 create mode 100644 tests/regression/ip/masquerade.t
 create mode 100644 tests/regression/ip6/masquerade.t

diff --git a/tests/regression/ip/masquerade.t b/tests/regression/ip/masquerade.t
new file mode 100644
index 0000000..c1371b5
--- /dev/null
+++ b/tests/regression/ip/masquerade.t
@@ -0,0 +1,25 @@
+*ip;test-ip4
+:output;type nat hook output priority 0
+
+# nf_nat flags combination
+udp dport 53 masquerade ;ok
+udp dport 53 masquerade random ;ok
+udp dport 53 masquerade random,persistent ;ok
+udp dport 53 masquerade random,persistent,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade random,random-fully ;ok
+udp dport 53 masquerade random,random-fully,persistent ;ok
+udp dport 53 masquerade persistent ;ok
+udp dport 53 masquerade persistent,random ;ok ;udp dport 53 masquerade random,persistent
+udp dport 53 masquerade persistent,random,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade persistent,random-fully ;ok ;udp dport 53 masquerade random-fully,persistent
+udp dport 53 masquerade persistent,random-fully,random;ok ;udp dport 53 masquerade random,random-fully,persistent
+
+# masquerade is a terminal statement
+tcp dport 22 masquerade counter packets 0 bytes 0 accept ;nok
+tcp sport 22 masquerade accept ;nok
+ip saddr 10.1.1.1 masquerade drop ;nok
+
+# masquerade with sets
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade ;ok
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade ;ok ;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade ;ok
diff --git a/tests/regression/ip6/masquerade.t b/tests/regression/ip6/masquerade.t
new file mode 100644
index 0000000..edbf317
--- /dev/null
+++ b/tests/regression/ip6/masquerade.t
@@ -0,0 +1,25 @@
+*ip6;test-ip6
+:output;type nat hook output priority 0
+
+# nf_nat flags combination
+udp dport 53 masquerade ;ok
+udp dport 53 masquerade random ;ok
+udp dport 53 masquerade random,persistent ;ok
+udp dport 53 masquerade random,persistent,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade random,random-fully ;ok
+udp dport 53 masquerade random,random-fully,persistent ;ok
+udp dport 53 masquerade persistent ;ok
+udp dport 53 masquerade persistent,random ;ok ;udp dport 53 masquerade random,persistent
+udp dport 53 masquerade persistent,random,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade persistent,random-fully ;ok ;udp dport 53 masquerade random-fully,persistent
+udp dport 53 masquerade persistent,random-fully,random;ok ;udp dport 53 masquerade random,random-fully,persistent
+
+# masquerade is a terminal statement
+tcp dport 22 masquerade counter packets 0 bytes 0 accept ;nok
+tcp sport 22 masquerade accept ;nok
+ip6 saddr ::1 masquerade drop ;nok
+
+# masquerade with sets
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade ;ok
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade ;ok ;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade ;ok

