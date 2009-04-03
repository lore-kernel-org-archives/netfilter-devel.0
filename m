From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addons 1.14 - DHCPMAC.Kconfig problem
Date: Sat, 4 Apr 2009 01:13:32 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904040111480.9894@fbirervta.pbzchgretzou.qr>
References: <gr38uq$mud$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Moravec <jim.lkml@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56262 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZDCXNg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:13:36 -0400
In-Reply-To: <gr38uq$mud$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-04-02 22:58, Jiri Moravec wrote:

>DHCPMAC.Kconfig some way lost TARGET_ ...

Nope, it's actually correct since the .c file contains  both target and 
match.

>diff -Nupr v1.14/extensions/xt_DHCPMAC.Kconfig v1.14-r1/extensions/xt_DHCPMAC.Kconfig
>--- v1.14/extensions/xt_DHCPMAC.Kconfig	2009-04-02 22:44:11.000000000 +0200
>+++ v1.14-r1/extensions/xt_DHCPMAC.Kconfig	2009-04-02 22:44:43.000000000 +0200
>@@ -1,4 +1,4 @@
>-config NETFILTER_XT_DHCPMAC
>+config NETFILTER_XT_TARGET_DHCPMAC
> 	tristate '"DHCPMAC" DHCP address matching and manipulation support'
> 	depends on NETFILTER_XTABLES
> 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
