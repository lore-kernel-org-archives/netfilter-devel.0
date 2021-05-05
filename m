Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81063C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0A7613D8
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhEEWY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 18:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234163AbhEEWYZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 18:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620253406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BWR5FBr/1okcsBpwhST7FdKe1nTOpx4h4JJnGuQk7dw=;
        b=FhxrxbDu/cKGp5Pytsh6lmZh3vqAgiiExa18ngkCuJVY5fi/px/7M1VFMNfo4JGMTEuqa8
        Nlr36YdGpwX7Cs5Ddq6CL5iyt47LyoAUc3czkWDCKZhsFzVJNpEoUBJeaCumoJETqS75i3
        gBcIJmtHfMSUgUL7dejUeZPr3PxAW6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-D9SKvLhXNLGrEUozJYWHIA-1; Wed, 05 May 2021 18:23:25 -0400
X-MC-Unique: D9SKvLhXNLGrEUozJYWHIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B81110066E6;
        Wed,  5 May 2021 22:23:24 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E84A6062C;
        Wed,  5 May 2021 22:23:23 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] segtree: Fix range_mask_len() for subnet ranges exceeding unsigned int
Date:   Thu,  6 May 2021 00:23:13 +0200
Message-Id: <5ff3ceab3d3a547ab23144adbfa2000f1604c39f.1620252768.git.sbrivio@redhat.com>
In-Reply-To: <cover.1620252768.git.sbrivio@redhat.com>
References: <cover.1620252768.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As concatenated ranges are fetched from kernel sets and displayed to
the user, range_mask_len() evaluates whether the range is suitable for
display as netmask, and in that case it calculates the mask length by
right-shifting the endpoints until no set bits are left, but in the
existing version the temporary copies of the endpoints are derived by
copying their unsigned int representation, which doesn't suffice for
IPv6 netmask lengths, in general.

PetrB reports that, after inserting a /56 subnet in a concatenated set
element, it's listed as a /64 range. In fact, this happens for any
IPv6 mask shorter than 64 bits.

Fix this issue by simply sourcing the range endpoints provided by the
caller and setting the temporary copies with mpz_init_set(), instead
of fetching the unsigned int representation. The issue only affects
displaying of the masks, setting elements already works as expected.

Reported-by: PetrB <petr.boltik@gmail.com>
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1520
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 src/segtree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index ad199355532e..353a0053ebc0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -838,8 +838,8 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
 	mpz_t tmp_start, tmp_end;
 	int ret;
 
-	mpz_init_set_ui(tmp_start, mpz_get_ui(start));
-	mpz_init_set_ui(tmp_end, mpz_get_ui(end));
+	mpz_init_set(tmp_start, start);
+	mpz_init_set(tmp_end, end);
 
 	while (mpz_cmp(tmp_start, tmp_end) <= 0 &&
 		!mpz_tstbit(tmp_start, 0) && mpz_tstbit(tmp_end, 0) &&
-- 
2.30.2

