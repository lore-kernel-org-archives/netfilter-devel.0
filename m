From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask
 patch
Date: Wed, 02 Apr 2008 11:52:51 +0200
Message-ID: <47F35773.4080700@trash.net>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com> <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr> <47F22F63.8020102@trash.net> <alpine.LNX.1.10.0804011653460.13835@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Iavor Stoev <iavor@icdsoft.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYDBJw4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:52:56 -0400
In-Reply-To: <alpine.LNX.1.10.0804011653460.13835@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-01 14:49, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>>  [NETFILTER]: xt_hashlimit: add workaround for >>32 case
>>>
>>>  Hardware surprisingly does nothing when a 32-bit right-shift is
>>>  to be done. Worse yet, compilers do not even work around it.
>>
>> Thats because the C standard states that the result is undefined.
>> Anyways, I think this patch is slightly nicer because it
>> gets rid of the double negation and the %32 == 0 special-casing
>> for IPv6.
>>
>> Do you want to add an ACKed-by?
> 
> 
> The special casing for %32==0 in the IPv6 block was not a workaround for 
> '>>32', but speed. 

I'm aware of that.

> Assuming the C code is already perfect and gets 
> transformed 1:1 into assembly without any further optimization, the cost 
> of the operation is 4 simple 'mov' instructions for %32==0, whereas 
> calling maskl() will involve a fair number of operations (at least 27 by 
> the count). [With your patch, maskl() is now 28 + a branch.]

The "optimization" results in bigger code and more branches itself.
Just removing it without fixing maskl reduces code size by over 35%:

net/netfilter/xt_hashlimit.c:
   hashlimit_ipv6_mask | -103 # 274 -> 171
  1 function changed, 103 bytes removed

Fixing maskl bloats it up again, but still a net win:

   hashlimit_ipv6_mask |   -9 # 274 -> 265, size inlines: 71 -> 148
   hashlimit_init_dst  |   +6 # 589 -> 595, size inlines: 86 -> 106
  2 functions changed, 6 bytes added, 9 bytes removed, diff: -3

Just the maskl fix results in:

net/netfilter/xt_hashlimit.c:
   hashlimit_ipv6_mask |  +95 # 274 -> 369, size inlines: 71 -> 143
   hashlimit_init_dst  |   +6 # 589 -> 595, size inlines: 86 -> 106
  2 functions changed, 101 bytes added
