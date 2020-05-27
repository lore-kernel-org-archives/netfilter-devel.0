Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B71C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FC12088E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qu4wfvwv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgE0Uvj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 16:51:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728571AbgE0Uvi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 16:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590612697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1rtaOUm8MqA6oCx1vA6Fr8pvAj67RlWlb9fxlJAjN/s=;
        b=Qu4wfvwvRrC45Cg+Lt7TICjfF07VF+cGdr/bhUEw9LizZ+yxdn/G1USkWbw3HbuOCKKQBg
        2ZxzaCGq68pmaOEF9jfFLtBVb97XthKS5DoOK7Ml+7D6bypOqbJsShZJ0yUuQE5peDYH9J
        sRMR2NW8Bsr848ojNLN/7jlMyCTc7SM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-glVDTuVMOsiuVfXVyU-XVA-1; Wed, 27 May 2020 16:51:35 -0400
X-MC-Unique: glVDTuVMOsiuVfXVyU-XVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B70800053;
        Wed, 27 May 2020 20:51:34 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EFE278B33;
        Wed, 27 May 2020 20:51:32 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2 0/2] Fix evaluation of anonymous sets with concatenated ranges
Date:   Wed, 27 May 2020 22:51:20 +0200
Message-Id: <cover.1590612113.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As reported by both Pablo and Phil, trying to add an anonymous set
containing a concatenated range would fail:

  # nft add rule x y ip saddr . tcp dport { 192.168.2.1 . 20-30 } accept
  BUG: invalid range expression type concat
  nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
  Aborted

  # nft add rule t c ip daddr . tcp dport '{ 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept'
  BUG: invalid range expression type concat
  nft: expression.c:1296: range_expr_value_low: Assertion `0' failed.

Patch 1/2 fixes this, and 2/2 enables a test for it in inet/sets.t.

v2: Don't add anonymous sets to cache, fix leak for object maps, and
    use existing test rule instead of adding a new test

Stefano Brivio (2):
  evaluate: Perform set evaluation on implicitly declared (anonymous)
    sets
  tests: py: Enable anonymous set rule with concatenated ranges in
    inet/sets.t

 src/evaluate.c                      | 20 ++++++++++----------
 tests/py/inet/sets.t                |  2 +-
 tests/py/inet/sets.t.payload.bridge | 14 ++++++++++++++
 tests/py/inet/sets.t.payload.inet   | 13 +++++++++++++
 tests/py/inet/sets.t.payload.netdev | 13 +++++++++++++
 5 files changed, 51 insertions(+), 11 deletions(-)

-- 
2.26.2

