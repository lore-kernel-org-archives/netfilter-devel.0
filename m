From: Patrick McHardy <kaber@trash.net>
Subject: Re: Get rid of refrences to no longer existant Fast NAT.
Date: Mon, 07 Jul 2008 14:12:32 +0200
Message-ID: <48720830.3060106@trash.net>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>	<20080707120516.4975.88905.sendpatchset@localhost.localdomain> <20080707.051002.114744444.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYGGMMf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:12:35 -0400
In-Reply-To: <20080707.051002.114744444.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon,  7 Jul 2008 14:05:17 +0200 (MEST)
> 
>> Get rid of refrences to no longer existant Fast NAT.
>>
>> IP_ROUTE_NAT support was removed in August of 2004, but references to Fast
>> NAT were left in a couple of config options.
>>
>> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
>> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> I guess this is patch 02/13, right? :-)


Right, sorry. My scripts are not fully used to the lower case
subsystem yet :)


