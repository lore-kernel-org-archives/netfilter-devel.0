From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in  
 2.6.22.6
Date: Mon, 12 Nov 2007 08:39:14 +0100
Message-ID: <47380322.8040707@trash.net>
References: <W352381485970601194435879@nocme1bl6.telenet-ops.be>	 <4731A7A9.1050606@trash.net> <1194478191.2983.7.camel@localhost.localdomain> <4737EBF6.6000506@trash.net> <47380238.6070502@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	"bdschuym@pandora.be" <bdschuym@telenet.be>,
	ron lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39240 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXKLHjl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:39:41 -0500
In-Reply-To: <47380238.6070502@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Philip Craig wrote:
> Patrick McHardy wrote:
>> Both are fine with me. Does this patch look correct to you?
>>
>> +	if (!nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))
> 
> I think it needs more parentheses:
> 
> 	if (!(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT)))
> 


Yes, I already noticed and fixed that when trying to compile it :)
