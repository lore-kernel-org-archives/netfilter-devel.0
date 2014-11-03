From: Ana Rey <anarey@gmail.com>
Subject: [nft PATCH] src: Add cgroup support in meta expresion
Date: Mon,  3 Nov 2014 18:10:51 +0100
Message-ID: <1415034651-27242-3-git-send-email-anarey@gmail.com>
References: <1415034651-27242-1-git-send-email-anarey@gmail.com>
Cc: dborkman@redhat.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53024 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKCRKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:10:45 -0500
Received: by mail-wi0-f173.google.com with SMTP id n3so7095951wiv.12
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 09:10:44 -0800 (PST)
In-Reply-To: <1415034651-27242-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new attribute of meta is "cgroup".

Example of use in nft:
 # nft add rule ip test output meta cgroup != 0x100001 counter drop

Moreover, It adds tests in meta.t test file.

The kernel support is add in the commit:
netfilter: nft_meta: add cgroup support

The libnftnl  support is add in the commit:
expr: meta: Add cgroup support

More information about the steps to use cgroup:
https://www.kernel.org/doc/Documentation/cgroups/net_cls.txt

More info about cgroup in iptables:
http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/commit/net/netfilter/xt_cgroup.c?id=82a37132f300ea53bdcd812917af5a6329ec80c3
---
 include/linux/netfilter/nf_tables.h |    2 ++
 src/meta.c                          |    3 +++
 src/parser.y                        |    2 ++
 src/scanner.l                       |    1 +
 tests/regression/any/meta.t         |    9 +++++++++
 5 files changed, 17 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f04d997..d21e41a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -579,6 +579,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_CPU: cpu id through smp_processor_id()
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
+ * @NFT_META_CGROUP: packet cgroup
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -604,6 +605,7 @@ enum nft_meta_keys {
 	NFT_META_CPU,
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
+	NFT_META_CGROUP,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index faa29eb..61dc5cf 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -436,6 +436,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup", &devgroup_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",  &integer_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 9e9a839..096a86d 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -324,6 +324,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token CPU			"cpu"
 %token IIFGROUP			"iifgroup"
 %token OIFGROUP			"oifgroup"
+%token CGROUP			"cgroup"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1759,6 +1760,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       CPU		{ $$ = NFT_META_CPU; }
 			|       IIFGROUP	{ $$ = NFT_META_IIFGROUP; }
 			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
+			|       CGROUP		{ $$ = NFT_META_CGROUP; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 32e59d9..859d18f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -432,6 +432,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "cpu"			{ return CPU; }
 "iifgroup"		{ return IIFGROUP; }
 "oifgroup"		{ return OIFGROUP; }
+"cgroup"		{ return CGROUP; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index 1e7a0fe..ba6756d 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -179,3 +179,12 @@ meta oifgroup {11,33};ok;oifgroup {11,33}
 meta oifgroup {11-33};ok
 - meta oifgroup != {11,33};ok
 - meta oifgroup != {11-33};ok
+
+meta cgroup 0x100001;ok;cgroup 1048577
+meta cgroup != 0x100001;ok;cgroup != 1048577
+meta cgroup { 0x100001, 0x100002};ok
+# meta cgroup != { 0x100001, 0x100002};ok
+meta cgroup 0x100001 - 0x100003;ok
+# meta cgroup != 0x100001 - 0x100003;ok
+meta cgroup {0x100001 - 0x100003};ok
+# meta cgroup != { 0x100001 - 0x100003};ok
-- 
1.7.10.4

