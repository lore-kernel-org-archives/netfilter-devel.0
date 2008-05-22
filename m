From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Thu, 22 May 2008 16:40:27 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805221639380.9332@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net>
 <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr> <4833EEC7.2080503@trash.net> <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr> <48345095.8000601@trash.net> <alpine.LNX.1.10.0805211843260.15136@fbirervta.pbzchgretzou.qr>
 <4835815B.5060505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59475 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYEVOk3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:40:29 -0400
In-Reply-To: <4835815B.5060505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-22 16:21, Patrick McHardy wrote:
>> 
>> Whoops, needs /files/ in the middle:
>>  http://dev.medozas.de/files/iptables-rw.tar.bz2
>
> Thanks. It does a lot of rewrites, but then fails with:
>
> ../runme3: line 7: /tmp/ipt-log/iptables.aux/add-tags: No such file or
> directory
>
> That file seems to be missing from the archive.
>
I added it now. (I used selective wildcards because there are other rewrite
scripts in the original directory, like do_rewrite2 which is an interactive
rewrite.)
