From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 12:28:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009231224340.27002@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com> <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
 <4C9AA703.5080301@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48445 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab0IWK2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:28:19 -0400
In-Reply-To: <4C9AA703.5080301@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-23 03:01, Mr Dash Four wrote:
>
>> That starts to sounds like the project is run with an uncorrelated concurrent
>> asynchronous interaction of the manus(es). Suggested anger management should
>> involve the double-agent maintainer who was bribed to put iptables in /sbin in
>> the first place.
> 
> Should they be in /usr/sbin then?

Yes. They are not essential to run fsck/mount/thelike in case of an 
emergency.

>>> [bugzilla.gentoo.org/325257]
>>> I just found that out to my cost - need to download the patch, update my
>>> source and rebuild the kernel again, then rinse, repeat with xtables and hope
>>> that it
>>>    
>>
>> I wonder. F13 ships with linux-glibc-devel-2.6.33, F14A with -2.6.35. So where
>> is the actual issue? Nevertheless, I have devised a workaround for 2.6.34
>> headers. Check out xt-a's b5e2c7255a87f3d981968e21ea7f88401fe8f8ad and let me
>> know.
>>  
> On my system it shows glibc-devel-2.12-3 (I don't have linux-glibc-devel).

It's called kernel-headers in Fedora. (Reason for it being called 
elsewhere is that some noobs spout out "you need kernel headers to build 
modules" and another noob installs kernel-headers rather than 
kernel-devel-XYZ.)
