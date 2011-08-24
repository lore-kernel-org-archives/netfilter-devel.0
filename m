From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libnl-nft PATCH] Fix the route object comparison using the wrong
 pointer
Date: Wed, 24 Aug 2011 18:22:55 +0200
Message-ID: <4E55255F.1050901@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:47979 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1HXQxl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:53:41 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 03F74300D3
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:22:56 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id C225F2AC54
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:22:56 +0200 (CEST)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id AD2682AC52
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:22:55 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Typo detected by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 lib/route/route_obj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/route/route_obj.c b/lib/route/route_obj.c
index 4e14d6d..8f1d4d5 100644
--- a/lib/route/route_obj.c
+++ b/lib/route/route_obj.c
@@ -403,7 +403,7 @@ static int route_compare(struct nl_object *_a, struct nl_object *_b,
 		diff |= ROUTE_DIFF(FLAGS,
 			  (a->rt_flags ^ b->rt_flags) & b->rt_flag_mask);
 	} else {
-		if (a->rt_nr_nh != a->rt_nr_nh)
+		if (a->rt_nr_nh != b->rt_nr_nh)
 			goto nh_mismatch;
 
 		/* search for a dup in each nh of a */
-- 
1.7.4.4

