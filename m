From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 19:25:01 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511111913560.15537@blackhole.kfki.hu>
References: <20151107074939.GA4003@compaq.slightly-cracked.com> <20151111165026.GA20549@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Philip Whineray <phil@firehol.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49174 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbbKKSXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 13:23:24 -0500
In-Reply-To: <20151111165026.GA20549@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Nov 2015, Pablo Neira Ayuso wrote:

> On Sat, Nov 07, 2015 at 07:49:39AM +0000, Philip Whineray wrote:
> > Reading these files is impossible in an unprivileged user namespace,
> > interfering with various firewall tools. For instance, iptables-save
> > relies on reading /proc/net/ip_tables_names to dump only loaded tables.
> > 
> > Hiding the contents from non-root users does not achieve anything
> > practical. Possible values are well-known and the specifics can
> > be inferred from a list of loaded modules on most systems.
> > 
> > Signed-off-by: Philip Whineray <phil@firehol.org>
> > ---
> > An alternate might be to change the ownership of the files within the
> > namespace when it is created:
> > 
> > https://lists.linuxcontainers.org/pipermail/lxc-users/2014-November/008110.html
> > 
> > I do not see that there is much advantage to this, it just ties the
> > ability to read the files to the ability to create an unprivileged
> > namespace.
> 
> So I understood this correctly, this approach would set the ownership
> of the /proc entry to the corresponding root uid mapping from the
> unpriviledged namespace, right? If so, I would prefer that approach.
> 
> This is partially leaking the filtering policy to non-root users as it
> contains what modules are being used, so you can at least infer how
> complex your ruleset is.
> 
> And I guess it will not be long time until someone else will follow up
> with a similar patch later on to expose the content of
> /proc/net/nf_conntrack to get this working on unpriviledged namespaces
> too.

Can't it be worked out by using CAP_NET_ADMIN? I don't really like the 
idea to expose the files to non root users or users with not sufficient 
capabilities.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
