From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Sat, 12 May 2012 01:06:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205120106100.4735@frira.vanv.qr>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu> <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr> <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu> <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr> <alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
 <CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com> <CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com> <alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu> <CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>
 <CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com> <CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com> <4FAC3A87.3010500@googlemail.com> <CAMQP0smebRtU8zpjYZTP0EKmOHS=Ncn+iShbcZQdBHnH7ed4bw@mail.gmail.com>
 <4FAD09FC.30707@googlemail.com> <alpine.DEB.2.00.1205112138580.22653@blackhole.kfki.hu> <4FAD997D.8060104@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Neutron Soutmun <neo.neutron@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51735 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2EKXG2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 19:06:28 -0400
In-Reply-To: <4FAD997D.8060104@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-05-12 00:58, Mr Dash Four wrote:
>>> I don't suppose you are working on ways to include ipset targets in tc by any
>>> chance, are you? *hopeful look*
>>>    
>>
>> Nothing required, all iptables targets are supported by tc.
>>  
> I meant ipsets themselves. In other words, instead of:
>
> tc filter add dev ifb0 protocol ip parent be:0 prio 10 u32 match ip src
> 10.1.1.1/24 match ip dst 10.2.1.1/24 match ip protocol 6 ...
>
> to have  ipset matching on src, destination, protocol etc instead of specifying
> hard-coded values, like "10.1.1.1/24", "10.2.1.1/24" and "protocol 6" in the
> above example.
>
> To my knowledge, that isn't yet possible or have I missed something?

There's always the nfmark that you can use, of course.
