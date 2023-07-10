Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B563EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 08:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjGJIu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 04:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGJIu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 04:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA104C3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688978982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ss4LqPV90koYkPPYmMN3WCvm/6+fZB+hrqiDFrdjejQ=;
        b=BosVxd9OKy7vH1sSMXdsrECpAE2rKzbU2tIV7SDiCIQuRnmgdMSS9YkJODpbD2TtY/GGB/
        cIDCCRP2yZ2qTnvHSricj4B+HMXMLhUNfcjAYViamOdGOtYB9kNeHIkQqtEDRVfg/R2fFq
        CRtO5fQWmgFulvnYt2isXF9K+dY+4kQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-oBQ07DEKP6SHcmaS6_C7uA-1; Mon, 10 Jul 2023 04:49:40 -0400
X-MC-Unique: oBQ07DEKP6SHcmaS6_C7uA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3246F2999B20
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 08:49:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB6B0111DCE1;
        Mon, 10 Jul 2023 08:49:39 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 0/4] libnftables: minor cleanups initalizing nf_sock instance of nft_ctx
Date:   Mon, 10 Jul 2023 10:45:15 +0200
Message-ID: <20230710084926.172198-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is some unnecessary or redundant code in "src/libnftables.c".
Clean up.

This was motivated by an attempt to add a new flag for nft_ctx_new(),
beside NFT_CTX_DEFAULT. The current "if (flags == NFT_CTX_DEFAULT)"
check is an odd usage for flags (because we would want that behavior for
all flags).

Thomas Haller (4):
  libnftables: always initialize netlink socket in nft_ctx_new()
  libnftables: drop unused argument nf_sock from nft_netlink()
  libnftables: inline creation of nf_sock in nft_ctx_new()
  libnftables: drop check for nf_sock in nft_ctx_free()

 src/libnftables.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

-- 
2.41.0

