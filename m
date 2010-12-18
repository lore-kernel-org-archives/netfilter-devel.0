From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 14:22:51 +0000
Message-ID: <4D0CC3BB.8030801@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45432 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab0LROW4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:22:56 -0500
In-Reply-To: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I'm happy to announce the new branch of ipset and release it's first 
> element, ipset-5.0.
>   
I see that you have considered my suggestions and added port ranges to 
the hash sets. That will make my job much easier! Thank you!

Is there any difference between hash:net,ip and hash:ip,port? It seems 
as though I can specify subnets (CIDR format) of different sizes in both 
sets!

I also spotted another feature I previously missed when looked at 
5.0-pre10 - nesting of datatypes (I think the default is 4, which would 
be enough for 99% of cases). That is absolutely brilliant as up until 
now I have used multiple --match-set directives to do that job, which 
can now be done 'internally' by ipset. It also addresses the issue of 
'binding' (a feature dropped in earlier ipset releases and a feature I 
badly missed if I am being honest), but the implementation this time is 
much better. This set of features will be put to the test as I will be 
using them quite extensively!

I do have another question however: Currently the protocol part from the 
port ranges (hash sets) is not mandatory. Does that mean that if I omit 
it then the port range is matched *regardless* of the protocol (tcp or 
udp)? For example, if I have 10.1.1.0/24,80 would that match 
10.1.1.1:tcp:80 *and* 10.1.1.1:udp:80? If so, that is very good news!

I downloaded the source to look at, but won't compile it just yet as I 
am waiting for this version to be integrated in the xtables tree and 
hoping that integration is flawless and without the silly compile-time 
errors as was the case with previous xtables releases (*nudges Jan*).

As part of that process I will try and create the .spec file needed to 
build the Fedora rpm package (it would be for FC13 as I am yet to 
migrate to FC14) and will submit it with them to integrate it with FC as 
soon as possible.

Final question from me: As part of the ipset-5.0 package you provide a 
netlink patch file. I have read the README and it seems that the only 
time that patch needs to be applied is if the kernel version is >= 
2.6.31. Is that the case and are there any other 
constraints/requirements? Do I apply this patch if the kernel version is 
<= 2.6.31? It is important for me to know the answer to this question 
when I prepare the .spec file for building the rpm for Fedora.
