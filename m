From: Jonh Wendell <jonh.wendell@gmail.com>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to a chain
Date: Tue, 26 Feb 2013 13:18:04 -0300
Message-ID: <CABXqP=idCE0Rj8uC11VeGCpf7Cfb46A1OuD0SXAbjxpXXaxr-Q@mail.gmail.com>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
	<alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr>
	<CABXqP=jq3rEE6b1xpgA0QtuwAQ04U5b3voMdTsuGmLB-qrsDxg@mail.gmail.com>
	<alpine.LNX.2.01.1302261639580.7776@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57013 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3BZQSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:18:06 -0500
Received: by mail-ob0-f169.google.com with SMTP id ta14so56020obb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2013 08:18:05 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1302261639580.7776@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/26 Jan Engelhardt <jengelh@inai.de>:
>
> On Tuesday 2013-02-26 15:57, Jonh Wendell wrote:
>>2013/2/26 Jan Engelhardt <jengelh@inai.de>
>>      On Tuesday 2013-02-26 12:33, jonh.wendell@gmail.com wrote:
>>
>>      >From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
>>      >
>>      >Similar to the --table argument, if a --chain (or -C) argument
>>      >is passed, we limit the output to rules of that chain.
>>
>>But we have `iptables -S chain` for that, don't we.
>>
>>
>>I'm afraid its output is not suitable for iptables-restore.
>
> I thought you just wanted to have a single chain shown, for the
> purposes of debugging (because nobody can frankly read -L's output).
> If however you want to feed it to replace, can you elaborate on your
> use case? I would be interested in that.

Hi!

My particular use case is: I want to flush all iptables rules except
those ones from a specific chain.
So, I save them with iptables-save -C <chain-name>, flush, and then
run iptables-restore on them.

I could do it without that -C flag, but I'd have to parse its output
to get only the chain I'm interested in.

In other words, my use case could be reached with something like
'iptables -F ! <chain-name>'.

All in all, I think it's a good addition to iptables-save, it can be
useful in other scenarios.

Thanks,
-- 
Jonh Wendell
http://www.bani.com.br
