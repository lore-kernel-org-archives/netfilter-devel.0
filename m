From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 19:41:41 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911051940550.25147@obet.zrqbmnf.qr>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911050924280.13373@blackhole.kfki.hu> <alpine.DEB.2.00.0911051134520.13373@blackhole.kfki.hu>
 <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu> <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911051934400.14280@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net,
	"Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57336 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452AbZKESlg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:36 -0500
In-Reply-To: <alpine.DEB.2.00.0911051934400.14280@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-11-05 19:36, Jozsef Kadlecsik wrote:
>> >
>> >Dave don't need to dig into his SPARC collection :-) - I'll setup this 
>> >machine as a testbed for netfilter/ipset.
>> 
>> But since the Ultra10 is just 32-bit IIRC, you would not have a
>> chance to hit the rare 64-bit alignment problems (both in terms of
>> SIGBUS and "invalid match size 16 != 12"), should there be any.
>
>SUN Ultra 10 has got a 300, 333, 360, or 440-MHz UltraSPARC[tm]-IIi 
>processor. So it's definitely a bigendian machine.

Note that I did not mention endianess at all in the ">>" level.
