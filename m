From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables  1.4.8
Date: Mon, 24 May 2010 07:17:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005240712390.23638@obet.zrqbmnf.qr>
References: <4BF66756.9010803@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43307 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0EXFRg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 May 2010 01:17:36 -0400
In-Reply-To: <4BF66756.9010803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On 2010-05-21 10:58:30, Patrick McHardy wrote:
>>> Files in /usr/lib/pkgconfig also contains 1.4.7.
>> 
>> Oops crap, I thought my release script would commit the version
>> change. I'll fix it up.
>
>Should be fixed now.

Woha, ugly tree history :-)
Next time, call me...

Since you did not fast-forward master (== hard-reset) anyway, the revert and
the rerevert in the tree geometry would not have been necessary.
