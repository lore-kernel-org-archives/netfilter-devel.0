From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/3] tests: remove useless logic
Date: Tue,  1 Dec 2015 23:45:22 +0100
Message-ID: <1449009923-10726-2-git-send-email-pablombg@gmail.com>
References: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36402 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbbLAWqG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2015 17:46:06 -0500
Received: by wmww144 with SMTP id w144so192771892wmw.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Dec 2015 14:46:05 -0800 (PST)
In-Reply-To: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the test files, some lines defining tables was commented out with a
minus "-" sign, also used to mark broken rules. This commit replaces
these signs with actual comments "#" and removes the code that handled
the situation.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/regression/any/ct.t     | 4 ++--
 tests/regression/ip/icmp.t    | 2 +-
 tests/regression/ip6/icmpv6.t | 2 +-
 tests/regression/ip6/snat.t   | 2 +-
 tests/regression/nft-test.py  | 2 --
 5 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index ab4b167..0f5394a 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -2,8 +2,8 @@
 *ip6;test-ip6
 *inet;test-inet
 # ct expresion is not supported in arp and bridge family yet.
-- *arp;test-arp
-- *bridge;test-bridge
+# *arp;test-arp
+# *bridge;test-bridge
 
 :output;type filter hook output priority 0
 
diff --git a/tests/regression/ip/icmp.t b/tests/regression/ip/icmp.t
index 9c2aba7..bd00f5c 100644
--- a/tests/regression/ip/icmp.t
+++ b/tests/regression/ip/icmp.t
@@ -1,6 +1,6 @@
 *ip;test-ip4
 # BUG: There is a bug with icmp protocol and inet family.
-- *inet;test-inet
+# *inet;test-inet
 :input;type filter hook input priority 0
 
 icmp type echo-reply accept;ok
diff --git a/tests/regression/ip6/icmpv6.t b/tests/regression/ip6/icmpv6.t
index c86c825..fca903f 100644
--- a/tests/regression/ip6/icmpv6.t
+++ b/tests/regression/ip6/icmpv6.t
@@ -1,6 +1,6 @@
 *ip6;test-ip6
 # BUG: There is a bug with icmpv6 and inet tables
-- *inet;test-inet
+# *inet;test-inet
 :input;type filter hook input priority 0
 
 icmpv6 type destination-unreachable accept;ok
diff --git a/tests/regression/ip6/snat.t b/tests/regression/ip6/snat.t
index 44ca9e4..8f841da 100644
--- a/tests/regression/ip6/snat.t
+++ b/tests/regression/ip6/snat.t
@@ -1,5 +1,5 @@
 *ip6;test-ip6
-- *inet;test-inet
+# *inet;test-inet
 :postrouting;type nat hook postrouting priority 0
 
 tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok;tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::80-100
diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 0b0be5d..9d623b7 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -809,8 +809,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
         # Rule
         rule = line.split(';')  # rule[1] Ok or FAIL
         if line[0] == "-":  # Run omitted lines
-            if line[1:].find("*") != -1:
-                continue
             if need_fix_option:
                 rule[0] = rule[0].rstrip()[1:].strip()
             else:
-- 
2.6.2

