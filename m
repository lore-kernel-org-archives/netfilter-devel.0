From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: xtables2: make ip_tables reentrant
Date: Wed, 21 Apr 2010 14:47:17 +0200
Message-ID: <4BCEF3D5.9070303@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-3-git-send-email-jengelh@medozas.de> <4BCC4B19.7040805@trash.net> <alpine.LSU.2.01.1004191451100.9177@obet.zrqbmnf.qr> <4BCC636A.1080401@trash.net> <4BCDA9BC.50201@trash.net> <alpine.LSU.2.01.1004201958220.5154@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40094 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0DUMrS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:47:18 -0400
In-Reply-To: <alpine.LSU.2.01.1004201958220.5154@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> netfilter: x_tables: move sleeping allocation outside BH-disabled region
> 
> The jumpstack allocation needs to be moved out of the critical region.
> Corrects this notice:
> 
> BUG: sleeping function called from invalid context at mm/slub.c:1705
> [  428.295762] in_atomic(): 1, irqs_disabled(): 0, pid: 9111, name: iptables
> [  428.295771] Pid: 9111, comm: iptables Not tainted 2.6.34-rc1 #2
> [  428.295776] Call Trace:
> [  428.295791]  [<c012138e>] __might_sleep+0xe5/0xed
> [  428.295801]  [<c019e8ca>] __kmalloc+0x92/0xfc
> [  428.295825]  [<f865b3bb>] ? xt_jumpstack_alloc+0x36/0xff [x_tables]

Applied, thanks Jan.
