Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCA3C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 19:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjHCTkt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjHCTks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 15:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7614226
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 12:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y2PNMcuP7SfDbVc/HZalcyOPU4kWy6cJXRoe8xCUC8g=;
        b=YWAtwOVGwx1mA7WBW2X/YD0MaXaInGDZYzcxG4+VTUbGbU45QBpDwACIRla5nYHhpnw5+7
        tBNaL375D0SN6QMWgnKBpLBnW+wBd5KX5X1w0rJEUliRaTs7rwVSD5LlZOOasyoq/MKfUo
        AtIPbmBlw6TLmQDbTlDhy4mol/qWxOo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-zAA2sq2ZNUqUwBcAEbNuBA-1; Thu, 03 Aug 2023 15:39:59 -0400
X-MC-Unique: zAA2sq2ZNUqUwBcAEbNuBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D77A41044589;
        Thu,  3 Aug 2023 19:39:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C73B4021520;
        Thu,  3 Aug 2023 19:39:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v4 0/6] add input flags and "no-dns"/"json" flags
Date:   Thu,  3 Aug 2023 21:35:12 +0200
Message-ID: <20230803193940.1105287-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v3:

- set-input() now returns the old value (both for Python and C API)
- python: API follows the style of existing set_debug()/get_debug()
  methods.
- nft_input_no_dns()/nft_input_json() helper functions added and used.
- python: new patch to better handle exception while creating Nftables
  instance.

Thomas Haller (6):
  src: add input flags for nft_ctx
  src: add input flag NFT_CTX_INPUT_NO_DNS to avoid blocking
  src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
  py: fix exception during cleanup of half-initialized Nftables
  py: extract flags helper functions for set_debug()/get_debug()
  py: add Nftables.{get,set}_input() API

 doc/libnftables.adoc           |  30 +++++++++-
 include/datatype.h             |   1 +
 include/nftables.h             |  15 +++++
 include/nftables/libnftables.h |   8 +++
 py/src/nftables.py             | 101 ++++++++++++++++++++++++++-------
 src/datatype.c                 |  68 +++++++++++++---------
 src/evaluate.c                 |  10 +++-
 src/libnftables.c              |  20 ++++++-
 src/libnftables.map            |   5 ++
 9 files changed, 203 insertions(+), 55 deletions(-)

-- 
2.41.0

