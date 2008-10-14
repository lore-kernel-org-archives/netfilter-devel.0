From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: fix ebtables dependencies
Date: Tue, 14 Oct 2008 16:48:47 +0200 (MEST)
Message-ID: <20081014144845.27355.60146.sendpatchset@x2.localnet>
References: <20081014144843.27355.98898.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38317 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYJNOss (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:48:48 -0400
In-Reply-To: <20081014144843.27355.98898.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 0a536ab6cb2021d764921a42ad22a5aadee8fbb8
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Oct 14 13:51:08 2008 +0200

    netfilter: fix ebtables dependencies
    
    Ingo Molnar reported a build error with ebtables:
    
    ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
    ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
    ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
    ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
    ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
    ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
    make[1]: *** [__modpost] Error 1
    make: *** [modules] Error 2
    
    This reason is a missing dependencies that got lost during Kconfig cleanups.
    Restore it.
    
    Tested-by: Ingo Molnar <mingo@elte.hu>
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 366d3e9..ba6f73e 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
+	depends on BRIDGE && BRIDGE_NETFILTER
 	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
