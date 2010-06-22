From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Tue, 22 Jun 2010 12:36:16 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006221235560.1327@obet.zrqbmnf.qr>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com> <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu> <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com> <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
 <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com> <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr> <alpine.DEB.2.00.1006221057510.2237@blackhole.kfki.hu> <alpine.DEB.2.00.1006221151050.2393@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nishit Shah <nsshah.82@gmail.com>,
	krunal patel <krunal.raj@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51067 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab0FVKgS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:36:18 -0400
In-Reply-To: <alpine.DEB.2.00.1006221151050.2393@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-06-22 11:53, Jozsef Kadlecsik wrote:
>> > >Well, that is not the case. With 2.6.18.8 latency is same as 6 msecs.
>> > 
>> > I think what you see could be noise.
>> > 
>> > See commit 848484c08cb4ad161074262994410387585259ff in
>> > xtables-addons. There I needed 3000 ping packets (sent with ping -f)
>> > *and* a linear search of 10000 ranges to get above 2000 msec overhead
>> > for a single rule.
>> 
>> The impact of one more rule should be negligible. Something is bad there, 
>> but we know too little on the setup, the configuration: what kind of 
>> architecture, hardware you run the testing? What do you get when you 
>> replace the rules with similar ones but with pure "-s src" matching, i.e. 
>> without calling ipset? And it'd be good if you'd test a recent kernel as 
>> well. 2.6.27 is almost two years old.
>
>I meant by "you" the OP, that is Krunal. :-)

I know but that does not stop me to add in related information anyway.
