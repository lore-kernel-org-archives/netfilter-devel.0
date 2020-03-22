Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3995C4332D
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB5720754
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WGOpGXkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCVCWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:22:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29832 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCWV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqMRJx8Nd24scWWRtrnkec7kVqNYX9y/2e5301wpfxg=;
        b=WGOpGXkBiipgOtghqW3k7gzcJ+1yjJfGlt2oH67vCgE0Kn1tVsYLmSLYgbc+t/2owvx04r
        7i6vguRnB3ltR5AvseOEOv81ENCY3+p+ZgMVNeVLyWH0raIqqqZIgWQKgpKo6mOLRGvchQ
        wTKq2PN1JPAKckdN2bNFL7osvbwjgQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-SlaT3gSVMS-hlFhRxeodwQ-1; Sat, 21 Mar 2020 22:22:18 -0400
X-MC-Unique: SlaT3gSVMS-hlFhRxeodwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 410B6800D50;
        Sun, 22 Mar 2020 02:22:17 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 070FA5C1B5;
        Sun, 22 Mar 2020 02:22:15 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 2/4] nft_set_pipapo: Separate partial and complete overlap cases on insertion
Date:   Sun, 22 Mar 2020 03:21:59 +0100
Message-Id: <4563a4d36ab694fb066c2a469340f61f776d7da0.1584841602.git.sbrivio@redhat.com>
In-Reply-To: <cover.1584841602.git.sbrivio@redhat.com>
References: <cover.1584841602.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

...and return -ENOTEMPTY to the front-end on collision, -EEXIST if
an identical element already exists. Together with the previous patch,
element collision will now be returned to the user as -EEXIST.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes

 net/netfilter/nft_set_pipapo.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index 4fc0c924ed5d..ef7e8ad2e344 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1098,21 +1098,41 @@ static int nft_pipapo_insert(const struct net *ne=
t, const struct nft_set *set,
 	struct nft_pipapo_field *f;
 	int i, bsize_max, err =3D 0;
=20
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		end =3D (const u8 *)nft_set_ext_key_end(ext)->data;
+	else
+		end =3D start;
+
 	dup =3D pipapo_get(net, set, start, genmask);
-	if (PTR_ERR(dup) =3D=3D -ENOENT) {
-		if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END)) {
-			end =3D (const u8 *)nft_set_ext_key_end(ext)->data;
-			dup =3D pipapo_get(net, set, end, nft_genmask_next(net));
-		} else {
-			end =3D start;
+	if (!IS_ERR(dup)) {
+		/* Check if we already have the same exact entry */
+		const struct nft_data *dup_key, *dup_end;
+
+		dup_key =3D nft_set_ext_key(&dup->ext);
+		if (nft_set_ext_exists(&dup->ext, NFT_SET_EXT_KEY_END))
+			dup_end =3D nft_set_ext_key_end(&dup->ext);
+		else
+			dup_end =3D dup_key;
+
+		if (!memcmp(start, dup_key->data, sizeof(*dup_key->data)) &&
+		    !memcmp(end, dup_end->data, sizeof(*dup_end->data))) {
+			*ext2 =3D &dup->ext;
+			return -EEXIST;
 		}
+
+		return -ENOTEMPTY;
+	}
+
+	if (PTR_ERR(dup) =3D=3D -ENOENT) {
+		/* Look for partially overlapping entries */
+		dup =3D pipapo_get(net, set, end, nft_genmask_next(net));
 	}
=20
 	if (PTR_ERR(dup) !=3D -ENOENT) {
 		if (IS_ERR(dup))
 			return PTR_ERR(dup);
 		*ext2 =3D &dup->ext;
-		return -EEXIST;
+		return -ENOTEMPTY;
 	}
=20
 	/* Validate */
--=20
2.25.1

