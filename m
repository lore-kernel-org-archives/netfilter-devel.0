From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Network Acceleration Module vs Service
Date: Fri, 2 Apr 2010 13:23:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004021313001.18189@obet.zrqbmnf.qr>
References: <m2g8363055a1004011716t4b1efccazdbc28910424ee93d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47203 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0DBLXQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:23:16 -0400
In-Reply-To: <m2g8363055a1004011716t4b1efccazdbc28910424ee93d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-04-02 02:16, Justin Yaple wrote:
>
>I have been working on a network accelerator, [...]
>Currently it can only compress/decompress the data field of the TCP
>segments.

So, what makes it better than ipcomp?

>I want to add the ability for it to generate signatures for
>common data patterns, and then substitute the signature in place of
>that data pattern.  The other accelerator host would the reverse that
>and replace the signature with the actual data pattern.

That is essentially the definition of coding/compression,
which you already seem to have (minus one change that you don't
throw away the dictionary).

>I am a little worried about the performance of the system overall
>assuming the only option is to move the majority of this to a user
>space service I would need to rewrite the module portion to QUEUE the
>packets to user space.  This might severely effect performance of the
>system in the number of packets per second that can be processed.
>Given that it could be doing database queries, and substituting TCP
>data for a signature or compressing the data the time it takes to move
>a packet from kernel to user space and back might be negligible.

If it is not the case already, devise a mechanism so that userspace gathers
multiple nfqueued packets at once instead of one-at-a-time.
 - multi-threading the userspace process might be worth looking into
 - using NFQUEUE to deliver into separate queues per CPU
   (so that one CPU does not have to wait for the lock of another)
