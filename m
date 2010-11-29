From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Mon, 29 Nov 2010 14:26:13 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011291422070.6372@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262057450.18326@blackhole.kfki.hu> <alpine.LNX.2.01.1011262159310.4752@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu> <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011271741030.21709@blackhole.kfki.hu> <alpine.LNX.2.01.1011271828270.28539@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011272053230.22091@blackhole.kfki.hu>
 <4CF39CD2.50107@netfilter.org> <alpine.DEB.2.00.1011291336400.27282@blackhole.kfki.hu> <4CF3A2D7.8040708@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50402 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab0K2N0O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:26:14 -0500
In-Reply-To: <4CF3A2D7.8040708@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-11-29 13:55, Pablo Neira Ayuso wrote:
>
>Suspending the process in the middle of the dump is a strange scenario. If you
>did this accidentally, then you can notice it since you hit EAGAIN over and
>over again, so you can kill the dumper manually.

Though since frontend programs like iptables automatically retry on -EAGAIN,
the user won't see it.

>A user-space process that stops in the middle of a dump must be considered
>buggy, you have to fix your user-space program.

Short of misscheduling of processes on behalf of the kernel ;-)

So barring process using -EAGAIN it is, then.
