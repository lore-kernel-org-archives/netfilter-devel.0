From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Cannot use iptables with kernel 2.6.30
Date: Fri, 23 Apr 2010 09:30:41 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004230927130.24961@obet.zrqbmnf.qr>
References: <g2g21df6cb71004220358y9a5f23f1w1b7795a90fae82e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Elison Niven <elison.niven@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <g2g21df6cb71004220358y9a5f23f1w1b7795a90fae82e2@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2010-04-22 12:58, Elison Niven wrote:
>
>I am trying to install iptables on ARM platform running linux kernel
>2.6.30. I have enabled all the netfilter modules as enabled in the
>kernel.
>
>When statically building iptables-1.4.7, I get the following error:
># iptables
>getsockopt failed strangely

iptables without a command should display "no command specified",
not getsockopt failed.

What commands did you use for static compilation?

>When I build it dynamically, I am able to run iptables:
># iptables -h
>(displays help)

>However, When I try to apply any rules, It says:
># iptables -F
>Can't initialize table filter.
>Perhaps iptables or your kernel needs to be updated.
>
>This is strange because I have enabled all the netfilter options in my kernel.

I have a vague idea it could be ARM's alignments..

>I also tried using iptables-1.4.4 and iptables-1.3.8 but am not able
>to run iptables.
>
>Searching a little more, It seems to be the bug reported here :
>
>https://lists.linux-foundation.org/pipermail/bugme-new/2009-April/021618.html

This report mentions that versions before 2.6.30-rc1 (e.g. 2.6.29) were fine.
Is that also the case for you?

>However this patch that claims to solve this is already applied in my
>kernel and I still get the same error:
>
>http://marc.info/?l=linux-crypto-vger&m=123924457316022&w=2

Does it happen when iptable_filter.ko is loaded already before
iptables is executed?
