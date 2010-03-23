From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 14:45:21 +0100
Message-ID: <4BA8C5F1.9060301@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr> <4BA7A1C8.8050402@trash.net> <alpine.LSU.2.01.1003221831070.2821@obet.zrqbmnf.qr> <4BA8AE4A.5090805@trash.net> <alpine.LSU.2.01.1003231327070.12342@obet.zrqbmnf.qr> <4BA8B641.5070700@trash.net> <alpine.LSU.2.01.1003231341130.12922@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58151 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0CWNpX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:45:23 -0400
In-Reply-To: <alpine.LSU.2.01.1003231341130.12922@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-03-23 13:38, Patrick McHardy wrote:
>>> 1. sending the clone through a tunnel - admin can't do much about MTU getting
>>> smaller here.
>> It either happens locally (before encapsulation) or for the
>> encapsulated packets, which isn't a problem.
> 
> That is what I am referring to. Suppose -j TEE is using
> a --gateway address whose route resolves to
> 
> default dev ipip0 [mtu 1480]
> 
> (There is no encapsulation or MTU decrease on the original path.) The
> admin then has two possibilities, to either drop the clone, or coerce
> the source in sending appropriately-sized packets.

True. He might also hack ipip to allow fragmentation of encapsulated
packets independant of the IP_DF flag of the original packet.

But in my opinion he should make sure not to send anything to the
source for duplicated packets.

BTW, I just noticed TEE is still using init_net. This should be
fixed.

