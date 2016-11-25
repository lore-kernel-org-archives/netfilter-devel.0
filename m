From: Phil Sutter <phil@nwl.cc>
Subject: [PATCH] xtables-translate: Support setting standard chain policy
Date: Fri, 25 Nov 2016 18:06:46 +0100
Message-ID: <20161125170646.8620-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59552 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753052AbcKYRG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2016 12:06:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looks like this bit was simply forgotten when implementing
xlate_chain_set() as everything needed was there to just print the
desired policy along with the chain definition.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 689533f3d4d85..0c706dcc2b9db 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -354,16 +354,22 @@ static int xlate_chain_set(struct nft_handle *h, const char *table,
 {
 	printf("add chain %s %s %s ", family2str[h->family], table, chain);
 	if (strcmp(chain, "PREROUTING") == 0)
-		printf("{ type filter hook prerouting priority 0; }\n");
+		printf("{ type filter hook prerouting priority 0; ");
 	else if (strcmp(chain, "INPUT") == 0)
-		printf("{ type filter hook input priority 0; }\n");
+		printf("{ type filter hook input priority 0; ");
 	else if (strcmp(chain, "FORWARD") == 0)
-		printf("{ type filter hook forward priority 0; }\n");
+		printf("{ type filter hook forward priority 0; ");
 	else if (strcmp(chain, "OUTPUT") == 0)
-		printf("{ type filter hook output priority 0; }\n");
+		printf("{ type filter hook output priority 0; ");
 	else if (strcmp(chain, "POSTROUTING") == 0)
-		printf("{ type filter hook postrouting priority 0; }\n");
+		printf("{ type filter hook postrouting priority 0; ");
 
+	if (strcmp(policy, "ACCEPT") == 0)
+		printf("policy accept; ");
+	else if (strcmp(policy, "DROP") == 0)
+		printf("policy drop; ");
+
+	printf("}\n");
 	return 1;
 }
 
-- 
2.10.0

