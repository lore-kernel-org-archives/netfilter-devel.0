From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ulogd - rpm file generation
Date: Fri, 20 Jul 2012 01:12:14 +0100
Message-ID: <5008A25E.2090108@googlemail.com>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr> <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr> <50088FB0.4020403@googlemail.com> <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr> <50089863.7000803@googlemail.com> <alpine.LNX.2.01.1207200150310.3054@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50614 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2GTAMV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:12:21 -0400
Received: by weyx8 with SMTP id x8so2174258wey.19
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jul 2012 17:12:20 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207200150310.3054@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> No idea what you patched in the package, or otherwise did to your
> system. On a pure Centos 5.8. I did *NOT* talk about fc13.
>   
I don't give two hoots what is/isn't supported on a bloody CentOS 
system, quite frankly! The point I was making is that libnetfilter_acct 
does *NOT* depend on glibc 2.9 as evident from my previous post.

Oh, and also:
>
>> ulogd depends on libnetfilter_acct, which in turn requires glibc >= 
>> 2.9, and RHEL5 is just too damn old.
>>   
> Nope! If libnetfilter_acct is compiled from source it does *not* 
> require glibc >= 2.9 and uses the version of glibc on the host system.
>
> It is how I managed to build (and use) ulogd on one of my FC13-based 
> machines - built and installed it from source, together with its 
> immediate dependencies (libnetfilter_acct-devel, 
> libnetfilter_log-devel, libnfnetlink-devel & 
> libnetfilter_conntrack_devel).
Can you read?
