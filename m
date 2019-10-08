Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8D2C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 18:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76AB21721
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 18:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfJHSPj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 14:15:39 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:49502
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfJHSPj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 14:15:39 -0400
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iHu1H-0007YP-UU; Tue, 08 Oct 2019 20:15:35 +0200
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] tests: shell: fix failed tests due to missing quotes
Date:   Tue,  8 Oct 2019 20:06:32 +0200
Message-Id: <20191008180632.28583-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add double quotes to protect newlines when using <<< redirection.

See also commit b878cb7d83855.

Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 tests/shell/testcases/flowtable/0001flowtable_0      | 2 +-
 tests/shell/testcases/listing/0015dynamic_0          | 2 +-
 tests/shell/testcases/listing/0017objects_0          | 2 +-
 tests/shell/testcases/listing/0018data_0             | 2 +-
 tests/shell/testcases/listing/0019set_0              | 2 +-
 tests/shell/testcases/maps/0007named_ifname_dtype_0  | 3 +--
 tests/shell/testcases/nft-f/0002rollback_rule_0      | 4 ++--
 tests/shell/testcases/nft-f/0003rollback_jump_0      | 4 ++--
 tests/shell/testcases/nft-f/0004rollback_set_0       | 4 ++--
 tests/shell/testcases/nft-f/0005rollback_map_0       | 4 ++--
 tests/shell/testcases/nft-f/0006action_object_0      | 2 +-
 tests/shell/testcases/nft-f/0017ct_timeout_obj_0     | 2 +-
 tests/shell/testcases/nft-f/0018ct_expectation_obj_0 | 2 +-
 tests/shell/testcases/sets/0029named_ifname_dtype_0  | 2 +-
 14 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/tests/shell/testcases/flowtable/0001flowtable_0 b/tests/shell/testcases/flowtable/0001flowtable_0
index 8336ec5a8f37..2e18099452a0 100755
--- a/tests/shell/testcases/flowtable/0001flowtable_0
+++ b/tests/shell/testcases/flowtable/0001flowtable_0
@@ -12,4 +12,4 @@ EXPECTED='table inet t {
 }'
 
 set -e
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/listing/0015dynamic_0 b/tests/shell/testcases/listing/0015dynamic_0
index 5ddc4ad83a50..4ff74e321b8c 100755
--- a/tests/shell/testcases/listing/0015dynamic_0
+++ b/tests/shell/testcases/listing/0015dynamic_0
@@ -12,7 +12,7 @@ EXPECTED="table ip filter {
 
 set -e
 
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
 
 GET="$($NFT list set ip filter test_set)"
 if [ "$EXPECTED" != "$GET" ] ; then
diff --git a/tests/shell/testcases/listing/0017objects_0 b/tests/shell/testcases/listing/0017objects_0
index 14d614382e1b..8a586e8034f9 100755
--- a/tests/shell/testcases/listing/0017objects_0
+++ b/tests/shell/testcases/listing/0017objects_0
@@ -8,7 +8,7 @@ EXPECTED="table inet filter {
 
 set -e
 
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
 $NFT flush map inet filter countermap
 
 GET="$($NFT list map inet filter countermap)"
diff --git a/tests/shell/testcases/listing/0018data_0 b/tests/shell/testcases/listing/0018data_0
index 767fe13ae65a..544b6bf588e2 100755
--- a/tests/shell/testcases/listing/0018data_0
+++ b/tests/shell/testcases/listing/0018data_0
@@ -8,7 +8,7 @@ EXPECTED="table inet filter {
 
 set -e
 
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
 $NFT flush map inet filter ipmap
 
 GET="$($NFT list map inet filter ipmap)"
diff --git a/tests/shell/testcases/listing/0019set_0 b/tests/shell/testcases/listing/0019set_0
index 04eb0faf74af..54a8a0644079 100755
--- a/tests/shell/testcases/listing/0019set_0
+++ b/tests/shell/testcases/listing/0019set_0
@@ -8,7 +8,7 @@ EXPECTED="table inet filter {
 
 set -e
 
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
 $NFT flush set inet filter ipset
 
 GET="$($NFT list set inet filter ipset)"
diff --git a/tests/shell/testcases/maps/0007named_ifname_dtype_0 b/tests/shell/testcases/maps/0007named_ifname_dtype_0
index 4c7e7895a5ce..b5c5116b5660 100755
--- a/tests/shell/testcases/maps/0007named_ifname_dtype_0
+++ b/tests/shell/testcases/maps/0007named_ifname_dtype_0
@@ -15,5 +15,4 @@ EXPECTED="table inet t {
 }"
 
 set -e
