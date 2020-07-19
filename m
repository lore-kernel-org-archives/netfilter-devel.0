Return-Path: <SRS0=Dw8A=A6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA55C433E1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jul 2020 10:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE782073A
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jul 2020 10:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgGSKCc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jul 2020 06:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSKCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jul 2020 06:02:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5A1C0619D2
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Jul 2020 03:02:31 -0700 (PDT)
Received: from localhost ([::1]:51928 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1jx69M-0005fl-Cd; Sun, 19 Jul 2020 12:02:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>
Subject: [nf-next PATCH v2] netfilter: include: uapi: Use C99 flexible array member
Date:   Sun, 19 Jul 2020 12:02:20 +0200
Message-Id: <20200719100220.4666-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent versions of gcc started to complain about the old-style
zero-length array as last member of various structs. For instance, while
compiling iptables:

| In file included from /usr/include/string.h:495,
|                  from libip4tc.c:15:
| In function 'memcpy',
|     inlined from 'iptcc_compile_chain' at libiptc.c:1172:2,
|     inlined from 'iptcc_compile_table' at libiptc.c:1243:13,
|     inlined from 'iptc_commit' at libiptc.c:2572:8,
|     inlined from 'iptc_commit' at libiptc.c:2510:1:
| /usr/include/bits/string_fortified.h:34:10: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
|    34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
|       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| In file included from ../include/libiptc/libiptc.h:12,
|                  from libip4tc.c:29:
| libiptc.c: In function 'iptc_commit':
| ../include/linux/netfilter_ipv4/ip_tables.h:202:19: note: at offset 0 to object 'entries' with size 0 declared here
|   202 |  struct ipt_entry entries[0];
|       |                   ^~~~~~~

(Similar for libip6tc.c.)

Avoid this warning by declaring these fields as an ISO C99 flexible
array member. This makes gcc aware of the intended use and enables
sanity checking as described in:
https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html

This patch is actually a follow-up on commit 6daf14140129d ("netfilter:
Replace zero-length array with flexible-array member") which seems to
have missed a few spots. Like it, alignment attribute syntax is fixed
where found in line with zero-length array fields.

Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix up any zero-length arrays found via:
  `grep -r '\[0\]' include/uapi/linux/netfilter*`.
- Perform alignment attribute syntax fixup just like 6daf14140129d does.
- Point at relationship with 6daf14140129d in commit message.
- Add Gustavo to Cc: for verification.
---
 include/uapi/linux/netfilter/x_tables.h         |  6 +++---
 include/uapi/linux/netfilter_arp/arp_tables.h   |  6 +++---
 include/uapi/linux/netfilter_bridge/ebt_among.h |  2 +-
 include/uapi/linux/netfilter_bridge/ebtables.h  | 10 +++++-----
 include/uapi/linux/netfilter_ipv4/ip_tables.h   |  6 +++---
 include/uapi/linux/netfilter_ipv6/ip6_tables.h  |  6 +++---
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/netfilter/x_tables.h
index a8283f7dbc519..7a52c69c74a2b 100644
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -28,7 +28,7 @@ struct xt_entry_match {
 		__u16 match_size;
 	} u;
 
-	unsigned char data[0];
+	unsigned char data[];
 };
 
 struct xt_entry_target {
@@ -51,7 +51,7 @@ struct xt_entry_target {
 		__u16 target_size;
 	} u;
 
-	unsigned char data[0];
+	unsigned char data[];
 };
 
 #define XT_TARGET_INIT(__name, __size)					       \
@@ -119,7 +119,7 @@ struct xt_counters_info {
 	unsigned int num_counters;
 
 	/* The counters (actually `number' of these). */
-	struct xt_counters counters[0];
+	struct xt_counters counters[];
 };
 
 #define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
diff --git a/include/uapi/linux/netfilter_arp/arp_tables.h b/include/uapi/linux/netfilter_arp/arp_tables.h
index bbf5af2b67a8f..a6ac2463f787a 100644
--- a/include/uapi/linux/netfilter_arp/arp_tables.h
+++ b/include/uapi/linux/netfilter_arp/arp_tables.h
@@ -109,7 +109,7 @@ struct arpt_entry
 	struct xt_counters counters;
 
 	/* The matches (if any), then the target. */
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 /*
@@ -181,7 +181,7 @@ struct arpt_replace {
 	struct xt_counters __user *counters;
 
 	/* The entries (hang off end: not really an array). */
-	struct arpt_entry entries[0];
+	struct arpt_entry entries[];
 };
 
 /* The argument to ARPT_SO_GET_ENTRIES. */
