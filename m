From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3 0/5]  ipset: add "inner" flag support
Date: Fri, 5 Jul 2013 22:48:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307052244220.21063@blackhole.kfki.hu>
References: <51CF5256.3010004@googlemail.com> <alpine.DEB.2.00.1307052001200.20246@blackhole.kfki.hu> <51D72D9B.9040003@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:47655 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3GEUso (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:48:44 -0400
In-Reply-To: <51D72D9B.9040003@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 5 Jul 2013, Dash Four wrote:

> Jozsef Kadlecsik wrote:
> > I have just noticed one single issue with your patches: the revision bumping
> > for the set types are missing.
> >   
> Interesting. I wasn't aware you've introduced this feature and by 
> looking at the logs, this has been present since 6.14 - shame on me for 
> not noticing it.
> 
> > So please extend the second patch with the type revisions incremented (have
> > a look at the hash:net type how the revision comments are kept)
> > and add a userspace patch with the revisions bumped in userspace too (it's
> > fine to copy the most recent ones and increase the revisions, adjust the
> > descriptions).
> In other words, something like:
> 
> kernel/net/netfilter/ip_set_*.c
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> -#define IPSET_TYPE_REV_MAX    3 /* Counters support added */
> +/*                             3    Counters support added */
> +#define IPSET_TYPE_REV_MAX    4 /* Inner flag support added */
> 
> lib/ipset_*.c
> ~~~~~~~~~~~~~
> copy the entire ipset_hash_netX struct, bump the ".revision" and adjust the
> ".description" fields?
> 
> Would that suffice?

Yes, exactly.
 
> Also, would you like me to modify my 3rd patch (which is where I've made 
> the changes to all sets - in patch two I reimplemented the "internal" 
> functions) and issue a separate one for all lib/ipset_*.c changes or 
> would you like me to reissue the whole set of patches (1-6)?

I meant the third patch, but wrote "second" above....

You can reissue just the third and send the new sixth for lib/ipset_*.c.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
