From: Thomas Jacob <jacob@internet24.de>
Subject: Re: iptables performance and alternatives
Date: Mon, 19 May 2008 09:51:46 +0200
Message-ID: <1211183506.15125.6.camel@enterprise.ims-firmen.de>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <200805151535.31933.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
	 <200805151557.28368.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
	 <1210857556.24732.10.camel@enterprise.ims-firmen.de>
	 <Pine.LNX.4.64.0805182253160.10481@tyr.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: hawk@diku.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:43824 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYESHvu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 03:51:50 -0400
In-Reply-To: <Pine.LNX.4.64.0805182253160.10481@tyr.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


[..
> I have fixed some of the ruleset parsing issues in libiptc. (50k chains 
> ruleset listing reduced from 5 minuts to 0.5 sec).
> 
[..]
> There are still some libiptc scalability issues left... That I promised 
> Patrick I would solve... Lets hope I'll fix them before the workshop ;-)

That's great news, hopefully those changes will end up in the mainline
releases pretty soon ;-)

> If doing a lot of rule changes, you should definitly use iptables-restore 
> or CPAN perl module IPTables::libiptc.

Incidentally, what happens during the time changes are being processed
by iptables-restore/the kernel. More specifically, do I need to
worry about packets being blocked/dropped when I would do a lot of
rule updates?

    Regards,
           Thomas

