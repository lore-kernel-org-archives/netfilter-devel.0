From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 5 Oct 2008 16:14:40 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051607030.32566@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr> <48E8D493.5@trash.net> <alpine.LNX.1.10.0810051054460.21891@fbirervta.pbzchgretzou.qr>
 <48E8D957.3000803@trash.net> <alpine.LNX.1.10.0810051216090.21891@fbirervta.pbzchgretzou.qr> <48E8EAA0.8010606@trash.net> <alpine.LNX.1.10.0810051226410.21891@fbirervta.pbzchgretzou.qr> <48E8ECF2.7050008@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48479 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYJEUOm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:14:42 -0400
In-Reply-To: <48E8ECF2.7050008@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 12:36, Patrick McHardy wrote:
>
>> > > Requesting verdict from you. :)
>> > > Make it const so that extensions don't tamper with it?
>> > Preferrably, yes.
>> Perfect.
> Great.

To save you from a patch bomb, I figured it would be best to give
a git url. Please *fetch* from

	git://dev.medozas.de/linux master

graph it in gitk, and then figure out how to proceed :p

`cherry-pick` (to add SOBs) or `checkout <something> && merge --no-ff 
mdz/master` seem viable.

(BTW, there is an ugly bug in stgit 0.14.3 during `stg uncommit` which
screws up the Date: line. It copies the UTC time *plus* timezone
into its cache, effectively moving commits forward/backward in time.
Like 14:00 -0400 (18:00 +0000) gets uncommited as 18:00 -0400.
Try avoid using uncommit for now.)
