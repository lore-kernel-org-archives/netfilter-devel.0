Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346A1C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Apr 2022 10:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiDRKMU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiDRKMS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 06:12:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B639D17E30
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:09:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ngOK8-0008Qp-8C; Mon, 18 Apr 2022 12:09:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: add concat test case with integer base type subkey
Date:   Mon, 18 Apr 2022 12:09:24 +0200
Message-Id: <20220418100924.5669-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418100924.5669-1-fw@strlen.de>
References: <20220418100924.5669-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/maps/dumps/typeof_maps_0.nft | 6 ++++++
 tests/shell/testcases/maps/typeof_maps_0           | 6 ++++++
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft | 9 +++++++++
 tests/shell/testcases/sets/typeof_sets_0           | 9 +++++++++
 4 files changed, 30 insertions(+)

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
index ea411335cbd4..a5c0a60927a7 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
@@ -20,11 +20,17 @@ table inet t {
 		elements = { "eth0" . tcp . 22 : accept }
 	}
 
+	map m5 {
+		typeof ipsec in reqid . iifname : verdict
+		elements = { 23 . "eth0" : accept }
+	}
+
 	chain c {
 		ct mark set osf name map @m1
 		meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
 		iifname . ip protocol . th dport vmap @m4
 		iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
+		ipsec in reqid . iifname vmap @m5
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index 1014d8115fd9..5cf5dddeb1d6 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -27,12 +27,18 @@ EXPECTED="table inet t {
 		elements = { eth0 . tcp . 22 : accept }
 	}
 
+	map m5 {
+		typeof ipsec in reqid . meta iifname : verdict
+		elements = { 23 . eth0 : accept }
+	}
+
 	chain c {
 		ct mark set osf name map @m1
 		ether type vlan meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
 		iifname . ip protocol . th dport vmap @m4
 		iifname . ip protocol . th dport vmap { \"eth0\" . tcp . 22 : accept, \"eth1\" . udp . 67 : drop }
+		ipsec in reqid . meta iifname vmap @m5
 	}
 }"
 
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index e397a6345462..68b4dcc56e9a 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -45,6 +45,11 @@ table inet t {
 			     15 }
 	}
 
+	set s10 {
+		typeof iifname . ip saddr . ipsec in reqid
+		elements = { "eth0" . 10.1.1.2 . 42 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -76,4 +81,8 @@ table inet t {
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
+
+	chain c10 {
+		iifname . ip saddr . ipsec in reqid @s10 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index be906cdcc842..5fc6a1214729 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -50,6 +50,11 @@ EXPECTED="table inet t {
 		elements = { 0, 1, 2, 3, 4, 15 }
 	}
 
+	set s10 {
+		typeof meta iifname . ip saddr . ipsec in reqid
+		elements = { \"eth0\" . 10.1.1.2 . 42 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -81,6 +86,10 @@ EXPECTED="table inet t {
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
+
+	chain c10 {
+		meta iifname . ip saddr . ipsec in reqid @s10 accept
+	}
 }"
 
 set -e
-- 
2.35.1

