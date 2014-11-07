From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3] tests/regression: redirect: fix invalid syntax
Date: Fri, 07 Nov 2014 12:39:30 +0100
Message-ID: <20141107113930.8480.59102.stgit@nfdev.cica.es>
References: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60513 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaKGLjk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:39:40 -0500
In-Reply-To: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes invalid syntax in the redirect test files.

I used ' ;ok' instead of ';ok', and ' ;nok' instead of ';fail'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/regression/ip/redirect.t  |   54 +++++++++++++++++++-------------------
 tests/regression/ip6/redirect.t |   56 ++++++++++++++++++++-------------------
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/tests/regression/ip/redirect.t b/tests/regression/ip/redirect.t
index 8e0f783..f69fd07 100644
--- a/tests/regression/ip/redirect.t
+++ b/tests/regression/ip/redirect.t
@@ -2,40 +2,40 @@
 :output;type nat hook output priority 0
 
 # without arguments
-udp dport 53 redirect ;ok
+udp dport 53 redirect;ok
 
 # nf_nat flags combination
-udp dport 53 redirect random ;ok
-udp dport 53 redirect random,persistent ;ok
-udp dport 53 redirect random,persistent,random-fully ;ok ;udp dport 53 redirect random,random-fully,persistent
-udp dport 53 redirect random,random-fully ;ok
-udp dport 53 redirect random,random-fully,persistent ;ok
-udp dport 53 redirect persistent ;ok
-udp dport 53 redirect persistent,random ;ok ;udp dport 53 redirect random,persistent
-udp dport 53 redirect persistent,random,random-fully ;ok ;udp dport 53 redirect random,random-fully,persistent
-udp dport 53 redirect persistent,random-fully ;ok ;udp dport 53 redirect random-fully,persistent
-udp dport 53 redirect persistent,random-fully,random;ok ;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect random;ok
+udp dport 53 redirect random,persistent;ok
+udp dport 53 redirect random,persistent,random-fully;ok;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect random,random-fully;ok
+udp dport 53 redirect random,random-fully,persistent;ok
+udp dport 53 redirect persistent;ok
+udp dport 53 redirect persistent,random;ok;udp dport 53 redirect random,persistent
+udp dport 53 redirect persistent,random,random-fully;ok;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect persistent,random-fully;ok;udp dport 53 redirect random-fully,persistent
+udp dport 53 redirect persistent,random-fully,random;ok;udp dport 53 redirect random,random-fully,persistent
 
 # port specification
-tcp dport 22 redirect :22 ;ok
-udp dport 1234 redirect :4321 ;ok
-ip daddr 172.16.0.1 udp dport 9998 redirect :6515 ;ok
-tcp dport 39128 redirect :993 ;ok
-redirect :1234 ;nok
-redirect :12341111 ;nok
+tcp dport 22 redirect :22;ok
+udp dport 1234 redirect :4321;ok
+ip daddr 172.16.0.1 udp dport 9998 redirect :6515;ok
+tcp dport 39128 redirect :993;ok
+redirect :1234;fail
+redirect :12341111;fail
 
 # invalid arguments
-tcp dport 9128 redirect :993 random ;nok
-tcp dport 9128 redirect :993 random-fully ;nok
-tcp dport 9128 redirect persistent :123 ;nok
-tcp dport 9128 redirect random,persistent :123 ;nok
+tcp dport 9128 redirect :993 random;fail
+tcp dport 9128 redirect :993 random-fully;fail
+tcp dport 9128 redirect persistent :123;fail
+tcp dport 9128 redirect random,persistent :123;fail
 
 # redirect is a terminal statement
-tcp dport 22 redirect counter packets 0 bytes 0 accept ;nok
-tcp sport 22 redirect accept ;nok
-ip saddr 10.1.1.1 redirect drop ;nok
+tcp dport 22 redirect counter packets 0 bytes 0 accept;fail
+tcp sport 22 redirect accept;fail
+ip saddr 10.1.1.1 redirect drop;fail
 
 # redirect with sets
-tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} redirect ;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect ;ok ;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect
-iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect ;ok
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} redirect;ok
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
diff --git a/tests/regression/ip6/redirect.t b/tests/regression/ip6/redirect.t
index 84ed88f..d972871 100644
--- a/tests/regression/ip6/redirect.t
+++ b/tests/regression/ip6/redirect.t
@@ -2,41 +2,41 @@
 :output;type nat hook output priority 0
 
 # with no arguments
-redirect ;ok
-udp dport 954 redirect ;ok
-ip6 saddr fe00::cafe counter packets 0 bytes 0 redirect ;ok
+redirect;ok
+udp dport 954 redirect;ok
+ip6 saddr fe00::cafe counter packets 0 bytes 0 redirect;ok
 
 # nf_nat flags combination
-udp dport 53 redirect random ;ok
-udp dport 53 redirect random,persistent ;ok
-udp dport 53 redirect random,persistent,random-fully ;ok ;udp dport 53 redirect random,random-fully,persistent
-udp dport 53 redirect random,random-fully ;ok
-udp dport 53 redirect random,random-fully,persistent ;ok
-udp dport 53 redirect persistent ;ok
-udp dport 53 redirect persistent,random ;ok ;udp dport 53 redirect random,persistent
-udp dport 53 redirect persistent,random,random-fully ;ok ;udp dport 53 redirect random,random-fully,persistent
-udp dport 53 redirect persistent,random-fully ;ok ;udp dport 53 redirect random-fully,persistent
-udp dport 53 redirect persistent,random-fully,random;ok ;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect random;ok
+udp dport 53 redirect random,persistent;ok
+udp dport 53 redirect random,persistent,random-fully;ok;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect random,random-fully;ok
+udp dport 53 redirect random,random-fully,persistent;ok
+udp dport 53 redirect persistent;ok
+udp dport 53 redirect persistent,random;ok;udp dport 53 redirect random,persistent
+udp dport 53 redirect persistent,random,random-fully;ok;udp dport 53 redirect random,random-fully,persistent
+udp dport 53 redirect persistent,random-fully;ok;udp dport 53 redirect random-fully,persistent
+udp dport 53 redirect persistent,random-fully,random;ok;udp dport 53 redirect random,random-fully,persistent
 
 # port specification
-udp dport 1234 redirect :1234 ;ok
-ip6 daddr fe00::cafe udp dport 9998 redirect :6515 ;ok
-tcp dport 39128 redirect :993 ;ok
-redirect :1234 ;nok
-redirect :12341111 ;nok
+udp dport 1234 redirect :1234;ok
+ip6 daddr fe00::cafe udp dport 9998 redirect :6515;ok
+tcp dport 39128 redirect :993;ok
+redirect :1234;fail
+redirect :12341111;fail
 
 # invalid arguments
-tcp dport 9128 redirect :993 random ;nok
-tcp dport 9128 redirect :993 random-fully ;nok
-tcp dport 9128 redirect persistent :123 ;nok
-tcp dport 9128 redirect random,persistent :123 ;nok
+tcp dport 9128 redirect :993 random;fail
+tcp dport 9128 redirect :993 random-fully;fail
+tcp dport 9128 redirect persistent :123;fail
+tcp dport 9128 redirect random,persistent :123;fail
 
 # redirect is a terminal statement
-tcp dport 22 redirect counter packets 0 bytes 0 accept ;nok
-tcp sport 22 redirect accept ;nok
-ip6 saddr ::1 redirect drop ;nok
+tcp dport 22 redirect counter packets 0 bytes 0 accept;fail
+tcp sport 22 redirect accept;fail
+ip6 saddr ::1 redirect drop;fail
 
 # redirect with sets
-tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} redirect ;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect ;ok ;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 redirect
-iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect ;ok
+tcp dport {1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} redirect;ok
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect;ok;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 redirect
+iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok

