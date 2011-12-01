From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libnl-nft PATCH resend] Fix the route object comparison using the wrong pointer
Date: Thu, 1 Dec 2011 12:05:17 +0100
Message-ID: <201112011205.18003.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:38873 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1LALFU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:05:20 -0500
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

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
