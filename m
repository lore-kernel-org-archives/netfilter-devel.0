Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F0CC4167D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 18:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjKCSaH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 14:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbjKCSaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 14:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8136D49
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699036160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uk3MP8KC5ctslCRICFZOCB7Eyvh8tNywvNsWm34ye+I=;
        b=N48WcyFOmgxBcHkiKXK3u7ml+zsCTq832x7W89StujKmj0O1GjitibEPYswnKR2FPtxQ8O
        U/L8LdbFtNE6+PKLOomiXtws0EijUcZ2lQg1uq6iIhswNRW2Z4IC+OQWn0XPk5n7Fu8mpy
        GzmulaHWB2tBDOOw6bw6IOymOUSyTw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-dkNUEUXUO2-WxKe449KswA-1; Fri, 03 Nov 2023 14:29:18 -0400
X-MC-Unique: dkNUEUXUO2-WxKe449KswA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAB8885A58B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 18:29:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AFE32166B2C;
        Fri,  3 Nov 2023 18:29:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 5/6] tools: check more strictly for bash shebang in "check-tree.sh"
Date:   Fri,  3 Nov 2023 19:26:02 +0100
Message-ID: <20231103182901.3795263-6-thaller@redhat.com>
In-Reply-To: <20231103182901.3795263-1-thaller@redhat.com>
References: <20231103182901.3795263-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no principle problem to allow any executable/shebang. However,
it also not clear why we would want to use anything except bash.  Unless
we have a good reason, check and reject anything else.

Also not that `./tests/shell/run-tests.sh -x` only works if the shebang
is either "#!/bin/bash" or "#!/bin/bash -e". It probably could also work
with other tests, but it's unclear what they are and how to enable
verbose mode in that case.

Just check that they are all bash scripts. If there is a use-case, we
can always adjust this check.

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

