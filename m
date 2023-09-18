Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34644CD13DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbjIRKb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbjIRKa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321C6115
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5qYzvMPosfU/uwPbGbaa8awj1oagjeI410P5th8zJE=;
        b=M0/ZtYwNFgkjqqErfrokxYQz//B5bpouoValFcES5VAIeuEpTV1BDM41PVoofP7xywctfl
        3O0KvFMChx/hymXjunIjzy++52cUihEdeRhweiKS+rrCfTzBJP1chp9d9ygzV2bxNku9aU
        aEgwEjLWNoNx3wNVPQonPgoGOlEOXx8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-RfGUL4AYNbmgNmt-W9cVFQ-1; Mon, 18 Sep 2023 06:30:04 -0400
X-MC-Unique: RfGUL4AYNbmgNmt-W9cVFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A41B43C025BF;
        Mon, 18 Sep 2023 10:30:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03031C15BB8;
        Mon, 18 Sep 2023 10:30:02 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 06/14] tests/shell: skip some tests if kernel lacks netdev egress support
Date:   Mon, 18 Sep 2023 12:28:20 +0200
Message-ID: <20230918102947.2125883-7-thaller@redhat.com>
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
 tests/shell/features/netdev_egress.nft            | 7 +++++++
 tests/shell/testcases/chains/0021prio_0           | 7 ++++++-
 tests/shell/testcases/chains/0042chain_variable_0 | 5 +++++
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/features/netdev_egress.nft

diff --git a/tests/shell/features/netdev_egress.nft b/tests/shell/features/netdev_egress.nft
new file mode 100644
index 000000000000..67d706d86c5f
--- /dev/null
+++ b/tests/shell/features/netdev_egress.nft
@@ -0,0 +1,7 @@
+# 42df6e1d221d ("netfilter: Introduce egress hook")
+# v5.16-rc1~159^2~167^2~10
+table netdev t {
+	chain c {
+		type filter hook egress devices = { lo } priority 0; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/chains/0021prio_0 b/tests/shell/testcases/chains/0021prio_0
index d450dc0b6c34..ceda15583520 100755
--- a/tests/shell/testcases/chains/0021prio_0
+++ b/tests/shell/testcases/chains/0021prio_0
@@ -69,7 +69,7 @@ done
 family=netdev
 echo "add table $family x"
 gen_chains $family ingress filter lo
-gen_chains $family egress filter lo
+[ "$NFT_TEST_HAVE_netdev_egress" != n ] && gen_chains $family egress filter lo
 
 family=bridge
 echo "add table $family x"
@@ -83,3 +83,8 @@ gen_chains $family postrouting srcnat
 
 ) >$tmpfile
 $NFT -f $tmpfile
+
+if [ "$NFT_TEST_HAVE_netdev_egress" = n ]; then
+	echo "Ran a modified version of the test due to NFT_TEST_HAVE_netdev_egress=n"
+	exit 77
+fi
diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
index f71b04155e44..1ea44e85c71f 100755
--- a/tests/shell/testcases/chains/0042chain_variable_0
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -24,6 +24,11 @@ table netdev filter2 {
 
 $NFT -f - <<< $EXPECTED
 
+if [ "$NFT_TEST_HAVE_netdev_egress" = n ] ; then
+	echo "Skip parts of the test due to NFT_TEST_HAVE_netdev_egress=n"
+	exit 77
+fi
+
 EXPECTED="define if_main = { lo, dummy0 }
 define lan_interfaces = { lo }
 
-- 
2.41.0

