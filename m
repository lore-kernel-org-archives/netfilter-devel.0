From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: check the length of the data before dereferencing
 it
Date: Sun, 01 Apr 2012 23:29:42 -0400 (EDT)
Message-ID: <20120401.232942.1829187970291547571.davem@davemloft.net>
References: <1333336250-4110-1-git-send-email-xiaosuo@gmail.com>
	<1333336773.2325.6531.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: xiaosuo@gmail.com, kaber@trash.net, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: eric.dumazet@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:47197 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2DBDbx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:31:53 -0400
In-Reply-To: <1333336773.2325.6531.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 02 Apr 2012 05:19:33 +0200

>> @@ -3845,6 +3845,8 @@ void tcp_parse_options(const struct sk_buff *skb, struct tcp_options_received *o
>>  			length--;
>>  			continue;
>>  		default:
>> +			if (length < 2)
>> +				return;
>>  			opsize = *ptr++;
>>  			if (opsize < 2) /* "silly options" */
>>  				return;
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Tag Eric, you're it.

You ACK'd this patch, so you get to show how this is actually able
to cause some kind of problem.

I assert that this is adding a useless test, that doesn't fix any kind
of possible crash or misbehavior.  If length == 1 at the default:, the
code will absolutely do the right thing.

Prove me wrong.
