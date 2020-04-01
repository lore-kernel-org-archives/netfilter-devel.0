Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ECCC43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85D520719
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgZjXKJx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbgDAPOs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:14:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732561AbgDAPOs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 11:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585754087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DC7ZsiyRZlD0LvEsH+JarmS3g/yYFnpVMI1lHwTUlAk=;
        b=bgZjXKJxZAjEBf4SJFpXHqswUR9eU3sb3gJYkPkGcRKWuapOSJVflWdahW+N7P+Flak9dq
        ReLJfsorp4DNF1/LLBbn2MuLGrmYlz/UVWchKmRf+sLqLIgUPC3nVIxFW+iN+575tpP5PG
        Zn2gDvBwD0qoQvtr6ikvbl7+0n9cGyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-quEpzsCKO6m72RvJ3UjhUQ-1; Wed, 01 Apr 2020 11:14:43 -0400
X-MC-Unique: quEpzsCKO6m72RvJ3UjhUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46861937FC0;
        Wed,  1 Apr 2020 15:14:42 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D3EC5DA66;
        Wed,  1 Apr 2020 15:14:41 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2] nft_set_rbtree: Drop spurious condition for overlap detection on insertion
Date:   Wed,  1 Apr 2020 17:14:38 +0200
Message-Id: <26b78e559de6ae7250108163c19b48bdf0d12bfd.1585754003.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Case a1. for overlap detection in __nft_rbtree_insert() is not a valid
one: start-after-start is not needed to detect any type of interval
overlap and it actually results in a false positive if, while
descending the tree, this is the only step we hit after starting from
the root.

This introduced a regression, as reported by Pablo, in Python tests
cases ip/ip.t and ip/numgen.t:

  ip/ip.t: ERROR: line 124: add rule ip test-ip4 input ip hdrlength vmap =
{ 0-4 : drop, 5 : accept, 6 : continue } counter: This rule should not ha=
ve failed.
  ip/numgen.t: ERROR: line 7: add rule ip test-ip4 pre dnat to numgen inc=
 mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}: This rule shou=
ld not have failed.

Drop case a1. and renumber others, so that they are a bit clearer. In
order for these diagrams to be readily understandable, a bigger rework
is probably needed, such as an ASCII art of the actual rbtree (instead
of a flattened version).

Shell script test sets/0044interval_overlap_0 should cover all
possible cases for false negatives, so I consider that test case still
sufficient after this change.

v2: Fix comments for cases a3. and b3.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps =
on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtre=
e.c
index 8617fc16a1ed..46d976969ca3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,27 +218,26 @@ static int __nft_rbtree_insert(const struct net *ne=
t, const struct nft_set *set,
=20
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
 	 *
-	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
-	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
 	 *
 	 * and clear it later on, as we eventually reach the points indicated b=
y
 	 * '?' above, in the cases described below. We'll always meet these
 	 * later, locally, due to tree ordering, and overlaps for the intervals
 	 * that are the closest together are always evaluated last.
 	 *
-	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
-	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b3. !_____>|            (insert end after existing start)
+	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
+	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
 	 *
-	 * Case a4. resolves to b1.:
+	 * Case a3. resolves to b3.:
 	 * - if the inserted start element is the leftmost, because the '0'
 	 *   element in the tree serves as end element
 	 * - otherwise, if an existing end is found. Note that end elements are
 	 *   always inserted after corresponding start elements.
 	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
 	 * in that order.
 	 *
 	 * The flag is also cleared in two special cases:
@@ -262,9 +261,9 @@ static int __nft_rbtree_insert(const struct net *net,=
 const struct nft_set *set,
 			p =3D &parent->rb_left;
=20
 			if (nft_rbtree_interval_start(new)) {
-				overlap =3D nft_rbtree_interval_start(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+				if (nft_rbtree_interval_end(rbe) &&
+				    nft_set_elem_active(&rbe->ext, genmask))
+					overlap =3D false;
 			} else {
 				overlap =3D nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
--=20
2.25.1

