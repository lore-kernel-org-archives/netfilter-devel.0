From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Fri, 23 Oct 2009 17:48:04 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35297 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZJWPsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:48:00 -0400
In-Reply-To: <200910231623.42725.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-10-23 16:23, Thomas Jarosch wrote:

>Hello Jan,
>
>a user of ipt_ACCOUNT recently sent me some patches regarding
>big endian support in ipt_ACCOUNT/xt_ACCOUNT:
>http://developer.intra2net.com/mailarchive/html/ipt_ACCOUNT/2009/msg00014.html
>
>I'm wondering if this is the best approach to support big endian machines
>with all those #ifdefs?

The second is ok, though I dunno why he did not chose to do the
same in the first. Hence:

parent 304e5e52ca600c4d7bc68722a514c49bbac45195 (v1.19-8-g304e5e5)
commit d0fd08cd390fde4698010d7e50ffb5b8aea3fbeb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Oct 23 17:37:54 2009 +0200

ACCOUNT: correctly account for network-order addresses on BE arches
---
 extensions/ACCOUNT/xt_ACCOUNT.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/ACCOUNT/xt_ACCOUNT.c b/extensions/ACCOUNT/xt_ACCOUNT.c
index 34e16b1..251ebe1 100644
--- a/extensions/ACCOUNT/xt_ACCOUNT.c
+++ b/extensions/ACCOUNT/xt_ACCOUNT.c
@@ -293,8 +293,8 @@ static void ipt_acc_depth0_insert(struct ipt_acc_mask_24 *mask_24,
 	}
 
 	/* Calculate array positions */
-	src_slot = (src_ip & 0xFF000000) >> 24;
-	dst_slot = (dst_ip & 0xFF000000) >> 24;
+	src_slot = ntohl(src_ip) & 0xFF;
+	dst_slot = ntohl(dst_ip) & 0xFF;
 
 	/* Increase size counters */
 	if (is_src) {
@@ -345,7 +345,7 @@ static void ipt_acc_depth1_insert(struct ipt_acc_mask_16 *mask_16,
 {
 	/* Do we need to process src IP? */
 	if ((net_ip & netmask) == (src_ip & netmask)) {
-		unsigned char slot = (src_ip & 0x00FF0000) >> 16;
+		unsigned char slot = (ntohl(src_ip) & 0xFF00) >> 8;
 		pr_debug("ACCOUNT: Calculated SRC 16 bit network slot: %d\n", slot);
 
 		/* Do we need to create a new mask_24 bucket? */
@@ -361,7 +361,7 @@ static void ipt_acc_depth1_insert(struct ipt_acc_mask_16 *mask_16,
 
 	/* Do we need to process dst IP? */
 	if ((net_ip & netmask) == (dst_ip & netmask)) {
-		unsigned char slot = (dst_ip & 0x00FF0000) >> 16;
+		unsigned char slot = (ntohl(dst_ip) & 0xFF00) >> 8;
 		pr_debug("ACCOUNT: Calculated DST 16 bit network slot: %d\n", slot);
 
 		/* Do we need to create a new mask_24 bucket? */
@@ -383,7 +383,7 @@ static void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8,
 {
 	/* Do we need to process src IP? */
 	if ((net_ip & netmask) == (src_ip & netmask)) {
-		unsigned char slot = (src_ip & 0x0000FF00) >> 8;
+		unsigned char slot = (ntohl(src_ip) & 0xFF0000) >> 16;
 		pr_debug("ACCOUNT: Calculated SRC 24 bit network slot: %d\n", slot);
 
 		/* Do we need to create a new mask_24 bucket? */
@@ -399,7 +399,7 @@ static void ipt_acc_depth2_insert(struct ipt_acc_mask_8 *mask_8,
 
 	/* Do we need to process dst IP? */
 	if ((net_ip & netmask) == (dst_ip & netmask)) {
-		unsigned char slot = (dst_ip & 0x0000FF00) >> 8;
+		unsigned char slot = (ntohl(dst_ip) & 0xFF0000) >> 16;
 		pr_debug("ACCOUNT: Calculated DST 24 bit network slot: %d\n", slot);
 
 		/* Do we need to create a new mask_24 bucket? */
-- 
# Created with git-export-patch
