From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: Fix switch statement warnings with recent
 gcc.
Date: Wed, 08 Apr 2015 15:21:04 -0400 (EDT)
Message-ID: <20150408.152104.2035331217337764143.davem@davemloft.net>
References: <20150407.230542.359453916233129441.davem@davemloft.net>
	<20150408164614.GA22526@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40645 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbDHTVG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 15:21:06 -0400
In-Reply-To: <20150408164614.GA22526@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 8 Apr 2015 18:46:14 +0200

> On Tue, Apr 07, 2015 at 11:05:42PM -0400, David Miller wrote:
>> 
>> More recent GCC warns about two kinds of switch statement uses:
>> 
>> 1) Switching on an enumeration, but not having an explicit case
>>    statement for all members of the enumeration.  To show the
>>    compiler this is intentional, we simply add a default case
>>    with nothing more than a break statement.
>> 
>> 2) Switching on a boolean value.  I think this warning is dumb
>>    but nevertheless you get it wholesale with -Wswitch.
>> 
>> This patch cures all such warnings in netfilter.
>> 
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Ok I tossed this into net-next, thanks for reviewing.
