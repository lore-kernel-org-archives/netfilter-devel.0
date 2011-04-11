From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: pknock extension crashes the kernel
Date: Mon, 11 Apr 2011 18:32:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104111831001.23395@obet.zrqbmnf.qr>
References: <59618.87.244.225.21.1296328332.squirrel@mail.atlantis.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: jp@skylan.sk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37452 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1DKQcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:32:35 -0400
In-Reply-To: <59618.87.244.225.21.1296328332.squirrel@mail.atlantis.sk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-01-29 20:12, jp@skylan.sk wrote:

>Hi,
>
>I am using gentoo, hardened build, kernel version 2.6.34-r6. The pknock
>module does not load, instead, it crashes. GCC version is 4.4.4-r2,
>iptables version 1.4.10. Tried all xtables-addons versions from 1.28 to
>newest 1.32, same result for all builds.

It is possible that this is fixed in v1.34:

xt_pknock: avoid crash when hash TFM could not be allocated (commit 0ba44bd)

I can't say more because you have symbols disabled in your kernel image
so that the IP value - normally suffixed by the name of the function -
is of no use.
>BUG: unable to handle kernel NULL pointer dereference at 000000000000002e
>IP: [<ffffffffa002c0a3>]
>Pid: 8772, comm: modprobe Not tainted 2.6.34-hardened-r6 #3 /ProLiant
