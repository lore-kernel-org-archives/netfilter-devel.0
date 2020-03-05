Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899D3C3F2D2
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CA6207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ci/MsYNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCEUdd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:33:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgCEUdd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:33:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNftTzZxI1b3cESst7sMGN9YhZe1vN+5jFr1kxCiOHw=;
        b=Ci/MsYNjwXfXAHMNktPhjyih8f2A8IFCHdPe0a/rdJuFMw0EnuI9xpdPNi3s0lah9dwvAP
        XhYZ6yqglUN/2USVC686EydftR2cbfqEQxmJUoUQDwKt5tGBQeUiEIJAssRb1Y/BdMVOu5
        fA9R0u1J28PthHpyhrmiUfEXV7AJSyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-bRoXTGYfOBGVq20avs5IcQ-1; Thu, 05 Mar 2020 15:33:28 -0500
X-MC-Unique: bRoXTGYfOBGVq20avs5IcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48A8B107ACC7;
        Thu,  5 Mar 2020 20:33:27 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1127810016EB;
        Thu,  5 Mar 2020 20:33:25 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf 4/4] nft_set_rbtree: Detect partial overlaps on insertion
Date:   Thu,  5 Mar 2020 21:33:05 +0100
Message-Id: <e6f84fe980f55dde272f7c17e2423390a03e942d.1583438771.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583438771.git.sbrivio@redhat.com>
References: <cover.1583438771.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

...and return -ENOTEMPTY to the front-end in this case, instead of
proceeding. Currently, nft takes care of checking for these cases
and not sending them to the kernel, but if we drop the set_overlap()
call in nft we can end up in situations like:

 # nft add table t
 # nft add set t s '{ type inet_service ; flags interval ; }'
 # nft add element t s '{ 1 - 5 }'
 # nft add element t s '{ 6 - 10 }'
 # nft add element t s '{ 4 - 7 }'
 # nft list set t s
 table ip t {
 	set s {
 		type inet_service
 		flags interval
 		elements =3D { 1-3, 4-5, 6-7 }
 	}
 }

This change has the primary purpose of making the behaviour
consistent with nft_set_pipapo, but is also functional to avoid
inconsistent behaviour if userspace sends overlapping elements for
any reason.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 68 ++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtre=
e.c
index 85572b2a6051..c97c493cd867 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -213,8 +213,43 @@ static int __nft_rbtree_insert(const struct net *net=
, const struct nft_set *set,
 	u8 genmask =3D nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
+	bool overlap =3D false;
 	int d;
=20
+	/* Detect overlaps as we descend the tree. Set the flag in these cases:
+	 *
+	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
+	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 *
+	 * and clear it later on, as we eventually reach the points indicated b=
y
+	 * '?' above, in the cases described below. We'll always meet these
+	 * later, locally, due to tree ordering, and overlaps for the intervals
+	 * that are the closest together are always evaluated last.
+	 *
+	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
+	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b3. !_____>|            (insert end after existing start)
+	 *
+	 * Case a4. resolves to b1.:
+	 * - if the inserted start element is the leftmost, because the '0'
+	 *   element in the tree serves as end element
+	 * - otherwise, if an existing end is found. Note that end elements are
+	 *   always inserted after corresponding start elements.
+	 *
+	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * in that order.
+	 *
+	 * The flag is also cleared in two special cases:
+	 *
+	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
+	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
+	 *
+	 * which always happen as last step and imply that no further
+	 * overlapping is possible.
+	 */
+
 	parent =3D NULL;
 	p =3D &priv->root.rb_node;
 	while (*p !=3D NULL) {
@@ -223,17 +258,40 @@ static int __nft_rbtree_insert(const struct net *ne=
t, const struct nft_set *set,
 		d =3D memcmp(nft_set_ext_key(&rbe->ext),
 			   nft_set_ext_key(&new->ext),
 			   set->klen);
-		if (d < 0)
+		if (d < 0) {
 			p =3D &parent->rb_left;
-		else if (d > 0)
+
+			if (nft_rbtree_interval_start(new)) {
+				overlap =3D nft_rbtree_interval_start(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else {
+				overlap =3D nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			}
+		} else if (d > 0) {
 			p =3D &parent->rb_right;
-		else {
+
+			if (nft_rbtree_interval_end(new)) {
+				overlap =3D nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else if (nft_rbtree_interval_end(rbe) &&
+				   nft_set_elem_active(&rbe->ext, genmask)) {
+				overlap =3D true;
+			}
+		} else {
 			if (nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(new)) {
 				p =3D &parent->rb_left;
+
+				overlap =3D false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p =3D &parent->rb_right;
+
+				overlap =3D false;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
 				*ext =3D &rbe->ext;
 				return -EEXIST;
@@ -242,6 +300,10 @@ static int __nft_rbtree_insert(const struct net *net=
, const struct nft_set *set,
 			}
 		}
 	}
+
+	if (overlap)
+		return -ENOTEMPTY;
+
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;
--=20
2.25.1

