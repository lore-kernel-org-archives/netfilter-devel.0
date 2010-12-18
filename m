From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 21:23:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:57217 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab0LRUXh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:23:37 -0500
In-Reply-To: <4D0CC3BB.8030801@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 18 Dec 2010, Mr Dash Four wrote:

> > I'm happy to announce the new branch of ipset and release it's first
> > element, ipset-5.0.
> >   
> I see that you have considered my suggestions and added port ranges to the
> hash sets. That will make my job much easier! Thank you!

That was not so hard, I hesitated just a little bit to add new features 
before the release.
 
> Is there any difference between hash:net,ip and hash:ip,port? It seems as
> though I can specify subnets (CIDR format) of different sizes in both sets!

You meant hash:net,port and hash:ip,port. Of course they are different. In 
hash:net,port you can store different sized netblock and port pairs, while 
in hash:ip,port you can store just IP address and port pairs. Let me show 
you an example:

# ipset create foo hash:net,port
# ipset add foo 192.168.0.0/30,80
# ipset list foo
Name: foo
Type: hash:net,port
Header: family inet hashsize 1024 maxelem 65536 
Size in memory: 16792
References: 0
Members:
192.168.0.0/30,tcp:80

# ipset create bar hash:ip,port
# ipset add bar 192.168.0.0/30,80
# ipset list bar
Name: bar
Type: hash:ip,port
Header: family inet hashsize 1024 maxelem 65536 
Size in memory: 16632
References: 0
Members:
192.168.0.0,tcp:80
192.168.0.1,tcp:80
192.168.0.2,tcp:80
192.168.0.3,tcp:80
 
> I also spotted another feature I previously missed when looked at 5.0-pre10 -
> nesting of datatypes (I think the default is 4, which would be enough for 99%
> of cases). That is absolutely brilliant as up until now I have used multiple
> --match-set directives to do that job, which can now be done 'internally' by
> ipset. It also addresses the issue of 'binding' (a feature dropped in earlier
> ipset releases and a feature I badly missed if I am being honest), but the
> implementation this time is much better. This set of features will be put to
> the test as I will be using them quite extensively!

Binding was unfortunately a bad ideas therefore had to be dropped. The 
multidimensional sets and the list of sets fairly well replace it.

> I do have another question however: Currently the protocol part from the port
> ranges (hash sets) is not mandatory. Does that mean that if I omit it then the
> port range is matched *regardless* of the protocol (tcp or udp)? For example,
> if I have 10.1.1.0/24,80 would that match 10.1.1.1:tcp:80 *and*
> 10.1.1.1:udp:80? If so, that is very good news!

No, that's just a shorthand notation. If the protocol is left out then TCP 
is assumed. If you need the same port with TCP and UDP, then you have to 
add both to the set. Just using the examle set bar above:

# ipset add bar 192.168.0.1,tcp:53
# ipset add bar 192.168.0.1,udp:53
# ipset list bar
Name: bar
Type: hash:ip,port
Header: family inet hashsize 1024 maxelem 65536 
Size in memory: 16696
References: 0
Members:
192.168.0.0,tcp:80
192.168.0.1,tcp:53
192.168.0.1,tcp:80
192.168.0.2,tcp:80
192.168.0.1,udp:53
192.168.0.3,tcp:80
 
> I downloaded the source to look at, but won't compile it just yet as I am
> waiting for this version to be integrated in the xtables tree and hoping that
> integration is flawless and without the silly compile-time errors as was the
> case with previous xtables releases (*nudges Jan*).

That won't be so easy for Jan, and it's up to him to decide, which ipset 
tree he wants to support in xtables-addons: the old one which does not 
need kernel patching or the new one with the burden of the netlink.patch.
 
> As part of that process I will try and create the .spec file needed to build
> the Fedora rpm package (it would be for FC13 as I am yet to migrate to FC14)
> and will submit it with them to integrate it with FC as soon as possible.
> 
> Final question from me: As part of the ipset-5.0 package you provide a netlink
> patch file. I have read the README and it seems that the only time that patch
> needs to be applied is if the kernel version is >= 2.6.31. Is that the case
> and are there any other constraints/requirements? Do I apply this patch if the
> kernel version is <= 2.6.31? It is important for me to know the answer to this
> question when I prepare the .spec file for building the rpm for Fedora.

In order to support kernel versions below 2.6.31, I had to add a lot of 
#ifdefs in xt_set.c to support the countless API changes in netfilter 
targets and matches. Hm, maybe I could support kernel releases from 
2.6.24. Below 2.6.24 there are missing netlink definitions as Jan 
mentioned.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
