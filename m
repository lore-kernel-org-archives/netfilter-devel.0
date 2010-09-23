From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 02:01:55 +0100
Message-ID: <4C9AA703.5080301@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50974 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0IWBCD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:02:03 -0400
Received: by wwb34 with SMTP id 34so82032wwb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2010 18:02:02 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> That starts to sounds like the project is run with an uncorrelated 
> concurrent asynchronous interaction of the manus(es). Suggested anger 
> management should involve the double-agent maintainer who was bribed to 
> put iptables in /sbin in the first place.
>   
Should they be in /usr/sbin then?

>> [bugzilla.gentoo.org/325257]
>> I just found that out to my cost - need to download the patch, update 
>> my source and rebuild the kernel again, then rinse, repeat with xtables 
>> and hope that it
>>     
>
> I wonder. F13 ships with linux-glibc-devel-2.6.33, F14A with -2.6.35. So 
> where is the actual issue? Nevertheless, I have devised a workaround for 
> 2.6.34 headers. Check out xt-a's 
> b5e2c7255a87f3d981968e21ea7f88401fe8f8ad and let me know.
>   
On my system it shows glibc-devel-2.12-3 (I don't have linux-glibc-devel).
