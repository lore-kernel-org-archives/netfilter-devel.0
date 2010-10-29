From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.10
Date: Fri, 29 Oct 2010 20:01:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010292000070.9621@obet.zrqbmnf.qr>
References: <4CCAEB8A.5090504@trash.net> <alpine.LNX.2.01.1010291953580.9183@obet.zrqbmnf.qr> <4CCB0B34.6030108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50750 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0J2SBm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:01:42 -0400
In-Reply-To: <4CCB0B34.6030108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-10-29 19:58, Patrick McHardy wrote:
>>>
>>> Version 1.4.10 can be obtained from:
>>>
>>> http://www.netfilter.org/projects/iptables/downloads.html
>>> ftp://ftp.netfilter.org/pub/iptables/
>>> git://git.netfilter.org/iptables.git
>> 
>> The v1.4.10 tag seems to not have made it onto the server. :^)
>
>It should be there:
>
>$ hostname
>vishnu.netfilter.org
>$ git tag -l|grep 1.4.10
>v1.4.10

Ah. git does not fetch tags if they are not reachable from a
branch head. (master is still at v1.4.10~1.)
