From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] accounting on ct kill
Date: Tue, 10 Jun 2008 11:22:16 +0200
Message-ID: <484E47C8.5040607@trash.net>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>	 <1211826305.19222.8.camel@pumper.lan.luxnet.ch>	 <483B93C2.1000905@trash.net> <483C1B9D.5060705@gmx.ch>	 <483C1F54.6040505@trash.net> <1211928920.14366.12.camel@pumper.lan.luxnet.ch> <483CDA82.8090802@trash.net> <483D1975.3000601@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61165 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYFJJWS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:22:18 -0400
In-Reply-To: <483D1975.3000601@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Introduces nf_ct_kill_acct() which increments the accounting counters on
>>> conntrack kill. The new function was necessary, because there are calls
>>> to nf_ct_kill() which don't need accounting:
> [...]
>> Good points. Applied, thanks Fabian.
>>
>> I've also pulled in Dave's latest net-next-2.6.git tree and will
>> push it out now.
> 
> Thank you as well, Patrick. What about my patch 1 (status field on ct 
> destroy event)? I didn't see it in you git repository. Should I repost 
> it with a signed-of-by?

Yes, please.

