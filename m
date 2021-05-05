Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213C5C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F15D0613D6
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhEEWY0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 18:24:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhEEWYZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 18:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620253405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=omSKo88GY/N5o6PcoB6p3bgJjXIAoPidF3hkjwbKxfk=;
        b=HkEuX9Qfzms+zlpNL/ljiZulLk5phv8Wyf+Ag2yzwh5XDMAermy4rwM/bpyLo90MOWXda8
        q073V7zSAyMv5TLxxsuaj644HSfSZclwimvPsTYB5tGeoItNPniyo4qVHv7GePC46zPlId
        yqSSA/3npx312UHB5avtvkvHFCzJLow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-kV1peOcDNjOTaoJ0NE-ttg-1; Wed, 05 May 2021 18:23:23 -0400
X-MC-Unique: kV1peOcDNjOTaoJ0NE-ttg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C843E18397A3;
        Wed,  5 May 2021 22:23:22 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA596062C;
        Wed,  5 May 2021 22:23:21 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/2] Fix display of < 64 bits IPv6 masks in concatenated elements
Date:   Thu,  6 May 2021 00:23:12 +0200
Message-Id: <cover.1620252768.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1/2 fixes the issue reported by PetrB, and patch 2/2 introduces a
test case for IPv4 and IPv6 ranges of different lengths in concatenated
set elements.

Stefano Brivio (2):
  segtree: Fix range_mask_len() for subnet ranges exceeding unsigned int
  tests: Introduce 0043_concatenated_ranges_1 for subnets of different
    sizes

 src/segtree.c                                 |  4 ++--
 .../testcases/sets/0043concatenated_ranges_1  | 23 +++++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0043concatenated_ranges_1

-- 
2.30.2

