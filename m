Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DC1C25B45
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 17:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjJWRB6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjJWRB5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 13:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC44100
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698080471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9iLNOxxMdEI37hTaXAchFNeig2293MngGC0WoX3oYQ=;
        b=djRGqVoG88RwF9aqExPvbqI8Pcb0hq3lsx14ltJMUffVXh8Dy01YbICszvke9WuB8udEon
        EXIxi+rGuimSH0a8RPancq2VW6SqUg50y+Q65A0ZRO+p6D66FoMDhPOVr3uDbd2i27B13f
        z6k43Kqk1cicw5O/Mr+P0B0f4v2/pXw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-NjNibsZbMCehj1lOvjpQaQ-1; Mon,
 23 Oct 2023 13:01:10 -0400
X-MC-Unique: NjNibsZbMCehj1lOvjpQaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFEA438062AC
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:01:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 411061121314;
        Mon, 23 Oct 2023 17:01:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: cover long interface name in "0042chain_variable_0" test
Date:   Mon, 23 Oct 2023 19:00:46 +0200
Message-ID: <20231023170058.919275-2-thaller@redhat.com>
In-Reply-To: <20231023170058.919275-1-thaller@redhat.com>
References: <20231023170058.919275-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

IFNAMSIZ is 16. Adjust "0042chain_variable_0" to use an interface name
with the maximum allowed bytes length.

Instead of adding an entirely different test, adjust an existing one to
use another interface name. The aspect for testing for a long interface
name is not special enough, to warrant a separate test. We can cover it
by extending an existing test.

Note that the length check in "parser_bison.y" is wrong. The test checks
still for the wrong behavior and that "d23456789012345x" is accepted.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/chains/0042chain_variable_0     | 36 ++++++++++++++++---
 .../chains/dumps/0042chain_variable_0.nft     |  4 +--
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
index 1ea44e85c71f..739dc05a1777 100755
--- a/tests/shell/testcases/chains/0042chain_variable_0
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -2,7 +2,8 @@
 
 set -e
 
-ip link add name dummy0 type dummy
+ip link add name d23456789012345 type dummy
+
 
 EXPECTED="define if_main = \"lo\"
 
@@ -14,22 +15,50 @@ table netdev filter1 {
 
 $NFT -f - <<< $EXPECTED
 
+
+EXPECTED="define if_main = \"lo\"
+
+table netdev filter2 {
+	chain Main_Ingress2 {
+		type filter hook ingress devices = { \$if_main, d23456789012345x } priority -500; policy accept;
+	}
+}"
+
+rc=0
+$NFT -f - <<< $EXPECTED || rc=$?
+test "$rc" = 0
+cat <<EOF | $DIFF -u <($NFT list ruleset) -
+table netdev filter1 {
+	chain Main_Ingress1 {
+		type filter hook ingress device "lo" priority -500; policy accept;
+	}
+}
+table netdev filter2 {
+	chain Main_Ingress2 {
+		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
+	}
+}
+EOF
+
+
 EXPECTED="define if_main = \"lo\"
 
 table netdev filter2 {
 	chain Main_Ingress2 {
-		type filter hook ingress devices = { \$if_main, dummy0 } priority -500; policy accept;
+		type filter hook ingress devices = { \$if_main, d23456789012345 } priority -500; policy accept;
 	}
 }"
 
 $NFT -f - <<< $EXPECTED
 
+
 if [ "$NFT_TEST_HAVE_netdev_egress" = n ] ; then
 	echo "Skip parts of the test due to NFT_TEST_HAVE_netdev_egress=n"
 	exit 77
 fi
 
-EXPECTED="define if_main = { lo, dummy0 }
+
+EXPECTED="define if_main = { lo, d23456789012345 }
 define lan_interfaces = { lo }
 
 table netdev filter3 {
@@ -43,4 +72,3 @@ table netdev filter3 {
 
 $NFT -f - <<< $EXPECTED
 
-
diff --git a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
index 5ec230d0bcfa..84a908d33dee 100644
--- a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
+++ b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
@@ -5,12 +5,12 @@ table netdev filter1 {
 }
 table netdev filter2 {
 	chain Main_Ingress2 {
-		type filter hook ingress devices = { dummy0, lo } priority -500; policy accept;
+		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
 	}
 }
 table netdev filter3 {
 	chain Main_Ingress3 {
-		type filter hook ingress devices = { dummy0, lo } priority -500; policy accept;
+		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
 	}
 
 	chain Main_Egress3 {
-- 
2.41.0

