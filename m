From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 13:46:15 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003231341130.12922@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr> <4BA7A1C8.8050402@trash.net> <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr>
 <4BA8AE4A.5090805@trash.net> <alpine.LSU.2.01.1003231327070.12342@obet.zrqbmnf.qr> <4BA8B641.5070700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58549 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab0CWMqR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:46:17 -0400
In-Reply-To: <4BA8B641.5070700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-23 13:38, Patrick McHardy wrote:
>
>> 1. sending the clone through a tunnel - admin can't do much about MTU getting
>> smaller here.
>
>It either happens locally (before encapsulation) or for the
>encapsulated packets, which isn't a problem.

That is what I am referring to. Suppose -j TEE is using
a --gateway address whose route resolves to

default dev ipip0 [mtu 1480]

(There is no encapsulation or MTU decrease on the original path.) The
admin then has two possibilities, to either drop the clone, or coerce
the source in sending appropriately-sized packets.

>> 2. the PTB may take longer to reach the source due to internet
>> routing - nothing the admin can really influence either.
>
>He should make sure any messages generated in response to duplicated
>packets are not routed or dropped.
