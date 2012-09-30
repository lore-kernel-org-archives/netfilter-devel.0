From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 06/17] iptables: fix order of internal commands list
Date: Sun, 30 Sep 2012 23:25:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209302313540.28050@nerf07.vanv.qr>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de> <1349000540-17508-7-git-send-email-jengelh@inai.de> <20120930210908.GA13681@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41084 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2I3VZo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:25:44 -0400
In-Reply-To: <20120930210908.GA13681@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-09-30 23:09, Pablo Neira Ayuso wrote:
>On Sun, Sep 30, 2012 at 12:22:09PM +0200, Jan Engelhardt wrote:
>> Specifying -S on the command line would add 4096 (0x1000, 1<<12) to the
>> cmd flags, but -S was in fact commands_v_options[13]. This led to a
>> bogus option checking and an error message:
>> 
>> $ iptables -A foo -S
>> iptables v1.4.14: Cannot use -E with -A
>
>Are you fixing old bugs?
>This works here:
># iptables -A foo -S
>iptables v1.4.15: Cannot use -S with -A

Hm.

>http://git.netfilter.org/[...]h=067a9baf6dc82babe466078ab3c05354c7741271

You only changed the "cmdflags" variable so that it lines up with
the CMD_ flags, however, you forgot to line up "commands_v_options"
as well.

Indeed your patch 067a9baf fixes "cannot use $that with $that".
My commit message was wrong, as I was misled by v1.4.14 behavior.
In fact, I had the real issue written down first. Approximate
excerpt from the reflog:


    iptables: fix order of command flags for option parser
    
    Specifying -S on the command line would add 4096 (0x1000, 1<<12) to the
    cmd flags, but -S was in fact commands_v_options[13].
    
    This problem never manifested itself before, because the [8]-[13] mostly
    had the same 'x' pattern. Now, when trying to allow --line-numbers for
    -S, the issue showed itself as --line-numbers was still rejected even
    after swapping 'x' for ' '.
    
    References: http://bugs.debian.org/642173


Does that make more sense?
