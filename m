Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3FDC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF36206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHk7g4w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgFNVmH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:42:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43602 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726844AbgFNVmH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592170926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iWIoNbbPiQapyQd3+GL17iM9l/cyZDSJFae5UkIyxDI=;
        b=cHk7g4w9qEfB9a7Uv/0UdUIXU9JHjWnRAuzrHjaQ+dDBMtkh0chA0U3pghyO+xYpLjHu1z
        fXyB0qNiy/zeGp7sEfeSDAy7ziBJMUU0aVJNG4gFd1mbtRmckVNQdgFi7F5jkHBlRuCfQp
        Y5/ryQvW7pI22v23QNqPohLJPOYIZl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-2dRNTRK9PHe-GUgXzV0ecA-1; Sun, 14 Jun 2020 17:41:57 -0400
X-MC-Unique: 2dRNTRK9PHe-GUgXzV0ecA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A48A107ACF4;
        Sun, 14 Jun 2020 21:41:56 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6C93100238D;
        Sun, 14 Jun 2020 21:41:54 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>,
        =?UTF-8?q?Laura=20Garc=C3=ADa=20Li=C3=A9bana?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Date:   Sun, 14 Jun 2020 23:41:49 +0200
Message-Id: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")
introduced the definition of DIFF at the top of run-tests.sh, to make
it visually part of the configuration section. Commit 68310ba0f9c2
("tests: shell: Search diff tool once and for all") override this
definition.

Drop the unexpected redefinition of DIFF.

Fixes: 68310ba0f9c2 ("tests: shell: Search diff tool once and for all")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/shell/run-tests.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 94115066b1bf..fcc87a8957c8 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -45,7 +45,6 @@ if [ ! -x "$MODPROBE" ] ; then
 	msg_error "no modprobe binary found"
 fi
 
-DIFF="$(which diff)"
 if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
-- 
2.27.0

