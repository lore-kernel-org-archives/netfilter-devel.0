From: Tobias Koeck <tobias.koeck@gmail.com>
Subject: Re: netfilter kernel modules question
Date: Mon, 14 Dec 2009 21:28:02 +0100
Message-ID: <4B269FD2.4020807@gmail.com>
References: <4B2657B7.5070405@gmail.com> <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58810 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZLNU2H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:28:07 -0500
Received: by fxm5 with SMTP id 5so4032331fxm.28
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2009 12:28:05 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.0912142115290.14355@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/14/2009 09:17 PM, Jan Engelhardt wrote:
> On Monday 2009-12-14 16:20, Tobias Koeck wrote:
>
>> I have two netfilter kernel modules (xt_RQS.c, xt_RQD.c, both include a header
>> file with a data structure in it).
>>
>> Does both kernel modules use the same datastructures or do they use seperate
>> ones (in normal C programming I know that but I'm not sure about the kernel
>> scopes).
>
> You decide whether they do. This does not change just because you are in
> kernel space.
Can you please give a short example how to to it?

Let's say you've got one data structure (int a) in the header file. 
How can you access it in both c-files? Do you have to export it?

Is there a deeper information how the kernel scope is structured?
