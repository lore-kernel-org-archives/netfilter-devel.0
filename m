From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [rfc] using xor in mark targets
Date: Tue, 4 Dec 2007 09:54:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712040951310.11746@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
 <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
 <47541C45.3090804@trash.net> <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr>
 <47550BC3.9080404@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57429 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLDIyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:54:54 -0500
In-Reply-To: <47550BC3.9080404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 4 2007 09:11, Patrick McHardy wrote:
>> But it concerns CONNMARK. See this patch, which introduces --set-xmark.
>> 
>> Assumes a xt_CONNMARK.ko v2 that does:
>> --set:
>> 	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;
>> --save:
>> 	ctmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
>> --restore:
>>  nfmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
>> 
>> As you can see, it would introduce a new option "--set-xmark", and
>> that name does not sound as appalling as --set-mark, so I was looking
>> for a better one ;-)
>
> It would be easier for me if you'd explain what every option does,
> especially why you need this set-xmark option.
>
--set-xmark would use the (yet to be written) xt_CONNMARK v2 semantic,
while --set-mark would do the compatible v0/v1 one.

What xt_CONNMARK does at the moment (.revision=0/1):
	ctmark = (ctmark & info->mask) | info->mark;

Essential operation of xt_CONNMARK (.revision=2):
>> 	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;

For CONNMARK, this allows to and/or/xor bits in one go rather than just
selectively and/or, as it is now.
