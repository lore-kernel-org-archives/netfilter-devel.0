From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 2/2 v2] New netfilter target to trigger LED devices
Date: Fri, 14 Nov 2008 08:18:17 +1000
Message-ID: <491CA7A9.9020403@shikadi.net>
References: <49196D3E.5080305@shikadi.net> <alpine.LNX.1.10.0811131653030.13330@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3882 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKMWST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:18:19 -0500
In-Reply-To: <alpine.LNX.1.10.0811131653030.13330@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> +/*
>> + * Known issues:
>> + *
>> + *  - It's possible to add multiple led triggers with the same name (as
>> + *    set with --led-trigger-id)
>> + *
>> + */
> 
> So fix this?

I don't know how :-(  Since the LED hardware class doesn't (to my knowledge)
allow you to get a list of available LED triggers on the system, I'd have to
have some sort of global list that I append to every time a trigger is
created.  Given the likelihood of this happening (and the fact that it mostly
works having two triggers with the same name, it just looks bad) I didn't
think it was important enough for the additional code.

If this functionality is added to the LED class then I will happily update
my code to make use of it.

> Not that it is overly important, but the comment style generally
> seems to be (for multilines)
> m{^(\s+)/\*\n(\1 \* \w+\n)+\1 \*/\n}

Will fix in the next revision.  I'm hoping to hear back from the "LED people"
before posting again as per Patrick's comment.

Cheers,
Adam.

