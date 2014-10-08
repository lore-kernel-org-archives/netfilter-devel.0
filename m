From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH xtables-compat 3/4] arptables-compat: fix missing error reporting
Date: Wed,  8 Oct 2014 22:17:50 +0200
Message-ID: <1412799471-7721-3-git-send-email-pablo@netfilter.org>
References: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaJHUQm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:16:42 -0400
In-Reply-To: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # arptables-compat -D INPUT -j ACCEPT
 arptables: Bad rule (does a matching rule exist in that chain?)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xtables-arp-standalone.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
index 23b6bcb..182dd9f 100644
--- a/iptables/xtables-arp-standalone.c
+++ b/iptables/xtables-arp-standalone.c
@@ -84,5 +84,10 @@ int xtables_arp_main(int argc, char *argv[])
 	if (ret)
 		ret = nft_commit(&h);
 
+	nft_fini(&h);
+
+	if (!ret)
+		fprintf(stderr, "arptables: %s\n", nft_strerror(errno));
+
 	exit(!ret);
 }
-- 
1.7.10.4

