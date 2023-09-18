Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D30CCD13DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbjIRKb7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbjIRKbo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F07218C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FgeIj1p3O8nezsM998IKPWjieVL8BXKKqqBnAnHhRVc=;
        b=YIMZ9AZFvFJH6pa5i2hYpmYVBtip+kG8UFSpEwJ6xGyQ14vKe7ppTEo70KBplf2J4JcOF4
        GtfVHWQIroK7RzpaEiCdZ3LkEUmjcHV7GuXe885jJplNiE06X3vGyXOhORgQU1so+7vPk2
        oGz3KbtYfXKO74iDpmK6reDnwpX/tYA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-4PVOVXfMMp6AuId70pkb-Q-1; Mon, 18 Sep 2023 06:30:10 -0400
X-MC-Unique: 4PVOVXfMMp6AuId70pkb-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99A2E1C05144
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 10:30:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 183E1C15BB8;
        Mon, 18 Sep 2023 10:30:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 14/14] tests/shell: check diff in "maps/typeof_maps_0" and "sets/typeof_sets_0" test
Date:   Mon, 18 Sep 2023 12:28:28 +0200
Message-ID: <20230918102947.2125883-15-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These tests run different variants based on NFT_TEST_HAVE_osf support.
Consequently, we cannot check the pre-generated diff.

Instead, construct what we expect dynamically in the script, and compare
the ruleset against that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/maps/typeof_maps_0 |  75 ++++++++++---
 tests/shell/testcases/sets/typeof_sets_0 | 133 ++++++++++++++++++++---
 2 files changed, 177 insertions(+), 31 deletions(-)

diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index 263390d51a5d..98517fd52506 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -4,18 +4,24 @@
 # without typeof, this is 'type string' and 'type integer',
 # but neither could be used because it lacks size information.
 
-OSFMAP=""
-OSFRULE=""
-if [ "$NFT_TEST_HAVE_osf" != n ] ; then
-	OSFMAP="map m1 {
-		typeof osf name : ct mark
-		elements = { "Linux" : 0x00000001 }
-	}"
-	OSFRULE="ct mark set osf name map @m1"
+set -e
+
+die() {
+	printf '%s\n' "$*"
+	exit 1
+}
+
+INPUT_OSF_CT="
+		ct mark set osf name map @m1"
+if [ "$NFT_TEST_HAVE_osf" = n ] ; then
+	INPUT_OSF_CT=
 fi
 
-EXPECTED="table inet t {
-	$OSFMAP
+INPUT="table inet t {
+	map m1 {
+		typeof osf name : ct mark
+		elements = { Linux : 0x00000001 }
+	}
 
 	map m2 {
 		typeof vlan id : mark
@@ -39,8 +45,7 @@ EXPECTED="table inet t {
 		elements = { 23 . eth0 : accept }
 	}
 
-	chain c {
-		$OSFRULE
+	chain c {$INPUT_OSF_CT
 		ether type vlan meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
 		iifname . ip protocol . th dport vmap @m4
@@ -49,10 +54,48 @@ EXPECTED="table inet t {
 	}
 }"
 
