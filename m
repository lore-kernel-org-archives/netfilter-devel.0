From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: Kconfig: default DCCP/SCTP conntrack support to
 the protocol config values
Date: Wed, 07 May 2008 09:47:38 +0200
Message-ID: <48215E9A.9070501@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030703090405040703000803"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55137 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbYEGHsN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2008 03:48:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030703090405040703000803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------030703090405040703000803
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: Kconfig: default DCCP/SCTP conntrack support to the protocol config values

When conntrack and DCCP/SCTP protocols are enabled, chances are good that
people also want DCCP/SCTP conntrack and NAT support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a080f74033697d16e644c6e81ff990c4aac21085
tree 8b362f99d92f388d93140471dd2771bbe70fa04f
parent 3f6886bf0dcfb06f81de3b27b607a45143c27916
author Patrick McHardy <kaber@trash.net> Tue, 06 May 2008 09:19:05 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 06 May 2008 09:19:05 +0200

 net/netfilter/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c1fc0f1..aa8d80c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -90,6 +90,7 @@ config NF_CT_PROTO_DCCP
 	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	default IP_DCCP
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on DCCP connections.
@@ -104,6 +105,7 @@ config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	default IP_SCTP
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on SCTP connections.
@@ -532,6 +534,7 @@ config NETFILTER_XT_MATCH_DCCP
 	tristate '"dccp" protocol match support'
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
+	default IP_DCCP
 	help
 	  With this option enabled, you will be able to use the iptables
 	  `dccp' match in order to match on DCCP source/destination ports
@@ -725,6 +728,7 @@ config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
 	depends on NETFILTER_ADVANCED
+	default IP_SCTP
 	help
 	  With this option enabled, you will be able to use the 
 	  `sctp' match in order to match on SCTP source/destination ports

--------------030703090405040703000803--
