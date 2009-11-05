From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Another issue with ipset on sparc64
Date: Thu, 5 Nov 2009 19:38:54 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911051936080.14280@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB992FEF@GVW1115EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	Jan Engelhardt <jengelh@medozas.de>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41390 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbZKESit (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:38:49 -0500
In-Reply-To: <4513233BE7DF454BB62D30017EEE55436CFB992FEF@GVW1115EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Nov 2009, Chini, Georg (HP App Services) wrote:

> I found another issue with ipset on sparc64 (Ultra2, 2 CPU, 2.6.31.5,
> Debian5).
> When I flush an iptreemap, one (of two) ksoftirqd goes up to 25% CPU
> load and remains there until I delete the set. I don't have to place
> anything in the map, just doing "ipset -N abc iptreemap; ipset -F abc" is
> enough. Doing that again with another map will add 25% load to the
> second ksoftirqd. Adding more maps will not change things further.

Thanks the reports! 

Tomorrow I'll setup the testbed and I'll be able to run the full test 
suite in ipset. Then I can work on cleaning up all bigendian issues.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
