Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34607EE800C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjIHORp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbjIHORp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FE31BF9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEHyN+tY9m5HoRYjF14nnIwP8uB0Bbp8W0eIoDD135E=;
        b=ATeINPqe2GTtlYFB2EEgdLt3NrUy1YcetN9SnOOa9JYSqhRIZR8clJqxIDLvfoB5UcOWjn
        leaKBZKwYaqfFYeXrSjvJvzD2OGj5oQIZN99MHaBsdnYbv6hQxpFdv8egIBWyPjSwR+0Qb
        umL14S3bzK7ZnXcAoG7W79s7Bm9XiM4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-D4AEYXCgN1y-kqmXGbNofg-1; Fri, 08 Sep 2023 10:16:54 -0400
X-MC-Unique: D4AEYXCgN1y-kqmXGbNofg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6400A280FED9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 14:16:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09FE40C6CCC;
        Fri,  8 Sep 2023 14:16:48 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 4/4] tests/shell: add ".nft" dump files for tests without dumps/ directory
Date:   Fri,  8 Sep 2023 16:14:27 +0200
Message-ID: <20230908141634.1023071-5-thaller@redhat.com>
In-Reply-To: <20230908141634.1023071-1-thaller@redhat.com>
References: <20230908141634.1023071-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DUMPGEN=y mode skips tests that don't have a corresponding "dumps/"
directory.

Add the "dumps/" directory for tests that lacked it, and generate ".nft"
files by running `./tests/shell/run-tests.sh -g`.

Yes, they are all empty. Not very exciting, but why not check for that
too?

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/bogons/dumps/assert_failures.nft    | 0
 tests/shell/testcases/netns/dumps/0001nft-f_0.nft         | 0
 tests/shell/testcases/netns/dumps/0002loosecommands_0.nft | 0
 tests/shell/testcases/netns/dumps/0003many_0.nft          | 0
 tests/shell/testcases/nft-i/dumps/0001define_0.nft        | 0
 tests/shell/testcases/owner/dumps/0001-flowtable-uaf.nft  | 0
 6 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/dumps/assert_failures.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0001nft-f_0.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0002loosecommands_0.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0003many_0.nft
 create mode 100644 tests/shell/testcases/nft-i/dumps/0001define_0.nft
 create mode 100644 tests/shell/testcases/owner/dumps/0001-flowtable-uaf.nft

diff --git a/tests/shell/testcases/bogons/dumps/assert_failures.nft b/tests/shell/testcases/bogons/dumps/assert_failures.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/netns/dumps/0001nft-f_0.nft b/tests/shell/testcases/netns/dumps/0001nft-f_0.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/netns/dumps/0002loosecommands_0.nft b/tests/shell/testcases/netns/dumps/0002loosecommands_0.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/netns/dumps/0003many_0.nft b/tests/shell/testcases/netns/dumps/0003many_0.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/nft-i/dumps/0001define_0.nft b/tests/shell/testcases/nft-i/dumps/0001define_0.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/owner/dumps/0001-flowtable-uaf.nft b/tests/shell/testcases/owner/dumps/0001-flowtable-uaf.nft
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.41.0

