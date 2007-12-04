From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 48/49]: remove NF_CONNTRACK_ENABLED option
Date: Tue,  4 Dec 2007 13:03:03 +0100 (MET)
Message-ID: <20071204120302.2442.16094.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62258 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbXLDMDE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:03:04 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove NF_CONNTRACK_ENABLED option

Remove the NF_CONNTRACK_ENABLED option. It was meant for a smoother upgrade
to nf_conntrack, people having reconfigured their kernel at least once since
ip_conntrack was removed will have the NF_CONNTRACK option already set.
People upgrading from older kernels have to reconfigure a lot anyway.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 961020004705df03d7f44449985d98ed4b99a0f7
tree 7b7419f8ed05d9f23f467876aee969b951c7a4f7
parent 999e49b544d7f49aef25b4331c6d33c106a591ec
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:31 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:36 +0100

 net/netfilter/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4182393..772c58c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -25,8 +25,7 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
-# Rename this to NF_CONNTRACK in a 2.6.25
-config NF_CONNTRACK_ENABLED
+config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	help
 	  Connection tracking keeps a record of what packets have passed
@@ -40,10 +39,6 @@ config NF_CONNTRACK_ENABLED
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NF_CONNTRACK
-	tristate
-	default NF_CONNTRACK_ENABLED
-
 config NF_CT_ACCT
 	bool "Connection tracking flow accounting"
 	depends on NF_CONNTRACK
