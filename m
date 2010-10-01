From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IS Mapping ipset to iptable chains possible
Date: Fri, 1 Oct 2010 09:20:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1010010918510.11563@blackhole.kfki.hu>
References: <AANLkTin81gLzh3iHbONkeAckWxc++WZtmuHXeFuMN6VT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46281 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0JAHUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:20:50 -0400
In-Reply-To: <AANLkTin81gLzh3iHbONkeAckWxc++WZtmuHXeFuMN6VT@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 1 Oct 2010, Anand Raj Manickam wrote:

> I m just learning to use ipsets .
> I have a basic doubt
> 
> Suppose i create a ipset
> 
> ipset -N test ipmap --network 192.168.0.0/16
> 
> add a few ips
> #ipset -A test 192.168.0.1
> ..
> 
> if i want to have 1 chain per ip
> 
> 192.168.0.1 to CHAIN1
> ..
> 192.168.0.100 to CHAIN100 

If you mean to store the IP addresses in a set and use it to "jump" to the 
chains, then no, that's not possible.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
