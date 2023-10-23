Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4874AC25B47
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 17:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjJWRCG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjJWRCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 13:02:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B68BD
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698080477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkMM5RtB7UM8WAnoGqfXP6ZqIk6tHpz+dOnVTT8cYzg=;
        b=JC9fE+IX+WW+OEcumHT/BqkEBU8PVset5nTQPBdZTj9otUGWnajgxcjLcGuGl1UoOV65Gi
        wN8MgB7yJJYTS401ODkMdSyxXChh6BbwgwniVLAMS19IZJwgdmOg9RimikOOPPWX9dpEF+
        BFL87abaoAKKnuzr3huCOCs+CU5L1s0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-saQMjylcMbGaEDXspM7VyQ-1; Mon,
 23 Oct 2023 13:01:10 -0400
X-MC-Unique: saQMjylcMbGaEDXspM7VyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A84FA38062A4
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:01:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 279C71121314;
        Mon, 23 Oct 2023 17:01:10 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] parser_bison: fix length check for ifname in ifname_expr_alloc()
Date:   Mon, 23 Oct 2023 19:00:47 +0200
Message-ID: <20231023170058.919275-3-thaller@redhat.com>
In-Reply-To: <20231023170058.919275-1-thaller@redhat.com>
References: <20231023170058.919275-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

IFNAMSIZ is 16, and the allowed byte length of the name is one less than
that. Fix the length check and adjust a test for covering the longest
allowed interface name.

This is obviously a change in behavior, because previously interface
names with length 16 were accepted and were silently truncated along the
way. Now they are rejected as invalid.

Fixes: fa52bc225806 ('parser: reject zero-length interface names')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/parser_bison.y                                | 3 ++-
 tests/shell/testcases/chains/0042chain_variable_0 | 7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f0652ba651c6..9bfc3cdb2d12 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -16,6 +16,7 @@
 #include <stdio.h>
 #include <inttypes.h>
 #include <syslog.h>
+#include <net/if.h>
 #include <netinet/ip.h>
 #include <netinet/tcp.h>
 #include <netinet/if_ether.h>
@@ -158,7 +159,7 @@ static struct expr *ifname_expr_alloc(const struct location *location,
 		return NULL;
 	}
 
-	if (length > 16) {
+	if (length >= IFNAMSIZ) {
 		xfree(name);
 		erec_queue(error(location, "interface name too long"), queue);
 		return NULL;
diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
index 739dc05a1777..a4b929f7344c 100755
--- a/tests/shell/testcases/chains/0042chain_variable_0
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -26,18 +26,13 @@ table netdev filter2 {
 
 rc=0
 $NFT -f - <<< $EXPECTED || rc=$?
-test "$rc" = 0
+test "$rc" = 1
 cat <<EOF | $DIFF -u <($NFT list ruleset) -
 table netdev filter1 {
 	chain Main_Ingress1 {
 		type filter hook ingress device "lo" priority -500; policy accept;
 	}
 }
-table netdev filter2 {
-	chain Main_Ingress2 {
-		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
-	}
-}
 EOF
 
 
-- 
2.41.0

