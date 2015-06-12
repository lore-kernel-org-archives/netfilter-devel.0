From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RESEND PATCH V2] Add element count to hash headers
Date: Fri, 12 Jun 2015 20:56:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506122056040.3707@blackhole.kfki.hu>
References: <1432913785-22187-1-git-send-email-emunson@akamai.com> <20150612123456.GA13973@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric B Munson <emunson@akamai.com>, Josh Hunt <johunt@akamai.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:37645 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbbFLS46 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 14:56:58 -0400
In-Reply-To: <20150612123456.GA13973@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 12 Jun 2015, Pablo Neira Ayuso wrote:

> On Fri, May 29, 2015 at 11:36:25AM -0400, Eric B Munson wrote:
> > It would be useful for userspace to query the size of an ipset hash,
> > however, this data is not exposed to userspace outside of counting the
> > number of member entries.  This patch uses the attribute
> > IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> > exported to userspace.  This field is then printed by the userspace
> > tool for hashes.
> > 
> > Because it is only meaningful for hashes to report their size, the
> > output is conditional on the set type.  To do this checking the
> > MATCH_TYPENAME macro was moved to utils.h.
> > 
> > The bulk of this patch changes the expected test suite to account for
> > the change in output.
> 
> AFAIK, Jozsef wants to integrate this into ipset once the RCU patchset
> for ipset is merged mainstream.

Yes, exactly, after that this patch will be applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
