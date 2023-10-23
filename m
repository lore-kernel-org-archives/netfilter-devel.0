Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7654DC25B47
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 17:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjJWRD4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjJWRCU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 13:02:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4787E6
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698080489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rR5viGeZ/Gm3D58t0qtB1DRIgVx9ABBgtxEXtURmT28=;
        b=JLrpWCwG/0sZ1nvDk8vosBx3oquT/bKbC9XvRtvQPaLK+JOTzFR3OJpqecELJVq7GgoJr3
        +urkcDDmiGIme3tfYcmA5Oq8qFwYQYxv6zF3ppAOxUkMxuwYTuCgTRZsushjPm2nFQ/qkF
        g5bXLJwfz5QgYVsk0aydvduR8THS+mc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-9i4eOF3fMpGSstGVjwCSfg-1; Mon,
 23 Oct 2023 13:01:11 -0400
X-MC-Unique: 9i4eOF3fMpGSstGVjwCSfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05FBA1C0518E
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:01:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79CD31121314;
        Mon, 23 Oct 2023 17:01:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: add "bogons/nft-f/zero_length_devicename2_assert"
Date:   Mon, 23 Oct 2023 19:00:45 +0200
Message-ID: <20231023170058.919275-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is copied from "bogons/nft-f/zero_length_devicename_assert" and
adjusted.

- `device""lo"` looks odd. In this file use `device ""` to only check
  against empty strings, without oddity.

- "ip" type has no hook ingress in filter. If the device name would be
  valid, the file would still be rejected. Use "netdev".

The purpose is to add a test for a file that would otherwise pass,
except having an empty device name. Without oddities.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/bogons/nft-f/zero_length_devicename2_assert    | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename2_assert

diff --git a/tests/shell/testcases/bogons/nft-f/zero_length_devicename2_assert b/tests/shell/testcases/bogons/nft-f/zero_length_devicename2_assert
new file mode 100644
index 000000000000..fe416f8536e9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/zero_length_devicename2_assert
@@ -0,0 +1,5 @@
+table netdev x {
+        chain Main_Ingress1 {
+                type filter hook ingress device "" priority -1
+	}
+}
-- 
2.41.0

