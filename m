Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7FCC41535
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 16:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjKNQJY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 11:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbjKNQJX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 11:09:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC7FE
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 08:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699978160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZMANz2O4E2UlZm37i1nFYAY1Rp4ec3xqNe157XszIQs=;
        b=OvEABi+V8PKAqW1GWhnCuPzLdRQ5Cvhx7dqUBnlAZZa+v3QvQpMHv4Z7NeNYrsDMyE3zcu
        yEU/ZLVv1E9pUcFtrtrwoyN5iwPaSVsAmXeDoZFmM5csdiRfBBXq4Ia1CNO89COJq9TPCz
        azwoDdfXPA/XP4ZvNyzjjVO0pPOrH6c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-ldn1bmCVOMCJE9iy0eMJ2A-1; Tue, 14 Nov 2023 11:09:18 -0500
X-MC-Unique: ldn1bmCVOMCJE9iy0eMJ2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86FFB811E93
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 16:09:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07CC4502C;
        Tue, 14 Nov 2023 16:09:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 5/6] tools: check more strictly for bash shebang in "check-tree.sh"
Date:   Tue, 14 Nov 2023 17:08:30 +0100
Message-ID: <20231114160903.409552-4-thaller@redhat.com>
In-Reply-To: <20231114160903.409552-1-thaller@redhat.com>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no problem in principle to allow any executable/shebang. However,
it also not clear why we would want to use anything except bash. Unless
we have a good use case, check and reject anything else.

Also not that `./tests/shell/run-tests.sh -x` only works if the shebang
is either exactly "#!/bin/bash" or "#!/bin/bash -e". While it probably
could be made work with other shebangs, the simpler thing is to just use
bash consistently.

Just check that they are all bash scripts. If there ever is a use-case,
we can always adjust this check.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tools/check-tree.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/check-tree.sh b/tools/check-tree.sh
index b16d37c4651b..4be874fcd85e 100755
--- a/tools/check-tree.sh
+++ b/tools/check-tree.sh
@@ -72,8 +72,13 @@ if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
 fi
 for t in "${SHELL_TESTS[@]}" ; do
 	check_shell_dumps "$t"
-	if head -n 1 "$t" |grep -q  '^#!/bin/sh' ; then
-		msg_err "$t uses #!/bin/sh instead of /bin/bash"
+	if ! ( head -n 1 "$t" | grep -q '^#!/bin/bash\( -e\)\?$' ) ; then
+		# Currently all tests only use bash as shebang. That also
+		# works with `./tests/shell/run-tests.sh -x`.
+		#
+		# We could allow other shebangs, but for now there is no need.
+		# Unless you have a good reason, create a bash script.
+		msg_err "$t should use either \"#!/bin/bash\" or \"#!/bin/bash -e\" as shebang"
 	fi
 done
 
-- 
2.41.0

