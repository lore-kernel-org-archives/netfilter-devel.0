From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 21:51:48 +0000
Message-ID: <4D0D2CF4.5070201@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> # ipset create foo hash:net,port
> # ipset add foo 192.168.0.0/30,80
> # ipset list foo
> Name: foo
> Type: hash:net,port
> Header: family inet hashsize 1024 maxelem 65536 
> Size in memory: 16792
> References: 0
> Members:
> 192.168.0.0/30,tcp:80
>
> # ipset create bar hash:ip,port
> # ipset add bar 192.168.0.0/30,80
> # ipset list bar
> Name: bar
> Type: hash:ip,port
> Header: family inet hashsize 1024 maxelem 65536 
> Size in memory: 16632
> References: 0
> Members:
> 192.168.0.0,tcp:80
> 192.168.0.1,tcp:80
> 192.168.0.2,tcp:80
> 192.168.0.3,tcp:80
>   
I see!


>> I do have another question however: Currently the protocol part from the port
>> ranges (hash sets) is not mandatory. Does that mean that if I omit it then the
>> port range is matched *regardless* of the protocol (tcp or udp)? For example,
>> if I have 10.1.1.0/24,80 would that match 10.1.1.1:tcp:80 *and*
>> 10.1.1.1:udp:80? If so, that is very good news!
>>     
>
> No, that's just a shorthand notation. If the protocol is left out then TCP 
> is assumed. If you need the same port with TCP and UDP, then you have to 
> add both to the set. Just using the examle set bar above:
>
> # ipset add bar 192.168.0.1,tcp:53
> # ipset add bar 192.168.0.1,udp:53
> # ipset list bar
> Name: bar
> Type: hash:ip,port
> Header: family inet hashsize 1024 maxelem 65536 
> Size in memory: 16696
> References: 0
> Members:
> 192.168.0.0,tcp:80
> 192.168.0.1,tcp:53
> 192.168.0.1,tcp:80
> 192.168.0.2,tcp:80
> 192.168.0.1,udp:53
> 192.168.0.3,tcp:80
>   
Would it be possible to have 'something', which disregards the protocol 
on port matching?

By 'something' I mean either omission of the protocol, or 'all' to be 
specified instead of the protocol to mean no matching on protocol would 
be made (in other words the protocol to be disregarded). This will be 
especially useful for sets with quite a few number of members and will 
avoid unnecessary duplication - as things stand I have to add the same 
number of members for both tcp and udp protocols when I don't need any 
protocol matching - just the subnets and port numbers I specified. Is 
this doable?


>> I downloaded the source to look at, but won't compile it just yet as I am
>> waiting for this version to be integrated in the xtables tree and hoping that
>> integration is flawless and without the silly compile-time errors as was the
>> case with previous xtables releases (*nudges Jan*).
>>     
>
> That won't be so easy for Jan, and it's up to him to decide, which ipset 
> tree he wants to support in xtables-addons: the old one which does not 
> need kernel patching or the new one with the burden of the netlink.patch.
>   
For me it won't really make a difference as I am always building the 
kernel from source and apply quite a few (I think 11 at the last count) 
patches myself - adding one more won't make any difference. With most 
Fedora distributions the position is exactly the same - they supply one 
or two patches with xtables as well so it won't be something new.

>> Final question from me: As part of the ipset-5.0 package you provide a netlink
>> patch file. I have read the README and it seems that the only time that patch
>> needs to be applied is if the kernel version is >= 2.6.31. Is that the case
>> and are there any other constraints/requirements? Do I apply this patch if the
>> kernel version is <= 2.6.31? It is important for me to know the answer to this
>> question when I prepare the .spec file for building the rpm for Fedora.
>>     
>
> In order to support kernel versions below 2.6.31, I had to add a lot of 
> #ifdefs in xt_set.c to support the countless API changes in netfilter 
> targets and matches. Hm, maybe I could support kernel releases from 
> 2.6.24. Below 2.6.24 there are missing netlink definitions as Jan 
> mentioned.
>   
The way I see it, it is best to leave 4.x tree for versions up to 2.6.24 
and leave 5.x for newer versions and then decide whether the netlink 
patch should be applied (my understanding is that if the kernel version 
is >= 2.6.31 the patch definitely needs to be applied - is that right?).

