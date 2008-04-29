From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 15:44:01 +1000
Message-ID: <4816B5A1.8050906@snapgear.com>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain> <481589D2.2050901@snapgear.com> <4815D842.8010303@trash.net> <4816A89B.7050300@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Russell King <rmk@arm.linux.org.uk>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:40257 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbYD2FoE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:44:04 -0400
In-Reply-To: <4816A89B.7050300@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Patrick McHardy wrote:
>> Thanks for tracking this down, I didn't realize we had holes
>> in struct nf_conntrack_tuple on ARM. There are two ways to
>> fix this, one is two remove the padding, the other one is to
>> clear the padding as you did. We could join all the tuple
>> structs to avoid padding, but unfortunately that probably
>> won't help because the port structs are also padded. Maybe
>> attribute(packed) on the individual port structs within the
>> union will work, I'm not sure about that.
> 
> I prefer to remove the padding so that we don't change how other
> architectures work.  The attached patch does this.  I'm not sure
> if this has any performance penalties on ARM. 

I just noticed that IP_CT_TUPLE_U_BLANK() memsets the addresses too
now (the comment before it is outdated).  There are only two lots
of 2 bytes it doesn't memset, which hardly seems worth it, and it
may even be slower on some architectures.  So the simpler fix is
to memset the whole structure.

It still might be nice to eliminate the padding on ARM to save
memory though: it adds 8 bytes per tuple.

Thoughts?

