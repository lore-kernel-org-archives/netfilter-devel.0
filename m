Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534ABC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21798207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NguiQ9tx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCEUdW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:33:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbgCEUdV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ap8APHzMqa/4FzjsKtRvDSeIA6ly7l3mgfhOtezo7UM=;
        b=NguiQ9txZCqCZvVqHryL8fCLlOoLRXL5LETUpHxnmDDRohaZhfVM6iVi9+I9wQHMz0LCGm
        Vfo7LHdrvhNT9Syqaga0G2SnoeMGVPm8JW+qaW9qXFA7l2lFupd88EXP+oW3a1jkw9nTKF
        l04eTXePpjNvb0zpTFuHn56ByT2BAJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-IMnyDbUSPUW_kNt1_4y9Pw-1; Thu, 05 Mar 2020 15:33:19 -0500
X-MC-Unique: IMnyDbUSPUW_kNt1_4y9Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC39318AB2C2;
        Thu,  5 Mar 2020 20:33:17 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FB0C10016EB;
        Thu,  5 Mar 2020 20:33:16 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf 0/4] nftables: Consistently report partial and entire set overlaps
Date:   Thu,  5 Mar 2020 21:33:01 +0100
Message-Id: <cover.1583438771.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Stefano Brivio (4):
  nf_tables: Allow set back-ends to report partial overlaps on insertion
  nft_set_pipapo: Separate partial and complete overlap cases on
    insertion
  nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
  nft_set_rbtree: Detect partial overlaps on insertion

 net/netfilter/nf_tables_api.c  |  5 ++
 net/netfilter/nft_set_pipapo.c | 34 +++++++++++---
 net/netfilter/nft_set_rbtree.c | 85 ++++++++++++++++++++++++++++++----
 3 files changed, 108 insertions(+), 16 deletions(-)

--=20
2.25.1

