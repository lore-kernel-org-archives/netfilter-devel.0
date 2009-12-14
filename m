From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter kernel modules question
Date: Mon, 14 Dec 2009 21:52:33 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912142151310.15986@obet.zrqbmnf.qr>
References: <4B2657B7.5070405@gmail.com> <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr> <4B269FD2.4020807@gmail.com> <alpine.LSU.2.01.0912142130020.14802@obet.zrqbmnf.qr> <4B26A497.8000900@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51648 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZLNUwf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:52:35 -0500
In-Reply-To: <4B26A497.8000900@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-12-14 21:48, Tobias Koeck wrote:
>>
>> You can argue what a data structure is or what it is not; a header
>> file should not include any definitions, only declarations. (And
>> perhaps static-inlines, but that's probably too expert for you at
>> this stage.) Various C-related forums or IRC channels can enlighten
>> you towards the reasoning for that.
>
> 'int a' is declaration (only used in a function it's a definition).

"int a" is always a definition. Inside a function it makes for an 
automatic variable, and outside a function it makes for one with static 
linkage.
