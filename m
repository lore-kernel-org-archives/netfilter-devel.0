Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE79C678DC
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjHRJpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359334AbjHRJoe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871CB1FC3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692351827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aKy3xy7ziKiQ9DFzPD4n2iYsq4qeXVlLBVpD6UmUixE=;
        b=SlByBVRgb2dWDDWea7q/NL/vSCpFKq9Xizly/cHXAT4gC1m/d35zxf4UGeVAZ5ie2NAMby
        MGV3rS9tlV9HBfZYICesq05ZJbx0Ptg6tAONyLGNAoaBNZhe3MiKHglq2xzci/FIZTnAIE
        6hCNbn2Mxmc8DlU4TACax4poqdJaug4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-dN7Qhs86Nx2hYPdmRtB1Rg-1; Fri, 18 Aug 2023 05:43:45 -0400
X-MC-Unique: dN7Qhs86Nx2hYPdmRtB1Rg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B9998015AA
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 09:43:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19DA640C6E8A;
        Fri, 18 Aug 2023 09:43:44 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v5 0/6] add input flags and "no-dns"/"json" flags
Date:   Fri, 18 Aug 2023 11:40:35 +0200
Message-ID: <20230818094335.535872-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v4:

- rename python API {set,get}_input() to {set,get}_input_flags() and
  update commit message. Other 5 out of 6 patches are unchanged (except
  adding Reviewed-by tag from Phil).

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
  py: add Nftables.{get,set}_input_flags() API

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

