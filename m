From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/31: netfilter update
Date: Thu, 11 Jun 2009 16:50:41 -0700 (PDT)
Message-ID: <20090611.165041.201036582.davem@davemloft.net>
References: <20090611.161910.109357779.davem@davemloft.net>
	<20090611.164047.74924409.davem@davemloft.net>
	<4A31978A.3040300@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44506
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147AbZFKXuj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:50:39 -0400
In-Reply-To: <4A31978A.3040300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 12 Jun 2009 01:47:22 +0200

> David Miller wrote:
>> From: David Miller <davem@davemloft.net>
>> Date: Thu, 11 Jun 2009 16:19:10 -0700 (PDT)
>> Nevermind, still broken:
>>
>> net/ipv4/netfilter/ip_tables.c: In function 'ipt_do_table':
>> net/ipv4/netfilter/ip_tables.c:421: error: 'comefrom' undeclared (first use in this function)
>> net/ipv4/netfilter/ip_tables.c:421: error: (Each undeclared identifier is reported only once
>> net/ipv4/netfilter/ip_tables.c:421: error: for each function it appears in.)
>>
>> You're not testing what you're sending to me.
>>   
> 
> Appologies again, I didn't test CONFIG_NETFILTER_DEBUG=y.
> I'll fix it up and do a few more compile tests myself.

Thank you.
