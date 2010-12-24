From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistent address treatment.
Date: Fri, 24 Dec 2010 09:46:03 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012240944000.13607@obet.zrqbmnf.qr>
References: <4D1358C0.4060704@earthlink.net> <alpine.LNX.2.01.1012232253090.28085@obet.zrqbmnf.qr> <4D13D0AC.3030106@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pascal.mail@plouf.fr.eu.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48341 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0LXIqF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:46:05 -0500
In-Reply-To: <4D13D0AC.3030106@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-12-23 23:43, Stephen Clark wrote:
> On 12/23/2010 04:53 PM, Jan Engelhardt wrote:
>> On Thursday 2010-12-23 15:12, Stephen Clark wrote:
>>
>>> Why the inconsistency in the way addresses are treated. I can use -d
>>> 2.2.2.2/32
>>> but not --to-source 205.201.149.214/32
>>>
>>> iptables -t nat -A POSTROUTING -o eth1 -s 10.0.128.0/17 -d 2.2.2.2/32 -j SNAT
>>> --to-source 205.201.149.214/32
>>>     
>> What inconsistency?
>>   
> If you try the above command you get a complaint about
>
> --to-source 205.201.149.214/32
> you have to use
> --to-source 205.201.149.214

Ah "that" sort of "inconsensitency". No, that is not an inconsistency.
-d takes an addr[/mask] or a addr[/prefixlen] or a list thereof, while
-m iprange and DNAT's --to-source take addr[-addr].

Each is subtly different. And documented.
