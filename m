From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables branch management
Date: Thu, 08 Sep 2011 12:05:15 +0200
Message-ID: <4E68935B.3000401@trash.net>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr> <20110905175425.GC32733@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46152 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1IHKF0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:05:26 -0400
In-Reply-To: <20110905175425.GC32733@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 05.09.2011 19:54, schrieb Pablo Neira Ayuso:
> Hi Jan,
> 
> On Fri, Sep 02, 2011 at 04:20:13PM +0200, Jan Engelhardt wrote:
>> Hei
>>
>> I would like to propose a "stable" branch that would be rooted 
>> in the most recent tag and only receive fixes. Furtheremore, 
>> the branch is merged time and again into master, so that the 
>> fix is available in both without cherry-pick. 1.4.12.x releases be made 
>> from stable, and 1.4.y from master.
>> How about it?
> 
> Hm, I remember that we had this discussion before.
> 
> I think it's probably too much overhead for it, looking at how other
> similar net-tools are maintained, the amount of contributions that
> er receive and amount of changes that get into every version.

I also think this is probably overkill, what's wrong with simply
creating stable branches on demand if there are important fixes
that require a new release?
