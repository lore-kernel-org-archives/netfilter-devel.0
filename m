Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C01BC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8628207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdKost+q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCEUd2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:33:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52017 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbgCEUd2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04QinAONAKj9D4agHfNS2x0xI6zvFC+YCqvflSCsvt8=;
        b=LdKost+quvLQ/3wV5qWufiI6j0H4sa4SLWQIADyYTjcfm44fMzSpYhe1xJ8CLfBpOZdSCO
        xLQJimYoAhxxgh4xqPeqHgpenL7BiAz2jj06k+qJIOHRbsyD4S3GAVCgj+XDys/SSsSbWL
        MZiBpePSznEAcENm1I5gt2Js9HNsdjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-mdJmBEMkPSe5Mn_PPaCGUg-1; Thu, 05 Mar 2020 15:33:25 -0500
X-MC-Unique: mdJmBEMkPSe5Mn_PPaCGUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB242107ACC7;
        Thu,  5 Mar 2020 20:33:22 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45EAE1001B2B;
        Thu,  5 Mar 2020 20:33:21 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/4] nft_set_pipapo: Separate partial and complete overlap cases on insertion
Date:   Thu,  5 Mar 2020 21:33:03 +0100
Message-Id: <4563a4d36ab694fb066c2a469340f61f776d7da0.1583438771.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583438771.git.sbrivio@redhat.com>
References: <cover.1583438771.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

