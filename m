From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Fri, 24 Apr 2009 10:06:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904240956390.13551@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
 <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu> <49EDBA7E.2040200@trash.net> <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu> <49EF3EE4.1090204@trash.net> <alpine.DEB.2.00.0904222234570.10604@blackhole.kfki.hu>
 <49F05B11.8040804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59259 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZDXIGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:06:08 -0400
In-Reply-To: <49F05B11.8040804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Thu, 23 Apr 2009, Patrick McHardy wrote:

> > Hmm, if there are multiple clients connecting to the same external node (or
> > even just a few ones but the exact time is not definite due to the unsynced
> > clocks) then the hunted client does not stand out. But it might indicate
> > multiple infected machines as well...
> 
> Yes, you'd need at least destination port numbers to reduce false
> positives. But the same is also true if you do log the NATed address.
> For the small-site case you describe, the external address is usually
> know anyways since there is only a single one :)
> 
> Just to be clear about this, I don't generally object to this,
> but before making this (quite undesirable IMO) change, I'd like
> to be sure that it actually provides a tantamount benefit.
> Please feel free to tell me that I'm missing the point :)

Because there's other solutions to log the data (ulogd2, conntrack)
and because the patch is suboptimal, let's forget about it. Maybe we'll be 
able to figure out a better way in nftables.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
