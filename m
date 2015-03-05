From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH v2 2/2] arptables-compat: delete extra space in
 target printing
Date: Thu, 05 Mar 2015 19:47:52 +0100
Message-ID: <20150305184743.4584.4220.stgit@nfdev.cica.es>
References: <20150305184720.4584.92956.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42629 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751083AbbCESsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 13:48:00 -0500
In-Reply-To: <20150305184720.4584.92956.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an extra space, let's get rid of it.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: split in two patches

 iptables/nft-arp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 523b3ec..503c65a 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -593,7 +593,7 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 	if (cs.jumpto != NULL && strcmp(cs.jumpto, "") != 0) {
 		printf("-j %s", cs.jumpto);
 	} else if (cs.target) {
-		printf("-j %s ", cs.target->name);
+		printf("-j %s", cs.target->name);
 		cs.target->print(&cs.fw, cs.target->t, format & FMT_NUMERIC);
 	}
 

