Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2CEC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8043207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYSEoMay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCEUdY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:33:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24741 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgCEUdY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YI0GgENBxaJXyanO0Z8b03viVDhGdDXJzr67wbY29NQ=;
        b=KYSEoMay74cJTT7wxRr4t0PVdZdyQyZ8aynSBui2eY4cUxJa7WSylNjDob0FAauRZYLCWq
        OAV/ArVn2fWse1qrL309KEjBSdx0lbms6bvE06Nlf6q+Z8kUV/ZhAxnhdxJwqB+AqVzbEm
        HEisMCr+Uj/aQHFm5mvIgKN93vd41K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-r6a21TPAMcKY2ceWtuqWuw-1; Thu, 05 Mar 2020 15:33:21 -0500
X-MC-Unique: r6a21TPAMcKY2ceWtuqWuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BCBB800D4E;
        Thu,  5 Mar 2020 20:33:20 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F5701001B2B;
        Thu,  5 Mar 2020 20:33:18 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/4] nf_tables: Allow set back-ends to report partial overlaps on insertion
Date:   Thu,  5 Mar 2020 21:33:02 +0100
Message-Id: <1625b855afe7a5f5c9029fcf91f549fd3d8b4b3e.1583438771.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583438771.git.sbrivio@redhat.com>
References: <cover.1583438771.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Currently, the -EEXIST return code of ->insert() callbacks is ambiguous: =
it
might indicate that a given element (including intervals) already exists =
as
such, or that the new element would clash with existing ones.

If identical elements already exist, the front-end is ignoring this witho=
ut
returning error, in case NLM_F_EXCL is not set. However, if the new eleme=
nt
can't be inserted due an overlap, we should report this to the user.

To this purpose, allow set back-ends to return -ENOTEMPTY on collision wi=
th
existing elements, translate that to -EEXIST, and return that to userspac=
e,
no matter if NLM_F_EXCL was set.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
Pablo, I added your From: here as the original patch came from you,
but I'm not sure how to handle this. Please change it as you see fit.

 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
index d1318bdf49ca..51371efe8bf0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5077,6 +5077,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, s=
truct nft_set *set,
 				err =3D -EBUSY;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err =3D 0;
+		} else if (err =3D=3D -ENOTEMPTY) {
+			/* ENOTEMPTY reports overlapping between this element
+			 * and an existing one.
+			 */
+			err =3D -EEXIST;
 		}
 		goto err_element_clash;
 	}
--=20
2.25.1

