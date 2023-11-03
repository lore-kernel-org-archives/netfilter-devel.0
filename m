Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB260C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 18:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjKCSaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 14:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbjKCSaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 14:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481DED4E
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699036155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJ6HJiSZLn4risYPFVNst9NQ1P/OwS1o/tiav80BmyE=;
        b=UQO6xE+AZdoSw9qEKY3tdGIl+gH7rPvTac34NcUsoYn8YBmu7wu347eXaKOKB/BIhbq8Is
        4QlVQWjJdtQm2X1Dippn9CxqqpWEqpls+dqZcdPHQtVpnlddquHE7vGNIaA555Hvm/Uf4z
        c8VJYBLDJO35+OaWf1OitIlUxf6QcWc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-eiDvawN-NXu6somtc_3ImQ-1; Fri, 03 Nov 2023 14:29:14 -0400
X-MC-Unique: eiDvawN-NXu6somtc_3ImQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B855A101A52D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 18:29:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 386352166B27;
        Fri,  3 Nov 2023 18:29:13 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/6] json: fix use after free in table_flags_json()
Date:   Fri,  3 Nov 2023 19:25:58 +0100
Message-ID: <20231103182901.3795263-2-thaller@redhat.com>
In-Reply-To: <20231103182901.3795263-1-thaller@redhat.com>
References: <20231103182901.3795263-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
index 068c423addc7..c0ccf06d85b4 100644
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

