From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: ipp2p: bittorrent commands patch
Date: Sat, 27 Feb 2010 16:00:03 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002271559510.29398@obet.zrqbmnf.qr>
References: <1202414722.20100126061604@gmail.com> <alpine.LSU.2.01.1002212207100.7948@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002240039060.11283@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Tomkowiak <bloodman@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59530 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab0B0PAE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:00:04 -0500
In-Reply-To: <alpine.LSU.2.01.1002240039060.11283@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-24 00:40, Jan Engelhardt wrote:
>On Sunday 2010-02-21 22:08, Jan Engelhardt wrote:
>>On Tuesday 2010-01-26 06:16, Tomasz Tomkowiak wrote:
>>>
>>>After testing I decide to write my patch to bittorrent
>>>GET commands from xt_ipp2p.c because old procedure is
>>>useless for modified and/or private trackers. teh new
>>>works fine but maybe someone can rewrite it to better C
>>>(yeah, im C/C++ n00b ;)
>>>btw. info_hash may be 3rd argument, passkey (private trackers)
>>>may be 1st argument (or not) etc. etc. so we need to search.
>
>Hm. This patch needs improvement. We cannot use strstr, because
>there may not be a NUL byte in the packet.

Now applied with the proper call (memmem, not strstr).
