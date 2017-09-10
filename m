From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [netfilter-core] Build failure with Linux 4.13+: ERROR:
 "__udivdi3" [net/netfilter/xt_hashlimit.ko] undefined!
Date: Sun, 10 Sep 2017 09:06:51 +0200
Message-ID: <cecac9f2eb8ec469674630e560e39251@molgen.mpg.de>
References: <02adf29d4b82dde97be78b0a9b20a3a6@molgen.mpg.de>
 <20170909192207.GA2103@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        =?UTF-8?Q?Ma?= =?UTF-8?Q?ciej_=C5=BBenczykowski?=
        <maze@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:55836 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751060AbdIJHGx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 03:06:53 -0400
In-Reply-To: <20170909192207.GA2103@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Pablo,


On 2017-09-09 21:22, Pablo Neira Ayuso wrote:
> On Sat, Sep 09, 2017 at 10:37:25AM +0200, Paul Menzel wrote:

>> Building the latest master branch from Linus, commit 0e271fd59fe9
>> (Merge tag 'platform-drivers-x86-v4.14-1' of
>> git://git.infradead.org/linux-platform-drivers-x86) fails with the 
>> error
>> below. The same development environment worked up to the release of 
>> Linux
>> 4.13.
>> 
>> ```
>> […]
>>   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
>>   CC      arch/x86/boot/compressed/misc.o
>> ERROR: "__udivdi3" [net/netfilter/xt_hashlimit.ko] undefined!
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=90c4ae4e2c1da9f1eaf846136861af43d4c1ff34
> 
> This patch is already in David S. Miller's net tree, so it should hit
> upstream soon.
> 
> Let me now if you still experience problems after it, thanks.

Thank you for your quick reply. When I read it, Linus had already pulled 
this fix in, and the build error is gone now.


Kind regards,

Paul
