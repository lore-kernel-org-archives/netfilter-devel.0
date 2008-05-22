From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Thu, 22 May 2008 16:21:15 +0200
Message-ID: <4835815B.5060505@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net> <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr> <4833EEC7.2080503@trash.net> <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr> <48345095.8000601@trash.net> <alpine.LNX.1.10.0805211843260.15136@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38755 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYEVOVQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:21:16 -0400
In-Reply-To: <alpine.LNX.1.10.0805211843260.15136@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-05-21 18:40, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> On Wednesday 2008-05-21 11:43, Patrick McHardy wrote:
>>>>> well would you accept a script that filters the repository
>>>>> to put proper committer/author in place?
>>>> Mhh .. I guess I would if its soon, before too many people
>>>> have started using that tree.
>>>>
>>> http://dev.medozas.de/iptables-rw.tar.bz2
>> This gives me a 404 error.
> 
> Whoops, needs /files/ in the middle:
> 	http://dev.medozas.de/files/iptables-rw.tar.bz2

Thanks. It does a lot of rewrites, but then fails with:

../runme3: line 7: /tmp/ipt-log/iptables.aux/add-tags: No such file or 
directory

That file seems to be missing from the archive.
