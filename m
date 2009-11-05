From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 12:30:55 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911050924280.13373@blackhole.kfki.hu> <alpine.DEB.2.00.0911051134520.13373@blackhole.kfki.hu>
 <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net,
	"Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36183 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZKELax (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:30:53 -0500
In-Reply-To: <alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-11-05 12:21, Jozsef Kadlecsik wrote:
>> >In a few days I'll be able to use an Ultra 10 for testing - that'll settle 
>> >the validating on big endian hardware.
>> 
>> Does not Dave have some 64-bit sparks in the basement that may
>> be shared and given remote access to?
>> (It seems Netfilter is one of the subsystems most plagued by endianess, 
>> aligning and sizeof(long) variances ;-)
>
>Dave don't need to dig into his SPARC collection :-) - I'll setup this 
>machine as a testbed for netfilter/ipset.

But since the Ultra10 is just 32-bit IIRC, you would not have a
chance to hit the rare 64-bit alignment problems (both in terms of
SIGBUS and "invalid match size 16 != 12"), should there be any.
