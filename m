From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/21] netfilter: kconfig: remove ct zone/label dependencies
Date: Sun,  5 Aug 2018 23:21:39 +0200
Message-ID: <20180805212141.3033-20-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

connection tracking zones currently depend on the xtables CT target.
The reasoning was that it makes no sense to support zones if they can't
be configured (which needed CT target).

Nowadays zones can also be used by OVS and configured via nftables,
so remove the dependency.

connection tracking labels are handled via hidden dependency that gets
auto-selected by the connlabel match.
Make it a visible knob, as labels can be attached via ctnetlink
or via nftables rules (nft_ct expression) too.

This allows to use conntrack labels and zones with nftables-only build.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 654588088676..71709c104081 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -106,7 +106,6 @@ config NF_CONNTRACK_SECMARK
 config NF_CONNTRACK_ZONES
 	bool  'Connection tracking zones'
 	depends on NETFILTER_ADVANCED
-	depends on NETFILTER_XT_TARGET_CT
 	help
 	  This option enables support for connection tracking zones.
 	  Normally, each connection needs to have a unique system wide
@@ -158,10 +157,11 @@ config NF_CONNTRACK_TIMESTAMP
 	  If unsure, say `N'.
 
 config NF_CONNTRACK_LABELS
-	bool
+	bool "Connection tracking labels"
 	help
 	  This option enables support for assigning user-defined flag bits
-	  to connection tracking entries.  It selected by the connlabel match.
+	  to connection tracking entries.  It can be used with xtables connlabel
+	  match and the nftables ct expression.
 
 config NF_CT_PROTO_DCCP
 	bool 'DCCP protocol connection tracking support'
-- 
2.11.0
