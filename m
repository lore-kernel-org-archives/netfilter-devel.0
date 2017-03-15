From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] proto: Add some exotic ICMPv6 types
Date: Wed, 15 Mar 2017 16:55:01 +0100
Message-ID: <20170315155501.8603-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58343 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752182AbdCOPz6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:55:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for matching on inverse ND messages as defined by
RFC3122 (not implemented in Linux) and MLDv2 as defined by RFC3810.

Note that ICMPV6_MLD2_REPORT macro is defined in linux/icmpv6.h but
including that header leads to conflicts with symbols defined in
netinet/icmp6.h.

In addition to the above, "mld-listener-done" is introduced as an alias
for "mld-listener-reduction".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This should resolve netfilter BZ#926.
---
 src/proto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index fb965304e59d9..6a8eed936d858 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -632,6 +632,10 @@ const struct proto_desc proto_ip = {
 
 #include <netinet/icmp6.h>
 
+#define IND_NEIGHBOR_SOLICIT	141
+#define IND_NEIGHBOR_ADVERT	142
+#define ICMPV6_MLD2_REPORT	143
+
 static const struct symbol_table icmp6_type_tbl = {
 	.base		= BASE_DECIMAL,
 	.symbols	= {
@@ -644,12 +648,16 @@ static const struct symbol_table icmp6_type_tbl = {
 		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
 		SYMBOL("mld-listener-report",		MLD_LISTENER_REPORT),
 		SYMBOL("mld-listener-reduction",	MLD_LISTENER_REDUCTION),
+		SYMBOL("mld-listener-done",		MLD_LISTENER_REDUCTION),
 		SYMBOL("nd-router-solicit",		ND_ROUTER_SOLICIT),
 		SYMBOL("nd-router-advert",		ND_ROUTER_ADVERT),
 		SYMBOL("nd-neighbor-solicit",		ND_NEIGHBOR_SOLICIT),
 		SYMBOL("nd-neighbor-advert",		ND_NEIGHBOR_ADVERT),
 		SYMBOL("nd-redirect",			ND_REDIRECT),
 		SYMBOL("router-renumbering",		ICMP6_ROUTER_RENUMBERING),
+		SYMBOL("mld2-listener-report",		ICMPV6_MLD2_REPORT),
+		SYMBOL("ind-neighbor-solicit",		IND_NEIGHBOR_SOLICIT),
+		SYMBOL("ind-neighbor-advert",		IND_NEIGHBOR_ADVERT),
 		SYMBOL_LIST_END
 	},
 };
-- 
2.11.0

