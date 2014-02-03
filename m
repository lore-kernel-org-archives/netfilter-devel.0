From: Eric Leblond <eric@regit.org>
Subject: [libnetfilter_acct PATCH] xml: fix inversion between pkt and bytes
Date: Tue,  4 Feb 2014 00:14:00 +0100
Message-ID: <1391469240-17592-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55676 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBCXOX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:14:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nfacct_snprintf_xml used to ouput accounting in XML format
was inverting packet and bytes. This patch restores the correct
order.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnetfilter_acct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index ba89e2d..77f58ce 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -298,8 +298,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 			"<pkts>%.20"PRIu64"</pkts>"
 			"<bytes>%.20"PRIu64"</bytes>",
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
 	BUFFER_SIZE(ret, size, rem, offset);
 
 	if (flags & NFACCT_SNPRINTF_F_TIME) {
-- 
1.9.rc1

