Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48363C3F2D7
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E32207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFLPWriU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCEUda (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:33:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgCEUd3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:33:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gm6CsBwWxX9MaH4qD8mvc2SymEbP2EQHRsHN7YuIRc8=;
        b=HFLPWriUHA/IUVNDgC5PL1PAbFMfNZpx3o+nCvjaNu4ZWkc/QctV45DkVyGM4G+jDrHxIc
        HTaH1FtWfbP+O9LrfGenx1DFPNtKiZq9ldYOd227mPmMk/OfA2C2kxNwdrWKvSwQRUinpR
        aMM1MBjMBzGbwo4BldWh7CpIf8lJXpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-R8o2MS7jOqiLpaqEntI5QA-1; Thu, 05 Mar 2020 15:33:26 -0500
X-MC-Unique: R8o2MS7jOqiLpaqEntI5QA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98930107ACC9;
        Thu,  5 Mar 2020 20:33:25 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6778210027B0;
        Thu,  5 Mar 2020 20:33:23 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf 3/4] nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
Date:   Thu,  5 Mar 2020 21:33:04 +0100
Message-Id: <1280879793dd754ef2024fd1ee96a573053b9aad.1583438771.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583438771.git.sbrivio@redhat.com>
References: <cover.1583438771.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace negations of nft_rbtree_interval_end() with a new helper,
nft_rbtree_interval_start(), wherever this helps to visualise the
problem at hand, that is, for all the occurrences except for the
comparison against given flags in __nft_rbtree_get().

This becomes especially useful in the next patch.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
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

