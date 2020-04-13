Return-Path: <SRS0=78bk=55=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE54BC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B3F206DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhkJgU9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbgDMTsY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:48:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388133AbgDMTsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 15:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586807299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7S6jfH2bXGnLm93hbRooNCsniyK1VHRpamB8kgQtNk=;
        b=HhkJgU9mhUoIOjpwkFRzeZl/7jxjAJdWT2lmwlDwDO0tUObmdO6iYEGnGd2DOKtxQXhd21
        05/BPg7LptZBnmZkf9+seihsXDPpECbet22X6+kk0+ZMqGmQxb6TyrVxS4YD/wIGwzoa1P
        luXioqBzJOqnCHBFmqmOBH+BWvD5WhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-5pV-29BsN2yxxbpf81w1pg-1; Mon, 13 Apr 2020 15:48:16 -0400
X-MC-Unique: 5pV-29BsN2yxxbpf81w1pg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5694718B5F97;
        Mon, 13 Apr 2020 19:48:15 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 728DF9F999;
        Mon, 13 Apr 2020 19:48:14 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] include: Resync nf_tables.h cache copy
Date:   Mon, 13 Apr 2020 21:48:02 +0200
Message-Id: <89cc1df6bae539f00756b7ae049db185a096d4a8.1586806931.git.sbrivio@redhat.com>
In-Reply-To: <cover.1586806931.git.sbrivio@redhat.com>
References: <cover.1586806931.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get this header in sync with nf.git as of commit ef516e8625dd.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilte=
r/nf_tables.h
index 30f2a87270dc..4565456c0ef4 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -276,6 +276,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
+ * @NFT_SET_CONCAT: set contains a concatenation
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		=3D 0x1,
@@ -285,6 +286,7 @@ enum nft_set_flags {
 	NFT_SET_TIMEOUT			=3D 0x10,
 	NFT_SET_EVAL			=3D 0x20,
 	NFT_SET_OBJECT			=3D 0x40,
+	NFT_SET_CONCAT			=3D 0x80,
 };
=20
 /**
--=20
2.25.1

