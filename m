Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD83C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 08:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbjKBIRK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 04:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345365AbjKBIRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 04:17:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC71182
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 01:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698912976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xNrTht97+0FRPvxo+w+8ZAHmWFax25OFefF5vMLzOtY=;
        b=fxtnJhETulPLmYa+ZKnDG1f2JlV8Ms8eOoXHqfrTsvl/CmoQcH9rk2VFkxOcpkGerW7xlp
        lln4oZUoopsiYsTzXKhPA5+nsD5u3EdYDs6tj1vzDEEwp74iudUPNjVyL8fZOEFRdnqNi3
        pZkicX6XDLxWVEx3b7GVUhLFotGC+p0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-SlXOb-8xP7OPbrjxf11ouQ-1; Thu, 02 Nov 2023 04:16:12 -0400
X-MC-Unique: SlXOb-8xP7OPbrjxf11ouQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BA00185A784
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 08:16:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1E4640C6EBC;
        Thu,  2 Nov 2023 08:16:11 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: fix mount command in "test-wrapper.sh"
Date:   Thu,  2 Nov 2023 09:15:41 +0100
Message-ID: <20231102081601.154862-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With Fedora 39 (util-linux-core-2.39.2-1.fc39), the mount command starts
to fail. It was still working with Fedora 38 (util-linux-core-2.38.1-4.fc38).

  $ unshare -f -p -m --mount-proc -U --map-root-user -n bash -c 'mount -t tmpfs --make-private /var/run && mount'
  mount: /run: mount failed: Invalid argument.

Not sure why this starts to fail. But arguably the command line
arguments were wrong. Fix it, we need a pseudo name for the device.

Fixes: df6f1a3e0803 ("tests/shell: bind mount private /var/run/netns in test container")
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 872a0c56ed54..b74c56168768 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -48,7 +48,7 @@ if [ "$NFT_TEST_HAS_UNSHARED_MOUNT" = y ] ; then
 	# Note that this also hides everything that might reside in /var/run.
 	# That is desirable, as tests should not depend on content there (or if
 	# they do, we need to explicitly handle it as appropriate).
-	if mount -t tmpfs --make-private "/var/run" ; then
+	if mount -t tmpfs --make-private tmpfs "/var/run" ; then
 		CLEANUP_UMOUNT_VAR_RUN=y
 	fi
 	mkdir -p /var/run/netns
-- 
2.41.0

