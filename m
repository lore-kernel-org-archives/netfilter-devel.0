From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 07:54:49 +0200
Message-ID: <4816B829.9080206@trash.net>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain> <481589D2.2050901@snapgear.com> <4815D842.8010303@trash.net> <4816A89B.7050300@snapgear.com> <4816B5A1.8050906@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Russell King <rmk@arm.linux.org.uk>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41739 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYD2Fys (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:54:48 -0400
In-Reply-To: <4816B5A1.8050906@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Philip Craig wrote:
>> Patrick McHardy wrote:
>>> Thanks for tracking this down, I didn't realize we had holes
>>> in struct nf_conntrack_tuple on ARM. There are two ways to
>>> fix this, one is two remove the padding, the other one is to
>>> clear the padding as you did. We could join all the tuple
>>> structs to avoid padding, but unfortunately that probably
>>> won't help because the port structs are also padded. Maybe
>>> attribute(packed) on the individual port structs within the
>>> union will work, I'm not sure about that.
>> I prefer to remove the padding so that we don't change how other
>> architectures work.  The attached patch does this.  I'm not sure
>> if this has any performance penalties on ARM. 
> 
> I just noticed that IP_CT_TUPLE_U_BLANK() memsets the addresses too
> now (the comment before it is outdated).  There are only two lots
> of 2 bytes it doesn't memset, which hardly seems worth it, and it
> may even be slower on some architectures.  So the simpler fix is
> to memset the whole structure.
> 
> It still might be nice to eliminate the padding on ARM to save
> memory though: it adds 8 bytes per tuple.
> 
> Thoughts?


I think the memset-solution is preferrable, using byte-wise
accesses to the entire tuple would really suck.


