From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 14:16:08 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009231415580.31650@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
 <4C9AA703.5080301@googlemail.com> <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr> <4C9B308E.5010804@googlemail.com> <alpine.LNX.2.01.1009231256200.29321@obet.zrqbmnf.qr> <4C9B3848.8010503@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55892 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab0IWMQK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:16:10 -0400
In-Reply-To: <4C9B3848.8010503@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-23 13:21, Mr Dash Four wrote:
>
>> rpm -q kernel-headers
>>  
> kernel-headers-2.6.34.7-56.<my local string>.fc13.x86_64 (this was compiled
> from source)
>
>>  
>>> that)? Also, how do I 'check out xt-a's
>>> b5e2c7255a87f3d981968e21ea7f88401fe8f8ad'?
>>>    
>>
>> `git clone
>> git://xtables-addons.git.sf.net/gitroot/xtables-addons/xtables-addons` 
>> is what you probably seek.
>>  
> Done, though there is no 'configure'! How do I compile this stuff?

./autogen.sh, then configure.
