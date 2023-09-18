Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D098CD13D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241252AbjIRKb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241259AbjIRKbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245FF121
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kxt4j6oVcvu6MyBZmLICaYlnqONi6uWO3Md3VzVKoTo=;
        b=NOzQOiVyo2A0+PWFmX80XKL5x5Ugsx1CwFxXTAFBJ6024Es4lCSTryDQCMqeNSaUDrU+vR
        9kDqtqw5+S1vkmeFx/9VYPum21l1o4kCUJHrQuDNgCp7sGHaZeFlruA8ax7M2lAyFe/W42
        +19jtwGwJBuvvtMZegDcNEVPFRdIb4A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-LReF8f_9PEiZLFy3yxiyrw-1; Mon, 18 Sep 2023 06:30:07 -0400
X-MC-Unique: LReF8f_9PEiZLFy3yxiyrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4121E85A5BA;
        Mon, 18 Sep 2023 10:30:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94876C15BB8;
        Mon, 18 Sep 2023 10:30:06 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 10/14] tests/shell: skip test cases involving osf match if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:24 +0200
Message-ID: <20230918102947.2125883-11-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/osf.nft             |  7 +++++++
 tests/shell/testcases/maps/typeof_maps_0 | 19 +++++++++++++++----
 tests/shell/testcases/sets/typeof_sets_0 | 23 +++++++++++++++++------
 3 files changed, 39 insertions(+), 10 deletions(-)
 create mode 100644 tests/shell/features/osf.nft

diff --git a/tests/shell/features/osf.nft b/tests/shell/features/osf.nft
new file mode 100644
index 000000000000..dbb6b4c333e2
--- /dev/null
+++ b/tests/shell/features/osf.nft
@@ -0,0 +1,7 @@
+# b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
+# v4.19-rc1~140^2~135^2~15
+table t {
+	chain c {
+		osf name "Linux"
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index 5cf5dddeb1d6..263390d51a5d 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -4,11 +4,18 @@
 # without typeof, this is 'type string' and 'type integer',
 # but neither could be used because it lacks size information.
 
-EXPECTED="table inet t {
-	map m1 {
+OSFMAP=""
+OSFRULE=""
+if [ "$NFT_TEST_HAVE_osf" != n ] ; then
+	OSFMAP="map m1 {
 		typeof osf name : ct mark
 		elements = { "Linux" : 0x00000001 }
-	}
+	}"
+	OSFRULE="ct mark set osf name map @m1"
+fi
+
+EXPECTED="table inet t {
+	$OSFMAP
 
 	map m2 {
 		typeof vlan id : mark
@@ -33,7 +40,7 @@ EXPECTED="table inet t {
 	}
 
 	chain c {
-		ct mark set osf name map @m1
+		$OSFRULE
 		ether type vlan meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
 		iifname . ip protocol . th dport vmap @m4
@@ -45,3 +52,7 @@ EXPECTED="table inet t {
 set -e
 $NFT -f - <<< $EXPECTED
 
+if [ "$NFT_TEST_HAVE_osf" = n ] ; then
+	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 9f777a8c90bc..6ed0c354bc25 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -4,11 +4,20 @@
 # s1 and s2 are identical, they just use different
 # ways for declaration.
 
-EXPECTED="table inet t {
-	set s1 {
+OSFSET=""
+OSFCHAIN=""
+if [ "$NFT_TEST_HAVE_osf" != n ] ; then
+	OSFSET="set s1 {
 		typeof osf name
 		elements = { \"Linux\" }
-	}
+	}"
+	OSFCHAIN="chain c1 {
+		osf name @s1 accept
+	}"
+fi
+
+EXPECTED="table inet t {
+	$OSFSET
 
 	set s2 {
 		typeof vlan id
@@ -60,9 +69,7 @@ EXPECTED="table inet t {
 		elements = { 3567 . 1.2.3.4 }
 	}
 
-	chain c1 {
-		osf name @s1 accept
-	}
+	$OSFCHAIN
 
 	chain c2 {
 		ether type vlan vlan id @s2 accept
@@ -104,3 +111,7 @@ EXPECTED="table inet t {
 set -e
 $NFT -f - <<< $EXPECTED
 
+if [ "$NFT_TEST_HAVE_osf" = n ] ; then
+	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
+	exit 77
+fi
-- 
2.41.0

