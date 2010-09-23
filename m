From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 02:55:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009230240510.10796@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr> <4C9A9FAF.8090804@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59096 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0IWAz6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:55:58 -0400
In-Reply-To: <4C9A9FAF.8090804@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-23 02:30, Mr Dash Four wrote:
>
>>You willingly chose to use Redhat/Fedora. Now endure the pain! :-)
>
>I just wished I hadn't! 5 minutes ago I found yet ANOTHER bug - this 
>time in selinux-policy - the SELinux context on all iptables 
>executables is set wrong simply because whoever wrote the policy choose 
>the wrong location of these files - in FC13 they are all installed in 
>/sbin, but iptables.fc says /usr/sbin so the context is not set. Lovely 
>stuff!

That starts to sounds like the project is run with an uncorrelated 
concurrent asynchronous interaction of the manus(es). Suggested anger 
management should involve the double-agent maintainer who was bribed to 
put iptables in /sbin in the first place.

>> Sounds like another Fedora problem. I know it works in openSUSE,
>> but that is probably because they make sure the custom string is
>> actually _in_ the version (as evidenced by `uname -r`).
> 
>So is on FC13 - I just checked and it is displayed - version + custom string.
>The problem is that the scripts are actually looking for the kernel numbers,
>ASSUMING there is nothing after it. How daft is that?

(Oh I can tell tales too. The most recent one is a bug report that ended 
in pretty much "if you don't want to use the graphical installer, live 
with whatever strange decisions anaconda unilaterally did for you". 
But... I digress.)

>[bugzilla.gentoo.org/325257]
>I just found that out to my cost - need to download the patch, update 
>my source and rebuild the kernel again, then rinse, repeat with xtables 
>and hope that it

I wonder. F13 ships with linux-glibc-devel-2.6.33, F14A with -2.6.35. So 
where is the actual issue? Nevertheless, I have devised a workaround for 
2.6.34 headers. Check out xt-a's 
b5e2c7255a87f3d981968e21ea7f88401fe8f8ad and let me know.
