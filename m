From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] tests/regression: masquerade: fix invalid syntax
Date: Fri, 07 Nov 2014 12:39:24 +0100
Message-ID: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60511 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbaKGLjk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:39:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes invalid syntax in the masquerade test files.

I used ' ;ok' instead of ';ok', and ' ;nok' instead of ';fail'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/regression/ip/masquerade.t  |   34 +++++++++++++++++-----------------
 tests/regression/ip6/masquerade.t |   34 +++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tests/regression/ip/masquerade.t b/tests/regression/ip/masquerade.t
index c1371b5..c2840b0 100644
--- a/tests/regression/ip/masquerade.t
+++ b/tests/regression/ip/masquerade.t
@@ -2,24 +2,24 @@
 :output;type nat hook output priority 0
 
 # nf_nat flags combination
-udp dport 53 masquerade ;ok
-udp dport 53 masquerade random ;ok
-udp dport 53 masquerade random,persistent ;ok
-udp dport 53 masquerade random,persistent,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
-udp dport 53 masquerade random,random-fully ;ok
-udp dport 53 masquerade random,random-fully,persistent ;ok
-udp dport 53 masquerade persistent ;ok
-udp dport 53 masquerade persistent,random ;ok ;udp dport 53 masquerade random,persistent
-udp dport 53 masquerade persistent,random,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
-udp dport 53 masquerade persistent,random-fully ;ok ;udp dport 53 masquerade random-fully,persistent
-udp dport 53 masquerade persistent,random-fully,random;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade;ok
+udp dport 53 masquerade random;ok
+udp dport 53 masquerade random,persistent;ok
+udp dport 53 masquerade random,persistent,random-fully;ok;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade random,random-fully;ok
+udp dport 53 masquerade random,random-fully,persistent;ok
+udp dport 53 masquerade persistent;ok
+udp dport 53 masquerade persistent,random;ok;udp dport 53 masquerade random,persistent
+udp dport 53 masquerade persistent,random,random-fully;ok;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade persistent,random-fully;ok;udp dport 53 masquerade random-fully,persistent
+udp dport 53 masquerade persistent,random-fully,random;ok;udp dport 53 masquerade random,random-fully,persistent
 
 # masquerade is a terminal statement
-tcp dport 22 masquerade counter packets 0 bytes 0 accept ;nok
-tcp sport 22 masquerade accept ;nok
-ip saddr 10.1.1.1 masquerade drop ;nok
+tcp dport 22 masquerade counter packets 0 bytes 0 accept;fail
+tcp sport 22 masquerade accept;fail
+ip saddr 10.1.1.1 masquerade drop;fail
 
 # masquerade with sets
-tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade ;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade ;ok ;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
-iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade ;ok
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok
diff --git a/tests/regression/ip6/masquerade.t b/tests/regression/ip6/masquerade.t
index edbf317..c0f8b87 100644
--- a/tests/regression/ip6/masquerade.t
+++ b/tests/regression/ip6/masquerade.t
@@ -2,24 +2,24 @@
 :output;type nat hook output priority 0
 
 # nf_nat flags combination
-udp dport 53 masquerade ;ok
-udp dport 53 masquerade random ;ok
-udp dport 53 masquerade random,persistent ;ok
-udp dport 53 masquerade random,persistent,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
-udp dport 53 masquerade random,random-fully ;ok
-udp dport 53 masquerade random,random-fully,persistent ;ok
-udp dport 53 masquerade persistent ;ok
-udp dport 53 masquerade persistent,random ;ok ;udp dport 53 masquerade random,persistent
-udp dport 53 masquerade persistent,random,random-fully ;ok ;udp dport 53 masquerade random,random-fully,persistent
-udp dport 53 masquerade persistent,random-fully ;ok ;udp dport 53 masquerade random-fully,persistent
-udp dport 53 masquerade persistent,random-fully,random;ok ;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade;ok
+udp dport 53 masquerade random;ok
+udp dport 53 masquerade random,persistent;ok
+udp dport 53 masquerade random,persistent,random-fully;ok;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade random,random-fully;ok
+udp dport 53 masquerade random,random-fully,persistent;ok
+udp dport 53 masquerade persistent;ok
+udp dport 53 masquerade persistent,random;ok;udp dport 53 masquerade random,persistent
+udp dport 53 masquerade persistent,random,random-fully;ok;udp dport 53 masquerade random,random-fully,persistent
+udp dport 53 masquerade persistent,random-fully;ok;udp dport 53 masquerade random-fully,persistent
+udp dport 53 masquerade persistent,random-fully,random;ok;udp dport 53 masquerade random,random-fully,persistent
 
 # masquerade is a terminal statement
-tcp dport 22 masquerade counter packets 0 bytes 0 accept ;nok
-tcp sport 22 masquerade accept ;nok
-ip6 saddr ::1 masquerade drop ;nok
+tcp dport 22 masquerade counter packets 0 bytes 0 accept;fail
+tcp sport 22 masquerade accept;fail
+ip6 saddr ::1 masquerade drop;fail
 
 # masquerade with sets
-tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade ;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade ;ok ;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
-iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade ;ok
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade;ok;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok

