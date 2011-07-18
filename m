From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: add per-namespace logging to
 nfnetlink_log.c
Date: Mon, 18 Jul 2011 22:28:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com> <20110718191956.GA2489@p183.telecom.by> <87hb6je5nh.fsf@sapphire.mobileactivedefense.com> <20110718.124638.30010338187296272.davem@davemloft.net>
 <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, adobriyan@gmail.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34235 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1GRU21 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:28:27 -0400
In-Reply-To: <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-07-18 22:17, Rainer Weikusat wrote:
>David Miller <davem@davemloft.net> writes:
>>
>>> [rw@sapphire]~/work/linux-2-6/net/netfilter $find -name '*.c' | xargs grep '^#ifdef' | wc -l
>>> 239
>>
>> You've shown nothing.  Showing exceptions does not prove that the
>> general effort has been to keep ifdef crap out of *.c files.
>
>I've 'shown' that the networking code contains a fair amount of
>#ifdefs in .c files. Consequently, 'we did it without' is wrong. At
>best, 'we would like to do without in future' seems justified.

Your count of ifdefs is just telling that we use ifdef, not how we
use it.

There is a difference between #ifdefs sprinkled inside a function,
and #ifdefs around functions or larger groups where possible,
feasible and optically preferable (cf. security.h, xt_TEE.c).
