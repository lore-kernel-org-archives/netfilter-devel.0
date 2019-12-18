Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55795C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3264C218AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLRLKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:10:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36080 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfLRLKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:10:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihXED-0007F3-6i; Wed, 18 Dec 2019 12:10:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Willi <martin@strongswan.org>
Subject: [PATCH nft] meta: add slave device matching
Date:   Wed, 18 Dec 2019 12:10:41 +0100
Message-Id: <20191218111041.14764-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218111041.14764-1-fw@strlen.de>
References: <20191218111041.14764-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds "meta sdif" and "meta sdifname".
Both only work in input/forward hook of ipv4/ipv6/inet family.

Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/primary-expression.txt          |  6 ++++++
 include/linux/netfilter/nf_tables.h |  4 ++++
 src/meta.c                          |  5 +++++
 tests/py/ip/meta.t                  |  3 +++
 tests/py/ip/meta.t.payload          | 11 +++++++++++
 tests/py/ip6/meta.t                 |  3 +++
 tests/py/ip6/meta.t.payload         | 12 ++++++++++++
 7 files changed, 44 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 6f636e13f5b5..94eccc20241a 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -76,6 +76,12 @@ ifname
 |oiftype|
 Output interface hardware type|
 iface_type
+|sdif|
+Slave device input interface index |
+iface_index
+|sdifname|
+Slave device interface name|
+ifname
 |skuid|
 UID associated with originating socket|
 uid
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ed8881ad18ed..c556ccd3dbf7 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -803,6 +803,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
  * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
+ * @NFT_META_SDIF: slave device interface index
+ * @NFT_META_SDIFNAME: slave device interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -838,6 +840,8 @@ enum nft_meta_keys {
 	NFT_META_TIME_NS,
 	NFT_META_TIME_DAY,
 	NFT_META_TIME_HOUR,
+	NFT_META_SDIF,
+	NFT_META_SDIFNAME,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 135f84b51c55..bc35f28fb2b6 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -700,6 +700,11 @@ const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SECMARK]	= META_TEMPLATE("secmark", &integer_type,
 						32, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SDIF]		= META_TEMPLATE("sdif", &ifindex_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SDIFNAME]	= META_TEMPLATE("sdifname", &ifname_type,
+						IFNAMSIZ * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 4db88354463e..f733d22de2c3 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -10,3 +10,6 @@ icmpv6 type nd-router-advert;ok
 
 meta ibrname "br0";fail
 meta obrname "br0";fail
+
+meta sdif "lo" accept;ok
+meta sdifname != "vrf1" accept;ok
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 322c0878f2c9..7bc69a290d24 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -33,3 +33,14 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000086 ]
 
+# meta sdif "lo" accept
+ip6 test-ip4 input
+  [ meta load sdif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ immediate reg 0 accept ]
+
+# meta sdifname != "vrf1" accept
+ip6 test-ip4 input
+  [ meta load sdifname => reg 1 ]
+  [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
+  [ immediate reg 0 accept ]
diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
index 24445084890b..dce97f5b0fd0 100644
--- a/tests/py/ip6/meta.t
+++ b/tests/py/ip6/meta.t
@@ -8,3 +8,6 @@ meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-adv
 meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
 meta l4proto 1 icmp type echo-request;ok;icmp type echo-request
 icmp type echo-request;ok
+
+meta sdif "lo" accept;ok
+meta sdifname != "vrf1" accept;ok
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index f203baaba16a..be04816eeec2 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -32,3 +32,15 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
+
+# meta sdif "lo" accept
+ip6 test-ip6 input
+  [ meta load sdif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ immediate reg 0 accept ]
+
+# meta sdifname != "vrf1" accept
+ip6 test-ip6 input
+  [ meta load sdifname => reg 1 ]
+  [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
+  [ immediate reg 0 accept ]
-- 
2.24.1

