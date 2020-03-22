Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE444C4332E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8038620754
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAc4cXrP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgCVCWR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:22:17 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45435 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCWR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HCQznCkaZF4kmaYSPL44GpmIL5TjiKsoIqzFyIUwFYQ=;
        b=TAc4cXrPkqJOnM5mDKug4zdSPG9SuXheulQ9yGeLtfg315ZmT2oekDgd/OwHZC2R4bEca3
        XP/IWA7BOA4egfJK1z0WB14GDQ/LQdJg/CYEUJOGQqdspc+WYofHOSn+T+LtlCqivjpXJi
        BPXrHs1XUljQxhDXBebhdfRTIfZeofU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-tIv9HSWUOR2oppVGo4QOYQ-1; Sat, 21 Mar 2020 22:22:15 -0400
X-MC-Unique: tIv9HSWUOR2oppVGo4QOYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C82DF8017CC;
        Sun, 22 Mar 2020 02:22:13 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2A985C1B5;
        Sun, 22 Mar 2020 02:22:11 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 0/4] nftables: Consistently report partial and entire set overlaps
Date:   Sun, 22 Mar 2020 03:21:57 +0100
Message-Id: <cover.1584841602.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil reports that inserting an element, that includes a concatenated
range colliding with an existing one, fails silently.

This is because so far set back-ends have no way to tell apart cases
of identical elements being inserted from clashing elements. On
insertion, the front-end would strip -EEXIST if NLM_F_EXCL is not
passed, so we return success to userspace while an error in fact
occurred.

As suggested by Pablo, allow back-ends to return -ENOTEMPTY in case
of partial overlaps, with patch 1/4. Then, with patches 2/4 to 4/4,
update nft_set_pipapo and nft_set_rbtree to report partial overlaps
using the new error code.

v2: Only consider active elements for rbtree overlap detection in
    patch 4/4 (Pablo Neira Ayuso)

Stefano Brivio (4):
  nf_tables: Allow set back-ends to report partial overlaps on insertion
  nft_set_pipapo: Separate partial and complete overlap cases on
    insertion
  nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
  nft_set_rbtree: Detect partial overlaps on insertion

 net/netfilter/nf_tables_api.c  |  5 ++
 net/netfilter/nft_set_pipapo.c | 34 ++++++++++---
 net/netfilter/nft_set_rbtree.c | 87 ++++++++++++++++++++++++++++++----
 3 files changed, 110 insertions(+), 16 deletions(-)

--=20
2.25.1

