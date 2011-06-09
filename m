From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] netfilter: ecn match fixes and IPv6 capable xtables
 port
Date: Thu, 09 Jun 2011 15:21:18 +0200
Message-ID: <4DF0C8CE.1050308@trash.net>
References: <1307621554-19108-1-git-send-email-kaber@trash.net> <alpine.LNX.2.01.1106091515160.22244@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: eric.dumazet@gmail.com, dave.taht@gmail.com,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38889 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab1FINVT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:21:19 -0400
In-Reply-To: <alpine.LNX.2.01.1106091515160.22244@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.06.2011 15:16, Jan Engelhardt wrote:
> On Thursday 2011-06-09 14:12, kaber@trash.net wrote:
> 
>> These patches contain two fixes for the ipt_ecn match and an IPv6 capable
>> xtables port. Nothing particulary exciting in the patches, if noone spots
>> any problems I'll push the first two patches to net-2.6 and the third one
>> to net-next-2.6.
>>
>> iptables patch will follow shortly.
>>
>> Patrick McHardy (3):
>>      netfilter: ipt_ecn: fix protocol check in ecn_mt_check()
>>      netfilter: ipt_ecn: fix inversion for IP header ECN match
>>      netfilter: xtables: add an IPv6 capable version of the ECN match
> 
> Do you have these in a git:// tree handy? I would like to see if the 
> automatic move detection still kicks in (since it has a 50% threshold).
> The raw non-move change could have been split otherwise.
> 

I pushed them out to

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-testing.git
