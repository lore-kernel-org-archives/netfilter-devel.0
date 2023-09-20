Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027C7CE79DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbjITObA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjITOa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76038AD
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b7j2L1ldlqazx+H6iA6L0qZxgG5xpwP/wZoq1frTRe8=;
        b=Eh4uInGTVlbak1eHRc99TfZLhkVg4Fo4KT97jcLVnAuFI87AUEfLvpdcbLlQ5dCHOBmyBN
        rf3MbLaB88fNPkVmznUSFyNTeAX1B+mNIoInRUO7z2tVEHsYytOR1sP6Z0pwphfBu4J9wY
        o20cnqPXVmM0I0IIKGN3nr/B+TeS/gM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-Nx7moyimNHiedM-zAFJiGQ-1; Wed, 20 Sep 2023 10:30:10 -0400
X-MC-Unique: Nx7moyimNHiedM-zAFJiGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BCD01C08974
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FD6F1004145;
        Wed, 20 Sep 2023 14:30:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/9] various cleanups related to enums and struct datatype
Date:   Wed, 20 Sep 2023 16:26:01 +0200
Message-ID: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Various loosely related patches in the hope to improve something.

Thomas Haller (9):
  src: fix indentation/whitespace
  include: fix missing definitions in <cache.h>/<headers.h>
  datatype: drop flags field from datatype
  datatype: use "enum byteorder" instead of int in set_datatype_alloc()
  payload: use enum icmp_hdr_field_type in
    payload_may_dependency_kill_icmp()
  netlink: handle invalid etype in set_make_key()
  expression: cleanup expr_ops_by_type() and handle u32 input
  datatype: use __attribute__((packed)) instead of enum bitfields
  proto: add missing proto_definitions for PROTO_DESC_GENEVE

 include/cache.h           |  9 +++++++++
 include/datatype.h        | 27 +++++++++++----------------
 include/expression.h      | 10 ++++++----
 include/headers.h         |  2 ++
 include/proto.h           | 11 +++++++----
 src/datatype.c            | 22 +++++++++-------------
 src/evaluate.c            |  2 +-
 src/expression.c          | 23 +++++++++++------------
 src/meta.c                |  6 +++---
 src/netlink.c             |  6 ++++--
 src/netlink_delinearize.c |  2 +-
 src/payload.c             | 10 ++++------
 src/proto.c               |  3 ++-
 src/rt.c                  |  2 +-
 src/segtree.c             |  5 ++---
 15 files changed, 73 insertions(+), 67 deletions(-)

-- 
2.41.0

