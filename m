From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] netfilter: Combine ipt_ttl and ip6t_hl source
Date: Thu, 19 Feb 2009 01:48:21 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902190143300.7806@fbirervta.pbzchgretzou.qr>
References: <1234972949-12036-1-git-send-email-jengelh@medozas.de> <1234972949-12036-3-git-send-email-jengelh@medozas.de> <499C4813.8070102@trash.net> <alpine.LSU.2.00.0902181855570.8011@fbirervta.pbzchgretzou.qr> <499C4E65.3050609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54223 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZBSAsY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:48:24 -0500
In-Reply-To: <499C4E65.3050609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-18 19:07, Patrick McHardy wrote:
>
> The alternative is to keep the text at the old options and have
> them select a new hidden one. After two releases we move the
> text over and kill the old ones.
>
> But we really should do something about the constant kconfig
> annoyance caused by these renames, let alone people who really
> drop an option by accident and start bug hunting.

Here, code speaks:

parent 5626248049fb71d3703e20268e2043df3fd78f46 (v2.6.29-rc4-29-g5626248)
commit 5eebd6df9f3304f74b611fe47bab50fd3a1c668b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Feb 19 01:42:57 2009 +0100

netfilter: xtables: add backward-compat options

Concern has been expressed about the changing Kconfig options.
Provide the old options that forward-select.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/Kconfig |   18 ++++++++++++++++++
 net/ipv6/netfilter/Kconfig |   18 ++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 40ad41f..f8d6180 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -92,6 +92,15 @@ config IP_NF_MATCH_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_MATCH_TTL
+	tristate '"ttl" match support'
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_MATCH_HL
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	COFNIG_NETFILTER_XT_MATCH_HL.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
@@ -313,6 +322,15 @@ config IP_NF_TARGET_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_TARGET_TTL
+	tristate '"TTL" target support'
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_TARGET_HL
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	COFNIG_NETFILTER_XT_TARGET_HL.
+
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4a8d7ec..625353a 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -94,6 +94,15 @@ config IP6_NF_MATCH_OPTS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_HL
+	tristate '"hl" hoplimit match support'
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_MATCH_HL
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	COFNIG_NETFILTER_XT_MATCH_HL.
+
 config IP6_NF_MATCH_IPV6HEADER
 	tristate '"ipv6header" IPv6 Extension Headers Match'
 	default m if NETFILTER_ADVANCED=n
@@ -121,6 +130,15 @@ config IP6_NF_MATCH_RT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The targets
+config IP6_NF_TARGET_HL
+	tristate '"HL" hoplimit target support'
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_TARGET_HL
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	COFNIG_NETFILTER_XT_TARGET_HL.
+
 config IP6_NF_TARGET_LOG
 	tristate "LOG target support"
 	default m if NETFILTER_ADVANCED=n
-- 
# Created with git-export-patch
