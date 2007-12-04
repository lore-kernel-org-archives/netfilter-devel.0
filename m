From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] using xor in mark targets
Date: Tue, 04 Dec 2007 09:11:47 +0100
Message-ID: <47550BC3.9080404@trash.net>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr> <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr> <47541C45.3090804@trash.net> <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56564 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXLDIMM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:12:12 -0500
In-Reply-To: <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 3 2007 16:09, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> I was asking what name I should give to the option that enables
>>> "new-style" handling (origmark & ~mask ^ val):
>>>
>>>  --set-extended-mark val/mask
>>>
>>> because it is not sooo extended after all, just a different notation of what
>>> libxt_MARK takes right now.
>> Why not simply "--and-mark", "--or-mark", "--xor-mark", ...?
>>
> Alright, I just saw that MARK will remain compatible to my plans.
> But it concerns CONNMARK. See this patch, which introduces --set-xmark.
> 
> Assumes a xt_CONNMARK.ko v2 that does:
> --set:
> 	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;
> --save:
> 	ctmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
> --restore:
> 	nfmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
> 
> 
> As you can see, it would introduce a new option "--set-xmark", and
> that name does not sound as appalling as --set-mark, so I was looking
> for a better one ;-)


It would be easier for me if you'd explain what every option does,
especially why you need this set-xmark option.
