From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 4/5] rule: Refactor chain_print_declaration()
Date: Thu, 28 Sep 2017 17:17:44 +0200
Message-ID: <20170928151745.28426-5-phil@nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35292 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PSN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:18:13 -0400
In-Reply-To: <20170928151745.28426-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of having two nearly identical printf() calls for netdev and
other chains, print the common parts separately and include the device
bit only for netdev chains.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 85505aecd5091..91129734a3d8f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -666,18 +666,12 @@ static void chain_print_declaration(const struct chain *chain)
 {
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		if (chain->dev != NULL) {
-			printf("\t\ttype %s hook %s device %s priority %d; policy %s;\n",
-			       chain->type,
-			       hooknum2str(chain->handle.family, chain->hooknum),
-			       chain->dev, chain->priority,
-			       chain_policy2str(chain->policy));
-		} else {
-			printf("\t\ttype %s hook %s priority %d; policy %s;\n",
-			       chain->type,
-			       hooknum2str(chain->handle.family, chain->hooknum),
-			       chain->priority, chain_policy2str(chain->policy));
-		}
+		printf("\t\ttype %s hook %s", chain->type,
+		       hooknum2str(chain->handle.family, chain->hooknum));
+		if (chain->dev != NULL)
+			printf(" device %s", chain->dev);
+		printf(" priority %d; policy %s;\n",
+		       chain->priority, chain_policy2str(chain->policy));
 	}
 }
 
-- 
2.13.1

