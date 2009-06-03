From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Wed, 03 Jun 2009 21:03:45 +1000
Message-ID: <4A265891.4050201@shikadi.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2858 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZFCLDv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:03:51 -0400
In-Reply-To: <4A26418C.5090707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Thanks for the explanation!  So - to get it straight in my mind - the
>> checkentry function will be called multiple times while the trigger
>> exists,
>> but is the destroy function also called multiple times?  Or is checkentry
>> called whenever tables are created, but destroy only ever called once
>> when the
>> table is removed for the last time?
> 
> They will always be called an equal amount of times - each one
> once per target instance.

Great, thanks for the info (thanks Jan too!)  I'm working on a patch so I'll
post it when I think I've solved the issue correctly.

Cheers,
Adam.
