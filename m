From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH] netfilter: nft_compat: fix sparse warning
Date: Thu, 12 Feb 2015 11:14:09 +0100
Message-ID: <20150212101408.20533.19035.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47775 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbbBLKOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 05:14:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_compat.c:140:37:    expected restricted __be16 [usertype] ethproto
   net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned] [usertype] proto
>> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_compat.c:351:37:    expected restricted __be16 [usertype] ethproto
   net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned] [usertype] proto

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index c598f74..b5dc651 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -137,7 +137,7 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
 	case NFPROTO_BRIDGE:
-		entry->ebt.ethproto = proto;
+		entry->ebt.ethproto = (__force __be16)proto;
 		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
 		break;
 	}
@@ -348,7 +348,7 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
 	case NFPROTO_BRIDGE:
-		entry->ebt.ethproto = proto;
+		entry->ebt.ethproto = (__force __be16)proto;
 		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
 		break;
 	}

