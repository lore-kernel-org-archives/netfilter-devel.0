Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B745C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 15:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjKNPcm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjKNPcl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 10:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ABB93
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 07:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699975958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=spxyS/g6gflZyUowk0ETgfotPS8E2LoKyBSH8A7LoX8=;
        b=UAIRxM34fQLZBGZK6M/it/Z3C3gDIomPb79qOI82DTRo12bywZH7d5Gfz7iqPd5NrUPWos
        YYRwIOZ8lI/pzCeaTau7SnaMghNW3n1V6+zHGFXV6cQ4VYkWwx8tRFlSpbI6PRhWqZzTzz
        IM2NDLMq/RMvH7d1Qgog8OpZrdxbOK0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-p5dm35oGNwKwy-yxgo00Mw-1; Tue,
 14 Nov 2023 10:32:36 -0500
X-MC-Unique: p5dm35oGNwKwy-yxgo00Mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD59E2808B24
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8F9DC12930;
        Tue, 14 Nov 2023 15:31:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 1/6] json: fix use after free in table_flags_json()
Date:   Tue, 14 Nov 2023 16:29:25 +0100
Message-ID: <20231114153150.406334-2-thaller@redhat.com>
In-Reply-To: <20231114153150.406334-1-thaller@redhat.com>
References: <20231114153150.406334-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add `$NFT -j list ruleset` to the end of "tests/shell/testcases/transactions/table_onoff".
Then valgrind will find this issue:

  $ make -j && ./tests/shell/run-tests.sh tests/shell/testcases/transactions/table_onoff -V

Gives:

  ==286== Invalid read of size 4
  ==286==    at 0x49B0261: do_dump (dump.c:211)
  ==286==    by 0x49B08B8: do_dump (dump.c:378)
  ==286==    by 0x49B08B8: do_dump (dump.c:378)
  ==286==    by 0x49B04F7: do_dump (dump.c:273)
  ==286==    by 0x49B08B8: do_dump (dump.c:378)
  ==286==    by 0x49B0E84: json_dump_callback (dump.c:465)
  ==286==    by 0x48AF22A: do_command_list_json (json.c:2016)
  ==286==    by 0x48732F1: do_command_list (rule.c:2335)
  ==286==    by 0x48737F5: do_command (rule.c:2605)
  ==286==    by 0x48A867D: nft_netlink (libnftables.c:42)
  ==286==    by 0x48A92B1: nft_run_cmd_from_buffer (libnftables.c:597)
  ==286==    by 0x402CBA: main (main.c:533)

Fixes: e70354f53e9f ("libnftables: Implement JSON output support")
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index 23bd247221d3..81328ab3a4e4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -496,7 +496,7 @@ static json_t *table_flags_json(const struct table *table)
 		json_decref(root);
 		return NULL;
 	case 1:
-		json_unpack(root, "[o]", &tmp);
+		json_unpack(root, "[O]", &tmp);
 		json_decref(root);
 		root = tmp;
 		break;
-- 
2.41.0

