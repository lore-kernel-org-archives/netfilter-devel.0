From: Patrick McHardy <kaber@trash.net>
Subject: Re: macvlan device blocks traffic for 30 secs
Date: Thu, 25 Feb 2010 18:35:58 +0100
Message-ID: <4B86B4FE.7020408@trash.net>
References: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr> <4B86AB36.6090402@trash.net> <alpine.LSU.2.01.1002251817040.13151@obet.zrqbmnf.qr> <4B86B132.9090906@trash.net> <alpine.LSU.2.01.1002251832340.13151@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab0BYRf7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:35:59 -0500
In-Reply-To: <alpine.LSU.2.01.1002251832340.13151@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-02-25 18:19, Patrick McHardy wrote:
>>>>> Can you reproduce this?
>>>> No, this works fine here. It might be related to filter reprogramming
>>>> of the NIC. Which driver are you using?
>>> tap0 on one the host, e1000 inside the virtualbox.
>> I have no idea about virtualbox. I guess it might be related to
>> bridging.
> 
> There is no vm bridging at all, it's plain routing between tap and eth 
> (aka "Host Only Networking" in VMware slingo).

Well then you have to send me some more data, like tcpdumps, a
description of the entire networking setup etc.
