From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_stealth as separate patch against xtables-addons-1.17
Date: Thu, 24 Sep 2009 02:14:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr>
References: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, spender@grsecurity.net
To: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49013 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZIXAN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:13:59 -0400
In-Reply-To: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-09-01 19:52, Jan Rafaj wrote:
> Hello Jan,
>
> As per your request, I'm sending the
>
> - xt_ACCOUNT
> - xt_pknock
> - xt_stealth
>
> ports, now each one as a standalone patch against xtables-addons-1.17 pristine,
> so that they can each start life in their own Xt-a git branch.

I looked at xt_stealth and it looks like

 -A INPUT -j sktest
 -A sktest -m socket -j RETURN
 -A sktest -j DROP

can do just the same.
Please tell me if I am wrong anywhere.

That would mean there is no need for xt_stealth.
