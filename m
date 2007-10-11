From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add ip6t_ aliases
Date: Thu, 11 Oct 2007 06:05:32 +0200
Message-ID: <470DA10C.9040101@trash.net>
References: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr> <20071010.163346.54951705.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46861 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXJKEFe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:05:34 -0400
In-Reply-To: <20071010.163346.54951705.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> From: Jan Engelhardt <jengelh@computergmbh.de>
> Date: Wed, 10 Oct 2007 13:44:49 +0200 (CEST)
> 
>> Hi,
>>
>>
>> I think this latecomer patch should go into 2.6.24.


Its never too late for bugfixes ..

>> ===
>>
>> Add missing ip6t_modulename aliases.
>>
>> The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
>> otherwise you will get
>>
>> 	ip6tables: No chain/target/match by that name
>>
>> when xt_<modulename> is not already loaded.
>>
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Patrick?


I got it, don't worry :)

