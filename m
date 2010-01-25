From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/09]: netfilter: xtables: add CT target
Date: Mon, 25 Jan 2010 18:33:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001251832200.17690@obet.zrqbmnf.qr>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <20100125153740.15305.76374.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001251745350.20906@obet.zrqbmnf.qr> <4B5DCB63.7020704@trash.net> <alpine.LSU.2.01.1001251753170.20906@obet.zrqbmnf.qr>
 <4B5DCD6E.4070103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51131 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0AYRdE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:33:04 -0500
In-Reply-To: <4B5DCD6E.4070103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-01-25 17:57, Patrick McHardy wrote:
>
>Does anyone have an opinion on supporting specifying helper parameters?
>I'm considering adding something like 5 generically usable u32s and have
>helpers initialize parameters like FTP "loose" or SIP "direct_media"
>based on those.
>
Is there a case where someone wants to loosen just half of their
FTP connections? Well yes maybe there is, but anyone ever request
it?
