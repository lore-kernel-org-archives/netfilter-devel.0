Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E85C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 12:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiLVMNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 07:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiLVMMv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 07:12:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43C142EF9E
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 04:06:29 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 2/2] ct: use inet_service_type for proto-src and proto-dst
Date:   Thu, 22 Dec 2022 13:06:23 +0100
Message-Id: <20221222120623.115538-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221222120623.115538-1-pablo@netfilter.org>
References: <20221222120623.115538-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of using the invalid type.

Problem was uncovered by this ruleset:

 table ip foo {
        map pinned {
                typeof ip daddr . ct original proto-dst : ip daddr . tcp dport
                size 65535
                flags dynamic,timeout
                timeout 6m
        }

        chain pr {
                meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
        }
 }

resulting in the following misleading error:

map-broken.nft:10:51-82: Error: datatype mismatch: expected concatenation of (IPv4 address), expression has type concatenation of (IPv4 address, internet network service)
                meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
                                 ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c                                                      | 4 ++--
 .../testcases/maps/dumps/typeof_maps_concat_update_0.nft      | 1 +
 tests/shell/testcases/maps/typeof_maps_concat_update_0        | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index e246d3039240..64327561d089 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -271,10 +271,10 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 	[NFT_CT_PROTOCOL]	= CT_TEMPLATE("protocol",   &inet_protocol_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      BITS_PER_BYTE),
-	[NFT_CT_PROTO_SRC]	= CT_TEMPLATE("proto-src",  &invalid_type,
+	[NFT_CT_PROTO_SRC]	= CT_TEMPLATE("proto-src",  &inet_service_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
-	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &invalid_type,
+	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &inet_service_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
 	[NFT_CT_LABELS]		= CT_TEMPLATE("label", &ct_label_type,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
index a2c3c139936b..f8b574f4e0cb 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
@@ -8,5 +8,6 @@ table ip foo {
 
 	chain pr {
 		update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
+		update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_maps_concat_update_0 b/tests/shell/testcases/maps/typeof_maps_concat_update_0
index e996f14e1830..2a52ea0e3220 100755
--- a/tests/shell/testcases/maps/typeof_maps_concat_update_0
+++ b/tests/shell/testcases/maps/typeof_maps_concat_update_0
@@ -11,6 +11,7 @@ EXPECTED="table ip foo {
   }
   chain pr {
      update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
+     meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
   }
 }"
 
-- 
2.30.2

