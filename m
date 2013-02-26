From: Jonh Wendell <jonh.wendell@gmail.com>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to a chain
Date: Tue, 26 Feb 2013 12:02:09 -0300
Message-ID: <CABXqP=hwsm65O-Nj-gt=NyE__CJO66_Y1gdm-1Vd+P3H03DxyA@mail.gmail.com>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
	<alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56027 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162Ab3BZPCK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:02:10 -0500
Received: by mail-oa0-f46.google.com with SMTP id k1so5374622oag.33
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2013 07:02:09 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/26 Jan Engelhardt <jengelh@inai.de>
>
> On Tuesday 2013-02-26 12:33, jonh.wendell@gmail.com wrote:
>
> >From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
> >
> >Similar to the --table argument, if a --chain (or -C) argument
> >is passed, we limit the output to rules of that chain.
>
> But we have `iptables -S chain` for that, don't we.


I'm afraid its output is not suitable for iptables-restore.

--
Jonh Wendell
http://www.bani.com.br