@@ -193,7 +193,7 @@ struct arpt_get_entries {
 	unsigned int size;
 
 	/* The entries. */
-	struct arpt_entry entrytable[0];
+	struct arpt_entry entrytable[];
 };
 
 /* Helper functions */
diff --git a/include/uapi/linux/netfilter_bridge/ebt_among.h b/include/uapi/linux/netfilter_bridge/ebt_among.h
index 9acf757bc1f79..73b26a280c4fd 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_among.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_among.h
@@ -40,7 +40,7 @@ struct ebt_mac_wormhash_tuple {
 struct ebt_mac_wormhash {
 	int table[257];
 	int poolsize;
-	struct ebt_mac_wormhash_tuple pool[0];
+	struct ebt_mac_wormhash_tuple pool[];
 };
 
 #define ebt_mac_wormhash_size(x) ((x) ? sizeof(struct ebt_mac_wormhash) \
diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index a494cf43a7552..0b4f8994a0a54 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -87,7 +87,7 @@ struct ebt_entries {
 	/* nr. of entries */
 	unsigned int nentries;
 	/* entry list */
-	char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	char data[] __aligned(__alignof__(struct ebt_replace));
 };
 
 /* used for the bitmask of struct ebt_entry */
@@ -129,7 +129,7 @@ struct ebt_entry_match {
 	} u;
 	/* size of data */
 	unsigned int match_size;
-	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
 };
 
 struct ebt_entry_watcher {
@@ -142,7 +142,7 @@ struct ebt_entry_watcher {
 	} u;
 	/* size of data */
 	unsigned int watcher_size;
-	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
 };
 
 struct ebt_entry_target {
@@ -155,7 +155,7 @@ struct ebt_entry_target {
 	} u;
 	/* size of data */
 	unsigned int target_size;
-	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
 };
 
 #define EBT_STANDARD_TARGET "standard"
@@ -188,7 +188,7 @@ struct ebt_entry {
 	unsigned int target_offset;
 	/* sizeof ebt_entry + matches + watchers + target */
 	unsigned int next_offset;
-	unsigned char elems[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char elems[] __aligned(__alignof__(struct ebt_replace));
 };
 
 static __inline__ struct ebt_entry_target *
diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
index 50c7fee625ae9..1485df28b2391 100644
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -121,7 +121,7 @@ struct ipt_entry {
 	struct xt_counters counters;
 
 	/* The matches (if any), then the target. */
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 /*
@@ -203,7 +203,7 @@ struct ipt_replace {
 	struct xt_counters __user *counters;
 
 	/* The entries (hang off end: not really an array). */
-	struct ipt_entry entries[0];
+	struct ipt_entry entries[];
 };
 
 /* The argument to IPT_SO_GET_ENTRIES. */
@@ -215,7 +215,7 @@ struct ipt_get_entries {
 	unsigned int size;
 
 	/* The entries. */
-	struct ipt_entry entrytable[0];
+	struct ipt_entry entrytable[];
 };
 
 /* Helper functions */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
index d9e364f96a5cf..d4d7f47d9104d 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
@@ -125,7 +125,7 @@ struct ip6t_entry {
 	struct xt_counters counters;
 
 	/* The matches (if any), then the target. */
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 /* Standard entry */
@@ -243,7 +243,7 @@ struct ip6t_replace {
 	struct xt_counters __user *counters;
 
 	/* The entries (hang off end: not really an array). */
-	struct ip6t_entry entries[0];
+	struct ip6t_entry entries[];
 };
 
 /* The argument to IP6T_SO_GET_ENTRIES. */
@@ -255,7 +255,7 @@ struct ip6t_get_entries {
 	unsigned int size;
 
 	/* The entries. */
-	struct ip6t_entry entrytable[0];
+	struct ip6t_entry entrytable[];
 };
 
 /* Helper functions */
-- 
2.27.0

