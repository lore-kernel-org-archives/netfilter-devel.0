From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] netlink: fix dictionary feature
Date: Sat, 28 Dec 2013 01:01:14 +0100
Message-ID: <1388188874-7667-2-git-send-email-pablo@netfilter.org>
References: <1388188874-7667-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51026 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab3L1ABY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:01:24 -0500
In-Reply-To: <1388188874-7667-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes dictionary feature, that allows you to conditionally
set packet fields based on a given selector, eg.

 add rule ip filter input meta mark set tcp dport map { 22 => 1, 23 => 2, }

This means that traffic flowing to tcp port 22 receives the packet
mark 1 and tcp port 23 receives mark 2.

This feature was partially broken by aae836a ("src: use libnftables")
although it also needs the kernel fix ("netfilter: nf_tables: fix wrong
datatype in nft_validate_data_load()").

This patch also fixes endianness issues when displaying the mark
via `list table' related to list_setelem_cb() since the byteorder
was left unset for the data part of a set element.

 meta mark set tcp dport map { telnet => 0x02000000, ssh => 0x01000000}
                                            ^                  ^
Note the wrong endianness in the example above.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index cab8cf4..59bd8e4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -157,13 +157,22 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
 				      &nld.value, nld.len);
 		netlink_gen_data(expr->right, &nld);
-		if (expr->right->ops->type == EXPR_VERDICT) {
+		switch (expr->right->ops->type) {
+		case EXPR_VERDICT:
 			nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT,
 						  expr->right->verdict);
 			if (expr->chain != NULL) {
 				nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_CHAIN,
 						nld.chain, strlen(nld.chain));
 			}
+			break;
+		case EXPR_VALUE:
+			nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_DATA,
+					      nld.value, nld.len);
+			break;
+		default:
+			BUG("unexpected set element expression\n");
+			break;
 		}
 	}
 
@@ -994,6 +1003,9 @@ static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 					  set->datatype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
 		data->dtype = set->datatype;
+		data->byteorder = set->datatype->byteorder;
+		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
 
 		expr = mapping_expr_alloc(&internal_location, expr, data);
 	}
-- 
1.7.10.4

