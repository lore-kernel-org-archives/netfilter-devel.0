From: Jonh Wendell <jonh.wendell@gmail.com>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to a chain
Date: Tue, 26 Feb 2013 20:30:01 -0300
Message-ID: <CABXqP=jsFJKvfb4QaFuN2jAshUn-ECpZ2FA6KLBYOencYTnXyQ@mail.gmail.com>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
	<alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr>
	<CABXqP=jq3rEE6b1xpgA0QtuwAQ04U5b3voMdTsuGmLB-qrsDxg@mail.gmail.com>
	<alpine.LNX.2.01.1302261639580.7776@nerf07.vanv.qr>
	<CABXqP=idCE0Rj8uC11VeGCpf7Cfb46A1OuD0SXAbjxpXXaxr-Q@mail.gmail.com>
	<alpine.LNX.2.01.1302262317240.13412@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33543 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3BZXaC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:30:02 -0500
Received: by mail-oa0-f52.google.com with SMTP id k14so6427746oag.39
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2013 15:30:02 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1302262317240.13412@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/26 Jan Engelhardt <jengelh@inai.de>:
>
> On Tuesday 2013-02-26 17:18, Jonh Wendell wrote:
>>
>>My particular use case is: I want to flush all iptables rules except
>>those ones from a specific chain.
>>So, I save them with iptables-save -C <chain-name>, flush, and then
>>run iptables-restore on them.
>
> But if chain-name is not a base chain, then you wipe out the
> main rules for all practical purposes.

actually, after flush all rules, I load a preset set of rules and only
then I run iptables-restore.

-- 
Jonh Wendell
http://www.bani.com.br
