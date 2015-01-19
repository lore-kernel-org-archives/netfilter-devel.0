From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 2/7] ebtables-compat: add nft rule compat
 information to bridge rules
Date: Mon, 19 Jan 2015 14:27:41 +0100
Message-ID: <20150119132741.7422.63774.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56999 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751578AbbASN1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:27:50 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compat information is required by some ebtables extensions to properly
work.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 9747405..af67a5a 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -184,6 +184,8 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 		add_cmp_u16(r, fw->ethproto, op);
 	}
 
+	add_compat(r, fw->ethproto, fw->invflags);
+
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
 		if (add_match(r, matchp->match->m) < 0)
 			break;

