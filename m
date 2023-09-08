Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8361BEE14D8
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 17:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbjIHROl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 13:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjIHROf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 13:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D58B199F
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 10:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694193224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zzT9S29F0D47mpuypGXROEAbqcMshuzBGpYGjxTQ6PI=;
        b=YSHUrfbCNhTTeCHDq0t3IBYPRupFlL6JIAh/uZN0dJpPe2mX82zgM/XcClKECmCL0UyOR0
        13RcMope4L9gOkV/uCBaFPLoTEvmNTxR+EPuYVdZW9g0DmGoKj65RUA5YCjC/G7RUy7sPA
        kmuImlWhrmvWGYwH0lUPQgTw4+fplkg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-bJx_VKYFM9arF6zQ9Awcrw-1; Fri, 08 Sep 2023 13:13:41 -0400
X-MC-Unique: bJx_VKYFM9arF6zQ9Awcrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC1481817929
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 17:13:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 368FB2013570;
        Fri,  8 Sep 2023 17:13:40 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] cache: avoid accessing uninitialized varible in implicit_chain_cache()
Date:   Fri,  8 Sep 2023 19:13:27 +0200
Message-ID: <20230908171329.1175287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  $ ./tests/shell/run-tests.sh -V tests/shell/testcases/cache/0010_implicit_chain_0

Gives:

  ==59== Conditional jump or move depends on uninitialised value(s)
  ==59==    at 0x48A6A6B: mnl_nft_rule_dump (mnl.c:695)
  ==59==    by 0x48778EA: rule_cache_dump (cache.c:664)
  ==59==    by 0x487797D: rule_init_cache (cache.c:997)
  ==59==    by 0x4877ABF: implicit_chain_cache.isra.0 (cache.c:1032)
  ==59==    by 0x48785C9: cache_init_objects (cache.c:1132)
  ==59==    by 0x48785C9: nft_cache_init (cache.c:1166)
  ==59==    by 0x48785C9: nft_cache_update (cache.c:1224)
  ==59==    by 0x48ADBE1: nft_evaluate (libnftables.c:530)
  ==59==    by 0x48AEC29: nft_run_cmd_from_buffer (libnftables.c:596)
  ==59==    by 0x402983: main (main.c:535)

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/cache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 3fe6bb407796..4e89fe1338f3 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1027,8 +1027,10 @@ static int implicit_chain_cache(struct netlink_ctx *ctx, struct table *table,
 	int ret = 0;
 
 	list_for_each_entry(chain, &table->chain_bindings, cache.list) {
-		filter.list.table = table->handle.table.name;
-		filter.list.chain = chain->handle.chain.name;
+		filter.list = (typeof(filter.list)) {
+			.table = table->handle.table.name,
+			.chain = chain->handle.chain.name,
+		};
 		ret = rule_init_cache(ctx, table, &filter);
 	}
 
-- 
2.41.0

