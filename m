Return-Path: <SRS0=biDG=Y7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0483C5DF61
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611A2214D8
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbfKGLp0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:45:26 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35796 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfKGLpZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 06:45:25 -0500
Received: from localhost ([::1]:48886 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iSgE8-0005f4-7K; Thu, 07 Nov 2019 12:45:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] files: Drop shebangs from config files
Date:   Thu,  7 Nov 2019 12:45:15 +0100
Message-Id: <20191107114516.9258-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are not meant to be executed as is but instead loaded via
'nft -f' - all-in-one.nft even points this out in header comment.
While being at it, drop two spelling mistakes found along the way.

Consequently remove executable bits - being registered in automake as
dist_pkgsysconf_DATA, they're changed to 644 upon installation anyway.

Also there is obviously no need for replacement of nft binary path
anymore, drop that bit from Makefile.am.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 files/nftables/Makefile.am        | 3 ---
 files/nftables/all-in-one.nft     | 4 +---
 files/nftables/arp-filter.nft     | 2 --
 files/nftables/bridge-filter.nft  | 2 --
 files/nftables/inet-filter.nft    | 2 --
 files/nftables/inet-nat.nft       | 2 --
 files/nftables/ipv4-filter.nft    | 2 --
 files/nftables/ipv4-mangle.nft    | 2 --
 files/nftables/ipv4-nat.nft       | 2 --
 files/nftables/ipv4-raw.nft       | 2 --
 files/nftables/ipv6-filter.nft    | 2 --
 files/nftables/ipv6-mangle.nft    | 2 --
 files/nftables/ipv6-nat.nft       | 2 --
 files/nftables/ipv6-raw.nft       | 2 --
 files/nftables/netdev-ingress.nft | 4 +---
 15 files changed, 2 insertions(+), 33 deletions(-)
 mode change 100755 => 100644 files/nftables/all-in-one.nft
 mode change 100755 => 100644 files/nftables/arp-filter.nft
 mode change 100755 => 100644 files/nftables/bridge-filter.nft
 mode change 100755 => 100644 files/nftables/inet-filter.nft
 mode change 100755 => 100644 files/nftables/inet-nat.nft
 mode change 100755 => 100644 files/nftables/ipv4-filter.nft
 mode change 100755 => 100644 files/nftables/ipv4-mangle.nft
 mode change 100755 => 100644 files/nftables/ipv4-nat.nft
 mode change 100755 => 100644 files/nftables/ipv4-raw.nft
 mode change 100755 => 100644 files/nftables/ipv6-filter.nft
 mode change 100755 => 100644 files/nftables/ipv6-mangle.nft
 mode change 100755 => 100644 files/nftables/ipv6-nat.nft
 mode change 100755 => 100644 files/nftables/ipv6-raw.nft
 mode change 100755 => 100644 files/nftables/netdev-ingress.nft

diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
index 2a511cd1729c1..fc8b94eac1d01 100644
--- a/files/nftables/Makefile.am
+++ b/files/nftables/Makefile.am
@@ -13,6 +13,3 @@ dist_pkgsysconf_DATA =	all-in-one.nft		\
 			ipv6-nat.nft		\
 			ipv6-raw.nft		\
 			netdev-ingress.nft
