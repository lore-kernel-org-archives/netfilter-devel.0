From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip6tables doesn't support --goto option
Date: Fri, 20 Jun 2008 20:10:49 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51073 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYFTSKu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:10:50 -0400
In-Reply-To: <1213980307.5485.5.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-06-20 18:45, Thomas Jacob wrote:

>Hello list,
>
>The ip6tables frontend in 1.4.1.1 doesn't seem to support the --goto
>option but the code for handling it seems to be in the kernel:
>
>ip6_tables.c/ip6t_do_table
>  if (table_base + v != (void *)e + e->next_offset
>     && !(e->ipv6.flags & IP6T_F_GOTO)) {
>       .....
>
>Is there some sort of technical/political reason for this, or has the
>feature simply not been implemented yet (and hence a patch would
>probably be welcome)?

I suppose it was just forgotten, as the original commit (17fc163b) only
touched iptables.c, not ip6tables.c.