-set -e
-$NFT -f - <<< $EXPECTED
+EXPECTED="table inet t {
+	map m1 {
+		typeof osf name : ct mark
+		elements = { \"Linux\" : 0x00000001 }
+	}
+
+	map m2 {
+		typeof vlan id : meta mark
+		elements = { 1 : 0x00000001, 4095 : 0x00004095 }
+	}
+
+	map m3 {
+		typeof ip saddr . ip daddr : meta mark
+		elements = { 1.2.3.4 . 5.6.7.8 : 0x00000001,
+			     2.3.4.5 . 6.7.8.9 : 0x00000002 }
+	}
+
+	map m4 {
+		typeof iifname . ip protocol . th dport : verdict
+		elements = { \"eth0\" . tcp . 22 : accept }
+	}
+
+	map m5 {
+		typeof ipsec in reqid . iifname : verdict
+		elements = { 23 . \"eth0\" : accept }
+	}
+
+	chain c {$INPUT_OSF_CT
+		meta mark set vlan id map @m2
+		meta mark set ip saddr . ip daddr map @m3
+		iifname . ip protocol . th dport vmap @m4
+		iifname . ip protocol . th dport vmap { \"eth0\" . tcp . 22 : accept, \"eth1\" . udp . 67 : drop }
+		ipsec in reqid . iifname vmap @m5
+	}
+}"
+
+$NFT -f - <<< "$INPUT" || die $'nft command failed to process input:\n'">$INPUT<"
+
+$DIFF -u <($NFT list ruleset) - <<<"$EXPECTED" || die $'diff failed between ruleset and expected data.\nExpected:\n'">$EXPECTED<"
+
 
 if [ "$NFT_TEST_HAVE_osf" = n ] ; then
-	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
-	exit 77
+    echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
+    exit 77
 fi
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 6ed0c354bc25..c1c0f51f399c 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -4,21 +4,35 @@
 # s1 and s2 are identical, they just use different
 # ways for declaration.
 
-OSFSET=""
-OSFCHAIN=""
-if [ "$NFT_TEST_HAVE_osf" != n ] ; then
-	OSFSET="set s1 {
+set -e
+
+die() {
+	printf '%s\n' "$*"
+	exit 1
+}
+
+INPUT_OSF_SET="
+	set s1 {
 		typeof osf name
 		elements = { \"Linux\" }
-	}"
-	OSFCHAIN="chain c1 {
+	}
+"
+INPUT_OSF_CHAIN="
+	chain c1 {
 		osf name @s1 accept
-	}"
-fi
+	}
+"
 
-EXPECTED="table inet t {
-	$OSFSET
+if [ "$NFT_TEST_HAVE_osf" = n ] ; then
+	if [ "$((RANDOM % 2))" -eq 1 ] ; then
+		# Regardless of $NFT_TEST_HAVE_osf, we can define the set.
+		# Randomly do so.
+		INPUT_OSF_SET=
+	fi
+	INPUT_OSF_CHAIN=
+fi
 
+INPUT="table inet t {$INPUT_OSF_SET
 	set s2 {
 		typeof vlan id
 		elements = { 2, 3, 103 }
@@ -68,9 +82,7 @@ EXPECTED="table inet t {
 		typeof vlan id . ip saddr
 		elements = { 3567 . 1.2.3.4 }
 	}
-
-	$OSFCHAIN
-
+$INPUT_OSF_CHAIN
 	chain c2 {
 		ether type vlan vlan id @s2 accept
 	}
@@ -108,8 +120,99 @@ EXPECTED="table inet t {
 	}
 }"
 
-set -e
-$NFT -f - <<< $EXPECTED
+EXPECTED="table inet t {$INPUT_OSF_SET
+	set s2 {
+		typeof vlan id
+		elements = { 2, 3, 103 }
+	}
+
+	set s3 {
+		typeof meta ibrpvid
+		elements = { 2, 3, 103 }
+	}
+
+	set s4 {
+		typeof frag frag-off
+		elements = { 1, 1024 }
+	}
+
+	set s5 {
+		typeof ip option ra value
+		elements = { 1, 1024 }
+	}
+
+	set s6 {
+		typeof tcp option maxseg size
+		elements = { 1, 1024 }
+	}
+
+	set s7 {
+		typeof sctp chunk init num-inbound-streams
+		elements = { 1, 4 }
+	}
+
+	set s8 {
+		typeof ip version
+		elements = { 4, 6 }
+	}
+
+	set s9 {
+		typeof ip hdrlength
+		elements = { 0, 1, 2, 3, 4,
+			     15 }
+	}
+
+	set s10 {
+		typeof iifname . ip saddr . ipsec in reqid
+		elements = { \"eth0\" . 10.1.1.2 . 42 }
+	}
+
+	set s11 {
+		typeof vlan id . ip saddr
+		elements = { 3567 . 1.2.3.4 }
+	}
+$INPUT_OSF_CHAIN
+	chain c2 {
+		vlan id @s2 accept
+	}
+
+	chain c4 {
+		frag frag-off @s4 accept
+	}
+
+	chain c5 {
+		ip option ra value @s5 accept
+	}
+
+	chain c6 {
+		tcp option maxseg size @s6 accept
+	}
+
+	chain c7 {
+		sctp chunk init num-inbound-streams @s7 accept
+	}
+
+	chain c8 {
+		ip version @s8 accept
+	}
+
+	chain c9 {
+		ip hdrlength @s9 accept
+	}
+
+	chain c10 {
+		iifname . ip saddr . ipsec in reqid @s10 accept
+	}
+
+	chain c11 {
+		vlan id . ip saddr @s11 accept
+	}
+}"
+
+
+$NFT -f - <<< "$INPUT" || die $'nft command failed to process input:\n'">$INPUT<"
+
+$DIFF -u <($NFT list ruleset) - <<<"$EXPECTED" || die $'diff failed between ruleset and expected data.\nExpected:\n'">$EXPECTED<"
 
 if [ "$NFT_TEST_HAVE_osf" = n ] ; then
 	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
-- 
2.41.0

