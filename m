From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: Re: Question about the "dst" field in sk_buff
Date: Thu, 4 Feb 2010 10:34:09 +0100
Message-ID: <2a3692de1002040134v7c4bcbbby6d3708506d37f053@mail.gmail.com>
References: <2a3692de1002031015l7ff6e1a1w61caa03d46afb55b@mail.gmail.com>
	 <alpine.LSU.2.01.1002031930070.27969@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:37721 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab0BDJeK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:34:10 -0500
Received: by fxm20 with SMTP id 20so2274138fxm.21
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Feb 2010 01:34:09 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002031930070.27969@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

How about in general...? What is required to make code compile that
has "skb->dst" in it?

Greetings,
Dominik


On Wed, Feb 3, 2010 at 7:35 PM, Jan Engelhardt <jengelh@medozas.de> wro=
te:
> On Wednesday 2010-02-03 19:15, Dominik Kaspar wrote:
>>
>>I'm trying to compile various xt_*.c files that try to access
>>skb->dst. However, the sk_buff structure has no "dst" field in the
>>kernel version I am using (2.6.31), only a "_skb_dst" field. So when =
I
>>run "make", for example to compile the xt_ECHO.c example from the
>>netfilter tutorial, I always encounter errors like this:
>>
>>error: =91struct sk_buff=92 has no member named =91dst=92
>>
>>What do I have to do to solve this? I guess it has something to do
>>with those "compat" files, but I don't how they are used... Any hint
>>would be highly appreciated.
>
> xt_ECHO is not normally built and thus has fallen behind in porting.
> This has now been rectified.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
