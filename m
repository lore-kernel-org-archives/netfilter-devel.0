From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons build fails
Date: Tue, 15 Jun 2010 01:05:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006150105390.14214@obet.zrqbmnf.qr>
References: <4C16A109.7050404@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: martinbarrowcliff <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60275 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0FNXF5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:05:57 -0400
In-Reply-To: <4C16A109.7050404@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-06-14 23:37, martinbarrowcliff wrote:

> A little compile problem here with xtables-addons-1.26 (and 1.27).
> This is a new system. linux-2.6.34, Gcc-4.5. It runs fine otherwise.
> Iptables is working. Networking is up.  Ipset compiles and works.
> Kernel and modules all build. All other apps compile fine so far.
> I have root access via a remote term.
> The same xt-a source compiles and runs on my other systems but not here?
>
> The source builds to this point, then compile fails as below:
>
> make[3]: Leaving directory `/usr/src/kernels/linux-2.6.34'
> make -f ../Makefile.iptrules all;
> make[3]: Entering directory
> `/usr/src/build/firewall/xtables-addons-1.27/extensions'
> CC     libxt_IPMARK.oo
> libxt_IPMARK.c:156:2: warning: implicit declaration of function 'ALIGN'

See http://marc.info/?t=127444218200001&r=1&w=2

