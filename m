From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: regression: ip6: reduce warning noise
Date: Sat, 13 Jun 2015 20:51:09 +0200
Message-ID: <1434221469-15380-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39865 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbbFMSqC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Jun 2015 14:46:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

getnameinfo() displays this:

 ::1234:1234:1234:1234:1234:1234:1234

as:

 0:1234:1234:1234:1234:1234:1234:1234

which is basically equivalent. nft accepts both inputs.

So add some exceptions to the tests to reduce the amount of noise in the tests,
so we can focus on real problems.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/ip6/ip6.t  |   21 +++++++++++----------
 tests/regression/ip6/vmap.t |   26 +++++++++++++-------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/tests/regression/ip6/ip6.t b/tests/regression/ip6/ip6.t
index 529a068..d4c5c7e 100644
--- a/tests/regression/ip6/ip6.t
+++ b/tests/regression/ip6/ip6.t
@@ -59,21 +59,22 @@ ip6 hoplimit {33-55};ok
 # v680		(({hex4}:){7}{hex4})
 ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234;ok
 # v670		((:)(:{hex4}{7}))
-ip6 saddr ::1234:1234:1234:1234:1234:1234:1234;ok
+ip6 saddr ::1234:1234:1234:1234:1234:1234:1234;ok;ip6 saddr 0:1234:1234:1234:1234:1234:1234:1234
 # v671		((({hex4}:){1})(:{hex4}{6}))
-ip6 saddr 1234::1234:1234:1234:1234:1234:1234;ok
+ip6 saddr 1234::1234:1234:1234:1234:1234:1234;ok;ip6 saddr 1234:0:1234:1234:1234:1234:1234:1234
 # v672		((({hex4}:){2})(:{hex4}{5}))
-ip6 saddr 1234:1234::1234:1234:1234:1234:1234;ok
+ip6 saddr 1234:1234::1234:1234:1234:1234:1234;ok;ip6 saddr 1234:1234:0:1234:1234:1234:1234:1234
+ip6 saddr 1234:1234:0:1234:1234:1234:1234:1234;ok
 # v673		((({hex4}:){3})(:{hex4}{4}))
-ip6 saddr 1234:1234:1234::1234:1234:1234:1234;ok
+ip6 saddr 1234:1234:1234::1234:1234:1234:1234;ok;ip6 saddr 1234:1234:1234:0:1234:1234:1234:1234
 # v674		((({hex4}:){4})(:{hex4}{3}))
-ip6 saddr 1234:1234:1234:1234::1234:1234:1234;ok
+ip6 saddr 1234:1234:1234:1234:0:1234:1234:1234;ok
 # v675		((({hex4}:){5})(:{hex4}{2}))
-ip6 saddr 1234:1234:1234:1234:1234::1234:1234;ok
+ip6 saddr 1234:1234:1234:1234:1234::1234:1234;ok;ip6 saddr 1234:1234:1234:1234:1234:0:1234:1234
 # v676		((({hex4}:){6})(:{hex4}{1}))
-ip6 saddr 1234:1234:1234:1234:1234:1234::1234;ok
+ip6 saddr 1234:1234:1234:1234:1234:1234:0:1234;ok
 # v677		((({hex4}:){7})(:))
-ip6 saddr 1234:1234:1234:1234:1234:1234:1234::;ok
+ip6 saddr 1234:1234:1234:1234:1234:1234:1234::;ok;ip6 saddr 1234:1234:1234:1234:1234:1234:1234:0
 # v67		({v670}|{v671}|{v672}|{v673}|{v674}|{v675}|{v676}|{v677})
 # v660		((:)(:{hex4}{6}))
 ip6 saddr ::1234:1234:1234:1234:1234:1234;ok
@@ -124,7 +125,7 @@ ip6 saddr 1234:1234::1234;ok
 ip6 saddr 1234:1234:1234::;ok
 # v63		({v630}|{v631}|{v632}|{v633})
 # v620		((:)(:{hex4}{2}))
-ip6 saddr ::1234:1234;ok
+ip6 saddr ::1234:1234;ok;ip6 saddr ::18.52.18.52
 # v621		((({hex4}:){1})(:{hex4}{1}))
 ip6 saddr 1234::1234;ok
 # v622		((({hex4}:){2})(:))
@@ -139,4 +140,4 @@ ip6 saddr 1234::;ok
 ip6 saddr ::/64;ok
 
 - ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok
-ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok
+ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok;ip6 daddr != 0:1234:1234:1234:1234:1234:1234:1234-1234:1234:0:1234:1234:1234:1234:1234
diff --git a/tests/regression/ip6/vmap.t b/tests/regression/ip6/vmap.t
index 705f369..301a28a 100644
--- a/tests/regression/ip6/vmap.t
+++ b/tests/regression/ip6/vmap.t
@@ -8,14 +8,14 @@ ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
 # Ipv6 address combinations
 # from src/scanner.l
 ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept};ok
-ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept};ok
-ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept};ok
-ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept};ok;ip6 saddr vmap { 0:1234:1234:1234:1234:1234:1234:1234 : accept}
+ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept};ok;ip6 saddr vmap { 1234:0:1234:1234:1234:1234:1234:1234 : accept}
+ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept};ok;ip6 saddr vmap { 1234:1234:0:1234:1234:1234:1234:1234 : accept}
+ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept};ok;ip6 saddr vmap { 1234:1234:1234:0:1234:1234:1234:1234 : accept}
+ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept};ok;ip6 saddr vmap { 1234:1234:1234:1234:0:1234:1234:1234 : accept}
+ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept};ok;ip6 saddr vmap { 1234:1234:1234:1234:1234:0:1234:1234 : accept}
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept};ok;ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:0:1234 : accept}
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept};ok;ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:0 : accept}
 ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept};ok
@@ -38,17 +38,17 @@ ip6 saddr vmap { ::1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234::1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234::1234 : accept};ok
 ip6 saddr vmap { 1234:1234:1234:: : accept};ok
-ip6 saddr vmap { ::1234:1234 : accept};ok
+ip6 saddr vmap { ::1234:1234 : accept};ok;ip6 saddr vmap { ::18.52.18.52 : accept}
 ip6 saddr vmap { 1234::1234 : accept};ok
 ip6 saddr vmap { 1234:1234:: : accept};ok
 ip6 saddr vmap { ::1234 : accept};ok
 ip6 saddr vmap { 1234:: : accept};ok
 ip6 saddr vmap { ::/64 : accept};ok
 
-ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop};ok
-ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop};ok
-ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop};ok
-ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop};ok
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop};ok;ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:0 : accept, ::aaaa : drop}
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop};ok;ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:0 : accept, ::bbbb : drop}
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop};ok;ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:0 : accept, ::cccc : drop}
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop};ok;ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:0 : accept, ::dddd: drop}
 
 # rule without comma:
 filter-input ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:bbbb:::accept::adda : drop};fail
-- 
1.7.10.4

