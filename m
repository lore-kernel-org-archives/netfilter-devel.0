Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8E5C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8C3D207DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvMMUF5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHSV7h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:59:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726209AbgHSV7g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 17:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597874375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0ejOJhJTlWNgcwT7ZmNLyZD7EEg0/dzqU1R2xwpDIpY=;
        b=gvMMUF5ldVHXC2M17QiACA57NskVUOh51JxtVh2N6U+vodrQ+QtBufl4ZndeW+JHRGxFq5
        Hw7j5nGRyfxtQ8WCZmpLBh4w/tWCezP0m4LA6FB1qbFKItnMlxA5ZKHNTsWs7Qlrs/DF2s
        mZhKIuowPfbbguLxHJHg6QrRs4g5NeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-aEyNWiigMIqFPSmqvG0VNQ-1; Wed, 19 Aug 2020 17:59:31 -0400
X-MC-Unique: aEyNWiigMIqFPSmqvG0VNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C8A71005E5A;
        Wed, 19 Aug 2020 21:59:29 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64BBA5C1D0;
        Wed, 19 Aug 2020 21:59:27 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Andreas Fischer <netfilter@d9c.eu>
Subject: [PATCH nf 0/2] nft_set_rbtree: Two fixes for overlap detection on insert
Date:   Wed, 19 Aug 2020 23:59:13 +0200
Message-Id: <cover.1597873312.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1/2 fixes false positive cases resulting from a flawed
assumption highlighted by
	https://bugzilla.netfilter.org/show_bug.cgi?id=1449
and is addressed for stable (5.6.x).

Patch 2/2 fixes a false negative case I noticed while skipping
different interval overlap checks in nft.

Stefano Brivio (2):
  nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
  nft_set_rbtree: Detect partial overlap with start endpoint match

 net/netfilter/nft_set_rbtree.c | 57 ++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 10 deletions(-)

-- 
2.28.0

