Return-Path: <SRS0=78bk=55=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4996C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9596E206DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JolhGMPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbgDMTs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:48:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388135AbgDMTsW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 15:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586807301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6LhhNRCmojD26RDFAMabxwkvxiOVsuKouxlm7IswvCA=;
        b=JolhGMPXW6OPu60klT+va9aCoBN3bzy4+5iysH+8RlDFO6kmZz3FEFQpju7CKbvR2cG3Sw
        dILuTq2pec0EMLCDcfCgApMgDJSxFZ8oxojp5xc70RrxzadEpQz3Rajl/mTUbN60oYoal1
        nXM5LsSeWHSPibLS8dtczQqUr3Fi+T0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-UlGUOzccOu-XDayesDkOeQ-1; Mon, 13 Apr 2020 15:48:17 -0400
X-MC-Unique: UlGUOzccOu-XDayesDkOeQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06D418017F3;
        Mon, 13 Apr 2020 19:48:17 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C478D96FB1;
        Mon, 13 Apr 2020 19:48:15 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: Set NFT_SET_CONCAT flag for sets with concatenated ranges
Date:   Mon, 13 Apr 2020 21:48:03 +0200
Message-Id: <12dd79d1d0ff6697fcc609056808abef4b53311a.1586806931.git.sbrivio@redhat.com>
In-Reply-To: <cover.1586806931.git.sbrivio@redhat.com>
References: <cover.1586806931.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo reports that nft, after commit 8ac2f3b2fca3 ("src: Add support
for concatenated set ranges"), crashes with older kernels (< 5.6)
without support for concatenated set ranges: those sets will be sent
to the kernel, which adds them without notion of the fact that
different concatenated fields are actually included, and nft crashes
while trying to list this kind of malformed concatenation.

Use the NFT_SET_CONCAT flag introduced by kernel commit ef516e8625dd
("netfilter: nf_tables: reintroduce the NFT_SET_CONCAT flag") when
sets including concatenated ranges are sent to the kernel, so that
older kernels (with no knowledge of this flag itself) will refuse set
creation.

Note that, in expr_evaluate_set(), we have to check for the presence
of the flag, also on empty sets that might carry it in context data,
and actually set it in the actual set flags.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 src/evaluate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index fcc79386b325..91901921155f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1382,10 +1382,16 @@ static int expr_evaluate_set(struct eval_ctx *ctx=
, struct expr **expr)
 			set->size      +=3D i->size - 1;
 			set->set_flags |=3D i->set_flags;
 			expr_free(i);
-		} else if (!expr_is_singleton(i))
+		} else if (!expr_is_singleton(i)) {
 			set->set_flags |=3D NFT_SET_INTERVAL;
+			if (i->key->etype =3D=3D EXPR_CONCAT)
+				set->set_flags |=3D NFT_SET_CONCAT;
+		}
 	}
=20
+	if (ctx->set && ctx->set->flags & (NFT_SET_CONCAT))
+		set->set_flags |=3D NFT_SET_CONCAT;
+
 	set->set_flags |=3D NFT_SET_CONSTANT;
=20
 	datatype_set(set, ctx->ectx.dtype);
@@ -3463,6 +3469,7 @@ static int set_evaluate(struct eval_ctx *ctx, struc=
t set *set)
 		memcpy(&set->desc.field_len, &set->key->field_len,
 		       sizeof(set->desc.field_len));
 		set->desc.field_count =3D set->key->field_count;
+		set->flags |=3D NFT_SET_CONCAT;
 	}
=20
 	if (set_is_datamap(set->flags)) {
--=20
2.25.1

