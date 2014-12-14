From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/4] datatype: missing byteorder in string_type
Date: Sun, 14 Dec 2014 18:01:00 +0100
Message-ID: <1418576463-3606-2-git-send-email-pablo@netfilter.org>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45110 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaLNQ6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:58:44 -0500
In-Reply-To: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule filter input iifname { "lo", "eth0" } counter

Now the listing shows:

	iifname { "lo", "eth0"}

instead of:

	iifname { "", ""}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/datatype.c b/src/datatype.c
index 4519d87..7f73077 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -324,6 +324,7 @@ const struct datatype string_type = {
 	.type		= TYPE_STRING,
 	.name		= "string",
 	.desc		= "string",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.print		= string_type_print,
 	.parse		= string_type_parse,
 };
-- 
1.7.10.4

