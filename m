Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5199E810DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 12:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjI0M2x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjI0M2w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 08:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9551AE
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 05:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695817677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xFqLSFb+2SmSmDG2KbeK0f/s5o2cCigxXB+SqXYHgJI=;
        b=frt4Mq3EE0NF5M2ywrwo4uqv12EJz+K+ywrWNw0AnSBVLr4889WR/1JpjcQIINzOpfqxbN
        uet4fLiHei35g4MbVmwCSCTMNaGvGt2Up0fKB2xBMgTIy3bI3+daX/6kgvbDMxbvH2Svmj
        H79qIGf3zmLYXI1qNed0xD3gYQMvjXo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-Mv3gfQD9PO2y7zIxRT-r4w-1; Wed, 27 Sep 2023 08:27:55 -0400
X-MC-Unique: Mv3gfQD9PO2y7zIxRT-r4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 475AF382134E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:27:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B855740C6EA8;
        Wed, 27 Sep 2023 12:27:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/3] Two fixes to avoid "-Wstrict-overflow" warnings
Date:   Wed, 27 Sep 2023 14:23:25 +0200
Message-ID: <20230927122744.3434851-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "-Wstrict-overflow=5" warning seems useful, as it's easy to get this
wrong. I think C really should have "-fwrapv" behavior, but the reality
is that we need to be careful about signed overflow. The warning helps
with that, and luckily there are only a few places that require fixes.
Note that libparser and mini-gmp.c cannot build with "-Wstrict-overflow=5".

Maybe there are other warnings, as it depends on the optimization level
and the compiler. This works for my gcc and -O3.

Thomas Haller (3):
  nft: add NFT_ARRAY_SIZE() helper
  nfnl_osf: rework nf_osf_parse_opt() and avoid "-Wstrict-overflow"
    warning
  netlink_linearize: avoid strict-overflow warning in
    netlink_gen_bitwise()

 include/nft.h           |   2 +
 src/netlink_linearize.c |   7 +--
 src/nfnl_osf.c          | 128 ++++++++++++++++++----------------------
 3 files changed, 63 insertions(+), 74 deletions(-)

-- 
2.41.0

