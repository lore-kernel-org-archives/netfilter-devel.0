From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] extensions: fix several test errors
Date: Tue, 15 Sep 2015 17:22:35 +0200
Message-ID: <1442330555-13092-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbbIOPQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2015 11:16:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

extensions/libxt_esp.t: ERROR: line 7 (should fail: iptables -A INPUT -p esp -m esp)
extensions/libip6t_rt.t: ERROR: line 5 (should fail: ip6tables -A INPUT -m rt)
extensions/libip6t_ah.t: ERROR: line 15 (should fail: ip6tables -A INPUT -m ah)
extensions/libipt_ah.t: ERROR: line 13 (should fail: iptables -A INPUT -p ah -m ah)

Fixes: 4264de1f270a ("extensions: restore matching any SPI id by default")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libip6t_ah.t |    2 +-
 extensions/libip6t_rt.t |    2 +-
 extensions/libipt_ah.t  |    2 +-
 extensions/libxt_esp.t  |    2 --
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/extensions/libip6t_ah.t b/extensions/libip6t_ah.t
index 36ca7df..c1898d4 100644
--- a/extensions/libip6t_ah.t
+++ b/extensions/libip6t_ah.t
@@ -12,4 +12,4 @@
 -m ah --ahspi invalid;;FAIL
 -m ah --ahspi 0:invalid;;FAIL
 -m ah --ahspi;;FAIL
--m ah;-m ah --ahspi 0;FAIL
+-m ah;=;OK
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
index 553123e..3c7b2d9 100644
--- a/extensions/libip6t_rt.t
+++ b/extensions/libip6t_rt.t
@@ -2,4 +2,4 @@
 -m rt --rt-type 0 --rt-segsleft 1:23 --rt-len 42 --rt-0-res;=;OK
 -m rt --rt-type 0 ! --rt-segsleft 1:23 ! --rt-len 42 --rt-0-res;=;OK
 -m rt ! --rt-type 1 ! --rt-segsleft 12:23 ! --rt-len 42;=;OK
--m rt;-m rt --rtsegsleft 0;FAIL
+-m rt;=;OK
diff --git a/extensions/libipt_ah.t b/extensions/libipt_ah.t
index 2993906..cd85386 100644
--- a/extensions/libipt_ah.t
+++ b/extensions/libipt_ah.t
@@ -10,4 +10,4 @@
 -m ah --ahspi 0;;FAIL
 -m ah --ahspi;;FAIL
 -m ah;;FAIL
--p ah -m ah;-p ah -m ah --ahspi 0;FAIL
+-p ah -m ah;=;OK
diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
index f207def..92c5779 100644
--- a/extensions/libxt_esp.t
+++ b/extensions/libxt_esp.t
@@ -4,7 +4,5 @@
 -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
 -p esp -m esp ! --espspi 0:4294967294;=;OK
 -p esp -m esp --espspi -1;;FAIL
--p esp -m esp;-p esp -m esp --espspi 0;FAIL
-# should fail?
 -p esp -m esp;=;OK
 -m esp;;FAIL
-- 
1.7.10.4

