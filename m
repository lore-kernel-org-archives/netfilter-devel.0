Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5003C4167D
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Oct 2023 18:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjJaSzu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjJaSzt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 14:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D67AB4
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 11:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698778501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=maccioG2vh1eoDZeRT+UvWaEaIlILNihdGDkYIWSUQI=;
        b=MI3Ef9yHLBBFx0N/0CzWnuL9qP/EWEn74uv+Jsp6Ku8bzs2OiCIX5fXkYep/zSvFHIcSPg
        p1PoH8/EC0JoV3AMkKB62YZSL4SgIVRF83x1RxQl2ombR0ZWp2aC8fqEtBO1hDuG5aVGTV
        utc/OTqbPIR7CCm9RYNqPXRXUWlyc/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-iiKAa9BCMa2LU3ltsMkg7w-1; Tue, 31 Oct 2023 14:55:00 -0400
X-MC-Unique: iiKAa9BCMa2LU3ltsMkg7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C884D185A782
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 18:54:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 140B310F51;
        Tue, 31 Oct 2023 18:54:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/7] json: fix use after free in table_flags_json()
Date:   Tue, 31 Oct 2023 19:53:27 +0100
Message-ID: <20231031185449.1033380-2-thaller@redhat.com>
In-Reply-To: <20231031185449.1033380-1-thaller@redhat.com>
References: <20231031185449.1033380-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Valgrind complains about this:

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
  ==286==  Address 0x5038650 is 0 bytes inside a block of size 32 free'd
  ==286==    at 0x48452AC: free (vg_replace_malloc.c:974)
  ==286==    by 0x49AECDD: UnknownInlinedFun (jansson.h:133)
  ==286==    by 0x49AECDD: UnknownInlinedFun (jansson.h:131)
  ==286==    by 0x49AECDD: UnknownInlinedFun (value.c:398)
  ==286==    by 0x49AECDD: json_delete (value.c:953)
  ==286==    by 0x48A9F61: json_decref (jansson.h:133)
  ==286==    by 0x48AA4AA: table_flags_json (json.c:494)
  ==286==    by 0x48AA52B: table_print_json (json.c:510)
  ==286==    by 0x48ABBAE: table_print_json_full (json.c:1695)
  ==286==    by 0x48ABD48: do_list_ruleset_json (json.c:1739)
  ==286==    by 0x48AF2A0: do_command_list_json (json.c:1962)
  ==286==    by 0x48732F1: do_command_list (rule.c:2335)
  ==286==    by 0x48737F5: do_command (rule.c:2605)
  ==286==    by 0x48A867D: nft_netlink (libnftables.c:42)
  ==286==    by 0x48A92B1: nft_run_cmd_from_buffer (libnftables.c:597)
  ==286==    by 0x402CBA: main (main.c:533)
  ==286==  Block was alloc'd at
  ==286==    at 0x484282F: malloc (vg_replace_malloc.c:431)
  ==286==    by 0x49AE4EA: UnknownInlinedFun (memory.c:27)
  ==286==    by 0x49AE4EA: UnknownInlinedFun (value.c:676)
  ==286==    by 0x49AE4EA: json_stringn_nocheck (value.c:696)
  ==286==    by 0x48AA464: table_flags_json (json.c:482)
  ==286==    by 0x48AA52B: table_print_json (json.c:510)
  ==286==    by 0x48ABBAE: table_print_json_full (json.c:1695)
  ==286==    by 0x48ABD48: do_list_ruleset_json (json.c:1739)
  ==286==    by 0x48AF2A0: do_command_list_json (json.c:1962)
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

