From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Understanding execution context of netfilter hooks
Date: Sat, 18 Jul 2009 00:02:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907172358270.16422@fbirervta.pbzchgretzou.qr>
References: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>  <alpine.LSU.2.00.0907172100370.18553@fbirervta.pbzchgretzou.qr> <704c29930907171312m1c986074y6b9fffa90128d379@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stefan Hellkvist <hellkvist@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZGQWCr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:02:47 -0400
In-Reply-To: <704c29930907171312m1c986074y6b9fffa90128d379@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>>So, the question, as mentioned in the beginning. What context is the
>>>hook executing in which causes the code to behave differently from
>>>when it executed in the module init method for instance?
>>
>> module_init either runs as user or kthread context. Your reading
>> of files would most likely also fail in the latter.
>
>I see, then this problem is not really netfilter specific I guess.

Nope. You could move your reading to netif_receive_skb and still get the 
same crash.

>If anyone knows of any good online documentation or book regarding
>these different contexts I would be grateful for the info. Otherwise I
>thank you for the feedback.

Chapters 5-8,10,12 of LDD3 (and perhaps more, I did not bother besides a 
quick grep) talk about it now and again.