-$NFT -f - <<< $EXPECTED
-
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
index 33e1212d94fb..8a9ca84a54e0 100755
--- a/tests/shell/testcases/nft-f/0002rollback_rule_0
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -27,13 +27,13 @@ table ip t2 {
 	}
 }"
 
-$NFT -f - <<< $GOOD_RULESET
+$NFT -f - <<< "$GOOD_RULESET"
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load good ruleset" >&2
 	exit 1
 fi
 
-$NFT -f - <<< $BAD_RULESET 2>/dev/null
+$NFT -f - <<< "$BAD_RULESET" 2>/dev/null
 if [ $? -eq 0 ]	; then
 	echo "E: bogus ruleset loaded?" >&2
 	exit 1
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
index 294a234eef97..6fb6f4e854b1 100755
--- a/tests/shell/testcases/nft-f/0003rollback_jump_0
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -27,13 +27,13 @@ table ip t2 {
 	}
 }"
 
-$NFT -f - <<< $GOOD_RULESET
+$NFT -f - <<< "$GOOD_RULESET"
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load good ruleset" >&2
 	exit 1
 fi
 
-$NFT -f - <<< $BAD_RULESET 2>/dev/null
+$NFT -f - <<< "$BAD_RULESET" 2>/dev/null
 if [ $? -eq 0 ]	; then
 	echo "E: bogus ruleset loaded?" >&2
 	exit 1
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
index 512840efb97b..bcc55df99061 100755
--- a/tests/shell/testcases/nft-f/0004rollback_set_0
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -27,13 +27,13 @@ table ip t2 {
 	}
 }"
 
-$NFT -f - <<< $GOOD_RULESET
+$NFT -f - <<< "$GOOD_RULESET"
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load good ruleset" >&2
 	exit 1
 fi
 
-$NFT -f - <<< $BAD_RULESET 2>/dev/null
+$NFT -f - <<< "$BAD_RULESET" 2>/dev/null
 if [ $? -eq 0 ]	; then
 	echo "E: bogus ruleset loaded?" >&2
 	exit 1
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
index b1eb3dd37471..913595d7cd98 100755
--- a/tests/shell/testcases/nft-f/0005rollback_map_0
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -30,13 +30,13 @@ table ip t2 {
 	}
 }"
 
-$NFT -f - <<< $GOOD_RULESET
+$NFT -f - <<< "$GOOD_RULESET"
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load good ruleset" >&2
 	exit 1
 fi
 
-$NFT -f - <<< $BAD_RULESET 2>/dev/null
+$NFT -f - <<< "$BAD_RULESET" 2>/dev/null
 if [ $? -eq 0 ]	; then
 	echo "E: bogus ruleset loaded?" >&2
 	exit 1
diff --git a/tests/shell/testcases/nft-f/0006action_object_0 b/tests/shell/testcases/nft-f/0006action_object_0
index fab3070f493f..ddee661dd65c 100755
--- a/tests/shell/testcases/nft-f/0006action_object_0
+++ b/tests/shell/testcases/nft-f/0006action_object_0
@@ -40,7 +40,7 @@ RULESET=$(for family in $FAMILIES ; do
 	generate1 $family
 done)
 
-$NFT -f - <<< $RULESET
+$NFT -f - <<< "$RULESET"
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load ruleset 1" >&2
 	exit 1
diff --git a/tests/shell/testcases/nft-f/0017ct_timeout_obj_0 b/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
index 1d6a0f7c84cf..4f407793b23b 100755
--- a/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
+++ b/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
@@ -13,4 +13,4 @@ EXPECTED='table ip filter {
 }'
 
 set -e
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/nft-f/0018ct_expectation_obj_0 b/tests/shell/testcases/nft-f/0018ct_expectation_obj_0
index eb9df3ceb121..4f9872f63130 100755
--- a/tests/shell/testcases/nft-f/0018ct_expectation_obj_0
+++ b/tests/shell/testcases/nft-f/0018ct_expectation_obj_0
@@ -15,4 +15,4 @@ EXPECTED='table ip filter {
 }'
 
 set -e
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/0029named_ifname_dtype_0 b/tests/shell/testcases/sets/0029named_ifname_dtype_0
index 724f16676c2e..39b3c90cf8dc 100755
--- a/tests/shell/testcases/sets/0029named_ifname_dtype_0
+++ b/tests/shell/testcases/sets/0029named_ifname_dtype_0
@@ -21,4 +21,4 @@ EXPECTED="table inet t {
 }"
 
 set -e
-$NFT -f - <<< $EXPECTED
+$NFT -f - <<< "$EXPECTED"
-- 
2.11.0

