Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C22EE01F0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjIMRIN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjIMRH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0E2B19B6
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUL0WmypW+wRSVrbU7jLHJJ2qafhUnPJ/1lnmq2FaDs=;
        b=FIrgRpe0DmUmwysTuqxCn9kYaNgARjIUxMfhJi3HatWQas83F12K1WB5ADPbNkdmE25JYJ
        EwBG+Ex1hMLTpnOI/Th+2krpShMFbqLDolt5V8B0i5Z2gJgMfmOB52j7hy5RREb5YAEl5t
        3IKxL7juaW+G0HdrFATTAVkQO7AQnrc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-wLq-SRgNPpuXnQtK1gEYhA-1; Wed, 13 Sep 2023 13:07:03 -0400
X-MC-Unique: wLq-SRgNPpuXnQtK1gEYhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD18A85570E
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF5A40C6EA8;
        Wed, 13 Sep 2023 17:07:02 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/6] tests/shell: add missing nft/nodump files for tests
Date:   Wed, 13 Sep 2023 19:05:06 +0200
Message-ID: <20230913170649.439394-4-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Three tests didn't have a nft/nodump file, because previously I only
generated files on Fedora kernel, where those tests are failing.

Generate them on CentOS-Stream-9 with kernel 5.14.0-354.el9.x86_64.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/listing/dumps/0013objects_0.nft | 29 +++++++++++++++++++
 .../sets/dumps/reset_command_0.nodump         |  0
 .../transactions/dumps/bad_expression.nft     |  0
 3 files changed, 29 insertions(+)
 create mode 100644 tests/shell/testcases/listing/dumps/0013objects_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/reset_command_0.nodump
 create mode 100644 tests/shell/testcases/transactions/dumps/bad_expression.nft

diff --git a/tests/shell/testcases/listing/dumps/0013objects_0.nft b/tests/shell/testcases/listing/dumps/0013objects_0.nft
new file mode 100644
index 000000000000..1ea610f8b8d8
--- /dev/null
+++ b/tests/shell/testcases/listing/dumps/0013objects_0.nft
@@ -0,0 +1,29 @@
+table ip test {
+	quota https-quota {
+		25 mbytes
+	}
+
+	ct helper cthelp {
+		type "sip" protocol tcp
+		l3proto ip
+	}
+
+	ct timeout cttime {
+		protocol udp
+		l3proto ip
+		policy = { unreplied : 15s, replied : 12s }
+	}
+
+	ct expectation ctexpect {
+		protocol tcp
+		dport 5432
+		timeout 1h
+		size 12
+		l3proto ip
+	}
+
+	chain input {
+	}
+}
+table ip test-ip {
+}
diff --git a/tests/shell/testcases/sets/dumps/reset_command_0.nodump b/tests/shell/testcases/sets/dumps/reset_command_0.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/transactions/dumps/bad_expression.nft b/tests/shell/testcases/transactions/dumps/bad_expression.nft
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.41.0

