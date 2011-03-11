From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: conntrack -L shows nothing
Date: Fri, 11 Mar 2011 14:47:55 -0800
Message-ID: <AANLkTikL=2eF2c2AzJU-YmqT6ww27KztZtkoQUf_n7in@mail.gmail.com>
References: <alpine.LNX.2.01.1103112029440.10848@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34696 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1CKWr5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:47:57 -0500
Received: by vws1 with SMTP id 1so1097768vws.19
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2011 14:47:56 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1103112029440.10848@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I have observed a really odd issue, whereby running Linux 2.6.37.{0,1,2}
> would cause `conntrack -L` to show nothing despite
> /proc/net/nf_conntrack clearly having entries. Furthermore, the
> functionality is restored in Patrick's nf-next that currently carries
> 2.6.38-rc1, so there might have been a bug fix I am not aware about.
> .config is the same in either case, and the nfnetlink modules are
> loaded.

I've seen this on ubuntu 10.10 after upgrading the kernel to one of
their prebuilt .38 release candidates, rc7 IIRC.

It might be related to this, which I've also seen:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=612272

http://www.spinics.net/lists/netfilter-devel/msg17279.html

Cheers,
Sam
