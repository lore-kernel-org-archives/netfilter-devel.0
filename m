From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Mon, 28 Apr 2008 15:59:30 +0200
Message-ID: <4815D842.8010303@trash.net>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain> <481589D2.2050901@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55749 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbYD1N7b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:59:31 -0400
In-Reply-To: <481589D2.2050901@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Patrick McHardy wrote:
>> [NETFILTER]: nf_conntrack: optimize hash_conntrack()
>>
>> Avoid calling jhash three times and hash the entire tuple in one go.
> 
> This has broken conntrack on a big endian ARM platform.  'conntrack -L'
> shows many unreplied connections all with the same addresses/ports,
> instead of just one connection.
> 
> It seems the problem is that we are now hashing the padding in struct
> nf_conntrack_tuple, which we previously didn't, and this padding isn't
> always zeroed, so the hash gives garbage.
> 
> Changing NF_CT_TUPLE_U_BLANK() to memset the whole tuple fixes it.
> 
> Adding __attribute__ ((packed)) everywhere to remove the padding
> didn't seem to fix it, but I don't understand why... maybe I did
> something wrong still.  This probably isn't a solution anyway since
> these structs are used in userspace?
> 
> I'm not sure what's special about big-endian or ARM to only affect
> this platform.  Any ideas?
> 
> I can work on this more tomorrow.


Thanks for tracking this down, I didn't realize we had holes
in struct nf_conntrack_tuple on ARM. There are two ways to
fix this, one is two remove the padding, the other one is to
clear the padding as you did. We could join all the tuple
structs to avoid padding, but unfortunately that probably
won't help because the port structs are also padded. Maybe
attribute(packed) on the individual port structs within the
union will work, I'm not sure about that.
