Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624D2C4332E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F5720754
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZoFB6SPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgCVCWW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:22:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58422 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCWW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Le3Y4tbpygoe7L6g1cdDZep8b2xvfkePFkhgnqcqtNo=;
        b=ZoFB6SPNCKS2uu2DPO5MMYm2Eiq2sCFc9MMcfaEsFd82UAxR4+mTr0nKDUod+CNhgggn89
        1i/d5OmGzVcUzucXJC/KaSlP6xh3bzHiFx7jw6aTLqpGC71Nna1dSfHcIoK4E2dX+JCNbX
        p2FLS48QmnQRi5H0sQYgaX3QJjz/FjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-ZbGcyWleNyyFGExPOYUDGA-1; Sat, 21 Mar 2020 22:22:20 -0400
X-MC-Unique: ZbGcyWleNyyFGExPOYUDGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E815A800D5B;
        Sun, 22 Mar 2020 02:22:18 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADC185C1B5;
        Sun, 22 Mar 2020 02:22:17 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 3/4] nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
Date:   Sun, 22 Mar 2020 03:22:00 +0100
Message-Id: <1280879793dd754ef2024fd1ee96a573053b9aad.1584841602.git.sbrivio@redhat.com>
In-Reply-To: <cover.1584841602.git.sbrivio@redhat.com>
References: <cover.1584841602.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace negations of nft_rbtree_interval_end() with a new helper,
nft_rbtree_interval_start(), wherever this helps to visualise the
problem at hand, that is, for all the occurrences except for the
comparison against given flags in __nft_rbtree_get().

This gets especially useful in the next patch.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes

 net/netfilter/nft_set_rbtree.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtre=
e.c
index 5000b938ab1e..85572b2a6051 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,6 +33,11 @@ static bool nft_rbtree_interval_end(const struct nft_r=
btree_elem *rbe)
 	       (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END);
 }
=20
+static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
+{
+	return !nft_rbtree_interval_end(rbe);
+}
+
 static bool nft_rbtree_equal(const struct nft_set *set, const void *this=
,
 			     const struct nft_rbtree_elem *interval)
 {
@@ -64,7 +69,7 @@ static bool __nft_rbtree_lookup(const struct net *net, =
const struct nft_set *set
 			if (interval &&
 			    nft_rbtree_equal(set, this, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(interval))
+			    nft_rbtree_interval_start(interval))
 				continue;
 			interval =3D rbe;
 		} else if (d > 0)
@@ -89,7 +94,7 @@ static bool __nft_rbtree_lookup(const struct net *net, =
const struct nft_set *set
=20
 	if (set->flags & NFT_SET_INTERVAL && interval !=3D NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    nft_rbtree_interval_start(interval)) {
 		*ext =3D &interval->ext;
 		return true;
 	}
@@ -224,9 +229,9 @@ static int __nft_rbtree_insert(const struct net *net,=
 const struct nft_set *set,
 			p =3D &parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(new)) {
+			    nft_rbtree_interval_start(new)) {
 				p =3D &parent->rb_left;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p =3D &parent->rb_right;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
@@ -317,10 +322,10 @@ static void *nft_rbtree_deactivate(const struct net=
 *net,
 			parent =3D parent->rb_right;
 		else {
 			if (nft_rbtree_interval_end(rbe) &&
-			    !nft_rbtree_interval_end(this)) {
+			    nft_rbtree_interval_start(this)) {
 				parent =3D parent->rb_left;
 				continue;
-			} else if (!nft_rbtree_interval_end(rbe) &&
+			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(this)) {
 				parent =3D parent->rb_right;
 				continue;
--=20
2.25.1

