From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] ct: add maximum helper length value
Date: Tue,  2 Jun 2015 12:57:40 +0200
Message-ID: <1433242661-32125-2-git-send-email-kaber@trash.net>
References: <1433242661-32125-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58050 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbFBK56 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 06:57:58 -0400
In-Reply-To: <1433242661-32125-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The current kernel restricts ct helper names to 16 bytes length. Specify
this limit in the ct expression table to catch oversized strings in userspace.
Since older versions of nft didn't support larger values, this does not
negatively affect interaction with old kernel versions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/ct.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index 2eb85ea..aa80138 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -161,6 +161,10 @@ static void __init ct_label_table_init(void)
 	ct_label_tbl = rt_symbol_table_init("/etc/xtables/connlabel.conf");
 }
 
+#ifndef NF_CT_HELPER_NAME_LEN
+#define NF_CT_HELPER_NAME_LEN	16
+#endif
+
 static const struct ct_template ct_templates[] = {
 	[NFT_CT_STATE]		= CT_TEMPLATE("state",	    &ct_state_type,
 					      BYTEORDER_HOST_ENDIAN,
@@ -178,7 +182,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN,
 					      4 * BITS_PER_BYTE),
 	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
-					      BYTEORDER_HOST_ENDIAN, 0),
+					      BYTEORDER_HOST_ENDIAN,
+					      NF_CT_HELPER_NAME_LEN * BITS_PER_BYTE),
 	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &invalid_type,
 					      BYTEORDER_INVALID,
 					      BITS_PER_BYTE),
-- 
2.1.0

