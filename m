From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH] datatype: fix name of icmp* code
Date: Wed,  3 Dec 2014 00:02:51 +0100
Message-ID: <1417561371-22624-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45932 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaLBXDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:03:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The name of datatypes can be used in set definition so they should
follow the same logic (and maybe not contain space to avoid problem
with parsing).

This patch adds an underscore to the name of the icmp* code
datatype.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/datatype.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 5f976aa..1948bfa 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -717,7 +717,7 @@ static struct error_record *icmp_code_type_parse(const struct expr *sym,
 
 const struct datatype icmp_code_type = {
 	.type		= TYPE_ICMP_CODE,
-	.name		= "icmp code",
+	.name		= "icmp_code",
 	.desc		= "icmp code",
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
@@ -749,7 +749,7 @@ static struct error_record *icmpv6_code_type_parse(const struct expr *sym,
 
 const struct datatype icmpv6_code_type = {
 	.type		= TYPE_ICMPV6_CODE,
-	.name		= "icmpv6 code",
+	.name		= "icmpv6_code",
 	.desc		= "icmpv6 code",
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
@@ -781,7 +781,7 @@ static struct error_record *icmpx_code_type_parse(const struct expr *sym,
 
 const struct datatype icmpx_code_type = {
 	.type		= TYPE_ICMPX_CODE,
-	.name		= "icmpx code",
+	.name		= "icmpx_code",
 	.desc		= "icmpx code",
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
-- 
2.1.3

