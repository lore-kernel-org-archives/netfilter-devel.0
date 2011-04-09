From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset issues in 2.6.39-rc2
Date: Sat, 9 Apr 2011 22:06:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104092203520.32398@blackhole.kfki.hu>
References: <20110409151655.GA22881@wantstofly.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41347 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1DIUG7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:06:59 -0400
In-Reply-To: <20110409151655.GA22881@wantstofly.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 9 Apr 2011, Lennert Buytenhek wrote:

> On the current Fedora Rawhide kernel (2.6.39-0.rc2.git0.0.fc16), I am
> seeing the following two issues:
> 
> 1. Attempting to create a -j SET rule with a certain invalid set of
>    flags leaks a reference to the specified pool:
> 
> 	# ipset create foo hash:ip
> 	# ipset list foo | grep References
> 	References: 0
> 	# iptables -A INPUT -j SET --del-set foo src,src,src,src,src,src
> 	iptables: Numerical result out of range.
> 	# ipset list foo | grep References
> 	References: 1
> 	#
> 
> 2. --del-set doesn't seem to work (or I don't understand how it's supposed
>    to work):
> 
> 	# ipset create bar hash:ip
> 	# ipset add bar 127.0.0.1
> 	# iptables -I INPUT -s 127.0.0.1 -p icmp -j SET --del-set bar src
> 	# ping -c 1 127.0.0.1
> 	[...]
> 	# iptables -L INPUT -v | grep SET
> 	    2   168 SET        icmp --  *      *       127.0.0.1            0.0.0.0/0           del-set bar src,dst,dst,dst,dst,dst 
> 	# ipset list bar
> 	[...]
> 	Members:
> 	127.0.0.1

Both are real bugs indeed. I have sent the fixes to netfilter-devel and 
I'll release a new ipset version at the weekend. I also fixed the set 
match/target in iptables to catch properly the invalid number of dir 
parameters and committed it in git.

Thanks for the bugreport!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
