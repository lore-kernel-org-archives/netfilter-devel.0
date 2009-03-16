From: Patrick McHardy <kaber@trash.net>
Subject: Re: size calculation wasted cpu time
Date: Mon, 16 Mar 2009 15:14:12 +0100
Message-ID: <49BE5EB4.8050504@trash.net>
References: <152544048.20090316160216@yandex.ru> <49BE5CD5.5000808@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46040 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZCPOOP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:14:15 -0400
In-Reply-To: <49BE5CD5.5000808@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Kuzin Andrey wrote:
>> In /net/netfilter/nfnetlink_queue.c every call of nfqnl_build_packet_message()
>> make series of call nla_total_size() for 'size' calculations.
>> I think 'size' is constant value for kernel build and may be define static
>> variable for this ?
> 
> We can calculate this during the module initialization, brave to cook a
> patch for it?

The compiler should realize its constant and perform the calculation
at calculation time.
