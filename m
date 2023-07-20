Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA37EB64DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 14:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjGTOcn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjGTOcm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 10:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93191BF7
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 07:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689863517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sOvrjdqzqFqd+Jmdk15HOFopThipyxKpvRS54iTxDM0=;
        b=drkgRAAscjBhalsKPGQQ0BVVWg2hi72Pz7Y7zLo8FIII7xYNyd/yDdmpcN7Bm9ERwJITCB
        26nJz+l/5pGJ81YMdfI+9yzdiYVADekPO3brxi8HnAvhPbNHdbEnfdtl5mmRZ9+PU0lDyW
        3GL8rewYrGlkS1zO3WFbjUBCLi4L9EQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-5d_TZS6zNQqWxgqzLECMFA-1; Thu, 20 Jul 2023 10:31:56 -0400
X-MC-Unique: 5d_TZS6zNQqWxgqzLECMFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21218185A794;
        Thu, 20 Jul 2023 14:31:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B3BB40C206F;
        Thu, 20 Jul 2023 14:31:55 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>
Subject: [nft v3 PATCH 0/4] add input flags and "no-dns"/"json" flags
Date:   Thu, 20 Jul 2023 16:26:59 +0200
Message-ID: <20230720143147.669250-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v3. Changes:

- new patch to add NFT_CTX_INPUT_JSON as hinted by Phil.
- no longer introduce parse_ctx_init() helper function
- various rewording

The Python API is still as before. I am not opposed to change it, once
consensus is found.

Thomas Haller (4):
  src: add input flags for nft_ctx
  src: add input flag NFT_CTX_INPUT_NO_DNS to avoid blocking
  src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
  py: add Nftables.input_{set,get}_flags() API

 doc/libnftables.adoc           | 26 +++++++++++++
 include/datatype.h             |  1 +
 include/nftables.h             |  5 +++
 include/nftables/libnftables.h |  8 ++++
 py/nftables.py                 | 54 +++++++++++++++++++++++++++
 src/datatype.c                 | 68 ++++++++++++++++++++--------------
 src/evaluate.c                 | 10 ++++-
 src/libnftables.c              | 18 ++++++++-
 src/libnftables.map            |  5 +++
 9 files changed, 163 insertions(+), 32 deletions(-)

-- 
2.41.0

