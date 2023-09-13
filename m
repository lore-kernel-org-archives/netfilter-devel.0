Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73532EE01EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjIMRIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjIMRHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46C3119B1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MbYumLuhjEcj3uy0cN0tdSGCK5uYpblGkAo9gGbZMxw=;
        b=NKf7CcM/BugzXl7qt2hkNK7viH1ZXHkO7BtViVVfEzbdyfo8j29MpawBAERtUME6A0whfZ
        pZQ4CFsm3LltbA65U5nZSQfzs5g1twzgar6VtKn02/6t/WAFEQ0h4toJs5gF7OgdYI5KmG
        dmmy5+t8gc8nEGF43eU6x73ThgVMry0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-TTRlAOLVOrmz6MoADNN0Cw-1; Wed, 13 Sep 2023 13:07:01 -0400
X-MC-Unique: TTRlAOLVOrmz6MoADNN0Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59D9381D79F
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCA5740C6EA8;
        Wed, 13 Sep 2023 17:07:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/6] tests/shell: remove spurious .nft dump files
Date:   Wed, 13 Sep 2023 19:05:04 +0200
Message-ID: <20230913170649.439394-2-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are left-over dumps ([1]), or dumps generated with the wrong name
([2]). Remove the files.

[1] commit eb14363d44ce ('tests: shell: move chain priority and policy to chain folder')
[2] commit b4775dec9f80 ('src: ingress inet support')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/chains/dumps/0043chain_ingress.nft      | 11 -----------
 .../testcases/nft-f/dumps/0026policy_variable_0.nft   |  5 -----
 2 files changed, 16 deletions(-)
 delete mode 100644 tests/shell/testcases/chains/dumps/0043chain_ingress.nft
 delete mode 100644 tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft

diff --git a/tests/shell/testcases/chains/dumps/0043chain_ingress.nft b/tests/shell/testcases/chains/dumps/0043chain_ingress.nft
deleted file mode 100644
index 74670423fc84..000000000000
--- a/tests/shell/testcases/chains/dumps/0043chain_ingress.nft
+++ /dev/null
@@ -1,11 +0,0 @@
-table inet filter {
-	chain ingress {
-		type filter hook ingress device \"lo\" priority filter; policy accept;
-	}
-	chain input {
-		type filter hook input priority filter; policy accept;
-	}
-	chain forward {
-		type filter hook forward priority filter; policy accept;
-	}
-}
diff --git a/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
deleted file mode 100644
index d729e1eab74d..000000000000
--- a/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
+++ /dev/null
@@ -1,5 +0,0 @@
-table inet global {
-	chain prerouting {
-		type filter hook prerouting priority filter; policy drop;
-	}
-}
-- 
2.41.0

