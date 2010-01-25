From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/09]: netfilter: xtables: add CT target
Date: Mon, 25 Jan 2010 18:36:55 +0100
Message-ID: <4B5DD6B7.9040003@trash.net>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <20100125153740.15305.76374.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001251745350.20906@obet.zrqbmnf.qr> <4B5DCB63.7020704@trash.net> <alpine.LSU.2.01.1001251753170.20906@obet.zrqbmnf.qr> <4B5DCD6E.4070103@trash.net> <alpine.LSU.2.01.1001251832200.17690@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0AYRg7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:36:59 -0500
In-Reply-To: <alpine.LSU.2.01.1001251832200.17690@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-01-25 17:57, Patrick McHardy wrote:
>> Does anyone have an opinion on supporting specifying helper parameters?
>> I'm considering adding something like 5 generically usable u32s and have
>> helpers initialize parameters like FTP "loose" or SIP "direct_media"
>> based on those.
>>
> Is there a case where someone wants to loosen just half of their
> FTP connections? Well yes maybe there is, but anyone ever request
> it?

Not FTP specifically, SIP and H.323 would be the primary use cases.
But if the infrastructure is there anyways, we might as well add
support for FTP.
