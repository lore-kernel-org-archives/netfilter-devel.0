From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v2] src: tests: files: Remove test files.
Date: Mon, 13 Nov 2017 22:45:51 +0530
Message-ID: <20171113171551.492-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43427 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753959AbdKMRQI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 12:16:08 -0500
Received: by mail-pf0-f196.google.com with SMTP id a84so7355547pfl.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 09:16:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes all the test cases from tests/files. As they are
already present in other test files.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v1:
- Added new test cases which were not present in tests/shell.
- Removed few test files from tests/files.

Changes in v2:
- Modified commit message.
- Removed all the test files from tests/files.

 tests/files/dictionary                  | 52 ---------------------------------
 tests/files/error.1                     |  9 ------
 tests/files/error.2                     | 18 ------------
 tests/files/expr-concat                 | 19 ------------
 tests/files/expr-ct                     | 26 -----------------
 tests/files/expr-meta                   | 40 -------------------------
 tests/files/family-bridge               | 13 ---------
 tests/files/family-ipv4                 | 14 ---------
 tests/files/family-ipv6                 | 13 ---------
 tests/files/feat-adjancent-load-merging | 13 ---------
 tests/files/payload-ll                  | 15 ----------
 tests/files/prefix                      |  5 ----
 tests/files/stmt-log                    |  6 ----
 13 files changed, 243 deletions(-)
 delete mode 100644 tests/files/dictionary
 delete mode 100644 tests/files/error.1
 delete mode 100644 tests/files/error.2
 delete mode 100644 tests/files/expr-concat
 delete mode 100644 tests/files/expr-ct
 delete mode 100644 tests/files/expr-meta
 delete mode 100644 tests/files/family-bridge
 delete mode 100644 tests/files/family-ipv4
 delete mode 100644 tests/files/family-ipv6
 delete mode 100644 tests/files/feat-adjancent-load-merging
 delete mode 100644 tests/files/payload-ll
 delete mode 100644 tests/files/prefix
 delete mode 100644 tests/files/stmt-log

