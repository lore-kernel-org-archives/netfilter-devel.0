From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter : nfmark routing in OUTPUT, mangle, NFQUEUE
Date: Tue, 15 Jul 2008 12:26:55 +0200
Message-ID: <487C7B6F.8010802@trash.net>
References: <4875A1FC.8050705@licour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laurent Licour <laurent@licour.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbYGOK04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:26:56 -0400
In-Reply-To: <4875A1FC.8050705@licour.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laurent Licour wrote:
> 
> This patch let nfmark to be evaluated for routing decision for OUTPUT 
> packet, in mangle
> table, when process paquet in NFQUEUE
> Until now, only change (in NFQUEUE process) on fields src_addr, 
> dest_addr and tos
> could make netfilter to reevalute the routing.
> Similar code could also be applied to ipv6 code...
> 
> 
> --- linux-2.6.18.i386.ori/net/ipv4/netfilter.c  2006-09-20 
> 05:42:06.000000000 +0200
> +++ linux-2.6.18.i386/net/ipv4/netfilter.c      2008-07-07 
> 02:04:34.000000000 +0200

Please resend against the current kernel tree if you want me to
apply this. Also it appears the patch is whitespace damaged,
please make sure you'll send it in a way that doesn't corrupt
it (f.i. as attachment).


