From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] add missing ipset_parse_tcp_udp_port to
 libipset.map
Date: Tue, 28 Oct 2014 19:38:08 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1410281937430.15435@blackhole.kfki.hu>
References: <544AA6FF.1000803@mageia.org> <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr> <544AB83A.4070707@mageia.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Thomas Backlund <tmb@mageia.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:38281 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaJ1Sh0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:37:26 -0400
In-Reply-To: <544AB83A.4070707@mageia.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Oct 2014, Thomas Backlund wrote:

> 
> 2014-10-24 23:07, Jan Engelhardt skrev:
> > On Friday 2014-10-24 21:23, Thomas Backlund wrote:
> > 
> > > Found this issue when we switched from 6.19 static build to 6.21 dynamic
> > > build,
> > > and is still there in 6.23
> > 
> > What has been released is immutable; after a release, only add
> > symbols to new sections.
> 
> Ok, so I guess it should be added after the patch:
> 
> [PATCH] libipset: Bump lib version and update map file
> 
> posted today, so something like:

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
