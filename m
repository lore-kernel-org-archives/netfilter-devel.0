From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Negation bug.
Date: Sun, 5 Apr 2009 00:08:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904050007330.18428@fbirervta.pbzchgretzou.qr>
References: <49C8DB3B.909@netfilter.org> <200904042100.34124.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36812 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZDDWIy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:08:54 -0400
In-Reply-To: <200904042100.34124.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-04-04 22:00, Steven Jan Springl wrote:

>If the following iptables rule is entered:
>
>-A FORWARD  -p 6  -m conntrack  ! --ctorigdst 4.3.2.2  -j ACCEPT
>
>If an iptables-save is then issued, the rule is listed but the "!" is missing.

I added the following fix to the 'plus' branch, pending inclusion
(git://dev.medozas.de/iptables plus)

Thanks for the report!


parent c9ccba543b52cb443f110670420967ac6a41c302 (v1.4.3.1-12-gc9ccba5)
commit 093d5fc9d1826b8f0ccfbb3160c98a3c844d0273
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Apr 5 00:05:30 2009 +0200

libxt_conntrack: properly output negation symbol

Because the wrong flag was checked, the "!" was either wrongly
printed, or not printed at all.
This was broken since v1.4.0-29-ga8ad34c.

Reported-by: Steven Jan Springl <steven@springl.ukfsn.org>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index a3fcafc..358b255 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -910,7 +910,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 	}
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC) {
-		if (info->invert_flags & XT_CONNTRACK_PROTO)
+		if (info->invert_flags & XT_CONNTRACK_ORIGSRC)
 			printf("! ");
 		printf("%sctorigsrc ", prefix);
 		conntrack_dump_addr(&info->origsrc_addr, &info->origsrc_mask,
@@ -918,7 +918,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 	}
 
 	if (info->match_flags & XT_CONNTRACK_ORIGDST) {
-		if (info->invert_flags & XT_CONNTRACK_PROTO)
+		if (info->invert_flags & XT_CONNTRACK_ORIGDST)
 			printf("! ");
 		printf("%sctorigdst ", prefix);
 		conntrack_dump_addr(&info->origdst_addr, &info->origdst_mask,
@@ -926,7 +926,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLSRC) {
-		if (info->invert_flags & XT_CONNTRACK_PROTO)
+		if (info->invert_flags & XT_CONNTRACK_REPLSRC)
 			printf("! ");
 		printf("%sctreplsrc ", prefix);
 		conntrack_dump_addr(&info->replsrc_addr, &info->replsrc_mask,
@@ -934,7 +934,7 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLDST) {
-		if (info->invert_flags & XT_CONNTRACK_PROTO)
+		if (info->invert_flags & XT_CONNTRACK_REPLDST)
 			printf("! ");
 		printf("%sctrepldst ", prefix);
 		conntrack_dump_addr(&info->repldst_addr, &info->repldst_mask,
-- 
# Created with git-export-patch
