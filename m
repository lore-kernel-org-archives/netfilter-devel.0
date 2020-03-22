Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7D4C4332E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9361920754
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFJIPQxV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCVCWU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:22:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31939 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oIDcKsleUjxydnHzk0WmnN3DoK1E2R/ZY0gPwXm9f0M=;
        b=NFJIPQxVjlGkZG7cleod58JFRtj4iq4pBfKzXBHEn6hbXVLQwLTJLbXVWAW0oeYqmJNrPB
        MesIL4LLtrgCxKGGB7y4FL6kAdjVEl/kfEck8+SVua1B4SMNQSZo0Fa7Nk6dcevwH+BmJ9
        YDMkQZSe9Q/7tlquWNVFtZyZ0jGSS+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-ENppvgvXOnSyZhzaPQ026g-1; Sat, 21 Mar 2020 22:22:16 -0400
X-MC-Unique: ENppvgvXOnSyZhzaPQ026g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D2C0107ACCC;
        Sun, 22 Mar 2020 02:22:15 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541E15C1B5;
        Sun, 22 Mar 2020 02:22:14 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 1/4] nf_tables: Allow set back-ends to report partial overlaps on insertion
Date:   Sun, 22 Mar 2020 03:21:58 +0100
Message-Id: <1625b855afe7a5f5c9029fcf91f549fd3d8b4b3e.1584841602.git.sbrivio@redhat.com>
In-Reply-To: <cover.1584841602.git.sbrivio@redhat.com>
References: <cover.1584841602.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
v2: No changes

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

