Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970C1C433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755AB207DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLy1kDXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHSV7j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:59:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbgHSV7h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 17:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597874376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LRVgme0aHZSN40LQ8x3jZkcWqAei3k6qlJ5+ci+N3iI=;
        b=VLy1kDXubN4utIqIcwNFepeaHIz1U09IaCVsv1sbg/lN1Dx2Mgijb2DdOmwbSFf2V5/1Zz
        3G+eeO9C1FV9qkLAoQY8naZb+y5fX/YqUiT7zjzZ+BM+pLFRFzWlyOYOYsa9HVXzMFpjSH
        t+KdyJcI4V3VvOMex3vespvRBZNMy3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-AVpSA1TuMV2KfjZ6szk3xg-1; Wed, 19 Aug 2020 17:59:34 -0400
X-MC-Unique: AVpSA1TuMV2KfjZ6szk3xg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20F51186A574;
        Wed, 19 Aug 2020 21:59:33 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0F875C1D0;
        Wed, 19 Aug 2020 21:59:31 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Andreas Fischer <netfilter@d9c.eu>
Subject: [PATCH nf 2/2] nft_set_rbtree: Detect partial overlap with start endpoint match
Date:   Wed, 19 Aug 2020 23:59:15 +0200
Message-Id: <c9e0d6efe9f783a32b8cc951547f6b18fb94d7e3.1597873312.git.sbrivio@redhat.com>
In-Reply-To: <cover.1597873312.git.sbrivio@redhat.com>
References: <cover.1597873312.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Getting creative with nft and omitting the interval_overlap()
check from the set_overlap() function, without omitting
set_overlap() altogether, led to the observation of a partial
overlap that wasn't detected, and would actually result in
replacement of the end element of an existing interval.

This is due to the fact that we'll return -EEXIST on a matching,
pre-existing start element, instead of -ENOTEMPTY, and the error
is cleared by API if NLM_F_EXCL is not given. At this point, we
can insert a matching start, and duplicate the end element as long
as we don't end up into other intervals.

For instance, inserting interval 0 - 2 with an existing 0 - 3
interval would result in a single 0 - 2 interval, and a dangling
'3' end element. This is because nft will proceed after inserting
the '0' start element as no error is reported, and no further
conflicting intervals are detected on insertion of the end element.

This needs a different approach as it's a local condition that can
be detected by looking for duplicate ends coming from left and
right, separately. Track those and directly report -ENOTEMPTY on
duplicated end elements for a matching start.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 27668f4e44ea..217ab3644c25 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,11 +218,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
+	bool overlap = false, dup_end_left = false, dup_end_right = false;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
-	bool overlap = false;
 	int d;
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
@@ -262,6 +262,20 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
+	 *
+	 * Another special case comes from the fact that start elements matching
+	 * an already existing start element are allowed: insertion is not
+	 * performed but we return -EEXIST in that case, and the error will be
+	 * cleared by the caller if NLM_F_EXCL is not present in the request.
+	 * This way, request for insertion of an exact overlap isn't reported as
+	 * error to userspace if not desired.
+	 *
+	 * However, if the existing start matches a pre-existing start, but the
+	 * end element doesn't match the corresponding pre-existing end element,
+	 * we need to report a partial overlap. This is a local condition that
+	 * can be noticed without need for a tracking flag, by checking for a
+	 * local duplicated end for a corresponding start, from left and right,
+	 * separately.
 	 */
 
 	parent = NULL;
@@ -281,19 +295,35 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
+				if (dup_end_left && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_right = true;
+					continue;
+				}
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
 
 			if (nft_rbtree_interval_end(new)) {
+				if (dup_end_right && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_left = true;
+					continue;
+				}
 			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = nft_rbtree_interval_end(rbe);
@@ -321,6 +351,8 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				p = &parent->rb_left;
 			}
 		}
+
+		dup_end_left = dup_end_right = false;
 	}
 
 	if (overlap)
-- 
2.28.0

