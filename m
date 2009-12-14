From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter kernel modules question
Date: Mon, 14 Dec 2009 21:32:39 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912142130020.14802@obet.zrqbmnf.qr>
References: <4B2657B7.5070405@gmail.com> <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr> <4B269FD2.4020807@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49390 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZLNUcl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:32:41 -0500
In-Reply-To: <4B269FD2.4020807@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-12-14 21:28, Tobias Koeck wrote:
>>> I have two netfilter kernel modules (xt_RQS.c, xt_RQD.c, both include a
>>> header
>>> file with a data structure in it).
>>>
>>> Does both kernel modules use the same datastructures or do they use seperate
>>> ones (in normal C programming I know that but I'm not sure about the kernel
>>> scopes).
>>
>> You decide whether they do. This does not change just because you are in
>> kernel space.
>
> Can you please give a short example how to to it?
>
> Let's say you've got one data structure (int a) in the header file. How can you
> access it in both c-files? Do you have to export it?

You can argue what a data structure is or what it is not; a header
file should not include any definitions, only declarations. (And
perhaps static-inlines, but that's probably too expert for you at
this stage.) Various C-related forums or IRC channels can enlighten
you towards the reasoning for that.
