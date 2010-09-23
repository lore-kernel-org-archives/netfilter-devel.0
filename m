From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Thu, 23 Sep 2010 01:30:39 +0100
Message-ID: <4C9A9FAF.8090804@googlemail.com>
References: <4C9A56D3.109@googlemail.com> <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr> <4C9A9003.7060103@googlemail.com> <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55477 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0IWAap (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:30:45 -0400
Received: by wyb28 with SMTP id 28so424795wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2010 17:30:44 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009230206250.9682@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> You willingly chose to use Redhat/Fedora. Now endure the pain! :-)
>   
I just wished I hadn't! 5 minutes ago I found yet ANOTHER bug - this 
time in selinux-policy - the SELinux context on all iptables executables 
is set wrong simply because whoever wrote the policy choose the wrong 
location of these files - in FC13 they are all installed in /sbin, but 
iptables.fc says /usr/sbin so the context is not set. Lovely stuff!

>> Since the 2 kmod-* and xtabbles-addons rpms do not recognise the custom-built
>> string after the kernel version -
>>     
>
> Sounds like another Fedora problem. I know it works in openSUSE,
> but that is probably because they make sure the custom string is
> actually _in_ the version (as evidenced by `uname -r`).
>   
So is on FC13 - I just checked and it is displayed - version + custom 
string. The problem is that the scripts are actually looking for the 
kernel numbers, ASSUMING there is nothing after it. How daft is that?


> Yes, someone made a big boo and furthermore did not send the fix to
> -stable (actually I don't know that), but what I know is that it
> did not appear in -stable yet. And then there is that 2.6.34 is
> no longer maintained. Let alone distros mostly don't even think
> about updating. So everybody using linux-glibc-devel-2.6.34
> (that is the userspace package providing /usr/include/linux) is
> screwed.
> http://bugs.gentoo.org/show_bug.cgi?id=325257
>   
I just found that out to my cost - need to download the patch, update my 
source and rebuild the kernel again, then rinse, repeat with xtables and 
hope that it works.
