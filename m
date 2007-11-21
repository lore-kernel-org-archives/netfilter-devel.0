From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [FIX] Re: Make/compile error for iptables-1.4.0rc1
Date: Wed, 21 Nov 2007 12:21:21 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711211219560.32378@fbirervta.pbzchgretzou.qr>
References: <1195245146.15945.50.camel@localhost.localdomain>
 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
 <1195390182.15945.57.camel@localhost.localdomain>
 <1195395787.15945.77.camel@localhost.localdomain> <1195600242.1228.7.camel@localhost.localdomain>
 <4743E403.8090408@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jdb@comx.dk, yasuyuki@netfilter.org,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41411 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbXKULVX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:21:23 -0500
In-Reply-To: <4743E403.8090408@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 21 2007 08:53, Patrick McHardy wrote:
> Jesper Dangaard Brouer wrote:
>> The problem is that "linux/netfilter/x_tables.h" got included in SVN
>> (changeset 6920).  The fix is to delete it from SVN, so that the systems
>> "x_tables.h" has effect again.
>> 
>> Can someone with SVN write access fix this?
>> 
>>   "svn rm include/linux/netfilter/x_tables.h"
>
>
> Actually the fix is the other way around, we want to be able to
> build iptables without having kernel sources locally. So I
> guess the x_tables.h file should be resynced or something?
>
Works as-is for me with r7090, so it must be something different.
