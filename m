From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [iptables PATCH 2/2] Improve readability of bitwise operation
Date: Mon, 05 Sep 2011 22:25:39 +0200
Message-ID: <4E653043.7040008@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:34596 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1IEUZn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:25:43 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs04.intra2net.com (Postfix) with ESMTP id 177E3220128
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:25:41 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id CD2292AC54
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:25:40 +0200 (CEST)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id E5F0C2AC53
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:25:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 extensions/libipt_CLUSTERIP.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 301e0e1..f4b638b 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -144,7 +144,7 @@ static void CLUSTERIP_print(const void *ip,
 	const struct ipt_clusterip_tgt_info *cipinfo =
 		(const struct ipt_clusterip_tgt_info *)target->data;
 	
-	if (!cipinfo->flags & CLUSTERIP_FLAG_NEW) {
+	if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 		printf(" CLUSTERIP");
 		return;
 	}
@@ -164,7 +164,7 @@ static void CLUSTERIP_save(const void *ip, const struct xt_entry_target *target)
 
 	/* if this is not a new entry, we don't need to save target
 	 * parameters */
-	if (!cipinfo->flags & CLUSTERIP_FLAG_NEW)
+	if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW))
 		return;
 
 	printf(" --new --hashmode %s --clustermac %s --total-nodes %d --local-node %d --hash-init %u",
-- 
1.7.4.4

