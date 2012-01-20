From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.11 patch to fix inclusion of linux/export.h
Date: Fri, 20 Jan 2012 13:42:31 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201201342040.11124@blackhole.kfki.hu>
References: <1326997881.6724.8.camel@moby.culcon.com> <alpine.DEB.2.00.1201192209070.9337@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Henry Culver <henry@culcon.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46364 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab2ATMme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:42:34 -0500
In-Reply-To: <alpine.DEB.2.00.1201192209070.9337@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Jan 2012, Jozsef Kadlecsik wrote:

> On Thu, 19 Jan 2012, Henry Culver wrote:
> 
> > The tests for inclusion of linux/export.h in
> > ipset-6.11:kernel/net/netfilter/ipset/{ip_set_getport.c,pfxlen.c} are
> > incorrect.  linux/export.h did not go in until 3.2.0, check the 3.2
> > patch set.  Attached is a patch to correct this.
> 
> Thanks, I'll release an updated version.

Committed and pushed to the repository, thanks again.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
