From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 2/2] nft-bridge: fix printing of inverted
 protocols, addresses
Date: Tue, 28 Oct 2014 19:33:06 +0100
Message-ID: <20141028183306.3948.5151.stgit@nfdev.cica.es>
References: <20141028183259.3948.15098.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44366 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbaJ1SdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:33:16 -0400
In-Reply-To: <20141028183259.3948.15098.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, no '!' is printed in payload comparisions.
This patch solves it, so we can print for example inverted protocols:

 % ebtables-compat -L
[...]
-p ! 0x800 -j ACCEPT

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 70501ac..891015a 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -259,15 +259,21 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 		get_cmp_data(e, addr, sizeof(addr), &inv);
 		for (i = 0; i < ETH_ALEN; i++)
 			fw->destmac[i] = addr[i];
+		if (inv)
+			fw->invflags |= EBT_IDEST;
 		break;
 	case offsetof(struct ethhdr, h_source):
 		get_cmp_data(e, addr, sizeof(addr), &inv);
 		for (i = 0; i < ETH_ALEN; i++)
 			fw->sourcemac[i] = addr[i];
+		if (inv)
+			fw->invflags |= EBT_ISOURCE;
 		break;
 	case offsetof(struct ethhdr, h_proto):
 		get_cmp_data(e, &ethproto, sizeof(ethproto), &inv);
 		fw->ethproto = ethproto;
+		if (inv)
+			fw->invflags |= EBT_IPROTO;
 		break;
 	}
 }

