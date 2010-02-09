From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter/iptables and network interface names
Date: Tue, 9 Feb 2010 12:44:23 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002091244050.12343@obet.zrqbmnf.qr>
References: <4B6AC467.7020209@redhat.com> <alpine.LSU.2.01.1002041528300.13435@obet.zrqbmnf.qr> <4B6ADA3A.7040201@trash.net> <alpine.LSU.2.01.1002041542150.13435@obet.zrqbmnf.qr> <4B6ADFFB.4050407@trash.net> <alpine.LSU.2.01.1002041743360.21982@obet.zrqbmnf.qr>
 <4B6AFAA1.5080703@trash.net> <alpine.LSU.2.01.1002041944120.30159@obet.zrqbmnf.qr> <4B6BF294.3020501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Woerner <twoerner@redhat.com>, netdev@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35773 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0BILoZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:44:25 -0500
In-Reply-To: <4B6BF294.3020501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-02-05 11:27, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Thursday 2010-02-04 17:49, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>>> The kernel also forbids ".".
>> 19:44 borg:/home/jengelh # ip tunnel add .3 mode sit local 1.2.3.6 remote
>> 5.6.7.7
>> 19:44 borg:/home/jengelh # ip a
>> 17: .3: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN 
>>     link/sit 1.2.3.6 peer 5.6.7.7
>
>OK you're right, but this seems to be an oversight. The names
>are checked during rename, but not on device registration.
>

So, what about the patch(es)? :-)
