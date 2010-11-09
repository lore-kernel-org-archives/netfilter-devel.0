From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 09 Nov 2010 18:39:18 +0100
Message-ID: <4CD98746.4050100@pandora.be>
References: <20101107152636.56f62235@caresse> <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr> <4CD959D6.1090705@trash.net> <20101109161047.GB25549@sd-11162.dedibox.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:42917 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0KIRjX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:39:23 -0500
In-Reply-To: <20101109161047.GB25549@sd-11162.dedibox.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 9/11/2010 17:10, Frederic Leroy schreef:
> On Tue, Nov 09, 2010 at 03:25:26PM +0100, Patrick McHardy wrote:
>> Am 07.11.2010 16:18, schrieb Jan Engelhardt:
>>> On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
>> Actually we already register for NFPROTO_UNSPEC, so simply
>> adding a userspace extension should do the job.
> Not really, the mangle table for arp seems to be inexistnet.
> And hacking and using the filter table  I got arptables complaining about
> chain INPUT missing although the command line with -A OUTPUT.
>
> It seems there need a big work on arptables userspace side.
>
I'm not sure why you think this requires a lot of work on the userspace
side. If you get stuck, feel free to post what you already have and I'll
have a look at it. As it seems the kernel functionality is already
there, I'd be glad to submit your userspace patch.

Best regards,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

