From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 5/7] ebtables-compat: include rule counters
 in ebtables rules
Date: Mon, 19 Jan 2015 14:27:57 +0100
Message-ID: <20150119132757.7422.9007.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57020 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbbASN2G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:28:06 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Counters are missing in ebtables rules.

This patch includes them just before the target, so counters are incremented
when the rule is about to take his action.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index af67a5a..3ef1357 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -191,6 +191,9 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 			break;
 	}
 
+	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
+		return -1;
+
 	return _add_action(r, cs);
 }
 

