Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43F2E3F9
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707480983; cv=none; b=UihMqosudC1zi9Pjx5QuI2g3VjNOJMw/SPcaXHanc8F0veH9fmT/++gAdyweUpqHXpGh8hDzcjZtqoS6p0zirYYYa9KWcSGLaPmxnhDEN6J2bVdiF5XlseAhZeoJYoJNte7M+8h09aCx/n5imFqBvSGR9v4Kold2i0ZkyiBR+J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707480983; c=relaxed/simple;
	bh=5UyMVEVBHpY+l9LWn9DHBzffUrZ4pVa4MnOe/x079FA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MLmtlWjTWs27Kt1PpR0whBTeik6Pcp3zgNKYtgprXyp9BuSYVIF0Xp8qGcD014aPWJEekY58HyM8rGwf5OA/EUu55d5rzAawkTMMFWJd2O4q6pBr/HfzH3lz8j/Ql+txSa6hEnmT2O4TcK/HbzvnUg/YJqAm+LJF/Jx5TcWkFTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzHWMy9Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzHWMy9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707480977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YHWHUqPxwmXZhtZslp9Igb1z3Asoo+SFPMXyW3jRBRA=;
	b=WzHWMy9Qa9VIcvKbaBrUJassoGHHxTlrTUDvbMqelfYlQtOfP3hKIkr9ndQAmlukkr3iMu
	2xjKSY2S0zY61Cdr2dDfFaTFIAyJs/UJ/ZH/SwnTjze9TwNIGH0xQ5rAgDwRPEHnsip4X7
	7TLCJ15TyQNHXlbhdOT0Aq0CBTP+b6Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-xCMFMHQUPr-No4URj6olog-1; Fri,
 09 Feb 2024 07:16:15 -0500
X-MC-Unique: xCMFMHQUPr-No4URj6olog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ED4938135E8
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:16:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.59])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85B7E2026D06;
	Fri,  9 Feb 2024 12:16:14 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH 1/1] tests: use common shebang in "packetpath/flowtables" test
Date: Fri,  9 Feb 2024 13:13:04 +0100
Message-ID: <20240209121603.2294742-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

"./tools/check-tree.sh" checks for a certain shebang. Either `/bin/bash` or
`/bin/bash -e`. No other are currently allowed, because it makes sense to be
strict/consistent and there is no need such flexibility.

Move the "-x" to a later command.

Note that "set -x" may not be a good choice anyway. If you want to debug
a test and see the shell commands, you could just run

  $ ./tests/shell/run-tests.sh tests/shell/testcases/packetpath/flowtables -x

That will automatically use `/bin/bash -x` as interpreter. And that
works for all tests the same. This is also the reason why
"check-tree.sh" checks for a well-known shebang. Because the "-x" option
of the test runner mangles the shebang, but for that it needs to
understand it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
Btw, "check-tree.sh" also complains about lack of .nft/.nodump file.
The test should get one of these (depending on what's appropriate). You
can generate them with

    $ ./tests/shell/run-tests.sh tests/shell/testcases/packetpath/flowtables -g

 tests/shell/testcases/packetpath/flowtables | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index 852a05c6d0ab..b962984fb6ec 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -1,7 +1,9 @@
-#! /bin/bash -x
+#!/bin/bash
 
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 
+set -x
+
 rnd=$(mktemp -u XXXXXXXX)
 R="flowtable-router-$rnd"
 C="flowtable-client-$rnd"
-- 
2.43.0

