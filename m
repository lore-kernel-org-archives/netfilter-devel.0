From: Patrick McHardy <kaber@trash.net>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 09 Nov 2010 17:48:51 +0100
Message-ID: <4CD97B73.2040402@trash.net>
References: <20101107152636.56f62235@caresse> <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr> <4CD959D6.1090705@trash.net> <20101109161047.GB25549@sd-11162.dedibox.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59758 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0KIQsz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:48:55 -0500
In-Reply-To: <20101109161047.GB25549@sd-11162.dedibox.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.11.2010 17:10, schrieb Frederic Leroy:
> On Tue, Nov 09, 2010 at 03:25:26PM +0100, Patrick McHardy wrote:
>> Am 07.11.2010 16:18, schrieb Jan Engelhardt:
>>> On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
>> Actually we already register for NFPROTO_UNSPEC, so simply
>> adding a userspace extension should do the job.
> 
> Not really, the mangle table for arp seems to be inexistnet.
> And hacking and using the filter table  I got arptables complaining about
> chain INPUT missing although the command line with -A OUTPUT.
> 
> It seems there need a big work on arptables userspace side.

Actually there is no technical reason for limiting the CLASSIFY
target to the mangle table. You can simply remove this.

