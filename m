From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistent address treatment.
Date: Sat, 8 Jan 2011 13:32:13 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101081321420.9010@obet.zrqbmnf.qr>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net> <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr> <4D1730B7.3090805@treenet.co.nz>
 <4D17B6FB.5020807@plouf.fr.eu.org> <alpine.LNX.2.01.1012262309540.5681@obet.zrqbmnf.qr> <4D27E60D.6080205@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Stephen Clark <sclark46@earthlink.net>,
	netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42316 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1AHMcO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 07:32:14 -0500
In-Reply-To: <4D27E60D.6080205@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2011-01-08 05:20, Amos Jeffries wrote:
>>>>
>>>> FWIW: we (Squid project) use the syntax "ip[-ip][/mask]".
>>>
>>> I'm being curious : what is the meaning of "ip-ip/mask" when both the
>>> range and mask are present ?
>>
>> Sounds like
>>
The scheme (a-b)/msk:
>>
>> 192.168.0.64-192.168.191/255.255.255.253
>> <=>
>> 192.168.0.{64 65 68 69 72 73 76 77 77...}
>>
>> Well, it's probably of use... to someone.
Squid's a-lastof(b/plen):
> For yourselves I was thinking limit it to CIDR masks.
> As in:
> 192.168.1.0-192.168.10.0/23  ==> 192.168.1.0-192.168.11.255

If, for any combination of a,b,plen in your a-lastof(b/plen), you get a
contiuguous range [and that does seem to be the case], it is
redundant to store plen, since that can just be expressed by an
appropriate contiguous range a-c.

That said, a-b/plen does look confusing, because one might
also assume (a-b)/plen:

192.168.1.0-192.168.10.0/23 => 192.168.0.0-192.168.11.255
(Because 192.168.1.0/23's top is 192.168.0.0)
