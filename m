From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] ipset: Add net namespace for ipset
Date: Sat, 28 Sep 2013 18:43:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309281842420.22866@blackhole.kfki.hu>
References: <5244222F.2030507@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vitaly Lavrov <vel21ripn@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49773 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3I1QnR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:43:17 -0400
In-Reply-To: <5244222F.2030507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 26 Sep 2013, Vitaly Lavrov wrote:

> This patch adds netns support for ipset.
> 
> Major changes were made in ip_set_core.c and ip_set.h.
> Global variables are moved to per net namespace.
> Added initialization code and the destruction of the network namespace ipset
> subsystem.
> In the prototypes of public functions ip_set_* added parameter "struct net*".
> 
> The remaining corrections related to the change prototypes of public functions
> ip_set_*.
> 
> The patch for git://git.netfilter.org/ipset.git commit
> 6a4ec96c0b8caac5c35474e40e319704d92ca347
> 
> Signed-off-by: Vitaly Lavrov <lve@guap.ru>

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
