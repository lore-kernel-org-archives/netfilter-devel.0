From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset-6.2 testsuite failure
Date: Mon, 11 Apr 2011 02:07:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104110207210.2501@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu> <alpine.LNX.2.01.1104101937470.549@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104102013230.3680@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37659 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1DKAHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 20:07:45 -0400
In-Reply-To: <alpine.DEB.2.00.1104102013230.3680@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2011-04-10 20:18, Jozsef Kadlecsik wrote:
>> >Also, the testsuite in ipset-6.2 contains the tests against the kernel in 
>> >the package itself: the patches I have submitted today are missing from 
>> >2.6.39-rc1+
>> 
>> Tried with ipset 6.3 and modules from ipset-6.3, and seems to work.
>
>Thanks! The kernel is a little bit behind the package.

The testsuite should use diff -u at least, the context numbers are not very
telling.
