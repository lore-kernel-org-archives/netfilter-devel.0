From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] netlink: fix listing of range set elements in host byteorder
Date: Mon,  8 Dec 2014 23:24:34 +0100
Message-ID: <1418077474-6431-3-git-send-email-pablo@netfilter.org>
References: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaLHWWV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:22:21 -0500
In-Reply-To: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to switch the byteorder of the element in
netlink_delinearize_setelem() for non-range values only.

This fixes the listing of:

  nft add rule filter input ct mark { 0x10-0x20 } counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 23f38b0..e59e297 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1379,7 +1379,9 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 	expr = netlink_alloc_value(&netlink_location, &nld);
 	expr->dtype	= set->keytype;
 	expr->byteorder	= set->keytype->byteorder;
-	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+
+	if (!(set->flags & SET_F_INTERVAL) &&
+	    expr->byteorder == BYTEORDER_HOST_ENDIAN)
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
-- 
1.7.10.4

