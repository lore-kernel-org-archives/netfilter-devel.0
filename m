From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] using xor in mark targets
Date: Tue, 04 Dec 2007 10:17:46 +0100
Message-ID: <47551B3A.7090100@trash.net>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr> <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr> <47541C45.3090804@trash.net> <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr> <47550BC3.9080404@trash.net> <Pine.LNX.4.64.0712040951310.11746@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58402 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbXLDJSN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:18:13 -0500
In-Reply-To: <Pine.LNX.4.64.0712040951310.11746@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 4 2007 09:11, Patrick McHardy wrote:
>>> But it concerns CONNMARK. See this patch, which introduces --set-xmark.
>>>
>>> Assumes a xt_CONNMARK.ko v2 that does:
>>> --set:
>>> 	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;
>>> --save:
>>> 	ctmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
>>> --restore:
>>>  nfmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
>>>
>>> As you can see, it would introduce a new option "--set-xmark", and
>>> that name does not sound as appalling as --set-mark, so I was looking
>>> for a better one ;-)
>> It would be easier for me if you'd explain what every option does,
>> especially why you need this set-xmark option.
>>
> --set-xmark would use the (yet to be written) xt_CONNMARK v2 semantic,
> while --set-mark would do the compatible v0/v1 one.
> 
> What xt_CONNMARK does at the moment (.revision=0/1):
> 	ctmark = (ctmark & info->mask) | info->mark;
> 
> Essential operation of xt_CONNMARK (.revision=2):
>>> 	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;
> 
> For CONNMARK, this allows to and/or/xor bits in one go rather than just
> selectively and/or, as it is now.


I still don't see why you can't keep --set-mark and add new options
--and-mark, --xor-mark, ...



