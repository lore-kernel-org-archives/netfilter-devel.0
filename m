From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 2/2] tests: py: Use stateless option on tests
Date: Tue, 17 Jan 2017 13:44:54 -0200
Message-ID: <20170117154454.GA31287@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:34761 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdAQPpB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 10:45:01 -0500
Received: by mail-ua0-f196.google.com with SMTP id i68so12683910uad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 07:45:01 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To don't trigger false errors because of unrelated traffic on the
tested machine.

Tests, which have rules with counter and 'ok' result, are updated to
avoid new Warnings.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 tests/py/ip/flowtable.t               | 2 +-
 tests/py/ip/flowtable.t.payload       | 2 +-
 tests/py/ip/masquerade.t              | 2 +-
 tests/py/ip/masquerade.t.payload      | 2 +-
 tests/py/ip/redirect.t                | 2 +-
 tests/py/ip/redirect.t.payload        | 2 +-
 tests/py/ip6/flowtable.t              | 4 ++--
 tests/py/ip6/masquerade.t             | 2 +-
 tests/py/ip6/masquerade.t.payload.ip6 | 2 +-
 tests/py/ip6/redirect.t               | 4 ++--
 tests/py/ip6/redirect.t.payload.ip6   | 4 ++--
 tests/py/nft-test.py                  | 2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
index aea57c3..41d5d3b 100644
--- a/tests/py/ip/flowtable.t
+++ b/tests/py/ip/flowtable.t
@@ -2,4 +2,4 @@
 
 *ip;test-ip;input
 
-flow table xyz { ip saddr timeout 30s counter packets 0 bytes 0};ok
+flow table xyz { ip saddr timeout 30s counter};ok
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
index ffadfd2..591abf2 100644
--- a/tests/py/ip/flowtable.t.payload
+++ b/tests/py/ip/flowtable.t.payload
@@ -1,4 +1,4 @@
-# flow table xyz { ip saddr timeout 30s counter packets 0 bytes 0}
+# flow table xyz { ip saddr timeout 30s counter}
 xyz test-ip 31
 xyz test-ip 0
 ip test-ip input 
diff --git a/tests/py/ip/masquerade.t b/tests/py/ip/masquerade.t
index cee6e0e..26c3704 100644
--- a/tests/py/ip/masquerade.t
+++ b/tests/py/ip/masquerade.t
@@ -26,5 +26,5 @@ ip saddr 10.1.1.1 masquerade drop;fail
 
 # masquerade with sets
 tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade;ok
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter masquerade;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index f4bbe99..ad0ea51 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -97,7 +97,7 @@ ip test-ip4 postrouting
   [ lookup reg 1 set __set%d ]
   [ masq ]
 
-# ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
+# ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter masquerade
 ip test-ip4 postrouting
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0000000a ]
diff --git a/tests/py/ip/redirect.t b/tests/py/ip/redirect.t
index f6ddfc0..7932361 100644
--- a/tests/py/ip/redirect.t
+++ b/tests/py/ip/redirect.t
@@ -43,7 +43,7 @@ ip saddr 10.1.1.1 redirect drop;fail
 
 # redirect with sets
 tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect;ok
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index dfb5a3b..1f050bf 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -179,7 +179,7 @@ ip test-ip4 output
   [ lookup reg 1 set __set%d ]
   [ redir ]
 
-# ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect
+# ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter redirect
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0000000a ]
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
index ae408b7..cf0a606 100644
--- a/tests/py/ip6/flowtable.t
+++ b/tests/py/ip6/flowtable.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;input
 
-flow table acct_out { meta iif . ip6 saddr timeout 600s counter };ok;flow table acct_out { iif . ip6 saddr timeout 10m counter packets 0 bytes 0}
-flow table acct_out { ip6 saddr . meta iif timeout 600s counter };ok;flow table acct_out { ip6 saddr . iif timeout 10m counter packets 0 bytes 0}
+flow table acct_out { meta iif . ip6 saddr timeout 600s counter };ok;flow table acct_out { iif . ip6 saddr timeout 10m counter}
+flow table acct_out { ip6 saddr . meta iif timeout 600s counter };ok;flow table acct_out { ip6 saddr . iif timeout 10m counter}
diff --git a/tests/py/ip6/masquerade.t b/tests/py/ip6/masquerade.t
index d36ff76..fea7391 100644
--- a/tests/py/ip6/masquerade.t
+++ b/tests/py/ip6/masquerade.t
@@ -26,5 +26,5 @@ ip6 saddr ::1 masquerade drop;fail
 
 # masquerade with sets
 tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade;ok
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter masquerade;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index ded74c0..31cedf1 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -97,7 +97,7 @@ ip6 test-ip6 postrouting
   [ lookup reg 1 set __set%d ]
   [ masq ]
 
-# ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
+# ip6 daddr fe00::1-fe00::200 udp dport 53 counter masquerade
 ip6 test-ip6 postrouting
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
diff --git a/tests/py/ip6/redirect.t b/tests/py/ip6/redirect.t
index c5d939c..37169bc 100644
--- a/tests/py/ip6/redirect.t
+++ b/tests/py/ip6/redirect.t
@@ -5,7 +5,7 @@
 # with no arguments
 redirect;ok
 udp dport 954 redirect;ok
-ip6 saddr fe00::cafe counter packets 0 bytes 0 redirect;ok
+ip6 saddr fe00::cafe counter redirect;ok
 
 # nf_nat flags combination
 udp dport 53 redirect random;ok
@@ -42,7 +42,7 @@ ip6 saddr ::1 redirect drop;fail
 
 # redirect with sets
 tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect;ok
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 420e1f3..f256326 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -10,7 +10,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x0000ba03 ]
   [ redir ]
 
-# ip6 saddr fe00::cafe counter packets 0 bytes 0 redirect
+# ip6 saddr fe00::cafe counter redirect
 ip6 test-ip6 output
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x000000fe 0x00000000 0x00000000 0xfeca0000 ]
@@ -163,7 +163,7 @@ ip6 test-ip6 output
   [ lookup reg 1 set __set%d ]
   [ redir ]
 
-# ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect
+# ip6 daddr fe00::1-fe00::200 udp dport 53 counter redirect
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index fc7ae60..62b7942 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -625,7 +625,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                                   gotf.name, 1)
 
                 # Check output of nft
-                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table',
+                process = subprocess.Popen([NFT_BIN, '-nnns', 'list', 'table',
                                             table.family, table.name],
                                            shell=False,
                                            stdout=subprocess.PIPE,
-- 
2.7.4

