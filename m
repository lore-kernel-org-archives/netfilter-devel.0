Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21FFC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbjH2S4o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjH2S4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10306193
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=66+81QyaxHxTnCRYqibuMEDsevT+sluV9T+mhU26rTc=;
        b=QMp1rb5io695RfPpjU8HlOfvOzmKpkoJ7gA3D62rYXC5H2zBA3G20DnyiZRF8JN6BfX4uI
        UXUeSrgL8f65bvC44XhZ9IDvMPeJW+F39DcpoN8liywVU8pxYRXTX92XiXcs4Gi11OgVCF
        YXbuCq/ZjfDiZT1/hb2WGuerwuszIIE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-BonKKyiWPH2XC6EzLy939A-1; Tue, 29 Aug 2023 14:55:25 -0400
X-MC-Unique: BonKKyiWPH2XC6EzLy939A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11C0B280BC4E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 868A2401051;
        Tue, 29 Aug 2023 18:55:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/5] fix compiler warnings with clang and "-Wextra"
Date:   Tue, 29 Aug 2023 20:54:06 +0200
Message-ID: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

More fixes (workarounds) for compiler warnings. Mostly by enabling
"-Wextra" with gcc.

Thomas Haller (5):
  rule: fix "const static" declaration
  utils: call abort() after BUG() macro
  src: silence "implicit-fallthrough" warnings
  xt: avoid "-Wmissing-field-initializers" for "original_opts"
  datatype: check against negative "type" argument in datatype_lookup()

 include/utils.h | 3 ++-
 src/datatype.c  | 2 +-
 src/optimize.c  | 1 +
 src/rule.c      | 4 ++--
 src/segtree.c   | 5 ++---
 src/xt.c        | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.41.0

