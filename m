From: Stefan Hellkvist <hellkvist@gmail.com>
Subject: Re: Understanding execution context of netfilter hooks
Date: Fri, 17 Jul 2009 22:12:40 +0200
Message-ID: <704c29930907171312m1c986074y6b9fffa90128d379@mail.gmail.com>
References: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
	 <alpine.LSU.2.00.0907172100370.18553@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42977 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZGQUMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:12:42 -0400
Received: by fxm18 with SMTP id 18so949184fxm.37
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2009 13:12:40 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0907172100370.18553@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 17, 2009 at 9:19 PM, Jan Engelhardt<jengelh@medozas.de> wrote:

>>So, the question, as mentioned in the beginning. What context is the
>>hook executing in which causes the code to behave differently from
>>when it executed in the module init method for instance?
>
> module_init either runs as user or kthread context. Your reading
> of files would most likely also fail in the latter.

I see, then this problem is not really netfilter specific I guess. I
guess I have many things to learn here. I suppose exec is also running
in user context when it reads files with kernel_read then.

If anyone knows of any good online documentation or book regarding
these different contexts I would be grateful for the info. Otherwise I
thank you for the feedback.

/Stefan
