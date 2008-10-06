From: "Martin Schwenke" <martin@meltin.net>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Mon, 6 Oct 2008 12:34:07 +1100
Message-ID: <18665.27407.93703.212846@martins.ozlabs.org>
References: <18661.41641.113458.932029@martins.ozlabs.org>
	<48E6166F.40607@trash.net>
	<alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
	<18662.61266.69230.675687@martins.ozlabs.org>
	<alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
Reply-To: "Martin Schwenke" <martin@meltin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:39031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJFBeM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:34:12 -0400
In-Reply-To: <alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> "Jan" == Jan Engelhardt <jengelh@medozas.de> writes:

    Jan> You can change the XT_ALIGN macro in the
    Jan> kernel/include/linux/netfilter/x_tables.h and
    Jan> iptables/include/linux/netfilter/x_tables.h to read

    Jan> 	#ifndef roundup
    Jan> 	#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
    Jan> 	#endif
    Jan> 	#define XT_ALIGN(s) roundup(s, sizeof(uint64_t))

    Jan> and try again. There might be more alignment issues hiding,
    Jan> so don't expect it to fix it all in a magic whizz.

Hmmm... that didn't do it.  I'm still seeing the same problem.

I've made the above change in both places (kernel tree, iptables
source).  I compiled the kernel with the cross compiler, and tried
both a statically linked, cross-compiled iptables binary, and natively
compiled complete iptables Debian package.

Weird...  but thanks for the possible workaround!

    >> Of course, I can't strace it because it is static.

    Jan> stracing is independent of staticness/dynamicness.

Oops... could I be thinking of ltrace or should I shut up before I
embarrass myself more?  ;-)  Whatever the case, strace doesn't work
on my static cross-compiled binary...  :-(

peace & happiness,
martin

