From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 6/8] [NETFILTER]: Make Ebtables use Xtables
 infrastructure
Date: Wed, 9 Apr 2008 18:52:58 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091847090.3866@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de> <47FCBFBF.5020805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34166 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYDIQw7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:52:59 -0400
In-Reply-To: <47FCBFBF.5020805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:08, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
>
> I like these patches (modulo the small NFPROTO_ARP nitpicks),
> I'd like to get an ACK from Bart before applying them though.
>
> I assume this doesn't affect userspace compatibility?
>
Additionally, we want this one at least.

===
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Apr 9 18:12:04 2008 +0200

    [NETFILTER]: ebt modules depend on NETFILTER_XTABLES now

    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/bridge/netfilter/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 4a3e2bf..8539741 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -7,6 +7,7 @@ menu "Bridge: Netfilter Configuration"
 
 config BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
+	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
 	  framework. Say 'Y' or 'M' here if you want to do Ethernet
@@ -44,6 +45,9 @@ config BRIDGE_EBT_T_NAT
 	  See the man page for ebtables(8).
 
 	  To compile it as a module, choose M here.  If unsure, say N.
+
+if NETFILTER_XTABLES
+
 #
 # matches
 #
@@ -212,4 +216,6 @@ config BRIDGE_EBT_ULOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+endif # NETFILTER_XTABLES
+
 endmenu

