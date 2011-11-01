From: pablo@netfilter.org
Subject: [PATCH 02/14] ipvs: Add documentation for new sysctl entries
Date: Tue,  1 Nov 2011 10:11:24 +0100
Message-ID: <1320138696-28048-3-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37211 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KAJL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:11:59 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>

Add missing documentation for conntrack, snat_reroute and sync_version.

Also fix up a typo, IPVS_DEBUG should be IP_VS_DEBUG.

Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.txt |   52 +++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 4ccdbca..1dcdd49 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -15,6 +15,23 @@ amemthresh - INTEGER
         enabled and the variable is automatically set to 2, otherwise
         the strategy is disabled and the variable is  set  to 1.
 
+conntrack - BOOLEAN
+	0 - disabled (default)
+	not 0 - enabled
+
+	If set, maintain connection tracking entries for
+	connections handled by IPVS.
+
+	This should be enabled if connections handled by IPVS are to be
+	also handled by stateful firewall rules. That is, iptables rules
+	that make use of connection tracking.  It is a performance
+	optimisation to disable this setting otherwise.
+
+	Connections handled by the IPVS FTP application module
+	will have connection tracking entries regardless of this setting.
+
+	Only available when IPVS is compiled with the CONFIG_IP_VS_NFCT
+
 cache_bypass - BOOLEAN
         0 - disabled (default)
         not 0 - enabled
@@ -39,7 +56,7 @@ debug_level - INTEGER
 	11         - IPVS packet handling (ip_vs_in/ip_vs_out)
 	12 or more - packet traversal
 
-	Only available when IPVS is compiled with the CONFIG_IPVS_DEBUG
+	Only available when IPVS is compiled with the CONFIG_IP_VS_DEBUG
 
 	Higher debugging levels include the messages for lower debugging
 	levels, so setting debug level 2, includes level 0, 1 and 2
@@ -141,3 +158,36 @@ sync_threshold - INTEGER
         synchronized, every time the number of its incoming packets
         modulus 50 equals the threshold. The range of the threshold is
         from 0 to 49.
+
+snat_reroute - BOOLEAN
+	0 - disabled
+	not 0 - enabled (default)
+
+	If enabled, recalculate the route of SNATed packets from
+	realservers so that they are routed as if they originate from the
+	director. Otherwise they are routed as if they are forwarded by the
+	director.
+
+	If policy routing is in effect then it is possible that the route
+	of a packet originating from a director is routed differently to a
+	packet being forwarded by the director.
+
+	If policy routing is not in effect then the recalculated route will
+	always be the same as the original route so it is an optimisation
+	to disable snat_reroute and avoid the recalculation.
+
+sync_version - INTEGER
+	default 1
+
+	The version of the synchronisation protocol used when sending
+	synchronisation messages.
+
+	0 selects the original synchronisation protocol (version 0). This
+	should be used when sending synchronisation messages to a legacy
+	system that only understands the original synchronisation protocol.
+
+	1 selects the current synchronisation protocol (version 1). This
+	should be used where possible.
+
+	Kernels with this sync_version entry are able to receive messages
+	of both version 1 and version 2 of the synchronisation protocol.
-- 
1.7.2.5