diff --git a/tests/files/dictionary b/tests/files/dictionary
deleted file mode 100644
index b4e6c52..0000000
--- a/tests/files/dictionary
+++ /dev/null
@@ -1,52 +0,0 @@
-#! nft -f
-#
-add table ip filter
-add chain ip filter output { type filter hook output priority 0 ; }
-
-add chain ip filter chain1
-add rule ip filter chain1 counter
-
-add chain ip filter chain2
-add rule ip filter chain2 counter
-
-# must succeed: expr { expr, ... }
-add rule ip filter OUTPUT tcp dport { \
-	22, \
-	23, \
-}
-
-# must fail: expr { type1, type2, ... }
-add rule ip filter OUTPUT tcp dport { \
-	22, \
-	192.168.0.1, \
-}
-
-# must succeed: expr { expr : verdict, ... }
-add rule ip filter OUTPUT tcp dport vmap { \
-	22 : jump chain1, \
-	23 : jump chain2, \
-}
-
-# must fail: expr { expr : verdict, expr : expr, ... }
-add rule ip filter OUTPUT tcp dport vmap { \
-	22 : jump chain1, \
-	23 : 0x100, \
-}
-
-# must fail: expr { expr : expr, ...}
-add rule ip filter OUTPUT tcp dport vmap { \
-	22 : 0x100, \
-	23 : 0x200, \
-}
-
-# must succeed: expr MAP { expr : expr, ... } expr
-add rule ip filter OUTPUT meta mark set tcp dport map { \
-	22 : 1, \
-	23 : 2, \
-}
-
-# must fail: expr MAP { expr : type1, expr : type2, .. } expr
-add rule ip filter OUTPUT meta mark set tcp dport map { \
-	22 : 1, \
-	23 : 192.168.0.1, \
-}
diff --git a/tests/files/error.1 b/tests/files/error.1
deleted file mode 100644
index bc3bf16..0000000
--- a/tests/files/error.1
+++ /dev/null
@@ -1,9 +0,0 @@
-#! nft -f
-
-# mixed syntactical and non-syntactical errors
-filter {
-filter input
-filter input tcp
-filter input tcp dport
-filter input tcp dport tcp
-filter input tcp dport tcp dport
diff --git a/tests/files/error.2 b/tests/files/error.2
deleted file mode 100644
index 744a63d..0000000
--- a/tests/files/error.2
+++ /dev/null
@@ -1,18 +0,0 @@
-#! nft -f
-
-# mixed syntactical and non-syntactical errors in blocks
-table filter {
-	# missing identifier
-	chain
-
-	# missing chain block
-	chain output
-
-	chain output {
-		tcp
-		tcp dport
-		tcp dport tcp
-		tcp dport tcp dport
-		tcp dport ssh
-	}
-}
diff --git a/tests/files/expr-concat b/tests/files/expr-concat
deleted file mode 100644
index bb284cc..0000000
--- a/tests/files/expr-concat
+++ /dev/null
@@ -1,19 +0,0 @@
-#! nft -f
-
-# Concat element mismatch
-add rule ip filter output ip daddr . tcp sport . tcp dport { \
-	192.168.0.1 . 22,	\
-	192.168.0.1 . 80,	\
-}
-
-# Concat type mismatch
-add rule ip filter output ip daddr . tcp dport { \
-	192.168.0.1 . 192.168.0.2,	\
-	192.168.0.1 . 192.168.0.3,	\
-}
-
-# Concat expression
-add rule ip filter output ip daddr . tcp dport { \
-	192.168.0.1 . 22,	\
-	192.168.0.1 . 80,	\
-}
diff --git a/tests/files/expr-ct b/tests/files/expr-ct
deleted file mode 100644
index 1dfc7ac..0000000
--- a/tests/files/expr-ct
+++ /dev/null
@@ -1,26 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0 ; }
-
-# ct: state
-add rule ip filter output ct state new,established counter
-
-# ct: direction original/reply
-add rule ip filter output ct direction original counter
-add rule ip filter output ct direction reply counter
-
-# ct: status
-add rule ip filter output ct status expected counter
-
-# ct: mark
-add rule ip filter output ct mark 0 counter
-
-# ct: secmark
-add rule ip filter output ct secmark 0 counter
-
-# ct: expiration
-add rule ip filter output ct expiration 30 counter
-
-# ct: helper ftp
-add rule ip filter output ct helper "ftp" counter
diff --git a/tests/files/expr-meta b/tests/files/expr-meta
deleted file mode 100644
index 360caa7..0000000
--- a/tests/files/expr-meta
+++ /dev/null
@@ -1,40 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0 ; }
-
-# meta: skb len
-add rule ip filter output meta length 1000 counter
-
-# meta: skb protocol
-add rule ip filter output meta protocol 0x0800 counter
-
-# meta: skb mark
-add rule ip filter output meta mark 0 counter
-
-# meta: skb iif
-add rule ip filter output meta iif lo counter
-
-# meta: skb iifname
-add rule ip filter output meta iifname "eth0" counter
-
-# meta: skb oif
-add rule ip filter output meta oif lo counter
-
-# meta: skb oifname
-add rule ip filter output meta oifname "eth0" counter
-
-# meta: skb sk uid
-add rule ip filter output meta skuid 1000 counter
-
-# meta: skb sk gid
-add rule ip filter output meta skgid 1000 counter
-
-# meta: nftrace
-add rule ip filter output meta nftrace 1 counter
-
-# meta: rtclassid (see /etc/iproute2/rt_realms)
-add rule ip filter output meta rtclassid cosmos counter
-
-# meta: secmark
-add rule ip filter output meta secmark 0 counter
diff --git a/tests/files/family-bridge b/tests/files/family-bridge
deleted file mode 100644
index c87c832..0000000
--- a/tests/files/family-bridge
+++ /dev/null
@@ -1,13 +0,0 @@
-#! nft -f
-
-add table bridge filter
-add chain bridge filter output { type filter hook output priority 0 ; }
-
-# LL protocol
-add rule bridge filter output eth type 0x0800 counter
-
-# IP address
-add rule bridge filter output eth type 0x0800 ip daddr 20.0.0.2 counter
-
-# IPv6 address
-add rule bridge filter output eth type 0x86DD ip6 daddr 2001:6f8:974:3::2 counter
diff --git a/tests/files/family-ipv4 b/tests/files/family-ipv4
deleted file mode 100644
index 0700e16..0000000
--- a/tests/files/family-ipv4
+++ /dev/null
@@ -1,14 +0,0 @@
-#! nft -f
-
-flush chain ip filter output
-delete chain ip filter output
-delete table filter
-
-add table ip filter
-add chain ip filter output { type filter hook input priority 0; }
-
-# IP address
-add rule ip filter output ip daddr 192.168.0.1 counter
-
-# TCP ports
-add rule ip filter output tcp dport 22 counter
diff --git a/tests/files/family-ipv6 b/tests/files/family-ipv6
deleted file mode 100644
index cfc740c..0000000
--- a/tests/files/family-ipv6
+++ /dev/null
@@ -1,13 +0,0 @@
-#! nft -f
-
-add table ip6 filter
-add chain ip6 filter output { type filter hook output priority 0 ; }
-
-# IP address
-add rule ip6 filter output ip6 daddr 2001:6f8:974::1 counter
-
-# Next protocol
-add rule ip6 filter output ip6 nexthdr tcp
-
-# TCP ports
-add rule ip6 filter output tcp dport 22 counter
diff --git a/tests/files/feat-adjancent-load-merging b/tests/files/feat-adjancent-load-merging
deleted file mode 100644
index 1177174..0000000
--- a/tests/files/feat-adjancent-load-merging
+++ /dev/null
@@ -1,13 +0,0 @@
-#! nft -f
-
-# adjacent payload expressions: 4 bytes in order
-add rule filter output tcp sport 1024 tcp dport 22 counter
-
-# adjacent payload expressions: 8 bytes in order
-add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter
-
-# adjacent payload expressions: 8 bytes in order
-add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22
-
-# adjacent payload expressions: 8 bytes in reverse order
-add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0
diff --git a/tests/files/payload-ll b/tests/files/payload-ll
deleted file mode 100644
index 7f5660b..0000000
--- a/tests/files/payload-ll
+++ /dev/null
@@ -1,15 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter input { type filter hook input priority 0; }
-
-# mac source
-add rule ip filter input @ll,48,48 00:15:e9:f0:10:f8 counter
-
-# mac dest
-add rule ip filter input @ll,0,48 00:1b:21:02:6f:ad counter
-
-# mac source and mac dest
-add rule ip filter input @ll,0,48 00:1b:21:02:6f:ad \
-			 @ll,48,48 00:15:e9:f0:10:f8 \
-			 counter
diff --git a/tests/files/prefix b/tests/files/prefix
deleted file mode 100644
index bada850..0000000
--- a/tests/files/prefix
+++ /dev/null
@@ -1,5 +0,0 @@
-add rule filter OUTPUT meta mark 123/0x000000ff
-add rule filter OUTPUT ip daddr 192.168.0.0/24
-add rule filter OUTPUT ip daddr 192.168.0.0/255.255.255.0
-add rule filter OUTPUT ip saddr . ip daddr 192.168.0.0/24 . 192.168.0.0/24
-add rule filter OUTPUT ip daddr { 192.168.0.0/24, 192.168.1.0/24}
diff --git a/tests/files/stmt-log b/tests/files/stmt-log
deleted file mode 100644
index 2ae7aae..0000000
--- a/tests/files/stmt-log
+++ /dev/null
@@ -1,6 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0; }
-
-add rule ip filter output log saddr "prefix" group 0 counter
-- 
2.13.6

