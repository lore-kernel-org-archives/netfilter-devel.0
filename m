From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset-6.2 testsuite failure
Date: Sun, 10 Apr 2011 19:38:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104101937470.549@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49326 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1DJRiU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 13:38:20 -0400
In-Reply-To: <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-04-07 21:10, Jozsef Kadlecsik wrote:
>On Thu, 7 Apr 2011, Jan Engelhardt wrote:
>
>> Using 2.6.39-rc1+ (kaber/nf-next) with ipset-6.2 (plain, nfnetlink):
>> 
>> jng-0:/home/jengelh/code/ipset/tests # ./runtest.sh 
>> hash:ip6: Network: Check listing: passed
>> hash:ip6: Sleep 5s so that elements can time out: passed
>> hash:ip6: Network: List set: passed
>> hash:ip6: Network: Check listing: 6a7
>> > 200:100:10:: timeout 0
>> FAILED
>> Failed test: diff -I 'Size in memory.*' .foo hash:ip6.t.list1 && rm .foo
>> jng-0:/home/jengelh/code/ipset/tests # 
>
>I was unable to reproduce this with the kernel from Patrick's tree and 
>with ipset-6.2.
>
>However, in the testsuite of ipset-6.2 the hash:ip6 tests are not executed 
>just after the ipmap tests: there are missing tests in the listing above.
>
>Also, the testsuite in ipset-6.2 contains the tests against the kernel in 
>the package itself: the patches I have submitted today are missing from 
>2.6.39-rc1+

Tried with ipset 6.3 and modules from ipset-6.3, and seems to work.
