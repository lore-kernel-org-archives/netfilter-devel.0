From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Fix ethernet address parser
Date: Tue, 6 May 2014 11:04:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1405061103470.10540@blackhole.kfki.hu>
References: <CAM=+jx8BjiVY6f3Gv8G3KPxr3KaDYkbTqeZWkxhBFakgdsnyLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Janeks Jaunups <th3n3x@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:38027 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934344AbaEFJEI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 05:04:08 -0400
In-Reply-To: <CAM=+jx8BjiVY6f3Gv8G3KPxr3KaDYkbTqeZWkxhBFakgdsnyLw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 30 Apr 2014, Janeks Jaunups wrote:

> Currently ipset would not parse ether addresses which are not exactly
> 17 characters long, for ex. 1:2:3:4:5:6
> 
> I've ran into this problem when trying to do fancy things with ISC
> DHCP scripts/events, which gladly skips zeroes in front of address
> element, at least in a way I was doing it.
> 
> on commit {
>   set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
>   set ClientMac = binary-to-ascii(16, 8, ":", substring(hardware, 1, 6));
> 
>   execute("sudo", "/usr/sbin/ipset", "add", "-exist", "dynnet",
> concat( ClientIP, ",", ClientMac));
> }

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
