From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ulogd - rpm file generation
Date: Fri, 20 Jul 2012 02:18:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207200216560.8197@frira.zrqbmnf.qr>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr>
 <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr> <50088FB0.4020403@googlemail.com> <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr>
 <50089863.7000803@googlemail.com> <alpine.LNX.2.01.1207200150310.3054@frira.zrqbmnf.qr> <5008A25E.2090108@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:33187 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2GTASX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:18:23 -0400
In-Reply-To: <5008A25E.2090108@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-07-20 02:12, Mr Dash Four wrote:

>
>> No idea what you patched in the package, or otherwise did to your
>> system. On a pure Centos 5.8. I did *NOT* talk about fc13.
>>  
> I don't give two hoots what is/isn't supported on a bloody CentOS system, quite
> frankly! The point I was making is that libnetfilter_acct does *NOT* depend on
> glibc 2.9 as evident from my previous post.

Nothing is evident from your post, except that you were building for 
FC13 which shipped glibc-2.12 and thus satisfies ">= 2.9".

