From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Patch using ipset match in policy routing.
Date: Wed, 5 Dec 2012 11:01:56 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212050926200.27565@blackhole.kfki.hu>
References: <Pine.LNX.4.64.1212032247290.19414@cube> <alpine.DEB.2.00.1212042115450.26188@blackhole.kfki.hu> <Pine.LNX.4.64.1212042240550.16537@cube>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: borg@uu3.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53492 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2LEKB7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:01:59 -0500
In-Reply-To: <Pine.LNX.4.64.1212042240550.16537@cube>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 4 Dec 2012, borg@uu3.net wrote:

> Uh. Seems you didnt read whole email?
> This is generaly a fix for wrong src addr in policy routing:
> https://bugzilla.kernel.org/show_bug.cgi?id=16216
> 
> While using iptables MARK and ip rule fwmark works for forwarded
> packets, this breaks localy generated packets making them
> routed correctly but having wrong src addr.
> This is because kernel first lookups routing table
> to get src addr and then pass packet to netfilter.
> In that stage is too late to do policy routing for localy
> generated packets.
> 
> This should be fixed, but unfortunately its not easy.

But you want to give an ipset-specific answer to a generic issue: fwmark 
is independent of ipset.

As far as I see, it's a chicken and egg problem: the kernel must lookup 
the routing table first to select a source address and that can't be 
changed later by policy routing.

In the bugzilla thread Ambroz Bizjak suggested using SNAT. Why doens't it 
a good solution?

The application could also be started in a net namespace.

> PS: Does IPSET have any mailing list or contacts? I couldnt
> find them.. Thats why I mailed netfilter-devel.

netfilter-devel is perfect for ipset.

[Please don't top post.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
