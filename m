From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addons 1.32/ipset-GENL 5.2
Date: Wed, 5 Jan 2011 13:08:04 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101051223190.12025@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr> <alpine.DEB.2.00.1101050921130.23762@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33459 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1AEMIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 07:08:06 -0500
In-Reply-To: <alpine.DEB.2.00.1101050921130.23762@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-01-05 10:22, Jozsef Kadlecsik wrote:
>On Tue, 4 Jan 2011, Jan Engelhardt wrote:
>
>> So a few people had been asking on whether ipset 5.x will be bundled 
>> along with Xtables-addons. Naturally this is a difficult question 
>> because ipset-5 wants a kernel patch. But yes, it is included as of Xt-a 
>> 1.32 (just out).
>> 
>> It has been augmented to not require the patch anymore, by moving it 
>> over from nfnetlink (booo) to genetlink which does not depend on static 
>> numbers, though you will need at least Linux 2.6.35 for this GENL 
>> variant in both compilation and at runtime.
>
>I fully appreciate your effort, however with it you forked ipset 5.x and 
>now the two branches cannot talk to each other.

Was not planned; I hardly see a case where there is a reason to mix
two versions of out-of-tree modules. (There is always a lockstep
update of both kernel and user side when using Xt-a.)

>I'm not convinced that ipset should be moved from nfnetlink to
>genetlink. It'd make life easier for the users at the beginning,
>however on the longer run it'd buy nothing and I believe ipset
>belongs to nfnetlink. I considered the idea of adding support of
>both protocols, however it might make the acceptance for kernel
>inclusion harder. I'm not happy.

The genl patch was solely made for the users wanting to try ipset5.

I cannot say I am happy about it either, knowing about the nfnetlink
doctrine. You say genl does not buy us anything, but I feel people
have not thought about what nfnl could possibly buy over genl. Right
now, nfnl has two drawbacks: preallocated IDs and extra memory use.

There were no intentions of inclusion of this genl patch, though that
does not mean I prohibit its integration.
