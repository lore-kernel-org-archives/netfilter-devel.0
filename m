From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Tue, 22 Mar 2011 14:42:24 -0700 (PDT)
Message-ID: <20110322.144224.183070503.davem@davemloft.net>
References: <1300747379.2837.23.camel@edumazet-laptop>
	<20110321.165829.28821319.davem@davemloft.net>
	<20110322212639.GA16534@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: eric.dumazet@gmail.com, netfilter-devel@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53659
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344Ab1CVVlp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:41:45 -0400
In-Reply-To: <20110322212639.GA16534@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Tue, 22 Mar 2011 22:26:39 +0100

> David Miller <davem@davemloft.net> wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Mon, 21 Mar 2011 23:42:59 +0100
>> 
>> > Ah sorry, I missed the "static const". Maybe I should just sleep now ;)
>> 
>> Well, I would really prefer if ip6_route_output() and friends mark
>> their 'sk' argument as 'const'.
>> 
>> Otherwise someone is going to read this code and be really concerned
>> that "sk" really might be modified in some way by this code path,
>> thus making parallel access to this static const 'sk' illegal.
> 
> good point.
> Its just a two-line change, so I guess its okay if I make this
> change in this patch, too.
> 
> If you object and think it should be a new patch, please let me
> know.

Please make the ipv6 route interface change seperate, thanks.
