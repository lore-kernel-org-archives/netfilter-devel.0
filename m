Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714FFC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FEF20776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TS31JgV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgEXNAs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgEXNAr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yCWbbSQdUSB34seiefqT+0h/Wh/XEyCYpwYHY597OdY=;
        b=TS31JgV1wgVMOa5RRf8reejIYxsoa8wJS98xYVhWoGlp7wvk9f5lAaSvk6TfGLIIkVBbnA
        8er6ZOaZyOKZrtcjL+K6dJ0OasjV0fNOLuzhdjOCeFZdNSJPVwHF/oTDtfW1yaTWBo3/Sy
        gZ3rjwwM6gjOhT8Ofx4lnp7G3ecz6+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-Zlxz1pTlPh-p4PLt8_R60A-1; Sun, 24 May 2020 09:00:44 -0400
X-MC-Unique: Zlxz1pTlPh-p4PLt8_R60A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEFB01855A00;
        Sun, 24 May 2020 13:00:43 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A957797EB;
        Sun, 24 May 2020 13:00:42 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: Introduce test for concatenated ranges in anonymous sets
Date:   Sun, 24 May 2020 15:00:27 +0200
Message-Id: <5735155a0e98738cdc5507385d6225e05c225465.1590324033.git.sbrivio@redhat.com>
In-Reply-To: <cover.1590324033.git.sbrivio@redhat.com>
References: <cover.1590324033.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a simple anonymous set including a concatenated range and check
it's inserted correctly. This is roughly based on the existing
0025_anonymous_set_0 test case.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/shell/testcases/sets/0048anonymous_set_concat_0      | 7 +++++++
 .../testcases/sets/dumps/0048anonymous_set_concat_0.nft    | 6 ++++++
 2 files changed, 13 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0048anonymous_set_concat_0
 create mode 100644 tests/shell/testcases/sets/dumps/0048anonymous_set_concat_0.nft

diff --git a/tests/shell/testcases/sets/0048anonymous_set_concat_0 b/tests/shell/testcases/sets/0048anonymous_set_concat_0
new file mode 100755
index 000000000000..fab61231d0c0
--- /dev/null
+++ b/tests/shell/testcases/sets/0048anonymous_set_concat_0
@@ -0,0 +1,7 @@
+#!/bin/sh -e
+#
+# 0048anonymous_sets_concat_0 - Anonymous sets with concatenated ranges
+
+${NFT} add table t
+${NFT} add chain t c '{ type filter hook forward priority 0 ; }'
+${NFT} add rule t c 'ip daddr . tcp dport { 192.0.2.1 . 49152-65535 }'
diff --git a/tests/shell/testcases/sets/dumps/0048anonymous_set_concat_0.nft b/tests/shell/testcases/sets/dumps/0048anonymous_set_concat_0.nft
new file mode 100644
index 000000000000..c54ffae9d6d2
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0048anonymous_set_concat_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook forward priority filter; policy accept;
+		ip daddr . tcp dport { 192.0.2.1 . 49152-65535 }
+	}
+}
-- 
2.26.2

