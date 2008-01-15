From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 19/38]: Update feature-removal-schedule.txt
Date: Tue, 15 Jan 2008 17:54:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801151749451.30034@fbirervta.pbzchgretzou.qr>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
 <20080115061933.3184.26013.sendpatchset@localhost.localdomain>
 <200801151615.m0FGFnL3010374@usagi.ingate.se> <478CE21A.80306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jones Desougi <jones@ingate.com>, davem@davemloft.net,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57074 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYAOQyv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:54:51 -0500
In-Reply-To: <478CE21A.80306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 15 2008 17:40, Patrick McHardy wrote:
> Jones Desougi wrote:
>> > With all the newly introduced features, there is a lot to remove
>> > later on after a compatibility grace period of 2 years.
>> ...
>> > +When:	January 2009 or Linux 2.7.0, whichever comes first
>> 
>> January 2009 is one year into the future though, not two.

Integer overflow on my behalf :p

> Yes, I noticed this myself. We can extend it if it seems to early
> at that time. But it can't hurt to announce a shorter timeframe :)

If the iptables patches get applied now (and a new version be
released soon), an implicit 2 months extra time can be gained. That
would also empty my patch queue there.
