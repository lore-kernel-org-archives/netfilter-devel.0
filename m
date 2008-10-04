From: "Martin Schwenke" <martin@meltin.net>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sat, 4 Oct 2008 14:21:38 +1000
Message-ID: <18662.61266.69230.675687@martins.ozlabs.org>
References: <18661.41641.113458.932029@martins.ozlabs.org>
	<48E6166F.40607@trash.net>
	<alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
Reply-To: "Martin Schwenke" <martin@meltin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:59748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYJDE0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 00:26:11 -0400
In-Reply-To: <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> "Jan" == Jan Engelhardt <jengelh@medozas.de> writes:

    Jan> Well, the kernel/userspace certainly has support for mixed
    Jan> 64/32 ABI, so calling for both being the same seems like an
    Jan> unnecessary push.

    Jan> I might wonder; what does

    Jan> 	#include <stdio.h>
    Jan> 	/* userspace program here */
    Jan> 	printf("%Zu\n", __alignof__(uint64_t));

    Jan> give on ARM?

If I compile using the native Debian etch gcc:

  gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

then it prints 4.

If I use the cross-compiler that I use to compile kernels (and use
--static) then it prints 8.  The version is:

  arm-none-linux-gnueabi-gcc (Sourcery G++ Lite 2008q1-126) 4.2.3

So there does seem to be a mismatch.

However, compiling iptables statically with the cross-compiler results
in:

  # ./iptables -L
  getsockopt failed strangely: No such file or directory

Of course, I can't strace it because it is static.  I could compile a
debug version and use gdb... but I'm not clued up enough on ABI issues
to know what to look for...  and I suspect that using gdb when I have
ABI issues is just going to confuse me.

I'm pretty sure I once tried compiling a kernel with the native 4.1.2
GCC but it wouldn't boot... which is annoying because trying it and
failing involves fixing it with a screwdriver!  :-(

Any suggestions before I try that again?  If all common sense points
to me needing to compile kernel's natively then I'll obviously give it
a try.  Alternatively, if there's a small hack that isn't obvious to
me then I'd be happy to hear about it.  That said, I suspect that if I
have ABI issues then I shouldn't be trying small hacks... but then
everything else on the box *seems* to work just fine...  yep, famous
last words...  ;-)

Thanks for any suggestions...

peace & happiness,
martin

