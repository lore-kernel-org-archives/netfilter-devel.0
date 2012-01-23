From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables2 a8, netlink interface
Date: Mon, 23 Jan 2012 16:42:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201231634330.9129@frira.zrqbmnf.qr>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1201201422230.11124@blackhole.kfki.hu> <alpine.LNX.2.01.1201211645300.28799@frira.zrqbmnf.qr> <alpine.DEB.2.00.1201212110100.13689@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59696 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab2AWPm6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:42:58 -0500
In-Reply-To: <alpine.DEB.2.00.1201212110100.13689@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-01-21 21:21, Jozsef Kadlecsik wrote:
>
>Netlink makes too easy to add new attributes - and ignores unknown ones. 
>However, in our case both communicating parties must know the exact 
>capabilities of the other one: it's unacceptable that say a new flag is 
>introduced and sent from userspace and got silently discarded by the 
>(older) kernel.

I thought about exposing the revision window here, much like
libtool's CURRENT and (CURRENT-AGE), rather than just a single rev
like ipset currently does. Does that make sense to you?

1. kern: 600--611, prog:    , 599 => prog too old
2. kern: 600--611, prog: 600, 610 => can use some/all features
3. kern: 600--611, prog: 611      => can use all features
4. kern: 600--611, prog: 612,     => kernel too old
