Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8D0C71155
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377650AbjHROMd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377649AbjHROMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849E170E
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692367897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KrQQVK/bVB7jlFzCo4PyVHeug+iz1onJ+1rQ68HZdlA=;
        b=HsgotAdQkhSXTX5EhcfGXkqjRRJJ6NLspLL3PWJGt74ogRDQyIHrtSGiKvrLQNbfz8BXT3
        spyhRWf6RW3MxIJBCjGhgJ7PUslPzT7iFA9yFVcm27rBcUTvF5oIhBYVUSPrsi78uJ+TZp
        OJjAFlPGwPKcKjoKPau50nlgwH/uiNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-l6YjgrtVMee0ajHm6H3AXQ-1; Fri, 18 Aug 2023 10:11:36 -0400
X-MC-Unique: l6YjgrtVMee0ajHm6H3AXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBC5285CBE5
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 14:11:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A10340C6F4E;
        Fri, 18 Aug 2023 14:11:35 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v3 0/3] src: use reentrant getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Date:   Fri, 18 Aug 2023 16:08:18 +0200
Message-ID: <20230818141124.859037-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since version 2:

- split the patch.

- add and use defines NFT_PROTONAME_MAXSIZE, NFT_SERVNAME_MAXSIZE,
  NETDB_BUFSIZE.

- add new GPL2+ source file as a place for the wrapper functions.

Thomas Haller (3):
  nftutils: add new internal file for general utilities
  nftutils: add wrappers for getprotoby{name,number}_r(),
    getservbyport_r()
  src: use wrappers for getprotoby{name,number}_r(), getservbyport_r()

 configure.ac    |   4 ++
 src/Makefile.am |   2 +
 src/datatype.c  |  33 ++++++++--------
 src/json.c      |  22 +++++------
 src/nftutils.c  | 102 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/nftutils.h  |  21 ++++++++++
 src/rule.c      |   7 ++--
 7 files changed, 161 insertions(+), 30 deletions(-)
 create mode 100644 src/nftutils.c
 create mode 100644 src/nftutils.h

-- 
2.41.0

