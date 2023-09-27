Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DDAE82CCD
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjI0UCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI0UCn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E010A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l/E8XM+athV1Vrc4+XSvopIP8fQrEF9FXAnOFkdXT+s=;
        b=db1AO4steH6eHhXKNu+jl/BMaaJV6BwTpyljqg12OZGUVOYOFuPl0zQv31hDiSz9YIuVyw
        5ZLw/ezpE5ZUi5ZQWKkz+GIcM8bZfdTEb5NTs6Cxg+m/bWb/lUQBDb6DUwXJBv1Ke9/8mk
        El+DlirIAn9DJgRMOWiaM8DI/NQcDpY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-XGpnNFI4Nki9W5X1DD45AQ-1; Wed, 27 Sep 2023 16:01:54 -0400
X-MC-Unique: XGpnNFI4Nki9W5X1DD45AQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48F108039D1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC61540C6EA8;
        Wed, 27 Sep 2023 20:01:53 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/5] more various cleanups related to struct datatype
Date:   Wed, 27 Sep 2023 21:57:23 +0200
Message-ID: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a followup to

  Subject:    [PATCH nft 0/9] various cleanups related to enums and struct datatype
  Date:       Wed, 20 Sep 2023 16:26:01 +0200

From that patchset, several patches were merged. Except:

1) [PATCH nft 8/9] datatype: use __attribute__((packed)) instead of enum bitfields
   This patch was rejected. It's gone and no longer present.

2) [PATCH nft 3/9] datatype: drop flags field from datatype
   This patch become the new "datatype: make "flags" field of datatype struct simple booleans"
   in this series. The flag DTYPE_F_ALLOC flag is preserved (as new "f_alloc" field).

Thomas Haller (5):
  datatype: make "flags" field of datatype struct simple booleans
  datatype: don't clone static name/desc strings for datatype
  datatype: don't clone datatype in set_datatype_alloc() if byteorder
    already matches
  datatype: extend set_datatype_alloc() to change size
  datatype: use xmalloc() for allocating datatype in datatype_clone()

 include/datatype.h        | 39 +++++++++++++------------
 src/datatype.c            | 61 +++++++++++++++++++++++++--------------
 src/evaluate.c            | 43 ++++++++++++---------------
 src/meta.c                |  2 +-
 src/netlink.c             |  4 +--
 src/netlink_delinearize.c |  2 +-
 src/payload.c             |  7 ++---
 src/rt.c                  |  2 +-
 src/segtree.c             |  5 ++--
 9 files changed, 89 insertions(+), 76 deletions(-)

-- 
2.41.0

