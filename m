Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8F0C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD5520776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JztJG87x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgEXNA5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387453AbgEXNA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RjH4gglHoTf2uVcb2F2TrW1GZ45Nz0Ss+6/pWuDuMuU=;
        b=JztJG87xw1eFE5EnU7TWLxjqgVfEmQ1eaFuwoBAcaIB8OjyXGmQ5X7zUTq3bjCUqiaJI+4
        2zfmZUbEVvxrL/2zgPxmqD08zsNeYMkSn3EJUTSpzEaGNOJvhO18vap4XZAyRq9QUrJvOO
        vKPtPi9XCQX38c9mwtK7mll85AHUFZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-RxT4MpwAPUmdCss1JHdi8w-1; Sun, 24 May 2020 09:00:41 -0400
X-MC-Unique: RxT4MpwAPUmdCss1JHdi8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6D7D460;
        Sun, 24 May 2020 13:00:40 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4D0E63F8C;
        Sun, 24 May 2020 13:00:37 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/2] Fix evaluation of anonymous sets with concatenated ranges
Date:   Sun, 24 May 2020 15:00:25 +0200
Message-Id: <cover.1590324033.git.sbrivio@redhat.com>
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

Patch 1/2 fixes this, and 2/2 adds a simple test for it.

Stefano Brivio (2):
  evaluate: Perform set evaluation on implicitly declared (anonymous)
    sets
  tests: shell: Introduce test for concatenated ranges in anonymous sets

 src/evaluate.c                                             | 5 ++++-
 tests/shell/testcases/sets/0048anonymous_set_concat_0      | 7 +++++++
 .../testcases/sets/dumps/0048anonymous_set_concat_0.nft    | 6 ++++++
 3 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/sets/0048anonymous_set_concat_0
 create mode 100644 tests/shell/testcases/sets/dumps/0048anonymous_set_concat_0.nft

-- 
2.26.2

