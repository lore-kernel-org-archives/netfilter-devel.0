From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] Build failure with Linux 4.13+: ERROR:
 "__udivdi3" [net/netfilter/xt_hashlimit.ko] undefined!
Date: Sat, 9 Sep 2017 21:22:07 +0200
Message-ID: <20170909192207.GA2103@salvia>
References: <02adf29d4b82dde97be78b0a9b20a3a6@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:46158 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdIITWd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Sep 2017 15:22:33 -0400
Content-Disposition: inline
In-Reply-To: <02adf29d4b82dde97be78b0a9b20a3a6@molgen.mpg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 09, 2017 at 10:37:25AM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Building the latest master branch from Linus, commit 0e271fd59fe9
> (Merge tag 'platform-drivers-x86-v4.14-1' of
> git://git.infradead.org/linux-platform-drivers-x86) fails with the error
> below. The same development environment worked up to the release of Linux
> 4.13.
> 
> ```
> […]
>   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
>   CC      arch/x86/boot/compressed/misc.o
> ERROR: "__udivdi3" [net/netfilter/xt_hashlimit.ko] undefined!

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=90c4ae4e2c1da9f1eaf846136861af43d4c1ff34

This patch is already in David S. Miller's net tree, so it should hit
upstream soon.

Let me now if you still experience problems after it, thanks.
