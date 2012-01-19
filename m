From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.11 patch to fix inclusion of linux/export.h
Date: Thu, 19 Jan 2012 22:09:30 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201192209070.9337@blackhole.kfki.hu>
References: <1326997881.6724.8.camel@moby.culcon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Henry Culver <henry@culcon.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:40378 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2ASVJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:09:33 -0500
In-Reply-To: <1326997881.6724.8.camel@moby.culcon.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Jan 2012, Henry Culver wrote:

> The tests for inclusion of linux/export.h in
> ipset-6.11:kernel/net/netfilter/ipset/{ip_set_getport.c,pfxlen.c} are
> incorrect.  linux/export.h did not go in until 3.2.0, check the 3.2
> patch set.  Attached is a patch to correct this.

Thanks, I'll release an updated version.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
