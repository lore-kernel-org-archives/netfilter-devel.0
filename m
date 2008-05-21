From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Wed, 21 May 2008 18:40:53 +0200
Message-ID: <48345095.8000601@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net> <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr> <4833EEC7.2080503@trash.net> <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45970 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYEUQky (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 12:40:54 -0400
In-Reply-To: <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-05-21 11:43, Patrick McHardy wrote:
>>> well would you accept a script that filters the repository
>>> to put proper committer/author in place?
>> Mhh .. I guess I would if its soon, before too many people
>> have started using that tree.
>>
> 
> http://dev.medozas.de/iptables-rw.tar.bz2

This gives me a 404 error.

> cd into the working directory, run `git status` (really necessary,
> can't be automated in the script for some stupid reason),
> and then run ../path/to/runme3.
> It also fixes the tags; be sure to remove the svn_t_ pseudobranchtagswhatever
> afterwards.

I'll try, thanks.


