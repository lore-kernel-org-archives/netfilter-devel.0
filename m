From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset and interfaces
Date: Tue, 24 May 2011 13:52:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu>
References: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oskar Berggren <oskar.berggren@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:48616 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1EXLw4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 07:52:56 -0400
In-Reply-To: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 24 May 2011, Oskar Berggren wrote:

> Regarding ipsets.... how crazy would it be to add a set type
> containing interface names?

Usually the number of interfaces are not quite high in a system, so it 
does not seem required.

> And how crazy would it be to add a set type containing tuples of
> ip-address and interface name?  (I.e. the set match would look for ip,
> and match if a tuple with the proper interface is found)

What is the case where a combination of matches does not solve the issue? 
Something like this

-N interfaces
-A interfaces -i foo -j ACTION
...

-A rule -m set --match-set src -j interfaces

and thus you can match IP addresses and possible (incoming) interfaces 
easily.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
