From: Patrick McHardy <kaber@trash.net>
Subject: Re: [FIX] Re: Make/compile error for iptables-1.4.0rc1
Date: Thu, 22 Nov 2007 11:31:04 +0100
Message-ID: <47455A68.3030309@trash.net>
References: <1195245146.15945.50.camel@localhost.localdomain>	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>	 <1195390182.15945.57.camel@localhost.localdomain>	 <1195395787.15945.77.camel@localhost.localdomain>	 <1195600242.1228.7.camel@localhost.localdomain>	 <4743E403.8090408@trash.net> <1195673456.1228.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yasuyuki@netfilter.org,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXKVKbN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:31:13 -0500
In-Reply-To: <1195673456.1228.14.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Wed, 2007-11-21 at 08:53 +0100, Patrick McHardy wrote:
>> Jesper Dangaard Brouer wrote:
>>> The problem is that "linux/netfilter/x_tables.h" got included in SVN
>>> (changeset 6920).  The fix is to delete it from SVN, so that the systems
>>> "x_tables.h" has effect again.
>>>
>>> Can someone with SVN write access fix this?
>>>
>>>   "svn rm include/linux/netfilter/x_tables.h"
>>
>> Actually the fix is the other way around, we want to be able to
>> build iptables without having kernel sources locally. So I
>> guess the x_tables.h file should be resynced or something?
> 
> If thats what you want, we need to add ip_tables.h in
> include/linux/netfilter_ipv4/.  Its the interaction between ip_tables.h
> and x_tables.h that screw things up.

Since you seem to be able to test it, would you care to send a patch? :)

> Both ip_tables.h and x_tables.h are part of the kernel source code.
> Thare might be some dependencies to specific kernel, so it might not be
> wise to include the files in SVN as we make a dependency to this
> specific kernel, and we also needs to keep them in sync.

The interface between userspace and kernel is stable, there's no
risk by including those files.
