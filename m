From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] add missing ipset_parse_tcp_udp_port to libipset.map
Date: Fri, 24 Oct 2014 22:44:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410242243060.22253@blackhole.kfki.hu>
References: <544AA6FF.1000803@mageia.org> <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Backlund <tmb@mageia.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43273 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaJXUnW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:43:22 -0400
In-Reply-To: <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Oct 2014, Jan Engelhardt wrote:

> On Friday 2014-10-24 21:23, Thomas Backlund wrote:
> 
> > Found this issue when we switched from 6.19 static build to 6.21 dynamic build,
> > and is still there in 6.23
> 
> What has been released is immutable; after a release, only add 
> symbols to new sections.

Yes, that's so. I'm going to write a check to catch such missing items 
before a release in the future.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
