From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH 2/2] ebtables-compat: fix rule deleting with -D in
 rules with no target
Date: Wed, 11 Mar 2015 18:55:03 +0100
Message-ID: <20150311175502.30898.36762.stgit@nfdev.cica.es>
References: <20150311175457.30898.35962.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45831 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750858AbbCKRzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 13:55:12 -0400
In-Reply-To: <20150311175457.30898.35962.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, rule deleting with -D produces segfault in rules
with no target.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index e3ab667..084dd58 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -619,7 +619,7 @@ static bool nft_bridge_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 		return false;
 	}
 
-	if (strcmp(cs->jumpto, this.jumpto) != 0) {
+	if (cs->jumpto != NULL && strcmp(cs->jumpto, this.jumpto) != 0) {
 		DEBUGP("Different verdict\n");
 		return false;
 	}

