From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] using xor in mark targets
Date: Tue, 04 Dec 2007 11:54:05 +0100
Message-ID: <475531CD.5070604@trash.net>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr> <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr> <47541C45.3090804@trash.net> <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr> <47550BC3.9080404@trash.net> <Pine.LNX.4.64.0712040951310.11746@fbirervta.pbzchgretzou.qr> <47551B3A.7090100@trash.net> <Pine.LNX.4.64.0712041145420.10859@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXLDKyI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:54:08 -0500
In-Reply-To: <Pine.LNX.4.64.0712041145420.10859@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 4 2007 10:17, Patrick McHardy wrote:
>> I still don't see why you can't keep --set-mark and add new options
>> --and-mark, --xor-mark, ...
>>
> 
> 	-j CONNMARK --xor-mark 0x01
> 	-j CONNMARK --and-mark 0xffffffdf
> 	-j CONNMARK --or-mark 0x400
> 
> I would prefer the single invocation:
> 
> 	-j CONNMARK --set-xmark 0x401/0xfffffbdf
> 

I wouldn't, thats way less readable :) Feel free to add a xmark
(maybe --raw-mark?) option, but the other ones should still exist
and --set-mark should behave as currently.