-
-install-data-hook:
-	${SED} -i 's|@sbindir[@]|${sbindir}/|g' ${DESTDIR}${pkgsysconfdir}/*.nft
diff --git a/files/nftables/all-in-one.nft b/files/nftables/all-in-one.nft
old mode 100755
new mode 100644
index d3aa7f37f29f1..15ac22e2d676f
--- a/files/nftables/all-in-one.nft
+++ b/files/nftables/all-in-one.nft
@@ -1,12 +1,10 @@
-#!@sbindir@nft -f
-
 # Here is an example of different families, hooks and priorities in the
 # nftables framework, all mixed together.
 #
 # more examples are located in files/examples in nftables source.
 # For up-to-date information please visit https://wiki.nftables.org
 #
-# This script is mean to be loaded with `nft -f <file>`
+# This script is meant to be loaded with `nft -f <file>`
 
 # clear all prior state
 flush ruleset
diff --git a/files/nftables/arp-filter.nft b/files/nftables/arp-filter.nft
old mode 100755
new mode 100644
index 8a350b1eba8aa..6e4c62489ba9c
--- a/files/nftables/arp-filter.nft
+++ b/files/nftables/arp-filter.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table arp filter {
 	chain input		{ type filter hook input priority 0; }
 	chain output		{ type filter hook output priority 0; }
diff --git a/files/nftables/bridge-filter.nft b/files/nftables/bridge-filter.nft
old mode 100755
new mode 100644
index 93efe86423011..f071205e3d0fa
--- a/files/nftables/bridge-filter.nft
+++ b/files/nftables/bridge-filter.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table bridge filter {
 	chain input		{ type filter hook input priority -200; }
 	chain forward		{ type filter hook forward priority -200; }
diff --git a/files/nftables/inet-filter.nft b/files/nftables/inet-filter.nft
old mode 100755
new mode 100644
index 7be447fd4df5f..bfe43b4fade7c
--- a/files/nftables/inet-filter.nft
+++ b/files/nftables/inet-filter.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table inet filter {
 	chain input		{ type filter hook input priority 0; }
 	chain forward		{ type filter hook forward priority 0; }
diff --git a/files/nftables/inet-nat.nft b/files/nftables/inet-nat.nft
old mode 100755
new mode 100644
index 52fcdb543ddab..babd7f00de32a
--- a/files/nftables/inet-nat.nft
+++ b/files/nftables/inet-nat.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table inet nat {
 	chain prerouting	{ type nat hook prerouting priority -100; }
 	chain input		{ type nat hook input priority 100; }
diff --git a/files/nftables/ipv4-filter.nft b/files/nftables/ipv4-filter.nft
old mode 100755
new mode 100644
index 51c060f62cf42..ab62024f2cc67
--- a/files/nftables/ipv4-filter.nft
+++ b/files/nftables/ipv4-filter.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table filter {
 	chain input		{ type filter hook input priority 0; }
 	chain forward		{ type filter hook forward priority 0; }
diff --git a/files/nftables/ipv4-mangle.nft b/files/nftables/ipv4-mangle.nft
old mode 100755
new mode 100644
index dba8888c06adf..07da5bd90b12c
--- a/files/nftables/ipv4-mangle.nft
+++ b/files/nftables/ipv4-mangle.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table mangle {
 	chain output		{ type route hook output priority -150; }
 }
diff --git a/files/nftables/ipv4-nat.nft b/files/nftables/ipv4-nat.nft
old mode 100755
new mode 100644
index 6754e5eede6a5..2c9ce7c5b7f4f
--- a/files/nftables/ipv4-nat.nft
+++ b/files/nftables/ipv4-nat.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table nat {
 	chain prerouting	{ type nat hook prerouting priority -100; }
 	chain input		{ type nat hook input priority 100; }
diff --git a/files/nftables/ipv4-raw.nft b/files/nftables/ipv4-raw.nft
old mode 100755
new mode 100644
index c3fed1919cfba..2318e8758bfa8
--- a/files/nftables/ipv4-raw.nft
+++ b/files/nftables/ipv4-raw.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table raw {
 	chain prerouting	{ type filter hook prerouting priority -300; }
 	chain output		{ type filter hook output priority -300; }
diff --git a/files/nftables/ipv6-filter.nft b/files/nftables/ipv6-filter.nft
old mode 100755
new mode 100644
index 266bed365671b..383d075d9ae24
--- a/files/nftables/ipv6-filter.nft
+++ b/files/nftables/ipv6-filter.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table ip6 filter {
 	chain input		{ type filter hook input priority 0; }
 	chain forward		{ type filter hook forward priority 0; }
diff --git a/files/nftables/ipv6-mangle.nft b/files/nftables/ipv6-mangle.nft
old mode 100755
new mode 100644
index 6b3e20dcd458a..88c51e5247dbb
--- a/files/nftables/ipv6-mangle.nft
+++ b/files/nftables/ipv6-mangle.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table ip6 mangle {
 	chain output		{ type route hook output priority -150; }
 }
diff --git a/files/nftables/ipv6-nat.nft b/files/nftables/ipv6-nat.nft
old mode 100755
new mode 100644
index ce0391df24756..6a356f1e49f3e
--- a/files/nftables/ipv6-nat.nft
+++ b/files/nftables/ipv6-nat.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table ip6 nat {
 	chain prerouting	{ type nat hook prerouting priority -100; }
 	chain input 		{ type nat hook input priority 100; }
diff --git a/files/nftables/ipv6-raw.nft b/files/nftables/ipv6-raw.nft
old mode 100755
new mode 100644
index 504fb3e5c851b..f92668be272a6
--- a/files/nftables/ipv6-raw.nft
+++ b/files/nftables/ipv6-raw.nft
@@ -1,5 +1,3 @@
-#!@sbindir@nft -f
-
 table ip6 raw {
 	chain prerouting	{ type filter hook prerouting priority -300; }
 	chain output		{ type filter hook output priority -300; }
diff --git a/files/nftables/netdev-ingress.nft b/files/nftables/netdev-ingress.nft
old mode 100755
new mode 100644
index 9e46b15a7e596..3ed881af21d37
--- a/files/nftables/netdev-ingress.nft
+++ b/files/nftables/netdev-ingress.nft
@@ -1,6 +1,4 @@
-#!@sbindir@nft -f
-
-# mind the NIC, it must exists
+# mind the NIC, it must exist
 table netdev filter {
         chain loinput { type filter hook ingress device lo priority 0; }
 }
-- 
2.24.0

