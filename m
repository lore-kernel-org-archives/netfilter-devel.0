From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 11:48:46 +0100
Message-ID: <4C9B308E.5010804@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr> <4C9AA703.5080301@googlemail.com> <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0IWKsy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:48:54 -0400
Received: by wyb28 with SMTP id 28so727487wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2010 03:48:53 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>> I wonder. F13 ships with linux-glibc-devel-2.6.33, F14A with -2.6.35. So where
>>> is the actual issue? Nevertheless, I have devised a workaround for 2.6.34
>>> headers. Check out xt-a's b5e2c7255a87f3d981968e21ea7f88401fe8f8ad and let me
>>> know.
>>>  
>>>       
>> On my system it shows glibc-devel-2.12-3 (I don't have linux-glibc-devel).
>>     
>
> It's called kernel-headers in Fedora. (Reason for it being called 
> elsewhere is that some noobs spout out "you need kernel headers to build 
> modules" and another noob installs kernel-headers rather than 
> kernel-devel-XYZ.)
>   
So, in other words I should be looking for kernel-devel (I am sure I've 
got that)? Also, how do I 'check out xt-a's 
b5e2c7255a87f3d981968e21ea7f88401fe8f8ad'?
