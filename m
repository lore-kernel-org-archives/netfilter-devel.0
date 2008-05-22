From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Thu, 22 May 2008 16:47:33 +0200
Message-ID: <48358785.6010003@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net> <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr> <4833EEC7.2080503@trash.net> <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr> <48345095.8000601@trash.net> <alpine.LNX.1.10.0805211843260.15136@fbirervta.pbzchgretzou.qr> <4835815B.5060505@trash.net> <alpine.LNX.1.10.0805221639380.9332@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39320 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYEVOre (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:47:34 -0400
In-Reply-To: <alpine.LNX.1.10.0805221639380.9332@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-05-22 16:21, Patrick McHardy wrote:
>>> Whoops, needs /files/ in the middle:
>>>  http://dev.medozas.de/files/iptables-rw.tar.bz2
>> Thanks. It does a lot of rewrites, but then fails with:
>>
>> ../runme3: line 7: /tmp/ipt-log/iptables.aux/add-tags: No such file or
>> directory
>>
>> That file seems to be missing from the archive.
>>
> I added it now. (I used selective wildcards because there are other rewrite
> scripts in the original directory, like do_rewrite2 which is an interactive
> rewrite.)

One thing I forgot - are you OK with putting your scripts
and files somewhere public on the netfilter servers?
I would like people to be able to recreate identical
SVN imports themselves for verification.

