From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sat, 4 Oct 2008 07:49:06 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
References: <18661.41641.113458.932029@martins.ozlabs.org> <48E6166F.40607@trash.net> <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr> <18662.61266.69230.675687@martins.ozlabs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Martin Schwenke <martin@meltin.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41759 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYJDLtI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:49:08 -0400
In-Reply-To: <18662.61266.69230.675687@martins.ozlabs.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-10-04 00:21, Martin Schwenke wrote:

>    Jan> 	#include <stdio.h>
>    Jan> 	/* userspace program here */
>    Jan> 	printf("%Zu\n", __alignof__(uint64_t));
>
>    Jan> give on ARM?
>
>If I compile using the native Debian etch gcc:
>
>  gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
>
>then it prints 4.

It's what I thought. There lies the reason for all those strange issues on
embedded devices ;-)

You can change the XT_ALIGN macro in the
kernel/include/linux/netfilter/x_tables.h and
iptables/include/linux/netfilter/x_tables.h to read

	#ifndef roundup
	#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
	#endif
	#define XT_ALIGN(s) roundup(s, sizeof(uint64_t))

and try again. There might be more alignment issues hiding, so
don't expect it to fix it all in a magic whizz.

>If I use the cross-compiler that I use to compile kernels (and use
>--static) then it prints 8.  The version is:
>
>  arm-none-linux-gnueabi-gcc (Sourcery G++ Lite 2008q1-126) 4.2.3
>
>So there does seem to be a mismatch.
>
>However, compiling iptables statically with the cross-compiler results
>in:
>
>  # ./iptables -L
>  getsockopt failed strangely: No such file or directory
>
>Of course, I can't strace it because it is static.

stracing is independent of staticness/dynamicness.
