From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iproute2: use automake
Date: Tue, 16 Nov 2010 11:09:06 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011161108330.25859@obet.zrqbmnf.qr>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de> <20101115142600.66a7e3c3@nehalam> <alpine.LNX.2.01.1011152327430.3784@obet.zrqbmnf.qr> <20101115.175928.104078108.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: shemminger@vyatta.com, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52220 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0KPKJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:09:08 -0500
In-Reply-To: <20101115.175928.104078108.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-11-16 02:59, David Miller wrote:
>
>> Not using something standardized is an affront to distributors,
>> and the build instructions just a sore for the eye:
>
>Making the build take 10 times longer is more of an affront
>than what you accuse iproute2 of doing.
>
>Please do not do this, I absolutely hate working on source
>trees that use this crap!
>
If you like cmake or another build system better, I'd have no problem 
with that.
