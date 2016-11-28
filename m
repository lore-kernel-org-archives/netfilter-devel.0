From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] xtables-translate: Fix chain type when translating nat table
Date: Mon, 28 Nov 2016 13:14:16 +0100
Message-ID: <20161128121416.27659-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48335 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754353AbcK1MO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 07:14:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes the type of translated chains in nat table to be of type
'nat' instead of 'filter' which is incorrect.

Verified like so:

| $ iptables-restore-translate -f /dev/stdin <<EOF
| *nat
| :POSTROUTING ACCEPT [0:0]
| [0:0] -A POSTROUTING -j MASQUERADE
| COMMIT
| EOF
| # Translated by ./install/sbin/iptables-restore-translate v1.6.0 on Mon Nov 28 12:11:30 2016
| add table ip nat
| add chain ip nat POSTROUTING { type nat hook postrouting priority 0; policy accept; }
| add rule ip nat POSTROUTING counter masquerade

Ditto for ip6tables-restore-translate.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This patch depends upon my previously submitted patch
"xtables-translate: Support setting standard chain policy".
---
 iptables/xtables-translate.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 0c706dcc2b9db..153bd6503c59b 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -352,17 +352,23 @@ static int xlate_chain_set(struct nft_handle *h, const char *table,
 			   const char *chain, const char *policy,
 			   const struct xt_counters *counters)
 {
-	printf("add chain %s %s %s ", family2str[h->family], table, chain);
+	const char *type = "filter";
+
+	if (strcmp(table, "nat") == 0)
+		type = "nat";
+
+	printf("add chain %s %s %s { type %s ",
+	       family2str[h->family], table, chain, type);
 	if (strcmp(chain, "PREROUTING") == 0)
-		printf("{ type filter hook prerouting priority 0; ");
+		printf("hook prerouting priority 0; ");
 	else if (strcmp(chain, "INPUT") == 0)
-		printf("{ type filter hook input priority 0; ");
+		printf("hook input priority 0; ");
 	else if (strcmp(chain, "FORWARD") == 0)
-		printf("{ type filter hook forward priority 0; ");
+		printf("hook forward priority 0; ");
 	else if (strcmp(chain, "OUTPUT") == 0)
-		printf("{ type filter hook output priority 0; ");
+		printf("hook output priority 0; ");
 	else if (strcmp(chain, "POSTROUTING") == 0)
-		printf("{ type filter hook postrouting priority 0; ");
+		printf("hook postrouting priority 0; ");
 
 	if (strcmp(policy, "ACCEPT") == 0)
 		printf("policy accept; ");
-- 
2.10.0

