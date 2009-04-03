From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addons 1.14 - DHCPMAC help
Date: Sat, 4 Apr 2009 01:15:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904040115020.9894@fbirervta.pbzchgretzou.qr>
References: <gr3ntd$uu6$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Moravec <jim.lkml@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56265 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339AbZDCXPT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:15:19 -0400
In-Reply-To: <gr3ntd$uu6$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-04-03 03:14, Jiri Moravec wrote:

>Another problem with DHCPMAC:
>
>-"DHCPADDDR target options:\n"
>+"DHCPMAC target options:\n"
> "  --set-mac lladdr[/mask]    Set MAC address in DHCP Client Host field\n"
> 	);
> }

Applied, thanks.
